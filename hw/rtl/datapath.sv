`include "rv32i_types.svh"

module datapath (
    input  logic        clk,
    input  logic        rst_n,

    // Controls from controller
    input  logic        branch_en,
    input  logic        jump,
    input  result_src_t result_src,
    input  alu_op_t     alu_op,
    input  logic        alu_src,
    input  logic        reg_write,

    // Memory bus
    output logic [31:0] pc,
    input  logic [31:0] inst,
    output logic [31:0] mem_addr,
    output logic [31:0] mem_wdata,
    input  logic [31:0] mem_rdata
);

    logic [31:0] pc_next;
    logic [31:0] pc_plus4;
    logic [31:0] pc_target;
    logic        pc_src;

    logic [31:0] imm;
    logic [31:0] rs1_data;
    logic [31:0] rs2_data;
    logic [31:0] alu_src_b;
    logic [31:0] alu_result;
    logic [31:0] result_data;
    logic        branch_taken;

    logic [4:0]  rs1;
    logic [4:0]  rs2;
    logic [4:0]  rd;
    logic [2:0]  funct3;

    assign rs1    = inst[19:15];
    assign rs2    = inst[24:20];
    assign rd     = inst[11:7];
    assign funct3 = inst[14:12];

    // PC Logic
    assign pc_plus4  = pc + 32'd4;
    assign pc_target = (jump && alu_src) ? (alu_result & ~32'd1) : (pc + imm); // JALR vs Branch/JAL
    assign pc_src    = jump | branch_taken;
    assign pc_next   = pc_src ? pc_target : pc_plus4;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) pc <= 32'h0;
        else        pc <= pc_next;
    end

    // Submodules
    regfile u_regfile (
        .clk       (clk),
        .reg_write (reg_write),
        .rs1_addr  (rs1),
        .rs2_addr  (rs2),
        .rd_addr   (rd),
        .wdata     (result_data),
        .rs1_data  (rs1_data),
        .rs2_data  (rs2_data)
    );

    imm_gen u_imm_gen (
        .inst (inst),
        .imm  (imm)
    );

    assign alu_src_b = alu_src ? imm : rs2_data;

    alu u_alu (
        .a        (rs1_data),
        .b        (alu_src_b),
        .alu_op   (alu_op),
        .result   (alu_result),
        .zero     ()
    );

    branch_unit u_branch_unit (
        .rs1_data     (rs1_data),
        .rs2_data     (rs2_data),
        .funct3       (funct3),
        .branch_en    (branch_en),
        .branch_taken (branch_taken)
    );

    // Memory & Writeback
    assign mem_addr  = alu_result;
    assign mem_wdata = rs2_data;

    always_comb begin
        unique case (result_src)
            RESULT_ALU: result_data = alu_result;
            RESULT_MEM: result_data = mem_rdata;
            RESULT_PC4: result_data = pc_plus4;
            RESULT_IMM: result_data = imm;
            default:    result_data = alu_result;
        endcase
    end

endmodule
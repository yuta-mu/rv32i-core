`ifndef RV32I_TYPES_SVH
`define RV32I_TYPES_SVH

typedef enum logic [6:0] {
    OP_REG      = 7'b0110011,
    OP_IMM      = 7'b0010011,
    OP_LOAD     = 7'b0000011,
    OP_STORE    = 7'b0100011,
    OP_BRANCH   = 7'b1100011,
    OP_JAL      = 7'b1101111,
    OP_JALR     = 7'b1100111,
    OP_LUI      = 7'b0110111,
    OP_AUIPC    = 7'b0010111
} opcode_t;

typedef enum logic [1:0] {
    RESULT_ALU  = 2'b00,
    RESULT_MEM  = 2'b01,
    RESULT_PC4  = 2'b10,
    RESULT_IMM  = 2'b11
} result_src_t;

typedef enum logic [1:0] {
    ALU_OP_ADD    = 2'b00,
    ALU_OP_BRANCH = 2'b01,
    ALU_OP_RTYPE  = 2'b10,
    ALU_OP_ITYPE  = 2'b11
} alu_op_mode_t;

typedef enum logic [3:0] {
    ALU_ADD  = 4'b0000,
    ALU_SUB  = 4'b1000,
    ALU_SLL  = 4'b0001,
    ALU_SLT  = 4'b0010,
    ALU_SLTU = 4'b0011,
    ALU_XOR  = 4'b0100,
    ALU_SRL  = 4'b0101,
    ALU_SRA  = 4'b1101,
    ALU_OR   = 4'b0110,
    ALU_AND  = 4'b0111
} alu_op_t;

localparam logic [2:0] FUNCT3_ADD   = 3'h0;
localparam logic [2:0] FUNCT3_SUB   = 3'h0;
localparam logic [2:0] FUNCT3_XOR   = 3'h4;
localparam logic [2:0] FUNCT3_OR    = 3'h6;
localparam logic [2:0] FUNCT3_AND   = 3'h7;
localparam logic [2:0] FUNCT3_SLL   = 3'h1;
localparam logic [2:0] FUNCT3_SRL   = 3'h5;
localparam logic [2:0] FUNCT3_SRA   = 3'h5;
localparam logic [2:0] FUNCT3_SLT   = 3'h2;
localparam logic [2:0] FUNCT3_SLTU  = 3'h3;

localparam logic [2:0] FUNCT3_ADDI  = 3'h0;
localparam logic [2:0] FUNCT3_XORI  = 3'h4;
localparam logic [2:0] FUNCT3_ORI   = 3'h6;
localparam logic [2:0] FUNCT3_ANDI  = 3'h7;
localparam logic [2:0] FUNCT3_SLLI  = 3'h1;
localparam logic [2:0] FUNCT3_SRLI  = 3'h5;
localparam logic [2:0] FUNCT3_SRAI  = 3'h5;
localparam logic [2:0] FUNCT3_SLTI  = 3'h2;
localparam logic [2:0] FUNCT3_SLTIU = 3'h3;

localparam logic [2:0] FUNCT3_LB    = 3'h0;
localparam logic [2:0] FUNCT3_LH    = 3'h1;
localparam logic [2:0] FUNCT3_LW    = 3'h2;
localparam logic [2:0] FUNCT3_LBU   = 3'h4;
localparam logic [2:0] FUNCT3_LHU   = 3'h5;

localparam logic [2:0] FUNCT3_SB    = 3'h0;
localparam logic [2:0] FUNCT3_SH    = 3'h1;
localparam logic [2:0] FUNCT3_SW    = 3'h2;

localparam logic [2:0] FUNCT3_BEQ   = 3'h0;
localparam logic [2:0] FUNCT3_BNE   = 3'h1;
localparam logic [2:0] FUNCT3_BLT   = 3'h4;
localparam logic [2:0] FUNCT3_BGE   = 3'h5;
localparam logic [2:0] FUNCT3_BLTU  = 3'h6;
localparam logic [2:0] FUNCT3_BGEU  = 3'h7;

localparam logic [2:0] FUNCT3_JALR  = 3'h0;

`endif


// hw/rtl/alu_tb.sv
// ALUのテストベンチ

module alu_tb;

    logic [31:0] a;
    logic [31:0] b;
    logic [3:0]  alu_ctrl;
    logic [31:0] result;
    logic        zero;

    alu dut (
        .a(a),
        .b(b),
        .alu_ctrl(alu_ctrl),
        .result(result),
        .zero(zero)
    );

    initial begin
        $display("=== ALU Simulation Start ===");

        // テスト1: 10 + 20 (ADD: 0010)
        a = 32'd10; b = 32'd20; alu_ctrl = 4'b0010;
        #10;
        $display("ADD : %d + %d = %d", a, b, result);

        // テスト2: 30 - 30 (SUB: 0110)
        a = 32'd30; b = 32'd30; alu_ctrl = 4'b0110;
        #10;
        $display("SUB : %d - %d = %d (zero=%b)", a, b, result, zero);

        // テスト3: 12 AND 10 (AND: 0000)
        a = 32'd12; b = 32'd10; alu_ctrl = 4'b0000;
        #10;
        $display("AND : %d & %d = %d", a, b, result);

        $display("=== ALU Simulation End ===");
        $finish;
    end

endmodule
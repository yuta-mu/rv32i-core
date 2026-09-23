// hw/rtl/imem_tb.sv
// 命令メモリのテストベンチ

module imem_tb;
    logic [31:0] a;
    logic [31:0] rd;

    imem uut (
        .a(a),
        .rd(rd)
    );

    initial begin
        $display("=== Instruction Memory Simulation Start ===");

        // Test1: 0番地の命令を要求
        a = 32'd0;
        #10;
        $display("Address: %0d -> Read Data: %h (Expected: 11111111)", a, rd);

        // Test2: 4番地の命令を要求
        a = 32'd4;
        #10;
        $display("Address: %0d -> Read Data: %h (Expected: 22222222)", a, rd);

        // Test3: 8番地の命令を要求
        a = 32'd8;
        #10;
        $display("Address: %0d -> Read Data: %h (Expected: 33333333)", a, rd);

        $display("=== Instruction Memory Simulation End ===");
        $finish;
    end
endmodule
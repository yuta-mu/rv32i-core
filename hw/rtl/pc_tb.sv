// hw/rtl/pc_tb.sv
// プログラムカウンタのテストベンチ

module pc_tb;
    logic        clk;
    logic        rst;
    logic [31:0] next_pc;
    logic [31:0] current_pc;

    pc uut (
        .clk(clk),
        .rst(rst),
        .next_pc(next_pc),
        .current_pc(current_pc)
    );

    always #5 clk = ~clk;

    initial begin
        // 初期化
        clk = 0;
        rst = 1;
        next_pc = 32'b0;

        $display("=== PC Simulation Start ===");

        // Test1: リセット時の動作確認
        #10;
        $display("Time: %0t | rst: %b | next_pc: %0d -> current_pc: %0d (Expected: 0)", $time, rst, next_pc, current_pc);

        // Test2: 次の命令（4番地）に進んでみる
        rst = 0;
        next_pc = 32'd4;
        #10;
        $display("Time: %0t | rst: %b | next_pc: %0d -> current_pc: %0d (Expected: 4)", $time, rst, next_pc, current_pc);

        // Test3: さらに次の命令（8番地）に進んでみる
        next_pc = 32'd8;
        #10;
        $display("Time: %0t | rst: %b | next_pc: %0d -> current_pc: %0d (Expected: 8)", $time, rst, next_pc, current_pc);

        // Test4: 離れたアドレスへGO
        next_pc = 32'd100;
        #10;
        $display("Time: %0t | rst: %b | next_pc: %0d -> current_pc: %0d (Expected: 100)", $time, rst, next_pc, current_pc);

        // Test5: 動作中にリセットスイッチを押してみる
        rst = 1;
        #10;
        $display("Time: %0t | rst: %b | next_pc: %0d -> current_pc: %0d (Expected: 0)", $time, rst, next_pc, current_pc);

        $display("=== PC Simulation End ===");
        $finish;
    end
endmodule
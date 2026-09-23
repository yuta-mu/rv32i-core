// hw/rtl/dmem_tb.sv
// データメモリのテストベンチ

module dmem_tb;
    logic        clk;
    logic        we;
    logic [31:0] a;
    logic [31:0] wd;
    logic [31:0] rd;

    dmem uut (
        .clk(clk),
        .we(we),
        .a(a),
        .wd(wd),
        .rd(rd)
    );

    always #5 clk = ~clk;

    initial begin
        // 初期化
        clk = 0;
        we = 0;
        a = 32'd0;
        wd = 32'd0;

        $display("=== Data Memory Simulation Start ===");

        // Test1: 書き込み許可1、4番地にデータを保存
        #10;
        we = 1;
        a = 32'd4;
        wd = 32'h12345678;
        $display("Time: %0t | Action: Write | Address: %0d | Write Data: %h", $time, a, wd);
        #10;

        // Test2: 8番地に別のデータを保存
        a = 32'd8;
        wd = 32'haabbccdd;
        $display("Time: %0t | Action: Write | Address: %0d | Write Data: %h", $time, a, wd);
        #10;

        we = 0;
        
        // Test3: さっき保存した4番地のデータを読み出してみる
        a = 32'd4;
        #10;
        $display("Time: %0t | Action: Read  | Address: %0d | Read Data:  %h (Expected: 12345678)", $time, a, rd);

        // Test5: 8番地を読み出してみる
        a = 32'd8;
        #10;
        $display("Time: %0t | Action: Read  | Address: %0d | Read Data:  %h (Expected: aabbccdd)", $time, a, rd);

        $display("=== Data Memory Simulation End ===");
        $finish;
    end
endmodule
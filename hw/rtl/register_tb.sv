// hw/rtl/register_tb.sv
// レジスタファイルのテストベンチ

module register_tb;
    logic clk;
    logic we;
    logic [4:0] rs1, rs2, rd;
    logic [31:0] wd;
    logic [31:0] rd1, rd2;

    regfile dut (
        .clk(clk),
        .we(we),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .wd(wd),
        .rd1(rd1),
        .rd2(rd2)
    );

    // 5時間単位ごとに切り替え
    always #5 clk = ~clk;

    initial begin
        $display("=== Register File Simulation Start ===");
        
        // 初期化
        clk = 0; we = 0; rs1 = 0; rs2 = 0; rd = 0; wd = 0;
        #10;

        // Test1: x1に100を書き込む
        rd = 5'd1; wd = 32'd100; we = 1;
        #10; we = 0;

        // Test2: x2に200を書き込む
        rd = 5'd2; wd = 32'd200; we = 1;
        #10; we = 0;

        // Test3: x1 と x2 を読み出してみる
        rs1 = 5'd1; rs2 = 5'd2;
        #10;
        $display("Read x1: %d (Expected: 100)", rd1);
        $display("Read x2: %d (Expected: 200)", rd2);

        // Test4: x0に999を書き込む（無視されることを期待）
        rd = 5'd0; wd = 32'd999; we = 1;
        #10; we = 0;
        
        // x0を読み出して確認
        rs1 = 5'd0;
        #10;
        $display("Read x0: %d (Expected: 0)", rd1);

        $display("=== Register File Simulation End ===");
        $finish;
    end
endmodule
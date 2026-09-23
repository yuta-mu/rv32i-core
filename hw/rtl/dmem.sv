// hw/rtl/dmem.sv
// データメモリ: 実行中のデータを保存・読み出しする

module dmem (
    input  logic        clk, // クロック信号
    input  logic        we,  // 書き込み許可
    input  logic [31:0] a,   // アドレス
    input  logic [31:0] wd,  // 書き込むデータ
    output logic [31:0] rd   // 読み出すデータ
);

    // 32ビット(4バイト)幅の箱を64個（計256バイト）
    logic [31:0] RAM[0:63];

    // 読み出し
    assign rd = RAM[a[7:2]];

    // 書き込み
    always_ff @(posedge clk) begin
        if (we) begin
            RAM[a[7:2]] <= wd;
        end
    end

endmodule
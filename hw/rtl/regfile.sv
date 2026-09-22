// hw/rtl/regfile.sv
// レジスタファイル: 32個の汎用レジスタ(x0〜x31)を持つ記憶領域

module regfile (
    input  logic        clk,      // クロック信号
    input  logic        we,       // 1のとき書き込みOK
    input  logic [4:0]  rs1,      // 読み出し指定番号1
    input  logic [4:0]  rs2,      // 読み出し指定番号2
    input  logic [4:0]  rd,       // 書き込み指定番号
    input  logic [31:0] wd,       // 書き込むデータ
    
    output logic [31:0] rd1,      // 読み出したデータ1
    output logic [31:0] rd2       // 読み出したデータ2
);

    // 32ビット幅のレジスタ32個
    logic [31:0] registers [0:31];

    // 読み出し
    assign rd1 = (rs1 == 5'b0) ? 32'b0 : registers[rs1];
    assign rd2 = (rs2 == 5'b0) ? 32'b0 : registers[rs2];

    // 書き込み
    always_ff @(posedge clk) begin
        // 書き込み許可かつ書き込み先が0番でない場合のみ保存
        if (we && (rd != 5'b0)) begin
            registers[rd] <= wd;
        end
    end

endmodule
// hw/rtl/pc.sv
// プログラムカウンタ: 現在実行中の命令のアドレスを記憶

module pc (
    input  logic        clk,      // クロック信号
    input  logic        rst,      // リセット信号
    input  logic [31:0] next_pc,  // 次に進むべきアドレス
    output logic [31:0] current_pc// 実行中のアドレス
);

    always_ff @(posedge clk) begin
        if (rst) begin
            // リセット1で0番地に戻る
            current_pc <= 32'b0;
        end else begin
            // ほか，指示された次のアドレスに更新
            current_pc <= next_pc;
        end
    end

endmodule
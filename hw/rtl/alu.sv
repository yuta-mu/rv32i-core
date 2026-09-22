// hw/rtl/alu.sv
// ALU (算術論理演算器)
// 2つの32bitデータを受け取り、alu_ctrlの指示に従って計算を行う

module alu (
    input  logic [31:0] a,        // 入力A
    input  logic [31:0] b,        // 入力B
    input  logic [3:0]  alu_ctrl, // デコーダからの演算指定信号
    
    output logic [31:0] result,   // 計算結果
    output logic        zero      // 結果が0のとき1になる比較用フラグ
);

    // 組み合わせ回路（クロックに依存せず、入力が入ればすぐ出力が変わる）
    always_comb begin
        case (alu_ctrl)
            4'b0000: result = a & b;       // AND (論理積)
            4'b0001: result = a | b;       // OR  (論理和)
            4'b0010: result = a + b;       // ADD (加算)
            4'b0110: result = a - b;       // SUB (減算)
            // 必要に応じて XOR, SLL などを追加
            default: result = 32'b0;
        endcase
    end

    // 計算結果が32ビットすべて0ならzeroフラグを立てる(分岐命令の判定で使用)
    assign zero = (result == 32'b0);

endmodule
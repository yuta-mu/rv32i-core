/*
 * 固定小数点演算の基本部品（符号付き32ビット、小数部16ビット）。
 *
 * 実際の値 = 保存する整数 / f_scale、f_scale = 2^16 = 65536。
 * 例: 1.0 は 65536、0.5 は 32768、-2.0 は -131072 として保存する。
 * 表現範囲は -32768 から 32768 - 1/65536、刻み幅は 1/65536。
 * fpm_t は int32_t の別名なので、型だけでは通常の整数と区別できない。
 * 定数は fpm_from_int / fpm_from_ratio で変換してから演算に渡す。
 *
 * 共通の前提:
 * - 各演算の最終結果は fpm_t の表現範囲に収まるものとする。
 * - ゼロ除算、範囲外の値、負数の平方根を検査する処理はまだない。
 * - 整数除算の端数は0方向に丸める（例: -1.5 を整数にすると -1）。
 * - 平方根は、正確な結果を超えない最大の保存値を返す。
 * - 同じ形式の値どうしなら、比較には通常の <、<=、== などを使える。
 *
 * 今後のファイル分割:
 * - fpm.h: fpm_t、倍率の定数、関数宣言を置き、利用側から include する。
 * - fpm.cpp: 固定小数点の関数定義を置き、fpm.h を include する。
 * - vec3.h / vec3.cpp: fpm_t を使う3次元ベクトルの型と演算を置く。
 * - 下の main は単体確認用。分割時は専用のテスト用 .cpp に移し、
 *   レイトレーサーの main.cpp とは別の実行ファイルとしてビルドする。
 * 利用側と fpm.cpp をコンパイルしてリンクする構成にする。
 */
#include <cmath>
#include <iostream>
#include <cstdint>
#include "fpm.h"


// 通常の整数を固定小数点に変換する。入力範囲は -32768 ～ 32767。
fpm_t fpm_from_int(int32_t value){
    fpm_t fpm_value = value*f_scale;
    return fpm_value;
};

// 倍率を除いて通常の整数に戻す。小数部分は0方向に丸める。
int fpm_to_int(fpm_t value){
    fpm_t fpm_value = value/f_scale;
    return fpm_value;
}

// 加算・減算: 両方の保存値が同じ倍率なので、そのまま足し引きできる。
fpm_t fpm_add(fpm_t a, fpm_t b){
    return a+b;
};

fpm_t fpm_sub(fpm_t a, fpm_t b){
    return a-b;
};

// 乗算: 保存値どうしの積は倍率が二乗になるため、f_scale で1回割る。
// 32ビットでの中間オーバーフローを避けるため、掛ける前に64ビットにする。
fpm_t fpm_mul(fpm_t a, fpm_t b){
    int64_t pro = static_cast<int64_t>(a) *b;
    int64_t scaled = pro / f_scale;
    fpm_t value = static_cast<fpm_t>(scaled);
        return value;
};

// 除算: 保存値の結果は (a * f_scale) / b。前提: b != 0。
// 先に a / b を計算すると小数部分が失われるため、倍率を先に掛ける。
fpm_t fpm_div(fpm_t a, fpm_t b){
    int64_t scaled_a = static_cast<int64_t>(a) * f_scale;
    int64_t pro = scaled_a / b;
    fpm_t value = static_cast<fpm_t>(pro);
        return value;
};

// 平方根: sqrt(a / S) * S = sqrt(a * S)（S = f_scale）。前提: a >= 0。
// a * S の整数平方根を二分探索し、答えの保存値を小さい方に丸める。
fpm_t fpm_sqrt(fpm_t a){
    int64_t scaled_a = static_cast<int64_t>(a) * f_scale;
    int64_t lo = 0;
    int64_t hi = int64_t{1} << 31;
    // lo^2 <= scaled_a < hi^2 を保つ。mid の二乗も64ビットに収まる。
    // 両端が隣り合えば、lo が「二乗して scaled_a を超えない最大の整数」。
    while(hi - lo > 1){
        int64_t mid = (hi+lo)/2;
        (mid * mid <= scaled_a) ? lo = mid : hi = mid;
    };
    fpm_t value = static_cast<fpm_t>(lo);
        return value;
};

// 通常の整数の分子・分母から固定小数点を作る。前提: denominator != 0。
// 計算式は fpm_div と同じだが、引数は分数を構成する通常の整数として扱う。
// 例: (1, 2) -> 32768、(1, 10) -> 6553（正確に表せない値は近似する）。
fpm_t fpm_from_ratio(int32_t numerator, int32_t denominator){
    int64_t scaled_num = static_cast<int64_t>(numerator) * f_scale;
    int64_t pro = scaled_num / denominator;
    fpm_t value = static_cast<fpm_t>(pro);
        return value;
};

// 単体確認: 出力は実際の値ではなく保存値。順に 32768、131072、32768。
/*int main() {
    std::cout << fpm_div(fpm_from_int(1), fpm_from_int(2)) << '\n';
    std::cout << fpm_sqrt(fpm_from_int(4)) << '\n';
    std::cout << fpm_from_ratio(1, 2) << '\n';
}*/
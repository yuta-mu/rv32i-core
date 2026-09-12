# --------------------------------------------------
# ツールチェーンと共通パス
# --------------------------------------------------
CC        := riscv64-unknown-elf-gcc
OBJCOPY   := riscv64-unknown-elf-objcopy
QEMU      := qemu-system-riscv32

BSP_DIR   := bsp
CRT0      := $(BSP_DIR)/crt0.s
LINKER    := $(BSP_DIR)/linker.ld

CFLAGS    := -march=rv32i -mabi=ilp32 -nostdlib -nostartfiles -fno-builtin -T $(LINKER) -O2

# --------------------------------------------------
# 疑似ターゲット
# --------------------------------------------------
.PHONY: all check-env run-boot run-hello run-mandelbrot test-sim clean

all: run-mandelbrot

# 環境確認
check-env:
	@echo "=== Checking Tool Versions ==="
	@$(CC) --version | head -n 1
	@$(QEMU) --version | head -n 1
	@verilator --version | head -n 1
	@iverilog -V | head -n 1
	@ocamlc -v | head -n 1
	@echo "All tools exist and are ready."

# --------------------------------------------------
# ビルド規則
# --------------------------------------------------
# .c のビルド
tests/c/%.elf: tests/c/%.c $(CRT0) $(LINKER)
	$(CC) $(CFLAGS) $(CRT0) $< -o $@

# .s のビルド: スタートアップ処理を自前で含むため crt0 は不要
tests/asm/%.elf: tests/asm/%.s $(LINKER)
	$(CC) $(CFLAGS) $< -o $@

# ELF から Verilog 用 hex ファイルへの変換
%.hex: %.elf
	$(OBJCOPY) -O verilog $< $@

# --------------------------------------------------
# 実行ターゲット (QEMU)
# --------------------------------------------------
run-boot: tests/asm/boot.elf
	@echo "Running QEMU... Press Ctrl-A then X to exit."
	$(QEMU) -M virt -bios none -kernel $< -nographic

run-hello: tests/asm/hello.elf
	$(QEMU) -M virt -bios none -kernel $< -nographic

run-mandelbrot: tests/c/mandelbrot.elf
	$(QEMU) -M virt -bios none -kernel $< -nographic

# --------------------------------------------------
# 汎用 QEMU 実行ターゲット
# --------------------------------------------------
# TARGET が指定されていない場合のデフォルト値
TARGET ?= tests/c/mandelbrot.elf

.PHONY: run
run: $(TARGET)
	@echo "=== Running QEMU: $< ==="
	$(QEMU) -M virt -bios none -kernel $< -nographic

# --------------------------------------------------
# ハードウェアシミュレーション (Icarus Verilog)
# --------------------------------------------------
test-sim:
	@mkdir -p hw/sim
	iverilog -o hw/sim/sim.out hw/rtl/counter.v
	vvp hw/sim/sim.out
	@echo "Simulation complete."

# --------------------------------------------------
# クリーンアップ
# --------------------------------------------------
clean:
	rm -f tests/c/*.elf tests/c/*.hex
	rm -f tests/asm/*.elf tests/asm/*.hex
	rm -f hw/sim/*.out hw/sim/*.vcd

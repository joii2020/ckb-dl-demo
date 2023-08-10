
CC := clang-16
LD := ld.lld-16
OBJCOPY := llvm-objcopy-16
AR := llvm-ar-16


# CC := riscv64-unknown-linux-gnu-gcc
# LD := riscv64-unknown-linux-gnu-ld
# OBJCOPY := riscv64-unknown-linux-gnu-objcopy
# AR := riscv64-unknown-linux-gnu-ar

CFLAGS := --target=riscv64 -march=rv64imc_zba_zbb_zbc_zbs -O3 -fno-builtin-printf -fno-builtin-memcmp -nostdinc -nostdlib -fvisibility=hidden -fdata-sections -ffunction-sections -Wall -Werror -Wno-nonnull -Wno-unused-function -g -DCKB_NO_ENTRY_GP -I deps/ckb-c-stdlib -I deps/ckb-c-stdlib/libc  -I deps/ckb-c-stdlib/molecule
LDFLAGS := -Wl,-static -fdata-sections -ffunction-sections -Wl,--gc-sections

all: \
	build/dl_interface \
	build/ckb_dl_demo \
	build/ckb_dl_demo_tx

build/dl_interface: dl_interface.c
	mkdir -p build
	$(CC) $(CFLAGS) -fPIC -c -o build/dl_interface.o dl_interface.c
	$(LD) --shared --gc-sections --dynamic-list dl_interface.syms -o $@ build/dl_interface.o
	cp $@ $@.debug
	$(OBJCOPY) --strip-debug --strip-all $@

build/ckb_dl_demo: example/ckb_dl_demo.c
	$(CC) $(CFLAGS) -fPIE $(LDFLAGS) -o $@ $<

build/ckb_dl_demo_tx:
	cd example/generate_tx && cargo run > ../../build/tx.json

install-ckb-debugger:
	wget 'https://github.com/XuJiandong/ckb-standalone-debugger/releases/download/ckb2023-0621/ckb-debugger-linux-x64.tar.gz'
	tar zxvf ckb-debugger-linux-x64.tar.gz
	mv ckb-debugger ~/.cargo/bin/ckb-debugger

clean:
	rm -rf build/dl_interface.o
	rm -rf build/dl_interface
	rm -rf build/dl_interface.debug
	rm -rf build/ckb_dl_demo
	rm -rf build/tx.json

CC := clang-16
LD := ld.lld-16
OBJCOPY := llvm-objcopy-16
AR := llvm-ar-16

CFLAGS := --target=riscv64 -march=rv64imc_zba_zbb_zbc_zbs -O0 -fno-builtin-printf -fno-builtin-memcmp -nostdinc -nostdlib -fvisibility=hidden -fdata-sections -ffunction-sections -Wall -Werror -Wno-nonnull -Wno-unused-function -g -DCKB_NO_ENTRY_GP -I deps/ckb-c-stdlib -I deps/ckb-c-stdlib/libc  -I deps/ckb-c-stdlib/molecule
LDFLAGS := -Wl,-static -fdata-sections -ffunction-sections -Wl,--gc-sections

all: \
	build/dl_interface \
	build/ckb_dl_demo \
	build/ckb_dl_demo_tx

build/dl_interface: dl_interface.c
	$(CC) $(CFLAGS) -fPIC -fPIE -c -o build/dl_interface.o dl_interface.c
	$(LD) --shared --gc-sections --dynamic-list dl_interface.syms -o $@ build/dl_interface.o

build/ckb_dl_demo: example/ckb_dl_demo.c
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $<

build/ckb_dl_demo_tx:
	cd example/generate_tx && cargo run > ../../build/tx.json

clean:
	rm -rf build/dl_interface.o
	rm -rf build/dl_interface
	rm -rf build/ckb_dl_demo
	rm -rf build/tx.json
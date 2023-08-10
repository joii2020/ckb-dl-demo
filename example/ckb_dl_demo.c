#define CKB_C_STDLIB_PRINTF
#include <stdio.h>

#include "blake2b.h"
#include "blockchain.h"
#include "ckb_consts.h"
#include "ckb_dlfcn.h"
#include "ckb_syscalls.h"

#define SCRIPT_SIZE 32768

int get_dl_interface_code_hash(uint8_t *code_hash) {
    int ret;
    unsigned char script[SCRIPT_SIZE];
    uint64_t len = SCRIPT_SIZE;
    ret = ckb_load_script(script, &len, 0);
    if (ret != CKB_SUCCESS) {
        return CKB_INVALID_DATA;
    }
    if (len > SCRIPT_SIZE) {
        return CKB_INVALID_DATA;
    }
    mol_seg_t script_seg;
    script_seg.ptr = (uint8_t *)script;
    script_seg.size = len;

    if (MolReader_Script_verify(&script_seg, false) != MOL_OK) {
        return CKB_INVALID_DATA;
    }

    mol_seg_t args_seg = MolReader_Script_get_args(&script_seg);
    mol_seg_t args_bytes_seg = MolReader_Bytes_raw_bytes(&args_seg);
    if (args_bytes_seg.size != (32)) {
        return CKB_INVALID_DATA;
    }

    memcpy(code_hash, args_bytes_seg.ptr, 32);
    return CKB_SUCCESS;
}

static uint8_t g_code_buff[300 * 1024] __attribute__((aligned(RISCV_PGSIZE)));
typedef int (*ckb_dl_add)(int a, int b);

int main() {
    printf("-- main --");

    uint8_t code_hash[32];
    int err = get_dl_interface_code_hash(code_hash);
    if (err != CKB_SUCCESS) {
        printf("-- get dl_interface code_hash failed: %d", err);
        return err;
    }

    printf("---- begin open dl");
    void *handle = NULL;
    size_t consumed_size = 0;
    err = ckb_dlopen2(code_hash, 2, g_code_buff, sizeof(g_code_buff), &handle,
                      &consumed_size);
    if (err != 0) {
        printf("-- ckb_dlopen2 failed, des: %d", err);

        return err;
    }

    printf("---- dlsym");
    ckb_dl_add func = (ckb_dl_add)ckb_dlsym(handle, "inc_add");
    if (func == 0) {
        printf("-- ckb_dlsym get inc_add failed");
        return CKB_INVALID_DATA;
    }
    printf("---- run inc_add, func: 0x%x", func);
    int c = func(123, 456);
    if (c != 123 + 456) {
        printf("-- inc_add return failed");
        return 1;
    }

    return 0;
}

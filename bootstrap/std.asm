[BITS 32]


GLOBAL  _asm_halt
GLOBAL  _asm_cli
GLOBAL  _asm_out8
GLOBAL  _asm_load_eflags
GLOBAL  _asm_store_eflags


[SECTION .text]

_asm_halt:
    HLT
    RET


_asm_cli:
    CLI
    RET


_asm_out8:
    MOV     EDX, [ESP+4]
    MOV     AL, [ESP+8]
    OUT     DX, AL
    RET


_asm_load_eflags:
    PUSHFD
    POP     EAX
    RET


_asm_store_eflags:
    MOV     EAX, [ESP+4]
    PUSH    EAX
    POPFD
    RET

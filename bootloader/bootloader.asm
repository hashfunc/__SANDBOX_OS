ORG   0x7C00


JMP   entry
DB    0x90
DB    "HASHFUNC"
DW    512
DB    1
DW    1
DB    2
DW    224
DW    2880
DB    0xF0
DW    9
DW    18
DW    2
DD    0
DD    0
DB    0, 1, 0x29
DD    100
DB    "HASHFUNC   ", 0
DB    "FAT12   "


entry:
MOV   AX, 0
MOV   SS, AX
MOV   SP, 0x7C00
MOV   DS, AX
MOV   ES, AX

MOV   SI, msg


print_loop:
MOV   AL, [SI]
ADD   SI, 1
CMP   AL, 0
JE    fin
MOV   AH, 0x0E
MOV   BX, 15
INT   0x10
JMP   print_loop

fin:
HLT
JMP   fin


msg:
DB    0x0A, 0x0A
DB    "hello, world"
DB    0x0A
DB    0

RESB  0x1FE - ($ - $$)

DB    0x55, 0xAA

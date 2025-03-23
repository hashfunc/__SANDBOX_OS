ORG     0x7C00


JMP     entry
NOP
DB      "HASHFUNC"
DW      512
DB      1
DW      1
DB      2
DW      224
DW      2880
DB      0xF0
DW      9
DW      18
DW      2
DD      0
DD      0
DB      0
DB      1
DB      0x29
DD      0x00000100
DB      "HASHFUNC   "
DB      0
DB      "FAT12   "


entry:
MOV     AX, 0
MOV     SS, AX
MOV     SP, 0x7C00
MOV     DS, AX

MOV     AX, 0x0820
MOV     ES, AX
MOV     CH, 0
MOV     DH, 0
MOV     CL, 2


read:
MOV     SI, 0


retry:
MOV     AH, 0x02
MOV     AL, 1
MOV     BX, 0
MOV     DL, 0x00
INT     0x13
JNC     read_next

ADD     SI, 1
CMP     SI, 5
JAE     handle_error

MOV     AH, 0x00
MOV     DL, 0x00
INT     0x13
JMP     retry


read_next:
MOV     AX, ES
ADD     AX, 0x0020
MOV     ES, AX
ADD     CL, 1
CMP     CL, 18
JBE     read

MOV     CL, 1
ADD     DH, 1
CMP     DH, 2
JB      read

MOV     DH, 0
ADD     CH, 1
CMP     CH, 10
JB      read

MOV     [0x0FF0], CH
JMP     0xC200


handle_error:
MOV		AX, 0
MOV		ES, AX
MOV     SI, error_message


print_loop:
MOV     AL, [SI]
ADD     SI, 1
CMP     AL, 0
JE      fin

MOV     AH, 0x0E
MOV     BX, 15
INT     0x10
JMP     print_loop


fin:
HLT
JMP     fin


error_message:
DB      0x0A, 0x0A
DB      "failed to read the disk"
DB      0x0A
DB      0

RESB    0x1FE - ($ - $$)

DB      0x55, 0xAA

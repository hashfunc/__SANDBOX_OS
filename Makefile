NASM := nasm
GCC  := x86_64-elf-gcc
LD   := x86_64-elf-ld

CFLAGS  := -Wall -m32 -fno-pie


.PHONY: build run clean


out/bootloader.bin: bootloader/bootloader.asm
	$(NASM) -f bin bootloader/bootloader.asm -o out/bootloader.bin


out/header.o: bootstrap/header.asm
	$(NASM) -f elf bootstrap/header.asm -o out/header.o


out/bootstrap.o: bootstrap/bootstrap.c
	$(GCC) $(CFLAGS) -c bootstrap/bootstrap.c -o out/bootstrap.o


out/std.o: bootstrap/std.asm
	$(NASM) -f elf bootstrap/std.asm -o out/std.o


out/bootstrap.sys: bootstrap/bootstrap.ld out/bootstrap.o out/std.o out/header.o
	$(LD) -m elf_i386 --oformat binary -T bootstrap/bootstrap.ld -o out/bootstrap.sys out/header.o out/bootstrap.o out/std.o


out/os.img: out/bootloader.bin out/bootstrap.sys
	dd if=/dev/zero of=out/os.img bs=512 count=2880
	dd if=out/bootloader.bin of=out/os.img bs=512 count=1 conv=notrunc
	dd if=out/bootstrap.sys of=out/os.img seek=33 conv=notrunc


build: out/os.img


run: out/os.img
	qemu-system-i386 -fda out/os.img


clean:
	rm -rf out/*

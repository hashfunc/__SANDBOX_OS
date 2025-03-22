.PHONY: run


out/bootloader.bin: bootloader/bootloader.asm
	nasm bootloader/bootloader.asm -o out/bootloader.bin


run: out/bootloader.bin
	qemu-system-i386 -m 32 -fda out/bootloader.bin

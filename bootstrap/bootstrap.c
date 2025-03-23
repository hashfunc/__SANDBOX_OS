#include "bootstrap.h"

void main(void)
{
    char *vram = (char *)0xa0000;

    int width = 320;
    int height = 200;

    init_palette();

    boxfill8(vram, width, COL8_008484, 0, 0, width - 1, height - 29);
    boxfill8(vram, width, COL8_C6C6C6, 0, height - 28, width - 1, height - 28);
    boxfill8(vram, width, COL8_FFFFFF, 0, height - 27, width - 1, height - 27);
    boxfill8(vram, width, COL8_C6C6C6, 0, height - 26, width - 1, height - 1);

    boxfill8(vram, width, COL8_FFFFFF, 3, height - 24, 59, height - 24);
    boxfill8(vram, width, COL8_FFFFFF, 2, height - 24, 2, height - 4);
    boxfill8(vram, width, COL8_848484, 3, height - 4, 59, height - 4);
    boxfill8(vram, width, COL8_848484, 59, height - 23, 59, height - 5);
    boxfill8(vram, width, COL8_000000, 2, height - 3, 59, height - 3);
    boxfill8(vram, width, COL8_000000, 60, height - 24, 60, height - 3);

    boxfill8(vram, width, COL8_848484, width - 47, height - 24, width - 4, height - 24);
    boxfill8(vram, width, COL8_848484, width - 47, height - 23, width - 47, height - 4);
    boxfill8(vram, width, COL8_FFFFFF, width - 47, height - 3, width - 4, height - 3);
    boxfill8(vram, width, COL8_FFFFFF, width - 3, height - 24, width - 3, height - 3);

    for (;;)
    {
        _asm_halt();
    }
}

void init_palette(void)
{
    static unsigned char table_rgb[16 * 3] = {
        0x00, 0x00, 0x00,
        0xff, 0x00, 0x00,
        0x00, 0xff, 0x00,
        0xff, 0xff, 0x00,
        0x00, 0x00, 0xff,
        0xff, 0x00, 0xff,
        0x00, 0xff, 0xff,
        0xff, 0xff, 0xff,
        0xc6, 0xc6, 0xc6,
        0x84, 0x00, 0x00,
        0x00, 0x84, 0x00,
        0x84, 0x84, 0x00,
        0x00, 0x00, 0x84,
        0x84, 0x00, 0x84,
        0x00, 0x84, 0x84,
        0x84, 0x84, 0x84};
    set_palette(0, 15, table_rgb);
}

void set_palette(int start, int end, unsigned char *rgb)
{
    int eflags = _asm_load_eflags();

    _asm_cli();

    _asm_out8(0x03c8, start);

    for (int i = start; i <= end; i++)
    {
        _asm_out8(0x03c9, rgb[0] / 4);
        _asm_out8(0x03c9, rgb[1] / 4);
        _asm_out8(0x03c9, rgb[2] / 4);
        rgb += 3;
    }

    _asm_store_eflags(eflags);
}

void boxfill8(unsigned char *vram, int width, unsigned char c, int x0, int y0, int x1, int y1)
{
    for (int y = y0; y <= y1; y++)
    {
        for (int x = x0; x <= x1; x++)
            vram[y * width + x] = c;
    }
}

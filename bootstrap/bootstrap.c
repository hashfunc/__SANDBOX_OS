void halt(void);

void main(void)
{
    fin:
        halt();
        goto fin;
}

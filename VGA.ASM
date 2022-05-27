vga_width  = 320
vga_height = 200

vga_init:
    mov ax, 13h
    int 10h
    mov ax, 0a000h
    mov es, ax
    ret

vga_deinit:
    mov ax, 3h
    int 10h
    ret

macro vga_set_px x, y, color
    {
        mov ax, y
        imul ax, vga_width
        add ax, x
        mov di, ax
        mov al, color
        stosb
    }

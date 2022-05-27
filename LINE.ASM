; Bresenham's line algorithm from wikipedia:
; plotLine(x0, y0, x1, y1)
;    dx = abs(x1 - x0)
;    sx = x0 < x1 ? 1 : -1
;    dy = -abs(y1 - y0)
;    sy = y0 < y1 ? 1 : -1
;    error = dx + dy
;
;    while true
;        plot(x0, y0)
;        if x0 == x1 && y0 == y1 break
;        e2 = 2 * error
;        if e2 >= dy
;            if x0 == x1 break
;            error = error + dy
;            x0 = x0 + sx
;        end if
;        if e2 <= dx
;            if y0 == y1 break
;            error = error + dx
;            y0 = y0 + sy
;        end if
;    end while

line_draw:
    push bp
    mov bp, sp
    sub sp, 10

    ; parameters
    color   equ [word bp+12]
    x0      equ [word bp+10]
    y0      equ [word bp+8]
    x1      equ [word bp+6]
    y1      equ [word bp+4]

    ; local variables
    d_x equ [word bp-2]
    s_x equ [word bp-4]
    d_y equ [word bp-6]
    s_y equ [word bp-8]
    e_2 equ [word bp-10]

    ; d_x = abs(x1 - x0)
    mov ax, x1
    sub ax, x0
    test ax, ax
    jns .x1_gt_x0
    neg ax
.x1_gt_x0:
    mov d_x, ax

    ; s_x
    mov ax, x0
    cmp ax, x1
    jb .x0_lt_x1
    mov word s_x, -1
    jmp @f
.x0_lt_x1:
    mov word s_x, 1
@@:

    ; d_y = -abs(y1 - y0)
    mov ax, y1
    sub ax, y0
    test ax, ax
    jns .y1_gt_y0
    neg ax
.y1_gt_y0:
    neg ax
    mov d_y, ax

    ; s_y
    mov ax, y0
    cmp ax, y1
    jb .y0_lt_y1
    mov word s_y, -1
    jmp @f
.y0_lt_y1:
    mov word s_y, 1
@@:

    ; error = d_x + d_y
    mov bx, d_x
    add bx, d_y


.draw:
    vga_set_px x0, y0, color
    mov ax, x0
    cmp ax, x1
    jne @f
    mov ax, y0
    cmp ax, y1
    jne @f
    jmp .end
@@:
    ; x0 != x1 || y0 != y1
    mov ax, bx
    imul ax, 2 ; e_2 = 2 * error
    mov e_2, ax
    cmp ax, d_y
    jl .e_2_lt_dy
    mov ax, x0
    cmp ax, x1
    je .end
    add bx, d_y
    mov ax, x0
    add ax, s_x
    mov x0, ax ; x0 = x0 + sx
.e_2_lt_dy:
    mov ax, e_2
    cmp ax, d_x ; if e_2 <= dx
    jg .draw
    mov ax, y0
    cmp ax, y1
    je .end
    add bx, d_x ; error = error + dx
    mov ax, y0
    add ax, s_y ; y0 = y0 + sy
    mov y0, ax
    jmp .draw

.end:
    mov sp, bp
    pop bp
    ret 10

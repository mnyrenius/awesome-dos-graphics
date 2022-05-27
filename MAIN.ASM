format MZ

entry main:start
stack 100h

segment main
include 'vga.asm'
include 'line.asm'

start:
    call vga_init

    ; 1st triangle
    push 12
    push 10
    push 70
    push 50
    push 160
    call line_draw

    push 12
    push 50
    push 160
    push 70
    push 80
    call line_draw

    push 12
    push 70
    push 80
    push 10
    push 70
    call line_draw

    ; 2nd triangle
    push 10
    push 180
    push 50
    push 150
    push 1
    call line_draw

    push 10
    push 150
    push 1
    push 70
    push 180
    call line_draw

    push 10
    push 70
    push 180
    push 180
    push 50
    call line_draw


    ; 3rd triangle
    push 11
    push 180
    push 150
    push 120
    push 160
    call line_draw

    push 11
    push 120
    push 160
    push 130
    push 180
    call line_draw

    push 11
    push 130
    push 180
    push 180
    push 150
    call line_draw

    mov ah, 0
    int 16h

    call vga_deinit

    mov ah, 4ch
    int 21h

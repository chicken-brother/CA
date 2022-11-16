; 2 labaratorine uzduotis 18 variantas Antanas Vasiliauskas
%include 'yasmmac.inc'

org 100h


section .text
    startas:

    macPutString 'Antanas Vasiliauskas 1 kursas 3 grupe', crlf, '$'
    macPutString 'Iveskite rezultatu failo pavadinima', crlf, '$'
    macPutString 'Ivesk skaitomo failo varda', crlf, '$'

    mov al, 128
    mov dx, output_filename
    call procGetStr
    macNewLine

    ; Open file
    mov dx, input_filename
    call procFOpenForReading

    read_loop:
    call read_line
    cmp ax, 0 ; - ax - bytes read. If 0 means EOF
    jz eof1
    call print_buffer
    jmp read_loop
    eof1:
   
   mov ah, 4Ch
   int 21h


read_line:
    ; Input: bx - file descriptor, variable buffer 256 bytes reserved, variable cursor: dw storing offset from file orgin.
    ; Output ax - how many bytes read. If 0 means EOF. Buffer is filled with string line. Newline is replaced with '$'. Cursor is changed to point to next line.
    
    push bx ; - File descriptor
    
    ; Read 256 bytes to the buffer
    mov dx, buffer
    mov cx, 256
    mov ah, 0x3F
    int 0x21

    ; If EOF, end
    cmp ax, 0
    jz eof
    
    ;find newline
    mov bx, 0
    cr_loop:
    inc bx
    cmp byte [bx + buffer - 1], 0Ah
    jnz cr_loop


    add [cursor], bx
    mov byte [bx+buffer], '$'

    ; fseek to cursor (last newline)
    pop bx
    push ax
    push bx
    push cx
    push dx
    mov ah, 42h
    mov al, 0
    mov cx, 0
    mov dx, [cursor]
    int 21h
    pop dx
    pop cx
    pop bx
    pop ax
    push bx
    
    eof:
    pop bx
    ret


print_buffer:
    push ax
    push bx
    push cx
    push dx
    mov dx, buffer
    mov ah, 09
    int 0x21 
    pop dx
    pop cx
    pop bx
    pop ax
    ret

%include 'yasmlib.asm'


section .data
    input_filename:
        db 'failas.csv', 00
    output_filename:
        times 256 db 00
    number_count:
        db 00, 00
    debug:
        db 00, 00, crlf, '$'
    buffer:
        times 256 db 00, crlf, '$'
    cursor:
        dw 0000
    
section .bss

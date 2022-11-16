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
    ; bx file descriptor
    ; CF = 1, if error
    

    ;adc byte [debug_carry], 30h
    ;mov dx, debug_carry
    ;mov ah, 09 
    ;int 0x21 

    call print_carry


    
    read_loop:
    ; Įvestis: bx - failo deskriptorius, dx - buferis, cx - kiek baitų nuskaityti
    mov bx, bx
    mov dx, buffer
    mov cx, 128
    mov ah, 0x3F
    int 0x21

    cmp ax, 0
    jz eof
    
    ;find newline
    cr_loop:
    inc word [index]
    push bx
    mov bx, buffer
    add bx, [index]
    sub bx, 1
    cmp byte [bx], 0Ah
    pop bx
    jnz cr_loop

    push ax
    mov ax, [cursor]
    add ax, [index]
    mov [cursor], ax
    call print_buffer
    mov word [index], 0
    pop ax

    ; fseek to cursor (last newline)
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

    ;push ax
    ;mov ax, [cursor]
    ;call procPutInt16
    ;pop ax

    
    
    ; EOF = 0, if not EOF, jump
    jmp read_loop
    eof:

    

    ;call print_carry
    ;call print_ax
    ;call print_buffer


   ; Read line from file (skip)
   ; Loop to read file line by line
   ; and call the function
   
   mov ah, 4Ch
   int 21h


print_carry:
    push ax
    push bx
    push cx
    push dx
    mov word [debug], 30h
    adc word [debug], 0
    mov dx, debug
    mov ah, 09
    int 0x21 
    pop dx
    pop cx
    pop bx
    pop ax
    ret



print_ax:
    push ax
    push bx
    push cx
    push dx
    mov word [debug], ax
    add word [debug], 30h
    mov dx, debug
    mov ah, 09
    int 0x21 
    pop dx
    pop cx
    pop bx
    pop ax
    ret

print_buffer:
    push ax
    push bx
    push cx
    push dx
    mov dx, buffer
    mov bx, [index]
    mov byte [bx+buffer], '$'
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
    index:
        dw 0000
    



section .bss

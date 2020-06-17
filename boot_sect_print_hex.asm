print_hex:
    pusha

    mov cx, 0 ; indeks (zmienna pomocnicza)
hex_loop:
    cmp cx, 4 ; loop 4 razy
    je end
    
    mov ax, dx ;używamy AX jako rejestru roboczego
    and ax, 0x000f ; 0x1234 -> 0x0004 zerowanie pierwszych trzech
    add al, 0x30 ; + 0x30 do N, żeby przekonwertować na (ASCII) "N"
    cmp al, 0x39 ; if > 9, dodaj dodatkowe 8, żeby uzyskać od 'A' do 'F'
    jle step2
    add al, 7 ; 'A' to ASCII 65, a nie 58 => 65-58=7

step2:
    mov bx, HEX_OUT + 5 ; base + długość
    sub bx, cx  ; indeks
    mov [bx], al ; kopiowanie ASCII char'a w 'al' do miejsca wskazywanego przez 'bx'
    ror dx, 4 ; 0x1234 -> 0x4123 -> 0x3412 -> 0x2341 -> 0x1234

    add cx, 1
    jmp hex_loop

end:
    mov bx, HEX_OUT
    call print

    popa
    ret

HEX_OUT:
    db '0x0000',0 ; pamięć na string

print:
    pusha

; while (string[i] != 0) { print string[i]; i++ }

; szukanie nullowego bajtu na końcu stringa:
start:
    mov al, [bx] ; 'bx' - adres string'a
    cmp al, 0 
    je done

    ; print z pomocą BIOSu
    mov ah, 0x0e
    int 0x10 ; 'al' już zawiera char

    ; inkrementuj pointer i zapętl
    add bx, 1
    jmp start

done:
    popa
    ret



print_nl:
    pusha
    
    mov ah, 0x0e
    mov al, 0x0a ; newline char
    int 0x10
    mov al, 0x0d ; carriage return
    int 0x10
    
    popa
    ret

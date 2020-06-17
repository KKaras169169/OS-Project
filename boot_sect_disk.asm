; ładuje 'dh'-sektory z dysku 'dl' do ES:BX
disk_load:
    pusha
    ; czytanie z dysku wymaga ustawienia odpowiednich wartości w rejestrach,
    ; więc nadpisywane są paramerty wejścia z 'dx' (dlatego push na stos)

    push dx

    mov ah, 0x02 ; ah <- int 0x13 function. 0x02 = 'read'
    mov al, dh   ; al <- liczba sektorów do przeczytania (0x01 .. 0x80)
    mov cl, 0x02 ; cl <- sektor (0x01 .. 0x11)
                 ; 0x01 BOOT SECTOR, więc 0x02 jest pierwszym wolnym 
    mov ch, 0x00 ; ch <- cylinder (0x0 .. 0x3FF, upper 2 bits in 'cl')
    ; dl <- numer dysku. Ustawiany jako parametr i pobierany z BIOSu
    ; (0 = floppy, 1 = floppy2, 0x80 = hdd, 0x81 = hdd2)
    mov dh, 0x00 ; dh <- head number (0x0 .. 0xF)

    ; [es:bx] <- pointer do bufora, gdzie dane będą zapisywane
    ; "wołający" ustawia (jest to też standardowa lokacja dla int 13h
    int 0x13      ; BIOS interrupt
    jc disk_error ; if error (w carry bit)

    pop dx
    cmp al, dh    ; BIOS ustawia 'al' na # sektorów przeczytanych 
    jne sectors_error
    popa

    ret


disk_error:
    mov bx, DISK_ERROR
    call print
    call print_nl
    mov dh, ah ; ah = error code, dl = dysk, który zwrócił błąd
    call print_hex ; KODY BŁĘDÓW: http://stanislavs.org/helppc/int_13-1.html
    jmp disk_loop

sectors_error:
    mov bx, SECTORS_ERROR
    call print

disk_loop:
    jmp $

DISK_ERROR: db "Disk read error", 0
SECTORS_ERROR: db "Incorrect number of sectors read", 0

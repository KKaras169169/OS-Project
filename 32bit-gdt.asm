gdt_start: ; don't remove the labels, they're needed to compute sizes and jumps
    ; Pierwszy deskryptor NULL
    dd 0x0 ; 4 byte
    dd 0x0 ; 4 byte

;Segment kodu (code/text) base = 0x00000000, długość = 0xfffff
gdt_code: 
    dd 0x0000ffff    ; segment length, bits 0-15

    db 0x0       ; segment base, bits 16-23
    db 10011010b ; flags (8 bits)
    db 11001111b ; flags (4 bits) + segment length, bits 16-19
    db 0x0       ; segment base, bits 24-31

; Segment danych (data). base i długość takie jak w Segmencie kodu.
gdt_data:
    dd 0x0000ffff

    db 0x0
    db 10010010b
    db 11001111b
    db 0x0

gdt_end:

; GDT descriptor
gdt_descriptor:
    dw gdt_end - gdt_start - 1 ; size (16 bit), always one less of its true size
    dd gdt_start ; address (32 bit)

; define some constants for later use
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

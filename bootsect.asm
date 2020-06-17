[org 0x7c00]
KERNEL_OFFSET equ 0x1000 

    mov [BOOT_DRIVE], dl ; Bios ustawia dysk w 'dl'
    mov bp, 0x9000
    mov sp, bp

    mov bx, MSG_REAL_MODE 
    call print
    add sp, 2 
    call print_nl
    call load_kernel ; czytanie kernela z dysku
TEST_LABEL:
    call switch_to_pm ; wyłącza przerwania, ładuje GDT, i skacze do 'BEGIN_PM' (begin protected mode)
    jmp $ ; Never executed

%include "boot_sect_print.asm"
%include "boot_sect_print_hex.asm"
%include "boot_sect_disk.asm"
%include "32bit-gdt.asm"
%include "32bit-print.asm"
%include "32bit-switch.asm"

;TOJESTOK_START
[bits 16]
load_kernel:
    mov bx, MSG_LOAD_KERNEL
    call print 
    add sp, 2
    call print_nl

    mov bx, KERNEL_OFFSET ; czytaj z dysku i wrzuć do 0x1000
    mov dh, 2

    mov dl, [BOOT_DRIVE]
    call disk_load

    jmp TEST_LABEL
;TOJESTOK_END


[bits 32]
BEGIN_PM:
    mov ebx, MSG_PROT_MODE
    call print_string_pm
    call KERNEL_OFFSET ; zwróć kontrolę do kernela
    jmp $ ; zostań do momentu zwrócenia kontroli z kernela (może nigdy)


BOOT_DRIVE db 0 ;  'dl' może zostać nadpisany, więc dodatkowo przechowywany tutaj
MSG_REAL_MODE db "Started in 16-bit Real Mode", 0
MSG_PROT_MODE db "  Landed in 32-bit Protected Mode", 0
MSG_LOAD_KERNEL db "Loading kernel into memory", 0
MSG_DEBUG db "Tutaj jestem", 0

; padding
times 510 - ($-$$) db 0
dw 0xaa55

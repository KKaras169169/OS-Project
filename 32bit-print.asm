[bits 32] ; using 32-bit protected mode

; this is how constants are defined
VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0a ; kolorowanie (wbrew pozorom nie jest wcale białe na czarnym,
; tylko zielone na czarnym)

print_string_pm:
    pusha
    mov edx, VIDEO_MEMORY

print_string_pm_loop:
    mov al, [ebx] ; [ebx] = adres znaku
    mov ah, WHITE_ON_BLACK

    cmp al, 0 ; if end of string
    je print_string_pm_done

    mov [edx], ax ; zapamiętaj znak + attr w Video Memory
    add ebx, 1 ; kolejny char
    add edx, 2 ; kolejna pozycja w Video Memory

    jmp print_string_pm_loop

print_string_pm_done:
    popa
    ret

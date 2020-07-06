; engine.asm
BITS 64

section .data
    uci_cmd db 'uci'
    uci_cmd_len equ $ - uci_cmd
    quit_cmd db 'quit'
    quit_cmd_len equ $ - quit_cmd
    ready_cmd db 'isready'
    ready_cmd_len equ $ - ready_cmd
    id_cmd db 'id name small', 0xA, 'id author Nerd on discord', 0xA, 'uciok', 0xA
    id_cmd_len equ $ - id_cmd
    readyok_cmd db 'readyok', 0xA
    readyok_cmd_len equ $ - readyok_cmd
    newln db '', 0xA, 0xD
    newln_len equ $ - newln

section .bss
    cmd resb 256

section     .text
    global      _start

_start:
    call uci_loop
    jmp exit

uci_loop:
    mov eax,3           ; sys_read
    mov ebx,2           ; stdin
    mov ecx,cmd         ; store into cmd
    mov edx,256         ; str size of 256
    int 80h

    ; uci command
    mov esi, cmd
    mov edi, uci_cmd
    mov ecx, 3
    cld
    repe cmpsb
    jecxz print_uci

    ; quit command
    mov esi, cmd
    mov edi, quit_cmd
    mov ecx, 4
    cld
    repe cmpsb
    jecxz exit

    ; isready command
    mov esi, cmd
    mov edi, ready_cmd
    mov ecx, 7
    cld
    repe cmpsb
    jecxz print_ready

    jmp loop

print_uci:
    mov eax,4
    mov ebx,1
    mov ecx,id_cmd
    mov edx,id_cmd_len
    int 80h
    jmp loop

print_ready:
    mov eax,4
    mov ebx,1
    mov ecx,readyok_cmd
    mov edx,readyok_cmd_len
    int 80h
    jmp loop

loop:
    jmp uci_loop

exit:
    mov eax,1
    int 80h

section .data align=1
greet: db "Welcome to the my humble calculator, made entirely in assembly!", 10 ;greet text
greetlen: equ $-greet
queryprompt: db "What operation would you like to do? (+,-,/,*)"
querypromptlen: equ $-queryprompt
buffer: db 64 dup(0);allocate 1kb buffer
bufferlen: equ $-buffer
byebye: db "See you soon!", 10
byebyelen: equ $-byebye
readinput: db "Enter number: "
readinputlen: equ $-readinput
bufferstore: db 64 dup(0)
bufferstorelen: equ $-bufferstore
badoperation: db "Bad operation specified!", 10
badoperationlen: equ $-badoperation


section .text align=1
global _start

read_input_number:
    push rbp
    mov rbp, rsp
    mov rax, 1
    mov rdi, 1
    lea rsi, [readinput]
    mov rdx, readinputlen
    syscall
    mov rax, 0
    mov rdi, 0
    lea rsi, [buffer]
    mov rdx, bufferlen
    syscall

    lea rsi, [buffer]
    mov rcx, rax
    sub rcx, 1
    mov rax, 0
    mov rbx, 10
    cmp rcx, 0
    je .end
.input_number_loop:
    mul rbx
    movzx rdx, byte [rsi]
    add rax, rdx
    sub rax, '0'
    inc rsi
    loop .input_number_loop
.end:
    mov rsp, rbp
    pop rbp
    ret

_start:
    mov rax, 1 ;sys_write
    mov rdi, 1 ;fd (stdout)
    lea rsi, [greet] ;data
    mov rdx, greetlen ;len
    syscall

start_query:
    mov rax, 1 ;sys_write
    mov rdi, 1 ;fd (stdout)
    lea rsi, [queryprompt] ;buf
    mov rdx, querypromptlen ;len
    syscall

    mov rax, 0 ;sys_read
    mov rdi, 0 ;fd (stdin)
    lea rsi, [buffer] ;buf
    mov rdx, bufferlen; len
    syscall

    cmp rax, 1; if input len==1, i.e. only new line, i.e. empty input
    je program_end ;then quit

    mov al, byte [buffer]
    cmp al, '*'
    je .continue_program
    cmp al, '+'
    je .continue_program
    cmp al, '-'
    je .continue_program
    cmp al, '/'
    je .continue_program
    mov rax, 1
    mov rdi, 1
    lea rsi, [badoperation]
    mov rdx, badoperationlen
    syscall
    jmp start_query
.continue_program:
    mov byte [bufferstore], al

    call read_input_number
    push rax
    call read_input_number
    push rax

    cmp byte [bufferstore], '+'
    je addition

    cmp byte [bufferstore], '-'
    je subtraction

    cmp byte [bufferstore], '*'
    je multiplication

    cmp byte [bufferstore], '/'
    je division

addition:
    pop rbx
    pop rax
    add rax, rbx
    jmp display_result

subtraction:
    pop rbx
    pop rax
    sub rax, rbx
    jmp display_result

multiplication:
    pop rbx
    pop rax
    mul rbx
    jmp display_result

division:
    pop rbx
    pop rax
    xor rdx, rdx
    div rbx
    jmp display_result

display_result:
    ;rax holds the value to be displayed
    lea rsi, [buffer+bufferlen-1]
    mov byte [rsi], 10
display_div_loop:
    dec rsi
    mov rbx, 10
    xor rdx, rdx
    div rbx ;rax quot, rdx rem
    mov byte [rsi], dl
    add byte [rsi], '0'
    cmp rax, 0
    jne display_div_loop

    mov rax, 1 ;write
    mov rdi, 1 ;stdout
    lea rdx, [buffer+bufferlen]
    sub rdx, rsi
    syscall

    jmp start_query



program_end:
    mov rax, 1 ;sys_write
    mov rdi, 1 ;stdout
    lea rsi, [byebye]
    mov rdx, byebyelen
    syscall

    mov rdi, 0 ;exit_code
    mov rax, 60 ;sys_exit
    syscall


data segment
segtab  db      3Fh, 06h, 5Bh, 4Fh, 66h, 6Dh	; 0-5
        db      7Dh, 07h, 7Fh, 6Fh, 77h, 7Ch	; 6-B
        db      39h, 5Eh, 79h, 71h		; C-F

dgtasc  db      "0123456789ABCDEF"
spcasc  db      " "
clnasc  db      ":"

mtrcw   db      00000001b, 00000011b, 00000010b, 00000110b
        db      00000100b, 00001100b, 00001000b, 00001001b

mtrccw  db      00001001b, 00001000b, 00001100b, 00000100b
        db      00000110b, 00000010b, 00000011b, 00000001b

mtrcwb  equ     offset mtrcw
mtrcwe  equ     offset mtrcw + 8
mtrccwb equ     offset mtrccw
mtrccwe equ     offset mtrccw + 8

mtrtabs equ     mtrcwe - mtrcwb			; motor signal table size
data ends

;; macro definitions
p0809   equ     08h
padeoc	equ     18h

p8279   equ     10h
p8279c  equ     11h

p8255a  equ     80h
p8255c  equ     83h

p8250   equ     180h
p8250c  equ     185h

pptr    equ     100h
p377    equ     28h
pbusy   equ     18h

segext  equ     8000h
dlycnt  equ     0FFFFh	; delay count
numspc  equ     3

dftspd  equ     0F00h	; default motor speed
minspd  equ	1600h	; minimal motor speed
maxspd  equ	0300h	; maximal motor speed
dltspd  equ     0100h	; delta speed

leddsp  macro
    push ax
    mov al, segtab[bx]
    not al
    out p8279, al
    pop ax
endm

leddb   macro   $dgt
    push bx
    push cx
    mov bx, $dgt
    and bx, 00F0h
    mov cl, 4
    shr bx, cl
    leddsp
    mov bx, $dgt
    and bx, 000Fh
    leddsp
    pop cx
    pop bx
endm

waitptr macro
local again
again:
    in al, pbusy
    test al, 80h
    jnz again
endm

ptrprt  macro $chr
    waitptr
    mov al, $chr
    out p377, al
    mov dx, pptr
    out dx, al
endm

prtchr  macro $chr
    waitptr
    ptrprt $chr
endm

prtwrd  macro
    mov bx, bp
    and bx, 00F0h
    mov cl, 4
    shr bx, cl
    ptrprt dgtasc[bx]
    mov bx, bp
    and bx, 000Fh
    ptrprt dgtasc[bx]
endm

delay   macro   $loops
local again
    push cx
    mov cx, $loops
again:
    loop again
    pop cx
endm

;; stack definition
stack segment
  stk   db      100 dup(?)
  top   equ     length stk
stack ends

code segment
     assume cs:code, ds:data, ss:stack
main:
    mov ax, data
    mov ds, ax
    mov ax, segext
    mov es, ax
    mov ax, stack
    mov ss, ax
    mov ax, top
    mov sp, ax
    xor di, di
    mov si, mtrcwb
    mov bx, offset input
    mov cx, dftspd

    ;; init 8279
    mov al, 11001101b	; 清除显示器ram和fifo
    out p8279c, al
    
    mov al, 00101010b	; 设置分频系数为10
    out p8279c, al
    
    mov al, 00000000b	; 设置键盘显示器方式
    out p8279c, al

    mov al, 01010000b	; 设置读fifo/传感器ram模式
    out p8279c, al

    mov al, 10010000b	; 设置写显示器
    out p8279c, al

    ;; init 8255
    mov al, 10000000b
    out p8255c, al

;; input key
input:
    in al, p8279c
    test al, 00000111b	; 测试fifo ram是否为空
    jz run

    ;; process key
    in al, p8279
key1:
    cmp al, 0C0h	; key 1
    jne key2
    mov bx, offset ad0809
    jmp run
key2:
    cmp al, 0C8h	; key 2
    jne key3
    mov bx, offset motor
    jmp run
key3:
    cmp al, 0D0h
    jne key4
    mov bx, offset input
    jmp run
key4:
    cmp al, 0D8h	; key 4
    je exit

run:
    jmp bx

exit:
    int 20h

;; ad0809 module
ad0809:
    xor al, al
    out p0809, al	; 10H是0809的端口0, 开始采样

waitstart:
    in al, padeoc	; 读入0809的eoc
    test al, 01h
    jnz waitstart	; 如果eoc不为0，则转换尚未启动

waitfinish:
    in al, padeoc
    test al, 01h
    jz waitfinish	; 如果eoc不为1，则转换尚未结束

    in al, p0809

    ;; display on led
    mov dl, al
    mov al, 10010000b	; 由于设定有8个LED实际只有4个，故每次设置写显示器
    out p8279c, al
    leddb di		; display addr
    leddb dx		; display value
    ;; output to printer
    push bx
    push cx
    push dx
    push si
    mov si, dx
    mov bp, di
    and bp, 0FF00h
    mov cl, 8
    shr bp, cl
    prtwrd		; print high addr
    mov bp, di
    and bp, 00FFh
    prtwrd		; print low addr
    prtchr clnasc
    mov bp, si
    prtwrd		; print value
    mov cx, numspc
spcagn:
    prtchr spcasc
    loop spcagn
    waitptr
    pop si
    pop dx
    pop cx
    pop bx
    
    ;; store to memory
    mov es:[di], dl
    inc di

    delay dlycnt

    jmp input

;; motor module
motor:
    ;; read and process key
    mov dx, p8250c
    in al, dx
    test al, 00000001b
    jz mtrrun
    mov dx, p8250
    in al, dx
keyu:
    cmp al, 'u'			; key 'u'
    jne keyd
    cmp si, mtrcwe
    jb mtrrun			; clockwise rotating now
    sub si, mtrtabs		; switch to conter clockwise
    jmp mtrrun
keyd:
    cmp al, 'd'			; key 'd'
    jne keyp
    cmp si, mtrccwb
    jae mtrrun			; counter clockwise rotating now
    add si, mtrtabs		; switch to conter clockwise
    jmp mtrrun
keyp:
    cmp al, '+'			; key '+'
    jne keyeq
keyeq:
    cmp al, '='			; key '=', shift '=' -> '+'
    jne keym
    cmp cx, maxspd
    jbe mtrrun			; max speed reached
    sub cx, dltspd
    jmp mtrrun
keym:
    cmp al, '-'			; key '-'
    jne mtrrun
    cmp cx, minspd
    jae mtrrun			; min speed reached
    add cx, dltspd
    jmp mtrrun

mtrrun:
    mov al, [si]
    out p8255a, al
    delay cx
    inc si
    cmp si, mtrcwe
    je rstmtr
    cmp si, mtrccwe
    je rstmtr
    jmp input
rstmtr:
    sub si, mtrtabs
    jmp input

code ends
end main

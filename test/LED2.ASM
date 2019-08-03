.MODEL SMALL
.DATA
B1      db      ?
B2      db      ?
B3      db      ?
B4      db      ?

SEGTAB  DB      3FH,06H,5BH,4FH,66H,6DH     ;0-5
        DB      7DH,07H,7FH,6FH,77H,7CH     ;6-B
        DB      39H,5EH,79H,71H,40H

.CODE
start:
        mov ax,@DATA
        mov ds,ax
        ;清除显示器ram和fifo
        mov al,0cdh
        out 11h,al
wat:
        in al,11h
	test al,80h
        jnz wat
	;设置分频系数为10
        mov al,2ah
        out 11h,al
        ;设置键盘显示器方式
        mov al,00h
        out 11h,al
        ;设置写显示器
        mov al,90h
        out 11h,al
        
        ;将数据写入显示器的ram
       
        mov al,9h
        mov ah,0h
        MOV     SI,OFFSET SEGTAB
        ADD     SI,AX
        MOV     AL,[SI]
        NOT     AL
 
        out 10h,al
        mov al,1h
        mov ah,0h
        MOV     SI,OFFSET SEGTAB
        ADD     SI,AX
        MOV     AL,[SI]
        NOT     AL
        out 10h,al

        mov al,0Fh
        mov ah,0h
        mov     si,offset segtab
        add     si,ax
        mov     al,[si]
        not     al
        out 10h,al

        MOV AX,0Eh
        mov     si,offset segtab
        add     si,ax
        mov     al,[si]
        not     al
        out 10h,al
       
        int 20h
        end start


;LED显示91FE
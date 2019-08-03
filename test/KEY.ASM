DATA SEGMENT
SEGTAB  DB      3FH,06H,5BH,4FH,66H,6DH     ;0-5
        DB      7DH,07H,7FH,6FH,77H,7CH     ;6-B
        DB      39H,5EH,79H,71H,40H
DATA ENDS

CODE SEGMENT
     ASSUME CS:CODE,DS:DATA
START:
    MOV AX,data
    MOV DS,AX
    ;清除显示器ram和fifo
    MOV AL,0CDH  ;11001101
    OUT 11H,AL
    ;设置分频系数为10
    MOV AL,2AH;  00101010(10)
    OUT 11H,AL
    ;设置键盘显示器方式
    MOV AL,00H;
    OUT 11H,AL
    XOR AL,AL
    ;读fifo/传感器ram
    MOV AL,50H  ;01010000
    OUT 11H,AL
        ;设置写显示器
        mov al,90h
        out 11h,al  

    MOV BX,2000H

INPUT:
    XOR AL,AL
    IN AL,11H
    AND AL,07H
    JZ INPUT

    IN AL,10H
    MOV [BX],AL

ECHO:
        MOV     SI,OFFSET SEGTAB
        MOV     AL,[SI]
        NOT     AL
        out 10h,al
    INT 20H


CODE ENDS
    END START
    
;第一个LED显示0,并在内存DS:2000H处存入按键的键码
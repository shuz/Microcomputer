




;DATA SEGMENT
 ;   DIG_NUM DB 128 DUP(0)
;DATA ENDS

CODE SEGMENT
     ASSUME CS:CODE

START:
     MOV AX,0H
     MOV DS,AX
     MOV BX,1000H
     MOV AL,0
     MOV CX,10
AGAIN:     OUT 08H,AL    ;10H是0809的端口0，开始采样

POLL:
     IN AL,18H     ;18H是0809的EOC
     TEST AL,01H   ;如果eoc不为0，则转换尚未启动
     JNZ POLL
NOEND:
     IN AL,18H
     TEST AL,01H
     JZ NOEND      ;转换结束
     IN AL,08H
     MOV [BX],AL   ;将转换后的数据存起来。
     INC BX
     LOOP AGAIN

     INT 20H
CODE ENDS
     END START


;电位器采样10次值,值存入DS:1000H处     
     

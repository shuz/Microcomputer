




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
AGAIN:     OUT 08H,AL    ;10H��0809�Ķ˿�0����ʼ����

POLL:
     IN AL,18H     ;18H��0809��EOC
     TEST AL,01H   ;���eoc��Ϊ0����ת����δ����
     JNZ POLL
NOEND:
     IN AL,18H
     TEST AL,01H
     JZ NOEND      ;ת������
     IN AL,08H
     MOV [BX],AL   ;��ת��������ݴ�������
     INC BX
     LOOP AGAIN

     INT 20H
CODE ENDS
     END START


;��λ������10��ֵ,ֵ����DS:1000H��     
     
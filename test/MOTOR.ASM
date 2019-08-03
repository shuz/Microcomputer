;        P50D = 180H
;        P50S = 185H
	P55A = 80H
        p55CTR = 83H

DATA SEGMENT
	MOTORDIRE DB 0H		;步进电机方向，0正转'U'，1反转'D'
	MDELAY DW 0FF0H		;步进电机延时
DATA ENDS

CODE SEGMENT
	ASSUME CS:CODE,DS:DATA
START:

MAIN PROC FAR
	MOV AX,DATA
	MOV DS,AX

        MOV AL,10000000B
        OUT p55CTR,AL
	MOV AL,01H
	MOV MOTORDIRE,AL
       MOV DX,20H

MLOOP:	CALL MOTOR1
       DEC DX
       JNZ MLOOP

	INT 20H
MAIN ENDP

MOTOR1 PROC NEAR		;MOTOR2 PROC NEAR      	  
	MOV AL,00000001B        ;    	MOV AL,00000001B        
	OUT P55A,AL             ;    	OUT P55B,AL             
	MOV CX,MDELAY           ;    	MOV CX,MDELAY           
DELAY11:LOOP DELAY11            ;DELAY21:LOOP DELAY21        
	MOV AL,00000011B        ;    	MOV AL,00001001B        
	OUT P55A,AL             ;    	OUT P55B,AL             
	MOV CX,MDELAY           ;    	MOV CX,MDELAY           
DELAY12:LOOP DELAY12            ;DELAY22:LOOP DELAY22        
	MOV AL,00000010B        ;    	MOV AL,00001000B        
	OUT P55A,AL             ;    	OUT P55B,AL             
	MOV CX,MDELAY           ;    	MOV CX,MDELAY           
DELAY13:LOOP DELAY13            ;DELAY23:LOOP DELAY23        
	MOV AL,00000110B        ;    	MOV AL,00001100B        
	OUT P55A,AL             ;    	OUT P55B,AL             
	MOV CX,MDELAY           ;    	MOV CX,MDELAY           
DELAY14:LOOP DELAY14            ;DELAY24:LOOP DELAY24        
	MOV AL,00000100B        ;    	MOV AL,00000100B        
	OUT P55A,AL             ;    	OUT P55B,AL             
	MOV CX,MDELAY           ;    	MOV CX,MDELAY           
DELAY15:LOOP DELAY15            ;DELAY25:LOOP DELAY25        
	MOV AL,00001100B        ;    	MOV AL,00000110B        
	OUT P55A,AL             ;    	OUT P55B,AL             
	MOV CX,MDELAY           ;    	MOV CX,MDELAY           
DELAY16:LOOP DELAY16            ;DELAY26:LOOP DELAY26        
	MOV AL,00001000B        ;    	MOV AL,00000010B        
	OUT P55A,AL             ;    	OUT P55B,AL             
	MOV CX,MDELAY           ;    	MOV CX,MDELAY           
DELAY17:LOOP DELAY17            ;DELAY27:LOOP DELAY27        
	MOV AL,00001001B        ;    	MOV AL,00000011B        
	OUT P55A,AL             ;    	OUT P55B,AL             
	MOV CX,MDELAY           ;    	MOV CX,MDELAY           
DELAY18:LOOP DELAY18            ;DELAY28:LOOP DELAY28        
	RET                     ;    	RET	                    
MOTOR1 ENDP                     ;MOTOR2 ENDP   

CODE ENDS
END START

;马达正转
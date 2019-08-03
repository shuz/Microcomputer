.model small
.code

org 100h

start:	jmp main

y0	db 99	; Y0:	.DB	0
y1	db 99	; Y1:	.DB	0
qutb	db 0	; QUTB:	.DB	0
ab	db 0	; AB:	.DB	0

main:	MOV	dl, 0
	mov	al, 	Y1
	MOV	bh, al
	MOV	dh, al
	mov	al, 	Y0
	MOV	bl, al
NEXTA:	MOV	al, bl
	DEC	al
	JZ	DONEA
	MOV	bl, al
	MOV	al, dh
	ADD	al, bh
	MOV	dh, al
	JC	CARRYA
	JMP	NEXTA
CARRYA:	MOV	al, dl
	INC	al
	MOV	dl, al
	JMP	NEXTA

DONEA:	MOV	bh, 0
	MOV	bl, 100
	MOV	al, 0
	mov	qutb, al
NEXTB:	MOV	al, dh
	SUB	al, bl
	JnC	RSM1B
	mov	ab, al
	MOV	al, dl
	MOV	bl, 1
	SUB	al, bl
	JnC	RSM0B
	mov	al, 	QUTB
	MOV	dl, al
	JMP	RTP0C
RSM0B:	MOV	dl, al
	MOV	bl, 100
	mov	al, 	AB
RSM1B:	MOV	dh, al
	mov	al, 	QUTB
	INC	al
	mov	qutb, al
	JMP	NEXTB


RTP0C:	MOV	al, dl
	mov	y1, al
	MOV	dl, 0
	MOV	bh, 10
NEXTC:	MOV	al, dh
	SUB	al, bh
	JNC	AGAINC
	MOV	al, dl
	Rcr	al, 1
	Rcr	al, 1
	Rcr	al, 1
	Rcr	al, 1
	Rcr	al, 1
	and	al, 0F0h
	ADD	al, dh
	MOV	dh, al
	JMP	RTP1C
AGAINC:	MOV	dh, al
	MOV	al, dl
	INC	al
	MOV	dl, al
	JMP	NEXTC


RTP1C:	MOV	al, dh
	mov	y0, al
	mov	al, 	Y1
	MOV	dh, al
	MOV	dl, 0
	MOV	bh, 10
NEXTF:	MOV	al, dh
	SUB	al, bh
	JNC	AGAINf
	MOV	al, dl
	Rcr	al, 1
	Rcr	al, 1
	Rcr	al, 1
	Rcr	al, 1
	Rcr	al, 1
	and	al, 0f0h
	ADD	al, dh
	MOV	dh, al
	JMP	RTP2C
AGAINF:	MOV	dh, al
	MOV	al, dl
	INC	al
	MOV	dl, al
	JMP	NEXTF
RTP2C:	MOV	al, dh
	mov	y1, al
	mov	ah, 4ch
	int	21h
end	start

title: int1ch
.model	small

; macro definitions
scall	macro	$ah, $int
	mov	ah, $ah
	int	$int
	endm

dos	macro	$ah
	scall	$ah, 21h
	endm

kbd	macro	$ah
	scall	$ah, 16h
	endm

; print message
prtmsg	macro	msg
	mov	dx, msg
	dos	09h
	endm	

setvec	macro	$int, $rtn
	mov	al, $int
	mov	dx, offset $rtn
	dos	25h
	endm

getvec	macro	$int, $seg, $off
	mov	al, $int
	mov	$seg, es
	mov	$off, bx
	dos	35h
	endm

; end macro definitions

.code
	org	100h

start:	jmp	begin
seg1c	dw	0
off1c	dw	0
num1c	dw	0
sec5	equ	51h
msg	equ	$
	db	'How are you, Mr. Wang!', 0dh, 0ah, '$'
ctl_c	equ	03h
intn	equ	1ch

int1c	proc
	dec	num1c
	iret
	int1c	endp

begin:	mov	num1c, sec5
	getvec	intn, seg1c, off1c
	mov	ax, cs
	mov	ds, ax
	setvec	intn, int1c
again:	mov	ax, num1c
	test	ax, 0ffffh
	jz	smsg
	kbd	01h
	jz	again
	kbd	00h
	cmp	al, ctl_c
	jz	exit
	jmp	again
smsg:	prtmsg	msg
	mov	num1c, sec5
	jmp	again

exit:	mov	ds, seg1c
	setvec	intn, off1c
	dos	4ch
	end	start

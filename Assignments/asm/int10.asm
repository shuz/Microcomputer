title: int10
.model small
.code
	org	100h
main:	jmp	begin

;data
mode	db	?
char	equ	0dbh

; macro definitions
scall	macro	$ah, $int
	mov	ah, $ah
	int	$int
	endm

dos	macro	$ah
	scall	$ah, 21h
	endm

disp	macro	$ah
	scall	$ah, 10h
	endm

kbd	macro	$ah
	scall	$ah, 16h
	endm

; get display mode
gdispm	macro	addr
	disp	0fh
	mov	addr, al
	endm

; set display mode
; mode:
cch42	equ	01h
sdispm	macro	mode
	mov	al, mode
	disp	00h
	endm

; prepare position arguments
prppos	macro	x, y
	mov	bh, 0
	mov	dh, y
	mov	dl, x
	endm

; set cursor position with implicit parameters
setposi	macro
	disp	02h
	endm

; set cursor position
setpos	macro	x, y
	prppos	x, y
	setposi
	endm

; write to cursor position
; extra parameter: cx = repeat count, bl = attr
; attr: BRGBIRGB
blue	equ	10h
wrpos	macro	char
	mov	al, char
	mov	bh, 0
	disp	09h
	endm

; check key
chkkey	macro	key
	local	out
	kbd	01h
	jz	out
	kbd	00h
	cmp	al, key
	jnz	out
	jmp	exit
out:	
	endm

delay	macro
	local	wait
	mov	cx, 0FFFFh
wait:	loop	wait
	endm

; end macro definitions

begin:	gdispm	mode
	sdispm	cch42
	
x0	equ	10h
y0	equ	05h
x1	equ	1fh
y1	equ	14h
ctl_c	equ	03h

	prppos	x0, y0
	mov	bl, blue
again:	setposi
	mov	cx, 01h
	wrpos	char
	chkkey	ctl_c
	delay
	inc	dh
	cmp	dh, y1
	jl	again
	mov	dh, y0
	inc	dl
	cmp	dl, x1
	jl	again
	mov	dl, x0
	inc	bl
	jmp	again

exit:	sdispm	mode
	dos	4ch
	end	main
title: delblank
.model small
.code
	org	100h
main:	jmp	begin

;data
errmsg	equ	$
	db	'Disk operation error!', 0dh, 0ah, '$'

inname	equ	$
	db	'delblank.asm', 0h
outname	equ	$
	db	'outfile.txt', 0h

infile	dw	?
outfile	dw	?

buf1	equ	1000h
buf2	equ	3000h
bufsz	equ	2000h

; macro definitions
dos	macro	$ah
	mov	ah, $ah
	int	21h
	endm

; print message
prtmsg	macro	msg
	mov	dx, msg
	mov	ah, 09h
	int	21h
	endm	

; print a char
prtchr	macro	ch
	mov	dl, ch
	mov	ah, 02h
	int	21h
	endm

; create a normal file
fcrt	macro	name
	mov	dx, name
	mov	cx, 0
	dos	3ch
	jc	abort
	endm

; open a file
; modes:
mread	equ	0
mwrite	equ	1
mboth	equ	2
fopen	macro	name, mode
	mov	dx, name
	mov	al, mode
	dos	3dh
	jc	abort
	endm

; close a file
fclose	macro	handle
	mov	bx, handle
	dos	3eh
	jc	abort
	endm

; read a file
fread	macro	handle, count, buf
	mov	bx, handle
	mov	cx, count
	mov	dx, buf
	dos	3fh
	jc	abort
	endm

; fwrite a file
fwrite	macro	handle, count, buf
	mov	bx, handle
	mov	cx, count
	mov	dx, buf
	dos	40h
	jc	abort
	xor	ax, cx
	jnz	abort
	endm

; end macro definitions

abort:	prtmsg	errmsg
	int 20h

begin:	fopen	inname, mread
	mov	infile, ax
	fcrt	outname
	mov	outfile, ax

rdbuf:	fread	infile, bufsz, buf1
	mov	cx, ax
	jcxz	exit

; process
	mov	si, buf1
	mov	di, buf2
	cld
nextch:	lodsb
	cmp	al, ' '
	jbe	blank
	stosb
	prtchr	al
blank:	loop	nextch

	sub	di, buf2
	fwrite	outfile, di, buf2
	jmp	rdbuf

exit:	fclose	infile
	fclose	outfile
	dos	4ch

	end	main

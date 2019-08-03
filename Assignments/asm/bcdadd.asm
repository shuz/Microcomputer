title: bcdadd
.model	small

.code
	org	100h
main:	jmp begin

val1	db	24h, 10h, 76h, 24h
val2	db	80h, 32h, 51h, 93h

val3	db	?, ?, ?, ?


adjust	macro
	local	out_a, out_b, rec_c
	pushf
	push	ax
	and	al, 0fh
	cmp	al, 0ah
	pop	ax
	jb	out_a
	add	al, 06h
out_a:  push	ax
	and	al, 0f0h
	cmp	al, 0a0h
	pop	ax
	jb	rec_c
	add	al, 60h
	jnc	rec_c
	popf
	stc
	jmp	out_b
rec_c:	popf
out_b:	
	endm


begin:	mov	bx, offset val1
	mov	si, offset val2
	mov	di, offset val3
        mov	cx, 04h
	clc

next:	mov	al, [bx]
	mov	dl, [si]

	adc	al, dl
	adjust
	mov	[di], al
	inc	bx
	inc	si
	inc	di
	loop	next

	mov	ah, 4ch
	int	21h

	end	main

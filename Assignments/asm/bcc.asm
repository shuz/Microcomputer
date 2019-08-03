title: bcc
.model	small

.code
	org	100h
main:	jmp begin

str	db	03h, 16h, 25h, 93h, 44h, 87h, 20h, 65h, 0f6h, 0c2h
strlen	equ	10
table	db	'0123456789ABCDEF'
msg	db	'The BCC of these code is '
bccbuf	db	0, 0, 'H.', 0dh, 0ah, '$'

begin:	mov	si, offset str
        mov	cx, strlen
	mov	ah, 0

next:	lodsb
	xor	ah, al
	loop	next

	mov	al, ah
	and	al, 0f0h
	mov	cl, 4
	shr	al, cl
	mov	bx, offset table
	xlat
	mov	bccbuf, al;

	mov	al, ah
	and	al, 0fh
	xlat
	mov	bccbuf + 1, al;

	mov	dx, offset msg
	mov	ah, 09h
	int	21h

	mov	ah, 4ch
	int	21h

	end	main

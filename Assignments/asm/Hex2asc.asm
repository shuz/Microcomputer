title: hex2asc$

data	segment
table	db	30h, 31h, 32h, 33h, 34h, 35h, 36h, 37h,
		38h, 39h, 41h, 42h, 43h, 44h, 45h, 46h
hex	db	4
asci	db	?
data	ends

stack1	segment stack'stack'
	dw	20h dup(0)
stack1	ends

code	segment
	assume	cs:code, ds:data, ss:stack1
begin:	mov	ax, data
	mov	ds, ax
	mov	bx, offset table
	mov	ah, 0
	mov	al, hex
	add	bx, ax
	mov	al, [bx]
	mov	asci, al
	mov	ah, 4ch
	int	21h
code	ends

end	begin

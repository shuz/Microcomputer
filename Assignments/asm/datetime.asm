title: datetime
.model	small

; 把al内的2位10进制数化为ascii码，存放在addr里, 用bx作为映射表的地址, ten寄存器存放10
toascb	macro	addr, ten
	mov	ah, 0
	div	ten
	xlat
	mov	addr, al
	mov	al, ah
	xlat
	mov	addr + 1, al
	endm

; 把ax内的4位10进制数化为ascii码，存放在addr里, 用bx作为映射表的地址, ten寄存器存放10
; 直接用8位商8位余数的除法，因为255*10 = 2550, 所以商不会溢出
toascw	macro	addr, ten
	div	ten
	xchg	al, ah
	xlat
	mov	addr + 3, al
	mov	al, ah
	mov	ah, 0
	div	ten
	xchg	al, ah
	xlat
	mov	addr + 2, al
	mov	al, ah
	toascb	addr, ten
	endm

.code
	org	100h
main:	jmp begin

table	db	'0123456789'
dmsg	db	'Current date is '
year	db	4 dup(?), '/'
month	db	2 dup(?), '/'
day	db	2 dup(?), 0dh, 0ah
tmsg	db	'Current time is '
hour	db	2 dup(?), ':'
min	db	2 dup(?), ':'
sec	db	2 dup(?), ':'
msec	db	2 dup(?), 0dh, 0ah, '$'

begin:	mov	bx, offset table

	mov	ah, 2ah
        int	21h

	mov	ax, cx
	mov	cl, 10
	toascw	year, cl
	mov	al, dh
	toascb	month, cl
	mov	al, dl
	toascb	day, cl

	mov	ah, 2ch
	int	21h

	mov	al, ch
	mov	ch, 10
	toascb	hour, ch
	mov	al, cl
	toascb	min, ch
	mov	al, dh
	toascb	sec, ch
	mov	al, dl
	toascb	msec, ch

	mov	dx, offset dmsg
	mov	ah, 09h
	int	21h

	mov	ah, 4ch
	int	21h

	end	main

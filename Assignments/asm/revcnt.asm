title: revcnt	rev ax dx, cnt dx

regsz 	equ	10h		; register size

data	segment
ans	dw	0
data	ends

stk	segment stack'stack'
	dw	20h dup(0)
stk	ends

code	segment
	assume	cs:code, ds:data, ss:stk
begin:	mov	dx, data
	mov	ds, dx
	mov	cx, regsz	; loop count
	mov	si, ax		; copy ax to si
rot:	rcl	si, 1
	rcr	dx, 1
	loop	rot

	mov	di, 0		; count 1s in dx
	mov	si, dx		; copy dx to si
	mov	cx, regsz	; loop count
cnt:	rol	dx, 1
	jnc	next
	inc	di
next:	loop	cnt
	mov	ans, di

	mov	ah, 4ch
	int	21h
code	ends
end	begin

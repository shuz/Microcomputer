.model small
.code

	org	100h
start:	jmp	main
; results
ly	db	0
hy	db	0

;a = al
;r0 = ah
;r1 = bl
;r2 = bh
;r3 = dl

; main
main:	
;local	rtp0, rtp1, rtp2, rtp3
;	lda	d00
;	sta	x0
;	lda	d10
;	sta	x1
;	lda	rtp0
;	sta	dmdip
	mov	al,d00
	mov	x0,al
	mov	al,d10
	mov	x1,al
	mov	cx,offset rtp0
	mov	dmdip,cx
	jmp	dmd
rtp0:	
;	lda	y
;	sta	y0

;	lda	d00
;	sta	x0
;	lda	d11
;	sta	x1
;	lda	rtp1
;	sta	dmdip
	mov	al,y
	mov	y0,al

	mov	al,d00
	mov	x0,al
	mov	al,d11
	mov	x1,al
	mov	cx,offset rtp1
	mov	dmdip,cx
	jmp	dmd
rtp1:	
;	lda	y
;	sta	y1

;	lda	d01
;	sta	x0
;	lda	d10
;	sta	x1
;	lda	rtp2
;	sta	dmdip

	mov	al,y
	mov	y1,al

	mov	al,d01
	mov	x0,al	
	mov	al,d10
	mov	x1,al
	mov	cx,offset rtp2
	mov	dmdip,cx
	jmp	dmd
rtp2:	
;	lda	y
;	mov	a, r0
;	lda	y1
;	add	a, r0
;	sta	y1
	mov	al,y
	mov	ah,al
	mov	al,y1
	add	al,ah
	mov	y1,al

;	lda	d01
;	sta	x0
;	lda	d11
;	sta	x1
;	lda	rtp3
;	sta	dmdip
	mov	al,d01
	mov	x0,al
	mov	al,d11
	mov	x1,al
	mov	cx,offset rtp3
	mov	dmdip,cx
	jmp	dmd
rtp3:	
;	lda	y
;	sta	y2
	mov	al,y
	mov	y2,al
;end 	local

;local	rtp0, rtp1, rtp2
;	lda	y0
;	sta	rem
;	lda	rtp0
;	sta	nlrip
	mov	al,y0
	mov	rem,al
	mov	cx,offset rtp4
	mov	nlrip,cx
	jmp	nlr
rtp4:
;	lda	rem
;	sta	y0
;	lda	qut
;	mov	a, r0
;	lda	y1
;	add	a, r0
	mov	al,rem
	mov	y0,al
	mov	al,qut
	mov	ah,al
	mov	al,y1
	add	al,ah

;	sta	rem
;	lda	rtp1
;	sta	nlrip
	mov	rem,al
	mov	cx,offset rtp5
	mov	nlrip,cx
	jmp	nlr
rtp5:
;	lda	rem
;	sta	y1
;	lda	qut
;	mov	a, r0
;	lda	y2
;	add	a, r0
	mov	al,rem
	mov	y1,al
	mov	al,qut
	mov	ah,al
	mov	al,y2
	add	al,ah

;	sta	rem
;	lda	rtp2
;	sta	nlrip
	mov	rem,al
	mov	cx,offset rtp6
	mov	nlrip,cx
	jmp	nlr
rtp6:
;	lda	rem
;	sta	y2
;	lda	qut
;	sta	y3
	mov	al,rem
	mov	y2,al
	mov	al,qut
	mov	y3,al
;end 	local

;local	rtp0, rtp1
;	lda	y0
;	sta	d0
;	lda	y1
;	sta	d1
;	lda	rtp0
;	sta	cmbip
	mov	al,y0
	mov	d0,al
	mov	al,y1
	mov	d1,al
	mov	cx,rtp7
	mov	cmbip,cx
	jmp	cmb
rtp7:	mov	al,yy	;lda	yy
	mov	ly,al	;sta	ly

	mov	al,y2	;lda	y2
	mov	d0,al	;	sta	d0
	mov	al,y3	;	lda	y3
	mov	d1,al	;	sta	d1
	mov	cx,rtp8	;	lda	rtp1
	mov	cmbip,cx	;	sta	cmbip
	jmp	cmb
rtp8:	mov	al,yy	;	lda	yy
	mov	hy,al	;	sta	hy
;end 	local
	mov	ah,4ch	;		halt
	int	21h

; variables of main
d00	db	9
d01	db	9
d10	db	9
d11	db	9

y0	db	0
y1	db	0
y2	db	0
y3	db	0


; digit multiply digit
x0	db	0	; i
x1	db	0	; i
y	db	0	; o

dmd:	mov	al,0	;	mov	a, 0
	mov	y,al	;	sta	y
next:	mov	al,x0	;	lda	x0
	cmp	al,0
	jz	done
	dec	al	;	mov	a, r0
			;	dec	a, r0
	mov	x0,al	;	sta	x0
	mov	al,x1	;	lda	x1
	mov	ah,al	;	mov	a, r0
	mov	al,y	;	lda	y
	add	al,ah	;	add	a, r0
	mov	y,al	;	sta	y
	jmp	next
done:	mov	si,dmdip
	jmp	si
dmdip	dw	0

; normalize result of dmd
rem	db	0	; i, o
qut	db	0	; o

nlr:	mov	al,0	;	mov	a, 0
	mov	qut,al	;	sta	qut
	mov	dl,10	;	mov	r3, 10
	mov	bh,1	;	mov	r2, 1
next1:	mov	al,rem	;	lda	rem
	sub	al,dl	;	sub	a, r3
	jc	done1
	mov	rem,al	;	sta	rem
	mov	al,qut	;	lda	qut
	add	al,bh	;	add	a, r2
	mov	qut,al	;	sta	qut
	jmp	next1
done1:	mov	si,nlrip
	jmp	si	;	jmp	(000)
nlrip	dw	0

; shift right
shrx	db	0	; i, o

;local	sethb, done
mshr:	mov	al, 7fh	;	mov	a, 0x7f
	mov	dl, al	;	mov	a, r3
	mov	al,shrx	;	lda	x
	rcr	al,1	;	mov	a, r0
			;	rrc	a, r0
	jc	seth	;	jc	seth
	and	al, dl	;	and	a, r3
	jmp	done2	;	jmp	done
seth:	mov	shrx, al	;	sta	shrx
	mov	al, 80h	;	mov	a, 0x80
	mov	bh, al	;	mov	a, r2
	mov	al, shrx	;	lda	shrx
	and	al, dl	;	and	a, r3
	add	al, bh	;	add	a, r2
done2:	mov	shrx,al	;	sta	x
	mov	si,shrip
	jmp	si	;	jmp	(010)
shrip	dw	0
;end	local

;.org	0x200
; combine 2 digits
d0	db	0	; i
d1	db	0	; i
yy	db	0	; o
cnt	db	0	; local

cmb:	mov	al,d1	;	lda	d1
	mov	shrx,al	;	sta	shrx
	mov	al,4	;	mov	a, 4
	mov	cnt,al	;	sta	cnt
	mov	cx,offset rtp	;	lda	rtp
	mov	shrip,cx	;	sta	shrip
again:	jmp	mshr
rtp:	mov	al,cnt	;	lda	cnt
	dec	al	;	mov	a, r0
			;	dec	a, r0
	mov	cnt,al	;	sta	cnt
	cmp	al, 0
	jz	next2
	jmp	again
	
next2:	mov	al,0f0h	;	mov	a, 0xf0
	mov	ah,al	;	mov	a, r0
	mov	al,d0	;	lda	d0
	mov	bl,al	;	mov	a, r1
	mov	al,shrx	;	lda	shrx
	and	al,ah	;	and	a, r0
	add	al,bl	;	add	a, r1
	mov	yy,al	;	sta	yy
	mov	si,cmbip	;	jmp	(000)
	jmp	si
cmbip	dw	0
end	start
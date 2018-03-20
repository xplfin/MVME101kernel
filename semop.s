	.text
|
	.include "context.i"
|
	.globl	SemP
|
SemP:
	move.l	4(%a7),%d0
	trap	#0
	rts
| 
	.globl	Trap0
|
Trap0:	
	move.w	#0x2700,%sr	
	jsr	SaveContext
	move.l	%d0,%a1
	subq.l	#1,(%a1)
	bpl	1f
	move.b	#WAITING,Ctx_state(%a0)
	lea	4(%a1),%a1
	bra	2f
3:	
	move.l	%d0,%a1
	lea	Ctx_Link(%a1),%a1
2:	
	move.l	(%a1),%d0
	bne	3b	
	move.l	%a0,(%a1)
	clr.l	Ctx_Link(%a0)
1:	
	jsr	PickNext
	jmp	Dispatch
|
	.globl	SemV
|
SemV:
	move.l	0x4(%a7),%a4
	trap	#1
	rts
|
	.globl	Trap1
|
Trap1:
	move.w	#0x2700,%sr
	jsr	SaveContext
	addq.l	#1,(%a4)
	bgt	1f
	move.l	4(%a4),%a2
	move.b	#READY,Ctx_state(%a2)
	move.l	Ctx_Link(%a2),4(%a4)
1:
	jsr	PickNext
	jmp	Dispatch
|


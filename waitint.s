|
	.include "context.i"
|
	.globl	WaitInt
|
WaitInt:
	move.l	4(%a7),%d0
	move.l	8(%a7),%d1
	trap	#3
	and.l	#7,%d0
	rts
|
	.globl	Trap3
Trap3:
	move.w	#0x2700,%sr
	jsr	SaveContext
	lea.l	PseudoVec,%a1
	move.l	%a0,0(%a1,%d0.w)
	move.b	#INTWAIT,Ctx_state(%a0)
	jsr	ClrLevel
	jsr	PickNext
	jmp	Dispatch
|
	.globl	WaitAnyInt
|
WaitAnyInt:
	trap	#4
	and.l	#0xFF,%d1
	move.l	%d0,(%a0)
	and.l	#0x7,%d0
	move.l	%d1,4(%a0)
	rts
|
| Vector 0 is catchall vector
|
	.globl	Trap4
Trap4:
	move.w	#0x2700,%sr
	jsr	SaveContext
	move.l	%a0,PseudoVec
	move.b	#INTWAIT,Ctx_state(%a0)
	jsr	PickNext
	jmp	Dispatch
|








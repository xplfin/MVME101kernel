	.text
|
	.include "context.i"
|
	.globl	Exception
|
Exception:
	move.b	#0xDE,0xFE00F1
1:	bra	1b
|
	.globl	ExtInt,AVIntr
|
AVIntr:
	move.w	#0x2700,%sr
	move.l	%a0,-(%a7)
	lea	PseudoVec,%a0
	add.w	10(%a7),%a0
	tst.l	(%a0)
	bne	1f
	move.l	(%a0),%a0
1:
	move.l	%a0,-(%a7)
	move.l	(%a0),%a0
	move.b	#READY,Ctx_state(%a0)
	clr.l	Ctx_regs(%a0)
	clr.l	Ctx_regs+4(%a0)
	move.w	Ctx_sr(%a0),Ctx_regs+2(%a0)
	move.w	14(%a7),Ctx_regs+6(%a0)
	move.l	(%a7)+,%a0
	clr.l	(%a0)
2:
	move.l	(%a7)+,%a0
	btst	#5,(%a7)
	bne	1f
	jsr	SaveContext
	jsr	PickNext
	jmp	Dispatch
1:	
	or.w	#0x0700,(%a7)
	rte
|
ExtInt:
	move.w	#0x2700,%sr
	move.l	%a0,-(%a7)
	lea	PseudoVec,%a0
	add.w	10(%a7),%a0
	tst.l	(%a0)
	bne	1f
	move.l	(%a0),%a0
1:
	move.l	%a0,-(%a7)
	move.l	(%a0),%a0
	move.b	#READY,Ctx_state(%a0)
	clr.l	Ctx_regs(%a0)
	clr.l	Ctx_regs+4(%a0)
	move.w	Ctx_sr(%a0),Ctx_regs+2(%a0)
	move.w	14(%a7),Ctx_regs+6(%a0)
	move.l	(%a7)+,%a0
	clr.l	(%a0)
2:
	move.l	(%a7)+,%a0
|
|	Here add signaling to worker processors
|
	btst	#5,(%a7)
	bne	1f
	jsr	SaveContext
	jsr	PickNext
	jmp	Dispatch
1:	
	or.w	#0x0700,(%a7)
	rte
|






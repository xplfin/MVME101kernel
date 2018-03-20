	.text
|
| Context switch for mvme101 kernel
|
	.include "context.i"
|
	.globl  SaveContext
SaveContext:
	move.l	%a0,-(%a7)
	move.l	Current,%a0
	move.l	(%a7)+,Ctx_a0(%a0)
	movem.l	%d0-%d7/%a1-%a6,Ctx_regs(%a0)	
	move.l	(%a7)+,%a1
	move.w	(%a7)+,Ctx_sr(%a0)
	move.l	(%a7)+,Ctx_pc(%a0)
	move.l	%usp,%a2
	move.l	%a2,Ctx_sp(%a0)
	move.b	#READY,Ctx_state(%a0)
|
	jmp	(%a1)
|
	.globl Dispatch
Dispatch:	
	move.l	Current,%a0
	move.l	Ctx_sp(%a0),%a1
	move.l	%a1,%usp
	move.l	#0x1000,%a7
	move.w	#0,-(%a7)
	move.l	Ctx_pc(%a0),-(%a7)
	move.w	Ctx_sr(%a0),-(%a7)
	move.b	CurIntPrio,(%a7)
|
	movem.l	Ctx_regs(%a0),%d0-%d7/%a1-%a6
	move.b	#CURRENT,Ctx_state(%a0)
|
	move.l	Ctx_a0(%a0),%a0
	rte
|




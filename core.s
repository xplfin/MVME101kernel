	.text
|
	.include "context.i"
|
| mvme101 kernel boot koodi
| konfig:	12K- RAM 0000-2FFF
|
Start:
	move.w	#0x2700,%sr
	lea	Start(%pc),%a1
	move.l	#0x600,%d0
	move.l	#0x1000,%a0
1:
	move.l	(%a1)+,(%a0)+
	dbra	%d0,1b
|
	jmp	TrueStart
|
TrueStart:
	lea	IVec,%a0
	lea	0,%a1
	lea	PseudoVec,%a2
	move.l	#255,%d0
|
1:
	move.l	(%a0)+,(%a1)+
	clr.l	(%a2)+
	dbra	%d0,1b
|
	move.b	#0x18,0xFE00F1
	lea	0x1000,%a7
|
	.globl	InitIO
|
	reset
	jsr	InitIO
|
	.globl	TimerInit
	jsr	TimerInit
|
	move.b	#0x17,0xFE00F1
|	
	jsr	PickNext
	jmp	Dispatch
1:
	bra	1b
|

	.globl SetPrio,Trap2
|
	.include "context.i"
|
	.text
|	
SetPrio:
	move.l	4(%a7),%d1
	trap	#2
	rts
|
Trap2:
	move.w	#0x2700,%sr
	jsr	SaveContext
	and.w	#7,%d1
	jsr	SetLevel
	jsr	PickNext
	jmp	Dispatch
|
	.globl	CSetLevel,CClrLevel
	.globl	SetLevel,ClrLevel
CSetLevel:
	move.l	4(%a7),%d1
|
SetLevel:
	lea	LevTab,%a0
	move.b	0(%a0,%d1.w),%d1
	or.b	CurIntMask,%d1
	move.b	%d1,CurIntMask
	move.b	16(%a0,%d1.w),CurIntPrio
	rts
|
CClrLevel:
	move.l	4(%a7),%d1
ClrLevel:
	lea	LevTab,%a0
	move.b	8(%a0,%d1.w),%d1
	and.b	CurIntMask,%d1
	move.b	%d1,CurIntMask
	move.b	16(%a0,%d1.w),CurIntPrio
	rts
LevTab:
	.byte	0x00,0x01,0x02,0x04,0x08,0x10,0x20,0x40,0x40
	.byte	0xFF,0xFE,0xFD,0xFB,0xF7,0xEF,0xDF,0xBF,0xBF
|
	.byte	0				| 0
	.byte	1				| 1
	.byte	2,2				| 2-3
	.byte	3,3,3,3				| 4-7
	.byte	4,4,4,4,4,4,4,4			| 8-15
	.byte	5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5	| 16-31
	.byte	6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6	| 32-63
	.byte	6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6	|
	.byte	7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7	| 64-127
	.byte	7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7
	.byte	7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7
	.byte	7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7

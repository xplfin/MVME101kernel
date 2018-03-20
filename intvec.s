|
	.include "context.i"
	.text
|
BusError:
AddressError:
	move.w	#0x2700,%sr
	move.b	#0xDF,0xFE00F1
	move.l	#0xDEADBEEF,-(%a7)
1:	
	bra	1b
Error:
	rte
|
	.globl	Trap0,Trap1,Trap2,Trap3,Trap4
|
Trap5:
Trap6:
Trap7:
Trap8:
Trap9:
TrapA:
TrapB:
TrapC:
TrapD:
TrapE:
TrapF:
	rte
|
	.globl	IVec
IVec:
	.long	0,0
|
	.long	BusError		| (8)
	.long	AddressError		| (C)
	.long	Exception		| (10) illegal
	.long	Exception		| (14) divbyzero
	.long	Exception		| (18) chkinstr
	.long	Exception		| (1C) trapv
	.long	Exception		| (20) privilege viol
	.long	Exception		| (24) trace
	.long	Exception		| (28) aline
	.long	Exception		| (2C) fline
	.long	Error,Error		| (30,34)
	.long	Exception		| (38) format error
	.long	ExtInt			| (3C) uninitialized vector 
	.long	Error,Error,Error,Error | (40,44,48,4C)
	.long	Error,Error,Error,Error	| (50,54,58,5C)
	.long	ExtInt			| (60)
	.long	AVIntr			| (64)
	.long	AVIntr			| (68)
	.long	AVIntr			| (6C)
	.long	AVIntr			| (70)
	.long	AVIntr			| (74)
	.long	AVIntr			| (78)
	.long	AVIntr			| (7C)
|
	.long	Trap0,Trap1,Trap2,Trap3	| (80,84,88,8C)
	.long	Trap4,Trap5,Trap6,Trap7	| (90,94,98,9C)
	.long	Trap8,Trap9,TrapA,TrapB	| (A0,A4,A8,AC)
	.long	TrapC,TrapD,TrapE,TrapF	| (B0,B4,B8,BC)
|
	.long	Error,Error,Error,Error | (C0,C4,C8,CC)
	.long	Error,Error,Error,Error | (D0,D4,D8,DC)
	.long	Error,Error,Error,Error | (E0,E4,E8,EC)
	.long	Error,Error,Error,Error | (F0,F4,F8,FC)

	.long   ExtInt,ExtInt,ExtInt,ExtInt | 100
	.long   ExtInt,ExtInt,ExtInt,ExtInt
	.long   ExtInt,ExtInt,ExtInt,ExtInt
	.long   ExtInt,ExtInt,ExtInt,ExtInt
	.long   ExtInt,ExtInt,ExtInt,ExtInt | 140
	.long   ExtInt,ExtInt,ExtInt,ExtInt
	.long   ExtInt,ExtInt,ExtInt,ExtInt
	.long   ExtInt,ExtInt,ExtInt,ExtInt
	.long   ExtInt,ExtInt,ExtInt,ExtInt | 180
	.long   ExtInt,ExtInt,ExtInt,ExtInt
	.long   ExtInt,ExtInt,ExtInt,ExtInt
	.long   ExtInt,ExtInt,ExtInt,ExtInt
	.long   ExtInt,ExtInt,ExtInt,ExtInt | 1C0
	.long   ExtInt,ExtInt,ExtInt,ExtInt
	.long   ExtInt,ExtInt,ExtInt,ExtInt
	.long   ExtInt,ExtInt,ExtInt,ExtInt

	.long   ExtInt,ExtInt,ExtInt,ExtInt | 200
	.long   ExtInt,ExtInt,ExtInt,ExtInt
	.long   ExtInt,ExtInt,ExtInt,ExtInt
	.long   ExtInt,ExtInt,ExtInt,ExtInt
	.long   ExtInt,ExtInt,ExtInt,ExtInt | 240
	.long   ExtInt,ExtInt,ExtInt,ExtInt
	.long   ExtInt,ExtInt,ExtInt,ExtInt
	.long   ExtInt,ExtInt,ExtInt,ExtInt
	.long   ExtInt,ExtInt,ExtInt,ExtInt | 280
	.long   ExtInt,ExtInt,ExtInt,ExtInt
	.long   ExtInt,ExtInt,ExtInt,ExtInt
	.long   ExtInt,ExtInt,ExtInt,ExtInt
	.long   ExtInt,ExtInt,ExtInt,ExtInt | 2c0
	.long   ExtInt,ExtInt,ExtInt,ExtInt
	.long   ExtInt,ExtInt,ExtInt,ExtInt
	.long   ExtInt,ExtInt,ExtInt,ExtInt

	.long   ExtInt,ExtInt,ExtInt,ExtInt | 300
	.long   ExtInt,ExtInt,ExtInt,ExtInt
	.long   ExtInt,ExtInt,ExtInt,ExtInt
	.long   ExtInt,ExtInt,ExtInt,ExtInt
	.long   ExtInt,ExtInt,ExtInt,ExtInt | 340
	.long   ExtInt,ExtInt,ExtInt,ExtInt
	.long   ExtInt,ExtInt,ExtInt,ExtInt
	.long   ExtInt,ExtInt,ExtInt,ExtInt
	.long   ExtInt,ExtInt,ExtInt,ExtInt | 380
	.long   ExtInt,ExtInt,ExtInt,ExtInt
	.long   ExtInt,ExtInt,ExtInt,ExtInt
	.long   ExtInt,ExtInt,ExtInt,ExtInt
	.long   ExtInt,ExtInt,ExtInt,ExtInt | 3c0
	.long   ExtInt,ExtInt,ExtInt,ExtInt
	.long   ExtInt,ExtInt,ExtInt,ExtInt
	.long   ExtInt,ExtInt,ExtInt,ExtInt
	.globl	EndIVec
EndIVec:





	.set	Ctx_Link,	0x00
	.set	Ctx_Name,	0x04
	.set	Ctx_state,	0x08
	.set	Ctx_prio,	0x09
	.set	Ctx_sr,		0x0A	
	.set	Ctx_pc,		0x0C
	.set	Ctx_sp,		0x10
	.set	Ctx_a0,		0x14
	.set	Ctx_regs,	0x18
|
	.set	CURRENT,        0x01
	.set	READY,		0x02
	.set	WAITING,	0x04
	.set	INTWAIT,	0x08
	.set	SLEEP,		0x10
	.set	TRAPPED,	0x20
	.set	EMPTY,		0x80
|
	.set	PseudoVec,    0xFC0400
|


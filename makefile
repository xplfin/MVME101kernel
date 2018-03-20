
cxSwitch.o: cxSwitch.s
	m68k-elf-as -m68010 -o cxSwitch.o cxSwitch.s

intvec.o: intvec.s
	m68k-elf-as -m68010 -o intvec.o intvec.s

interrupts.o: interrupts.s
	m68k-elf-as -m68010 -o interrupts.o interrupts.s

waitint.o : waitint.s
	m68k-elf-as -m68010 -o waitint.o waitint.s

setprio.o : setprio.s
	m68k-elf-as -m68010 -o setprio.o setprio.s

semop.o : semop.s
	m68k-elf-as -m68010 -o semop.o semop.s

kernel.o : kernel.c
	m68k-elf-gcc -m68000 -c kernel.c

io.o : io.c
	m68k-elf-gcc -m68000 -c io.c

all:	cxSwitch.o intvec.o interrupts.o setprio.o semop.o waitint.o kernel.o io.o
	m68k-elf-ld -M -Ttext 0x100000 -Tdata 0x1000 -o m101kernel.bin cxSwitch.o interrupts.o intvec.o setprio.o semop.o waitint.o kernel.o io.o >m101kernel.map




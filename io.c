
#include "context.h"
#include "semaphore.h"

#define EPCI1Base ((char*)0xFE00A0)
#define EPCI2Base ((char*)0xFE00B0)

#define Data    (0x1)
#define State   (0x3)
#define Mode    (0x5)
#define Command (0x7)

#define ENABLERECEIVE  (4)
#define ENABLETRANSMIT (1)

#define DISABLERECEIVE  (~ENABLERECEIVE)
#define DISABLETRANSMIT (~ENABLETRANSMIT)

void InitEPCI( char* EPCI )
{
  EPCI[Mode] = 0x4E;
  EPCI[Mode] = 0x7A;    /* baud 7 = 1200 C=4800 E=9600 A=2400 */
  EPCI[Command] = 0x22;
}

#define PIABase ((char*)0xFE00C0)

#define CRA     (0x3)
#define CRB     (0x7)
#define DDRA    (0x1)
#define DDRB    (0x5)
#define AData    (0x1)
#define BData    (0x5)

/*
  Pia ports initialized as outputs
*/

void InitPIA( char* PIA )
{
  PIA[CRA] = 0x30;
  PIA[DDRA] = 0xFF;
  PIA[CRA] = 0x34;
  PIA[AData] = 0x55;

  PIA[CRB] = 0x30;
  PIA[DDRB] = 0xFF;
  PIA[CRB] = 0x34;
  PIA[BData] = 0xAA;

}

#define CR1       (1)
#define CR3       (1)
#define CR2       (3)
#define Status    (3)
#define Counter1  (5)
#define Latch1    (7)
#define Counter2  (9)
#define Latch2    (11)
#define Counter3  (13)
#define Latch3    (15)

#define LSB(x)  ((x)&0xFF)

#define MSB(x)  (((x)>>8)&0xFF)

#define TIMERBase ((char*)0xFE00D0)
#define TIMERVector (0x68)
#define TIMERPrio   (2)
/*
  Timer control bits:

   CRX7, Output enable (0 -> disable, 1 -> enable )
    !
    !  CRX6, Interrupt enable (0 -> disable, 1 -> enable )
    !   !
    !   !  CRX5-----------------+
    !   !   !                   !
    !   !   !  CRX4-------------+--> mode and control
    !   !   !   !               !    (000 -> continuous mode,
    !   !   !   !  CRX5---------+    write to latches initialize counter)
    !   !   !   !   !
    !   !   !   !   !  CRX2, Counting mode (0-> 16 bit, 1-> dual 8-bit)
    !   !   !   !   !   !
    !   !   !   !   !   !  CRX1, clock source, (0->external, 1-> enable clock)
    !   !   !   !   !   !   !
    !   !   !   !   !   !   !  CR30, timer #3 prescale (0->no, 1-> /8)
    !   !   !   !   !   !   !  CR20, register select, (0-> CR#3, 1-> CR#1 )
    !   !   !   !   !   !   !  CR10, resetbit ( 0-> go, 1-> preset hold )
    !   !   !   !   !   !   !   !
  +---+---+---+---+---+---+---+---+
  !   !   !   !   !   !   !   !   !  
  +---+---+---+---+---+---+---+---+

*/

void InitTimer( char* Timer )
{
  /*
    Timer 3

    external clock 2 MHz, prescale active, 250 kHz counted
    250000/12500 => 20 Hz ( 50ms )

    Timer 2

    external clock timer 3 output
    20 / 10 > 2 Hz (500 ms) interrupt enabled

    Timer 1

    external clock timer 2 output
    2.5 s 
  */
 
  Timer[Counter3] = MSB(12500-1); Timer[Latch3] = LSB(12500-1);
  Timer[CR3] = 0x81;
  Timer[Counter2] = MSB(10-1); Timer[Latch2] = LSB(10-1);
  Timer[CR2] = 0xC1;
  Timer[Counter1] = MSB(5-1); Timer[Latch1] = LSB(5-1);
  Timer[CR1] = 0x80;  
}

void InitIO()
{
  InitEPCI( EPCI1Base );
  InitEPCI( EPCI2Base );

  InitPIA( PIABase );

  InitTimer( TIMERBase );
}

struct Port {
  char* EPCI;
  int Vector;
  int Prio;
  struct Semaphore InSem;
  struct Semaphore OutSem;
} Ports[2] = {
  { EPCI1Base, 0x70, 4, {0, (struct Context*)0}, {0,(struct Context*)0} },
  { EPCI2Base, 0x74, 5, {0, (struct Context*)0}, {0,(struct Context*)0} },
};

#define BUFLEN (32)

struct Buffer {
  char b[BUFLEN];
  int first;
  int last;
  struct Semaphore Stuff;
  struct Semaphore Space;
  struct Semaphore Mutex;
} Buffers[4] = {
  { {0}, 0, 0, {0, 0}, {BUFLEN, 0 }, {1, 0} },
  { {0}, 0, 0, {0, 0}, {BUFLEN, 0 }, {1, 0} },
  { {0}, 0, 0, {0, 0}, {BUFLEN, 0 }, {1, 0} },
  { {0}, 0, 0, {0, 0}, {BUFLEN, 0 }, {1, 0} },
};

void AddChar( struct Buffer *, char );

void WriteChar( int port, char c )
{
  struct Buffer *bp = &Buffers[2+port];

  SemP( &bp->Mutex );
  AddChar( bp, c );
  SemV( &bp->Mutex );
}

void PutString( int port, char* str )
{
  while( *str ) {
    WriteChar( port, *str++ );
  }
}

char PickChar( struct Buffer * );

char ReadChar( int port )
{
  struct Buffer *bp = &Buffers[port];
  char c;

  SemP( &bp->Mutex );
  c = PickChar( bp );
  SemV( &bp->Mutex );
  return c;
}

void AddChar( struct Buffer *bp, char c )
{
  SemP( &bp->Space );
  bp->b[bp->last] = c;
  bp->last = (bp->last+1)%BUFLEN;
  SemV( &bp->Stuff );
}

char PickChar( struct Buffer *bp )
{
  char c;

  SemP( &bp->Stuff );
  c = bp->b[bp->first];
  bp->first = (bp->first+1)%BUFLEN;
  SemV( &bp->Space );
  return c;
}

void EPCIHandler( struct Port *p )
{
  char *EPCI = p->EPCI;
  char c;

  while( 1 ) {
    WaitInt( p->Vector, p->Prio );
    c = EPCI[State];

    if( c & 2 ) {
      SemV( &p->InSem );
    } else if( c & 1 ) {
      SemV( &p->OutSem );
    }
  }
}

void EPCI1Handler()
{
  EPCIHandler( &Ports[0] );
}

void EPCI2Handler()
{
  EPCIHandler( &Ports[1] );
}

void EPCIReader( struct Port *p, struct Buffer* bp )
{
  char* EPCI = p->EPCI;
  char c;

  EPCI[Command] |= ENABLERECEIVE;

  while( 1 ) {
    SemP( &p->InSem );
    c = EPCI[Data];
    CClrLevel( p->Prio );
    AddChar( bp, c );
  }
}

void EPCIWriter( struct Port *p, struct Buffer* bp )
{
  char* EPCI = p->EPCI;
  char c;

  while( 1 ) {
    c = PickChar( bp );
    EPCI[Command] |= ENABLETRANSMIT;
    EPCI[Data] = c;
    CClrLevel( p->Prio );
    SemP( &p->OutSem );
    EPCI[Command] &= DISABLETRANSMIT;
  }
}

void EPCI1Reader()
{
  EPCIReader( &Ports[0], &Buffers[0] );
}

void EPCI2Reader()
{
  EPCIReader( &Ports[1], &Buffers[1] );
}

void EPCI1Writer()
{
  EPCIWriter( &Ports[0], &Buffers[2] );
}

void EPCI2Writer()
{
  EPCIWriter( &Ports[1], &Buffers[3] );
}

void TimerHandler()
{
  char c;

  while(1) {
    WaitInt( TIMERVector, TIMERPrio );
    c = TIMERBase[CR2];
    c = TIMERBase[Latch2];
    CClrLevel( TIMERPrio );
  }
}









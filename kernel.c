#include "context.h"

struct Context *Current = 0;

char CurIntPrio = 0;
char CurIntMask = 0;

#define NPROC (16)

void NullProc();
void EPCI1Handler();
void EPCI2Handler();
void EPCI1Reader();
void EPCI2Reader();
void EPCI1Writer();
void EPCI2Writer();
void TimerHandler();

struct Context ProcTable[NPROC] = 
{
  { 0, "Null Process", READY, 0, 0, NullProc,      0, 0, {0} },

  { 0, "EPCI1Handler", READY, 0, 40, EPCI1Handler, 0, 0, {0} },
  { 0, "EPCI2Handler", READY, 0, 40, EPCI2Handler, 0, 0, {0} },
  { 0, "EPCI1Reader",  READY, 0, 30, EPCI1Reader,  0, 0, {0} },
  { 0, "EPCI2Reader",  READY, 0, 30, EPCI2Reader,  0, 0, {0} },
  { 0, "EPCI1Writer",  READY, 0, 20, EPCI1Writer,  0, 0, {0} },
  { 0, "EPCI2Writer",  READY, 0, 20, EPCI2Writer,  0, 0, {0} },

  { 0, "TimerHandler", READY, 0, 40, TimerHandler, 0, 0, {0} },

  { 0, "Empty",        EMPTY, 0, 0, 0, 0, 0, {0} },
  { 0, "Empty",        EMPTY, 0, 0, 0, 0, 0, {0} },
  { 0, "Empty",        EMPTY, 0, 0, 0, 0, 0, {0} },
  { 0, "Empty",        EMPTY, 0, 0, 0, 0, 0, {0} },
  { 0, "Empty",        EMPTY, 0, 0, 0, 0, 0, {0} },
  { 0, "Empty",        EMPTY, 0, 0, 0, 0, 0, {0} },
  { 0, "Empty",        EMPTY, 0, 0, 0, 0, 0, {0} },
  { 0, "Empty",        EMPTY, 0, 0, 0, 0, 0, {0} },
};

void PickNext()
{
  struct Context *p;

  Current = &ProcTable[0];

  for( p = &ProcTable[1] ; p != &ProcTable[NPROC]; p++ ) {
    if( (p->state == READY) && (p->prio > Current->prio) ) {
      Current = p;
    }
  }
}

/*
  Processes
*/

void NullProc()
{
  while(1);
}




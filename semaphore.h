struct Semaphore {
  char Lock;
  char Spare;
  short int Count;
  struct Context *Wq;
};

void SemP( struct Semaphore* );
void SemV( struct Semaphore* );


struct Context {
  struct Context* Link;
  char* Name;
  char state;
  char prio;
  short int R_sr;
  int R_pc;
  int R_sp;
  int R_a0;
  int R_regs[14];
};

#define CURRENT (1)
#define READY   (2)
#define WAITING (4)
#define INTWAIT (8)
#define SLEEP   (16)
#define TRAPPED (32)
#define EMPTY   (128)

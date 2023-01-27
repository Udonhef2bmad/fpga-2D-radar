// "Simple.c"
// Ce programme simple permet de tester les périphériques de votre système
// en lisant les différentes entrées et en écrivant sur les différentes sorties

#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "unistd.h"
#include "stdio.h"



int main() {
  
  unsigned int SevenSeg[10] = {0x3F, 0x06, 0x5B, 0x4F, 0x66, 0xED, 0xFD, 0x07, 0xFF, 0xEF};
  
  //Envoyer un message sur la sortie série standard (Jtag ou RS232)
  printf("Hello World !\n");
  
  while (1) {

    usleep(200000); // tempo de 200 000 µs --> 200 ms
    
    
    //Ecriture sur les afficheurs 7 segments
    IOWR_ALTERA_AVALON_PIO_DATA(SEVEN_SEG_BASE + 0, ~SevenSeg[0] );
    IOWR_ALTERA_AVALON_PIO_DATA(SEVEN_SEG_BASE + 4, ~SevenSeg[1] );
    IOWR_ALTERA_AVALON_PIO_DATA(SEVEN_SEG_BASE + 8, ~SevenSeg[2] );
    IOWR_ALTERA_AVALON_PIO_DATA(SEVEN_SEG_BASE + 12, ~SevenSeg[3] );
    IOWR_ALTERA_AVALON_PIO_DATA(SEVEN_SEG_BASE + 16, ~SevenSeg[4] );
    IOWR_ALTERA_AVALON_PIO_DATA(SEVEN_SEG_BASE + 20, ~SevenSeg[5] );
    
  }
  return 0;
}

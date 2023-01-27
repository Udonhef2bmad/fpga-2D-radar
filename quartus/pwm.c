#include <stdio.h>
#include <stdlib.h>
#include "altera_avalon_pwm.h"
#include "system.h"

int main()
{
  int rx_char;

  printf("Application - PWM\n");
  printf("\nEnter intensity LED between 1 and 4 (0 to exit)\n");

  IOWR_ALTERA_AVALON_PWM_DIVIDER(AVALON_PWM_INST_BASE,0xFF);
  IOWR_ALTERA_AVALON_PWM_DUTY(AVALON_PWM_INST_BASE,0xFF);

  while (1)
  {
    rx_char = getc(stdin);

    switch (rx_char)
    {
      case '4':
        IOWR_ALTERA_AVALON_PWM_DUTY(AVALON_PWM_INST_BASE,0xFF);
        printf("Intensity level 4\n");
        break;

      case '3':
        IOWR_ALTERA_AVALON_PWM_DUTY(AVALON_PWM_INST_BASE,0x80);
        printf("Intensity level 3\n");
        break;

      case '2':
        IOWR_ALTERA_AVALON_PWM_DUTY(AVALON_PWM_INST_BASE,0x30);
        printf("Intensity level 2\n");
        break;

      case '1':
        IOWR_ALTERA_AVALON_PWM_DUTY(AVALON_PWM_INST_BASE,0x10);
        printf("Intensity level 1\n");
        break;

      case '0':
        printf("\nBye bye ...\n");
        return 0;
        break;

      default:
        printf("Enter intensity LED between 1 and 4\n");
        break;
    }
  }
  return 0;
}

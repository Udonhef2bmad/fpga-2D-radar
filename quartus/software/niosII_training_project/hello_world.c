/* This program demonstrates use of parallel ports in the DE1-SoC Basic Computer
 *
 * It performs the following:
 * 1. displays the SW switch values on the red LED
 * 2. displays a rotating pattern on the HEX displays
 * 3. Read the analog value from the 6 ADC channels
 */
#include <stdio.h>
#include <io.h>
#include <unistd.h>
#include "system.h"

#include "altera_avalon_pio_regs.h"

int chaseLedsCount = 9;
int chaseLedsStep = 0;

void updateChaseLeds(int count, int *step)
{
	int activeLed = 0;

	while(1)
	{
		if((*step) < count)
		{
			//go forwards
			activeLed = (*step);
			break;
		}
		if((*step) < count*2)
		{
			//go backwards
			activeLed = (count*2) - (*step);
			break;
		}
		//reset step
		(*step) = 0;
		break;
	}

	//increment step;
	(*step) = (*step)+1;

	//printf("chaseLedsStep : %d\n", (*step));
	printf("activeLed : %d\n", activeLed);
	IOWR_ALTERA_AVALON_PIO_DATA(LEDR_BASE,(1 << activeLed));
}

const unsigned char seg_codes_inverted[] =
{
63, 6, 91, 79, 102, 109, 125, 7,
127, 111, 119, 124, 57, 94, 121, 113
};

const unsigned char seg_codes[] =
{
0xC0, //0
0xF9, //1
0xA4, //2
0xB0, //3
0x99, //4
0x92, //5
0x82, //6
0xF8, //7
0x80, //8
0x90, //9
0x88, //A
0x83, //B
0xC6, //C
0xA1, //D
0x86, //E
0x8E  //F
};

void controlHex(int id, int number)
{
	//convert to seven segment display value
	//number = ~seg_codes_inverted[number%16];
	number = seg_codes[number%16];

	switch(id)
	{
		case '0':
			IOWR_ALTERA_AVALON_PIO_DATA(HEX0_BASE, number);
			break;
		case '1':
			IOWR_ALTERA_AVALON_PIO_DATA(HEX1_BASE, number);
			break;
		case '2':
			IOWR_ALTERA_AVALON_PIO_DATA(HEX2_BASE, number);
			break;
		case '3':
			IOWR_ALTERA_AVALON_PIO_DATA(HEX3_BASE, number);
			break;
		case '4':
			IOWR_ALTERA_AVALON_PIO_DATA(HEX4_BASE, number);
			break;
		case '5':
			IOWR_ALTERA_AVALON_PIO_DATA(HEX5_BASE, number);
			break;
	}
}


void consoleControl()
{
	char str[10];
	int number;

	printf("Waiting for input : ");
	if(scanf("%s %d", str, &number) != 2)
	{
		printf("Invalid input\n");
		return;
	}


	switch(str[0])
	{
		case 'r':
			printf("Writing to led\n");
			IOWR_ALTERA_AVALON_PIO_DATA(LEDR_BASE, number);
			break;
		case 'h':
			printf("Writing to HEX%c\n", str[1]);
			controlHex(str[1], number);
			break;

		default:
			printf("Invalid input\n");
			break;
	}
}


// function to get the value of the nth bit
int bitval(int val, int n)
{
	// shift the value right by n bits
	int result = val >> n;
	// mask the result with 1 to get the value of the nth bit
	result &= 1;
	return result;
}

void speedControl(unsigned int *delay, int val)
{
	switch(IORD_ALTERA_AVALON_PIO_DATA(KEY_BASE))
	{
	case 7:
		//button 1 pressed
		if(*delay > 0)
		{
			*delay -= val;
			printf("new speed : %d\n", *delay);
		}
		break;
	case 11:
		//button 2 pressed
		*delay += val;
		printf("new speed : %d\n", *delay);
		break;
	case 13:
		//unassigned
		break;
	case 0:
		//unassigned
		break;
	case 15:
		//nothing pressed
		break;
	default:
		break;
	}
}



// define the maximum number of digits
#define MAX_DIGITS 5

void sevenSegCounter(int count)
{
	int digits[MAX_DIGITS]; // array to store the digits
	int i;
	// split the count into individual digits
	for (i = 0; i < MAX_DIGITS; i++)
	{
		digits[i] = count % 10;
		count /= 10;
	}

	/*/ print the digits in order
	for (i = MAX_DIGITS - 1; i >= 0; i--)
	{
		printf("%d ", digits[i]);
	}*/
	printf("\n");
	IOWR_ALTERA_AVALON_PIO_DATA(HEX0_BASE, ~seg_codes_inverted[digits[0]]);
	IOWR_ALTERA_AVALON_PIO_DATA(HEX1_BASE, ~seg_codes_inverted[digits[1]]);
	IOWR_ALTERA_AVALON_PIO_DATA(HEX2_BASE, ~seg_codes_inverted[digits[2]]);
	IOWR_ALTERA_AVALON_PIO_DATA(HEX3_BASE, ~seg_codes_inverted[digits[3]]);
	IOWR_ALTERA_AVALON_PIO_DATA(HEX4_BASE, ~seg_codes_inverted[digits[4]]);
	IOWR_ALTERA_AVALON_PIO_DATA(HEX5_BASE, ~seg_codes_inverted[digits[5]]);
}





int fieldLength = 10;
int swingRange = 3; //range in which the ball can be hit by the player
int cooldown = 2; //can hit every 3 ticks
int button_1 = 3; //button 4
int button_2 = 2; //button 3
int lastSwing_1 = 0;
int lastSwing_2 = 0;


#include <stdbool.h>

struct pingPongGame{
	int initialDelay;//delay every match starts with
	int decrementDelay;//amount by which the delay gets reduced after every successful swing

	int totalServes;//total serves since game start
	int firstServer;//player who server first [0:first player, 1:second player]
	int servesPerPlayer;//total serves a player gets before the next one can serve
	int winsPerGame;//total matches a player has to win to win the game

	int status;//game status : [0:awaiting serve, 1:]
	int ballPosition;//ball position
	int ballDirection;//direction the ball is going
};




struct player{
	int minRange;//player swing range
	int maxRange;
	int direction;// direction the player is facing
	int servePosition;// position of the ball at serve
	int lossLimit; //limit at which the player loses a point

	int button; //button the player has to push in order to attempt a swing
	int score; // player score
	int cooldown; //cooldown between each swing to prevent spamming
};


// returns 1 if button is pushed, else 0
int isButtonPushed(int button_reg, int button)
{
	return (!bitval(button_reg, button) == 0);
}

void firstServe(struct pingPongGame game, struct player player1, struct player player2)
{
	int button_reg;
	while(1)
	{
		//first one who swings gets to serve
		button_reg = IORD_ALTERA_AVALON_PIO_DATA(KEY_BASE);

		if(isButtonPushed(button_reg, player1.button))
		{
			game.firstServer = 0;
			game.ballPosition = player1.servePosition;
			game.ballDirection = player1.direction;
			return;
		}
		if(isButtonPushed(button_reg, player2.button))
		{
			game.firstServer = 1;
			game.ballPosition = player2.servePosition;
			game.ballDirection = player2.direction;
			return;
		}
	}
}

void playerServe(int button_reg, struct pingPongGame game, struct player player1, struct player player2)
{
	if(isButtonPushed(button_reg, player1.button))
	{
		game.firstServer = 0;
		game.ballPosition = player1.servePosition;
		game.ballDirection = player1.direction;
		return;
	}
}

void serveHandler(struct pingPongGame game, struct player player1, struct player player2)
{
	//check if game is awaiting a serve
	if(!game.status == 0)
	{
		return;
	}

	//check if it's the first serve
	if(!game.totalServes == 0)
	{
		firstServe(game, player1, player2);
		return;
	}


	//check who has to serve
	if(game.totalServes % 10 > 5)
	{

	}

}

void pingPongGame()
{
	//init game settings and players
	struct pingPongGame game = {
		.initialDelay = 10000,
		.decrementDelay = 5,

		.totalServes = 0,
		.servesPerPlayer = 5,
		.winsPerGame = 5,

		.status = 0
	};

	struct player player1 = {
		.minRange = 0,
		.maxRange = 3,
		.direction = 0,
		.lossLimit = -1,

		.button = 1,
		.score = 0,
		.cooldown = 3
	};

	struct player player2 = {
		.minRange = 6,
		.maxRange = 9,
		.direction = 1,
		.lossLimit = 10,

		.button = 1,
		.score = 0,
		.cooldown = 3
	};

	//game loop
	while(1)
	{
		//serving handler

		{

		}
		if(game.totalServes == 0)
		{
			//wait for a first player to push a button
			while()
		}
		if()

		//
	}

}




void pingPongSwing(int KEY_value, int playerButton, int *ballDistance, int *direction, int *lastSwing)
{
	while(1)
	{


		//check if player can swing
		/*if(!(*lastSwing-*ballDistance > cooldown))
		{
			// player can't swing
			break;
		}*/

		//printf("player can swing\n");

		//player swings, did he hit something?
		*lastSwing = *ballDistance;

		// check if swing can reach ball
		if(*ballDistance < swingRange)
		{
			//congrats, you swung at nothing
			break;
		}
		printf("player %d can swing\n", playerButton);

		// check if player tried to swing
		if(!bitval(KEY_value, playerButton) == 0) //check button 4(-1) : left player
		{
			// player didn't swing
			break;
		}
		printf("player tried to swing\n");

		printf("success! player %d hit the ball\n", playerButton);
		//ball changes directions (TODO : don't hit ball twice?)
		*direction = !*direction;
		*ballDistance = fieldLength - *ballDistance;
		break;
	}
}


void updateScore(int score1, int score2)
{
	int digits1[2]; // array to store the digits
	int digits2[2]; // array to store the digits
	int i;
	// split the count into individual digits
	for (i = 0; i < 2; i++)
	{
		digits1[i] = score1 % 10;
		score1 /= 10;
		digits2[i] = score2 % 10;
		score2 /= 10;
	}

	IOWR_ALTERA_AVALON_PIO_DATA(HEX0_BASE, seg_codes[digits1[0]]);
	IOWR_ALTERA_AVALON_PIO_DATA(HEX1_BASE, seg_codes[digits1[1]]);
	IOWR_ALTERA_AVALON_PIO_DATA(HEX2_BASE, 0x3F); //OFF
	IOWR_ALTERA_AVALON_PIO_DATA(HEX3_BASE, 0x3F); //OFF
	IOWR_ALTERA_AVALON_PIO_DATA(HEX4_BASE, seg_codes[digits2[0]]);
	IOWR_ALTERA_AVALON_PIO_DATA(HEX5_BASE, seg_codes[digits2[1]]);
}

void updateDisplay(int direction, int ballDistance)
{
	int activeLed = 0;
	if(direction == 0)
	{
		activeLed = ballDistance;
	}
	else
	{
		activeLed = fieldLength - ballDistance;
	}
	IOWR_ALTERA_AVALON_PIO_DATA(LEDR_BASE,(1 << activeLed));
}


void serveBall(int *direction, int* ballDistance)
{
	while(1)
	{

	}
}





int delayReduction = 1; //delay lost each swing
int playerScore_1 = 0;
int playerScore_2 = 0;

// length : terrain length in (led count)
void pingPong(int *direction, int *ballDistance, unsigned int *delay)
{

	//get key input
	//printf("get key input\n");
	int KEY_value = IORD_ALTERA_AVALON_PIO_DATA(KEY_BASE);

	//printf("Performing swings\n");
	int relativeDistance_1 = *ballDistance;
	int relativeDistance_2 = fieldLength - *ballDistance;
	pingPongSwing(KEY_value, button_1, &relativeDistance_1, direction, &lastSwing_1);
	pingPongSwing(KEY_value, button_2, &relativeDistance_2, direction, &lastSwing_2);


	//check who lost
	//printf("check who lost\n");
	if (*direction == 0)
	{
		 if(*ballDistance < 0)
		 {
			 printf("player 2 lost\n");
			 playerScore_1++;
			 *direction = !(*direction);
			 *ballDistance = fieldLength;
		 }
	}
	else
	{
		if(*ballDistance < 0)
		 {
			 printf("player 1 lost\n");
			 playerScore_2++;
			 *direction = !(*direction);
			 *ballDistance = fieldLength;
		 }
	}

	//update ball position
	*ballDistance = *ballDistance-1;

	//reduce delay to increase difficulty (TODO : negative )
	*delay = *delay - delayReduction;

	//update scoreboard
	updateScore(playerScore_1, playerScore_2);


	//update ball display
	updateDisplay(*direction, *ballDistance);

	printf("direction : %d\n", *direction);
	printf("distance : %d\n", *ballDistance);
	printf("delay : %d\n", *delay);
	printf("score : %d - %d\n", playerScore_1, playerScore_2);
	printf("last swing : %d - %d\n", lastSwing_1, lastSwing_2);
	fflush(stdout);
}


int main(void) {
	/* Declare volatile pointers to I/O registers (volatile means that IO load
	 * and store instructions will be used to access these pointer locations,
	 * instead of regular memory loads and stores)
	 */
	/*
	volatile int * red_LED_ptr = (int *) LEDR_BASE; // red LED address
	volatile int * HEX0_ptr = (int *) HEX0_BASE; // HEX0 address
	volatile int * HEX1_ptr = (int *) HEX1_BASE; // MODIFIED (prev 0x00081070) HEX0 address
	volatile int * SW_switch_ptr = (int *) SW_BASE; // SW slider switch address
	volatile int * KEY_ptr = (int *) KEY_BASE; // MODIFIED (prev 0x00081020) pushbutton KEY address*/


	int HEX_bits = 0x0000000F; // pattern for HEX displays
	int SW_value, KEY_value;
	volatile int delay_count; // volatile so the C compiler doesn't remove the loop
	int ch = 0;
	const int nReadNum = 10; // max 1024
	int i, Value, nIndex = 0;

	//pingPong
	unsigned int delay = 1000000;
	int direction = 1;
	int ballDistance = 0;


	printf("Yellow World !\n");
	while (1) {

		ch = IORD(SW_BASE, 0x00) & 0x07;
		SW_value = IORD_ALTERA_AVALON_PIO_DATA(SW_BASE); // read the SW slider switch values
		IOWR_ALTERA_AVALON_PIO_DATA(LEDR_BASE, SW_value); // light up the red LEDs
		IOWR_ALTERA_AVALON_PIO_DATA(HEX0_BASE, HEX_bits); // display pattern on HEX3 ... HEX0


		//#1#
		//printf("KEY_BASE : %d\n", IORD_ALTERA_AVALON_PIO_DATA(KEY_BASE));
		//updateChaseLeds(chaseLedsCount, &chaseLedsStep);
		/*
		//#2#
		consoleControl();

		//#3#
		printf("KEY_BASE : %d\n", IORD_ALTERA_AVALON_PIO_DATA(KEY_BASE));
		speedControl(&delay, 100);
		updateChaseLeds(chaseLedsCount, &chaseLedsStep);

		//#4#
		sevenSegCount ++;
		sevenSegCounter(sevenSegCount);*/

		//#5#
		//printf("Entering pingPong...\n");
		//fflush(stdout);
		pingPong(&direction, &ballDistance, &delay);


		/* rotate the pattern shown on the HEX displays */
		/*if (HEX_bits & 0x80)
			HEX_bits = (HEX_bits << 1) | 1;
		else
			HEX_bits = HEX_bits << 1;*/

		/*printf("======================= %d, ch=%d\r\n", nIndex++, ch);
		// set measure number for ADC convert
		IOWR(ADC_LTC2308_BASE, 0x01, nReadNum);
		// start measure
		IOWR(ADC_LTC2308_BASE, 0x00, (ch << 1) | 0x00);
		IOWR(ADC_LTC2308_BASE, 0x00, (ch << 1) | 0x01);
		IOWR(ADC_LTC2308_BASE, 0x00, (ch << 1) | 0x00);
		usleep(1);
		// wait measure done
		while ((IORD(ADC_LTC2308_BASE, 0x00) & 0x01) == 0x00)
			;
		// read adc value
		for (i = 0; i < nReadNum; i++) {
			Value = IORD(ADC_LTC2308_BASE, 0x01);
			printf("CH%d=%.3fV (0x%04x)\r\n", ch, (float) Value / 1000.0,
					Value);
		}*/
		usleep(delay); //replaced by millis delay
	} // while
	return 0;
}

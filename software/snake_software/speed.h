#ifndef _SPEED_H_
#define _SPEED_H_
#include "snake_io.h"

int SPEED_SIZE = 1;
unsigned long PRNG_seed = 15;

struct Speed{
	int xCoord;
	int yCoord;
	int enable;
};

void initSpeed(struct Speed speed[]){
	printf("Initializing speed\n");
	int x,y;
	x = (150/16)*16; y = (255/16)*16;
	/*PRNG_seed = PRNG_seed *1103515245 + 12345;
	PRNG_seed = (PRNG_seed/65536)%32768;
	x = PRNG_seed;
	PRNG_seed = PRNG_seed *1103515245 + 12345;
	PRNG_seed = (PRNG_seed/65536)%32768;
	y = PRNG_seed;

	x = x%RIGHT_BOUND;
	y = y%BOT_BOUND;*/

	speed[0].enable = 1;
	speed[0].xCoord = x;
	speed[0].yCoord = y;

	/*
	speed[1].enable = 1;
	speed[1].xCoord = 370;
	speed[1].yCoord = y;

	speed[2].enable = 1;
	speed[2].xCoord = 400;
	speed[2].yCoord = y;*/

	addTilePiece(SPEED_CODE, (short) y/16, (short) x/16 );
	//printf("speed location x:%d, y:%d\n", x, y);

}

void removeSpeed(struct Speed speed[], int index){
	printf("Removing speed\n");
	speed[index].enable = 0;
	//removeTilePiece((short) speed[index].yCoord/16, (short) speed[index].xCoord/16)
}

#endif

#ifndef _FOOD_H_
#define _FOOD_H_
#include "snake_io.h"
#define LEFT_BOUND	0
#define RIGHT_BOUND	640
#define BOT_BOUND	480
#define TOP_BOUND	0

int FOOD_SIZE = 1;
unsigned long PRNG_seed = 15;

struct Food{
	int xCoord;
	int yCoord;
	int enable;
};

void initFood(struct Food food[]){
	printf("Initializing food\n");
	int x,y;
	x = (350/16)*16; y = (255/16)*16;
	/*PRNG_seed = PRNG_seed *1103515245 + 12345;
	PRNG_seed = (PRNG_seed/65536)%32768;
	x = PRNG_seed;
	PRNG_seed = PRNG_seed *1103515245 + 12345;
	PRNG_seed = (PRNG_seed/65536)%32768;
	y = PRNG_seed;

	x = x%RIGHT_BOUND;
	y = y%BOT_BOUND;*/

	food[0].enable = 1;
	food[0].xCoord = x;
	food[0].yCoord = y;

	/*
	food[1].enable = 1;
	food[1].xCoord = 370;
	food[1].yCoord = y;

	food[2].enable = 1;
	food[2].xCoord = 400;
	food[2].yCoord = y;*/

	addTilePiece(RABBIT_CODE, (short) y/16, (short) x/16 );
	printf("food location x:%d, y:%d\n", x, y);

}

void removeFood(struct Food food[], int index){
	printf("Removing food\n");
	food[index].enable = 0;
	removeTilePiece((short) food[index].yCoord/16, (short) food[index].xCoord/16)
}

#endif

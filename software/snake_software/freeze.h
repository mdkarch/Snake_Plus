#ifndef _FREEZE_H_
#define _FREEZE_H_
#include "snake_io.h"

int FREEZE_SIZE = 1;

struct Freeze{
	int xCoord;
	int yCoord;
	int enable;
};

void initFreeze(struct Freeze freeze[]){
	printf("Initializing freeze\n");
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

	freeze[0].enable = 1;
	freeze[0].xCoord = x;
	freeze[0].yCoord = y;

	/*
	freeze[1].enable = 1;
	freeze[1].xCoord = 370;
	freeze[1].yCoord = y;

	freeze[2].enable = 1;
	freeze[2].xCoord = 400;
	freeze[2].yCoord = y;*/

	//addTilePiece(RABBIT_CODE, (short) y/16, (short) x/16 );
	//printf("freeze location x:%d, y:%d\n", x, y);

}

void removeFreeze(struct Freeze freeze[], int index){
	printf("Removing freeze\n");
	freeze[index].enable = 0;
	//removeTilePiece((short) freeze[index].yCoord/16, (short) freeze[index].xCoord/16)
}

#endif

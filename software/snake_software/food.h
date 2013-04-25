#ifndef _FOOD_H_
#define _FOOD_H_
#include "snake_io.h"
#define LEFT_BOUND	0
#define RIGHT_BOUND	640
#define BOT_BOUND	480
#define TOP_BOUND	0

int FOOD_SIZE = 1;

struct Food{
	int xCoord;
	int yCoord;
	int enable;
};

void initFood(struct Food food[]){
	printf("Initializing food\n");
	int x,y;
	x = (350/16)*16; y = (255/16)*16;

	food[0].enable = 1;
	food[0].xCoord = x;
	food[0].yCoord = y;
	addTilePiece(RABBIT_CODE, (short) x/16, (short) y/16 );

	x = (150/16)*16; y = (355/16)*16;
	food[1].enable = 1;
	food[1].xCoord = x;
	food[1].yCoord = y;
	addTilePiece(RABBIT_CODE, (short) x/16, (short) y/16 );
	printf("food location x:%d, y:%d\n", x, y);

}

void removeFood(struct Food food[], int index){
	printf("Removing food\n");
	food[index].enable = 0;
	removeTilePiece((short) food[index].xCoord/16, (short) food[index].yCoord/16);
}

#endif

#ifndef _FOOD_H_
#define _FOOD_H_
#include "snake_io.h"
#define X_LEN 40
#define Y_LEN 30

struct Food{
	int xCoord;
	int yCoord;
	int enable;
};

void initFood(struct Food food[], int board[X_LEN][Y_LEN]){
	printf("Initializing food\n");
	int i;
	int j;
	int count = 0;
	for(i = 0; i < X_LEN; i++){
		for(j = 0; j < Y_LEN; j++){
			if(board[i][j] == 0){
				food[count].enable = 0;
				food[count].xCoord = i;
				food[count].yCoord = j;
				count++;
			}
		}
	}


	/*for(i = 0; i < X_LEN; i++){
		for(j = 0; j < Y_LEN; j++){
			if(board[i][j] == 0){
				printf("food location x:%d, y:%d\n", i, j);
			}
		}
	}*/
	/*int x,y;
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
	x = (100/16)*16; y = (355/16)*16;

	food[2].enable = 1;
	food[2].xCoord = x;
	food[2].yCoord = y;
	addTilePiece(RABBIT_CODE, (short) x/16, (short) y/16 );
	x = (400/16)*16; y = (355/16)*16;

	food[3].enable = 1;
	food[3].xCoord = x;
	food[3].yCoord = y;
	addTilePiece(RABBIT_CODE, (short) x/16, (short) y/16 );
	x = (10/16)*16; y = (355/16)*16;

	food[4].enable = 1;
	food[4].xCoord = x;
	food[4].yCoord = y;
	addTilePiece(RABBIT_CODE, (short) x/16, (short) y/16 );
	printf("food location x:%d, y:%d\n", x, y);*/

}

void startFood(struct Food food[]){
	food[0].enable = 1;
	addTilePiece(RABBIT_CODE, (short) food[0].xCoord, (short) food[0].yCoord);
}

void drawFood(struct Food food[], int index){
	food[index].enable = 1;
	addTilePiece(RABBIT_CODE, (short) food[index].xCoord, (short) food[index].yCoord);
}

void removeFood(struct Food food[], int index){
	printf("Removing food\n");
	food[index].enable = 0;
	removeTilePiece((short) food[index].xCoord/16, (short) food[index].yCoord/16);
}

#endif

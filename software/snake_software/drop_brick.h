#ifndef _DROP_BRICK_H_
#define _DROP_BRICK_H_

#include "snake_io.h"
#include "powboard.h"
#include "constants.h"

void initBrickTile(){
	short i;
	short j;
	for(i = 0; i < X_LEN; i++){
		for(j = 0; j < Y_LEN; j++){
			brick_tiles[i][j] = 0;
		}
	}

	for(i = 0; i < X_LEN; i++){
		brick_tiles[i][0] = 1;
		brick_tiles[i][Y_LEN-1] = 1;
	}

	for(i = 0; i < Y_LEN; i++){
		brick_tiles[0][i] = 1;
		brick_tiles[X_LEN-1][i] = 1;
	}

}

void setBrickTile(struct Snake snake[], int index){
	short x_tile = (short)snake[index].xCoord;///16;
	short y_tile = (short)snake[index].yCoord;///16;
	brick_tiles[x_tile][y_tile] = 1;
	addTilePiece(WALL_CODE, x_tile, y_tile);
}
#endif

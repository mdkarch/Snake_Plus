#ifndef _BRICK_H_
#define _BRICK_H_
#include "snake_io.h"
#include "powboard.h"
#define MAX	136
#define X_LEN	40
#define Y_LEN	29

void initBorder(){
	int x;
	int y;
	for(x = 0; x < X_LEN){
		addTilePiece(WALL_CODE,   x,   0);
	}
	for(x = 0; x < X_LEN){
		addTilePiece(WALL_CODE,   x,   29);
	}
	for(y = 1; y < y_LEN){
		addTilePiece(WALL_CODE,   0,   y);
	}
	for(y = 1; y < y_LEN){
		addTilePiece(WALL_CODE,   39,   y);
	}
}

#endif
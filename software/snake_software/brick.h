#ifndef _BRICK_H_
#define _BRICK_H_

#include "snake_io.h"
#include "powboard.h"

#define MAX	136
#define X_BORDER	40
#define Y_BORDER	30

void initBorder(){
	int x;
	int y;
	for(x = 0; x < X_BORDER; x++){
		addTilePiece(WALL_CODE,   x,   0);
	}
//	for(x = 0; x < X_BORDER; x++){
//		addTilePiece(WALL_CODE,   x,   29);
//	}
//	for(y = 1; y < Y_BORDER; y++){
//		addTilePiece(WALL_CODE,   0,   y);
//	}
//	for(y = 1; y < Y_BORDER; y++){d
//		addTilePiece(WALL_CODE,   39,   y);
//	}
}

#endif

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
	for(x = 0; x < X_BORDER; x++){
		addTilePiece(WALL_CODE,   x,   29);
	}
	for(y = 1; y < Y_BORDER; y++){
		addTilePiece(WALL_CODE,   0,   y);
	}
	for(y = 1; y < Y_BORDER; y++){
		addTilePiece(WALL_CODE,   39,   y);
	}
}

void updateBorder(){
	NEW_TOP += 1;
	NEW_BOT -= 1;
	NEW_LEFT += 1;
	NEW_RIGHT -= 1;
	LEFT_BOUND	+= 1;
	RIGHT_BOUND	-= 1;
	BOT_BOUND	-= 1;
	TOP_BOUND	+= 1;

	int x;
	int y;
	for(x = 0; x < X_BORDER; x++){
		brick_tiles[x][NEW_TOP] = 1;
		checkOverlap(x, NEW_TOP);
		addTilePiece(WALL_CODE,   x,   NEW_TOP);
	}
	for(x = 0; x < X_BORDER; x++){
		brick_tiles[x][NEW_BOT] = 1;
		checkOverlap(x, NEW_BOT);
		addTilePiece(WALL_CODE,   x,   NEW_BOT);
	}
	for(y = 1; y < Y_BORDER; y++){
		brick_tiles[NEW_LEFT][y] = 1;
		checkOverlap(NEW_LEFT, y);
		addTilePiece(WALL_CODE,   NEW_LEFT,   y);
	}
	for(y = 1; y < Y_BORDER; y++){
		brick_tiles[NEW_RIGHT][y] = 1;
		checkOverlap(NEW_RIGHT, y);
		addTilePiece(WALL_CODE,   NEW_RIGHT,   y);
	}
}

void checkOverlap(int x, int y){
	if(food[food_index-1].enable && food[food_index-1].xCoord == x && food[food_index-1].yCoord == y){
		food[food_index-1].enable = 0;
		food_count--;
		removeTilePiece((short)x, (short)y);
	}else if(speed[speed_index-1].enable && speed[speed_index-1].xCoord == x && speed[speed_index-1].yCoord == y){
		speed[speed_index-1].enable = 0;
		removeTilePiece((short)x, (short)y);
		speed_drawn = 0;
	}else if(freeze[freeze_index-1].enable && freeze[freeze_index-1].xCoord == x && freeze[freeze_index-1].yCoord == y){
		freeze[freeze_index-1].enable = 0;
		removeTilePiece((short)x, (short)y);
		freeze_drawn = 0;
	}if(edwards[edwards_index-1].enable && edwards[edwards_index-1].xCoord == x && edwards[edwards_index-1].yCoord == y){
		edwards[edwards_index-1].enable = 0;
		removeTilePiece((short)x, (short)y);
		edwards_drawn = 0;
	}
}

#endif

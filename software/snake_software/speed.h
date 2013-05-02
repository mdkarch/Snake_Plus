#ifndef _SPEED_H_
#define _SPEED_H_
#include "snake_io.h"
#include "powboard.h"
#include "constants.h"

void initSpeed(struct Speed speed[], int board[X_LEN][Y_LEN]){
	printf("Initializing speed\n");
	int i;
	int j;
	int count = 0;
	for(i = 0; i < X_LEN; i++){
		for(j = 0; j < Y_LEN; j++){
			if(board[i][j] == 2){
				speed[count].enable = 0;
				speed[count].xCoord = i;
				speed[count].yCoord = j;
				count++;
			}
		}
	}

	shuffle_speed(speed,MAX_POWERUP_SIZE);
}


int drawSpeed(struct Speed speed[], int index){
	if((speed[index].xCoord <= 2 || speed[index].xCoord >= X_LEN-1)
			|| (speed[index].yCoord <= 2 || speed[index].yCoord >= Y_LEN-1)){
		return 0;
	}

	short t_xCoord = speed[index].xCoord;
	short t_yCoord = speed[index].yCoord;

	if(brick_tiles[t_xCoord][t_yCoord]){
		return 0;
	}

	if(freeze[index].enable || food[index].enable || edwards[index].enable){
			return 0;
	}

	speed[index].enable = 1;
	addTilePiece(SPEED_CODE, (short) speed[index].xCoord, (short) speed[index].yCoord);
	return 1;
}

void removeSpeed(struct Speed speed[], int index){
	printf("Removing speed\n");
	speed[index].enable = 0;
	removeTilePiece((short) speed[index].xCoord, (short) speed[index].yCoord);
}

void shuffle_speed(struct Speed arr[], int n){
	int i;
	for(i = 0; i < n; i++){
		int index = PRNG(n);
		struct Speed temp = arr[index];
		arr[index] = arr[i];
		arr[i] = temp;
	}
}
#endif

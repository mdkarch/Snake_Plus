#ifndef _SPEED_H_
#define _SPEED_H_
#include "snake_io.h"
#include "powboard.h"
#define X_LEN		40
#define Y_LEN		30
#define MAX_SPEED	400

struct Speed{
	int xCoord;
	int yCoord;
	int enable;
};

void initSpeed(struct Speed speed[]){
	printf("Initializing speed\n");
	int i;
	int j;
	int count = 0;
	for(i = 0; i < X_LEN; i++){
		for(j = 0; j < Y_LEN; j++){
			if(board[i][j] == 1){
				speed[count].enable = 0;
				speed[count].xCoord = i;
				speed[count].yCoord = j;
				count++;
			}
		}
	}

	shuffle_speed(speed,MAX_SPEED);
}

void startSpeed(struct Speed speed[]){
	speed[15].enable = 1;
	addTilePiece(FREEZE_CODE, (short) speed[15].xCoord, (short) speed[15].yCoord);
}

int drawSpeed(struct Speed speed[], int index){
	if((speed[index].xCoord == 0 || speed[index].xCoord == 29)
			|| (speed[index].yCoord == 0 || speed[index].yCoord == 39)){
		return 0;
	}

	speed[index].enable = 1;
	addTilePiece(FREEZE_CODE, (short) speed[index].xCoord, (short) speed[index].yCoord);
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

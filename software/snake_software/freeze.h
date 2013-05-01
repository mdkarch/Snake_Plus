#ifndef _FREEZE_H_
#define _FREEZE_H_
#include "snake_io.h"
#include "powboard.h"
#define X_LEN		40
#define Y_LEN		30
#define MAX_FREEZE	400

struct Freeze{
	int xCoord;
	int yCoord;
	int enable;
};

void initFreeze(struct Freeze freeze[], int board[X_LEN][Y_LEN]){
	printf("Initializing freeze\n");
	int i;
	int j;
	int count = 0;
	for(i = 0; i < X_LEN; i++){
		for(j = 0; j < Y_LEN; j++){
			if(board[i][j] == 1){
				freeze[count].enable = 0;
				freeze[count].xCoord = i;
				freeze[count].yCoord = j;
				count++;
			}
		}
	}

	shuffle_freeze(freeze,MAX_FREEZE);
}

void startFreeze(struct Freeze freeze[]){
	freeze[15].enable = 1;
	addTilePiece(FREEZE_CODE, (short) freeze[15].xCoord, (short) freeze[15].yCoord);
}

int drawFreeze(struct Freeze freeze[], int index){
	if((freeze[index].xCoord <= 2 || freeze[index].xCoord <= X_LEN-1)
			|| (freeze[index].yCoord <= 2 || freeze[index].yCoord <= Y_LEN-1)){
		return 0;
	}

	freeze[index].enable = 1;
	addTilePiece(FREEZE_CODE, (short) freeze[index].xCoord, (short) freeze[index].yCoord);
	return 1;
}

void removeFreeze(struct Freeze freeze[], int index){
	printf("Removing freeze\n");
	freeze[index].enable = 0;
	removeTilePiece((short) freeze[index].xCoord, (short) freeze[index].yCoord);
}

void shuffle_freeze(struct Freeze arr[], int n){
	int i;
	for(i = 0; i < n; i++){
		int index = PRNG(n);
		struct Freeze temp = arr[index];
		arr[index] = arr[i];
		arr[i] = temp;
	}
}

#endif

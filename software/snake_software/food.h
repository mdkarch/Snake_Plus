#ifndef _FOOD_H_
#define _FOOD_H_
#include "snake_io.h"
#include "powboard.h"
#define X_LEN		40
#define Y_LEN		30
#define MAX_FOOD	400

struct Food{
	int xCoord;
	int yCoord;
	int enable;
	int type;
};

void initFood(struct Food food[], int board[X_LEN][Y_LEN]){
	printf("Initializing food\n");
	int t = 0;
	int i;
	int j;
	int count = 0;
	for(i = 0; i < X_LEN; i++){
		for(j = 0; j < Y_LEN; j++){
			if(board[i][j] == 0){
				food[count].enable = 0;
				food[count].type = t;
				food[count].xCoord = i;
				food[count].yCoord = j;
				count++;
				if(t == 0){
					t = 1;
				}
				else {
					t = 0;
				}
			}
		}
	}

	shuffle_food(food,MAX_FOOD);
}


int drawFood(struct Food food[], int index){
	if((food[index].xCoord <= 2 || food[index].xCoord >= X_LEN-1)
			|| (food[index].yCoord <= 2 || food[index].yCoord >= Y_LEN-1)){
		return 0;
	}

	food[index].enable = 1;
	if(food[index].type){
		addTilePiece(RABBIT_CODE, (short) food[index].xCoord, (short) food[index].yCoord);
	}else{
		addTilePiece(MOUSE_CODE, (short) food[index].xCoord, (short) food[index].yCoord);
	}
	return 1;
}

void removeFood(struct Food food[], int index){
	printf("Removing food\n");
	food[index].enable = 0;
	removeTilePiece((short) food[index].xCoord, (short) food[index].yCoord);
}

void shuffle_food(struct Food arr[], int n){
	int i;
	for(i = 0; i < n; i++){
		int index = PRNG(n);
		struct Food temp = arr[index];
		arr[index] = arr[i];
		arr[i] = temp;
	}
}


#endif

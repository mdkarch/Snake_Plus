#ifndef _FOOD_H_
#define _FOOD_H_
#include "snake_io.h"
#include "powboard.h"
#include "constants.h"


void initFood(){
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

	shuffle_food(MAX_POWERUP_SIZE);
}

int checkFood(struct Snake snake[], int dir, int player, struct SnakeInfo * info)
{
	//struct Snake *head = snake[0];
	int j;
	for(j = 0; j < MAX_POWERUP_SIZE; j++){
		if(food[j].enable){
			int xDiff = abs(snake[0].xCoord - food[j].xCoord*16);
			int yDiff = abs(snake[0].yCoord - food[j].yCoord*16);
			//printf("snake x: %d y: %d\n",snake[0].xCoord, snake[0].yCoord);
			//printf("food x: %d y: %d\n",food[j].xCoord, food[j].yCoord);
			if(xDiff <= col_offset && yDiff <= col_offset){
				printf("Eating Food!\n");
				removeFood(j);
				addEnd(snake, dir, player, info);
				if(food_index == MAX_POWERUP_SIZE){
					food_index = 0;
				}
				while( !drawFood(food_index++) );
				break;		// Original sleep time/SLEEP_TIME

			}
		}
	}
	return 0;
}

int drawFood(int index){
	if((food[index].xCoord <= 2 || food[index].xCoord >= X_LEN-1)
			|| (food[index].yCoord <= 2 || food[index].yCoord >= Y_LEN-1) ){
		return 0;
	}
	short f_xCoord = food[index].xCoord;
	short f_yCoord = food[index].yCoord;

	if(brick_tiles[f_xCoord][f_yCoord]){
		return 0;
	}

	if(freeze[index].enable || speed[index].enable || edwards[index].enable){
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

void removeFood(int index){
	printf("Removing food\n");
	food[index].enable = 0;
	removeTilePiece((short) food[index].xCoord, (short) food[index].yCoord);
}

void shuffle_food(int n){
	int i;
	for(i = 0; i < n; i++){
		int index = PRNG(n);
		struct Food temp = food[index];
		food[index] = food[i];
		food[i] = temp;
	}
}


#endif

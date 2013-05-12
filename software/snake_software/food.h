#ifndef _FOOD_H_
#define _FOOD_H_
#include "snake_io.h"
#include "powboard.h"
#include "constants.h"
#include "audio.h"


void initFood(){
	//printf("Initializing food\n");
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

int checkFood(struct Snake snake[], struct Snake other_snake[], int dir, int player, struct SnakeInfo * info)
{
	/* if food count == 0 it will try to draw food in the next available location */
	if(food_count == 0){
		drawFood(snake, other_snake);
	}
	//struct Snake *head = snake[0];
	int j;
	for(j = 0; j < MAX_POWERUP_SIZE; j++){
		if(food[j].enable){
			//int xDiff = abs(snake[0].xCoord - food[j].xCoord*16);
			//int yDiff = abs(snake[0].yCoord - food[j].yCoord*16);
			//////printf("snake x: %d y: %d\n",snake[0].xCoord, snake[0].yCoord);
			//////printf("food x: %d y: %d\n",food[j].xCoord, food[j].yCoord);
			if(snake[0].xCoord == food[j].xCoord && snake[0].yCoord == food[j].yCoord){//if(xDiff <= col_offset && yDiff <= col_offset){
				////printf("Eating Food!\n");
				play_powerup_sound();
				removeFood(j);
				addEnd(snake, dir, player, info);
				/*food_index == MAX_POWERUP_SIZE){
					food_index = 0;
				}*/
				//while( !drawFood(snake, other_snake) );
				/* iterate 100 times looking for the next
				 * free element, if not found
				 */
				if(player == PLAYER1){
					player1_food_eaten++;
					if(player1_food_eaten == 5){
						player1_food_eaten = 0;
						PLAYER1_SLEEP_CYCLES -= 1;
					}
				}else{
					if(player2_food_eaten == 5){
						player2_food_eaten = 0;
						PLAYER2_SLEEP_CYCLES -= 1;
					}
				}
				int i;
				for(i = 0 ; i < 50; i++){
					if(drawFood(snake, other_snake)){
						break;
					}
				}
				break;		// Original sleep time/SLEEP_TIME

			}
		}
	}
	return 0;
}

int drawFood(struct Snake snake[], struct Snake other_snake[]){
	if(food_index == MAX_POWERUP_SIZE){
		food_index = 0;
	}
	if((food[food_index].xCoord <= 2 || food[food_index].xCoord >= X_LEN-1)
			|| (food[food_index].yCoord <= 2 || food[food_index].yCoord >= Y_LEN-1) ){
		food_index++;
		return 0;
	}
	short f_xCoord = food[food_index].xCoord;
	short f_yCoord = food[food_index].yCoord;
	int i;
	for(i = 0; i < SNAKE_SIZE; i++){
		if(!(snake[i].enable || other_snake[i].enable)){
			break;
		}
		if(snake[i].enable){
			if(snake[i].xCoord == f_xCoord && snake[i].yCoord == f_yCoord){
				food_index++;
				return 0;
			}
		}
		if(other_snake[i].enable){
			if(other_snake[i].xCoord == f_xCoord && other_snake[i].yCoord == f_yCoord){
				food_index++;
				return 0;
			}
		}
	}
	if(brick_tiles[f_xCoord][f_yCoord]){
		food_index++;
		return 0;
	}

	if(freeze[food_index].enable || speed[food_index].enable || edwards[food_index].enable){
		food_index++;
		return 0;
	}

	food[food_index].enable = 1;
	if(food[food_index].type){
		addTilePiece(RABBIT_CODE,  food[food_index].xCoord,  food[food_index].yCoord);
	}else{
		addTilePiece(MOUSE_CODE,  food[food_index].xCoord,  food[food_index].yCoord);
	}
	food_index++;
	food_count++;
	return 1;
}

void removeFood(int index){
	////printf("Removing food\n");
	food[index].enable = 0;
	removeTilePiece( food[index].xCoord,  food[index].yCoord);
	food_count--;
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

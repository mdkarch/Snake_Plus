#ifndef _SPEED_H_
#define _SPEED_H_
#include "snake_io.h"
#include "powboard.h"
#include "constants.h"

void initSpeed(){
	//printf("Initializing speed\n");
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

	shuffle_speed(MAX_POWERUP_SIZE);
}

int checkSpeed(struct Snake snake[], struct Snake other_snake[], int player, struct SnakeInfo * info){
	int j;
	for(j = 0; j < MAX_POWERUP_SIZE; j++){
		if(speed[j].enable){
			//int xDiff = abs(snake[0].xCoord - speed[j].xCoord*16);
			//int yDiff = abs(snake[0].yCoord - speed[j].yCoord*16);
			//printf("snake x: %d y: %d\n",snake[0].xCoord, snake[0].yCoord);
			//printf("food x: %d y: %d\n",food[j].xCoord, food[j].yCoord);
			if(snake[0].xCoord == speed[j].xCoord && snake[0].yCoord == speed[j].yCoord){//if(xDiff <= col_offset && yDiff <= col_offset){
				//printf("Eating Speed!\n");
				removeSpeed(j);
				info->speed_enabled = 1;
				info->speed_count = 0;
				//addEnd(snake, dir, player, info);
				if(player == PLAYER1){
					PLAYER1_SLEEP_CYCLES 	= SPEED_SLEEP_CYCLE / SLEEP_TIME;
				}else{
					PLAYER2_SLEEP_CYCLES 	= SPEED_SLEEP_CYCLE / SLEEP_TIME;
				}
				//				if(speed_index == MAX_POWERUP_SIZE){
				//					speed_index = 0;
				//				}
				//while( !drawSpeed(speed_index++) );
				break;
			}
		}
	}
	if(speed_pow_count == 250 && !speed_drawn){
		int i;
		for(i = 0 ; i < 50; i++){
			if(drawSpeed(snake, other_snake)){
				break;
			}
		}
		//speed_drawn = 1;
		speed_pow_count  = 0;
	}
	if(speed_pow_count == 300){
		speed_pow_count  = 0;
	}
	speed_pow_count++;
	//printf("speed_count: %d\n", info->speed_count);
	if(info->speed_enabled){
		info->speed_count++;
		if(info->speed_count >=  SPEED_TIME){
			//printf("reseting speed\n");
			info->speed_enabled = 0;
			info->speed_count = 0;
			if(player == PLAYER1){
				PLAYER1_SLEEP_CYCLES 	= DEFAULT_SLEEP_CYCLE / SLEEP_TIME;
			}else{
				PLAYER2_SLEEP_CYCLES 	= DEFAULT_SLEEP_CYCLE / SLEEP_TIME;
			}
		}
	}
	return 0;
}

int drawSpeed(struct Snake snake[], struct Snake other_snake[]){
	if(speed_index == MAX_POWERUP_SIZE){
		speed_index = 0;
	}
	if((speed[speed_index].xCoord <= 2 || speed[speed_index].xCoord >= X_LEN-1)
			|| (speed[speed_index].yCoord <= 2 || speed[speed_index].yCoord >= Y_LEN-1)){
		speed_index++;
		return 0;
	}

	short t_xCoord = speed[speed_index].xCoord;
	short t_yCoord = speed[speed_index].yCoord;
	int i;
	for(i = 0; i < SNAKE_SIZE; i++){
		if(!(snake[i].enable || other_snake[i].enable)){
			break;
		}
		if(snake[i].enable){
			if(snake[i].xCoord == t_xCoord && snake[i].yCoord == t_yCoord){
				speed_index++;
				return 0;
			}
		}
		if(other_snake[i].enable){
			if(other_snake[i].xCoord == t_xCoord && other_snake[i].yCoord == t_yCoord){
				speed_index++;
				return 0;
			}
		}
	}
	if(brick_tiles[t_xCoord][t_yCoord]){
		speed_index++;
		return 0;
	}

	if(freeze[speed_index].enable || food[speed_index].enable || edwards[speed_index].enable){
		speed_index++;
		return 0;
	}

	speed[speed_index].enable = 1;
	speed_drawn = 1;
	addTilePiece(SPEED_CODE,  speed[speed_index].xCoord,  speed[speed_index].yCoord);
	speed_index++;
	return 1;
}

void removeSpeed( int index){
	//printf("Removing speed\n");
	speed[index].enable = 0;
	speed_drawn = 0;
	removeTilePiece( speed[index].xCoord,  speed[index].yCoord);
}

void shuffle_speed(int n){
	int i;
	for(i = 0; i < n; i++){
		int index = PRNG(n);
		struct Speed temp = speed[index];
		speed[index] = speed[i];
		speed[i] = temp;
	}
}
#endif

#ifndef _FREEZE_H_
#define _FREEZE_H_

#include "snake_io.h"
#include "powboard.h"
#include "constants.h"
#include "audio.h"



void initFreeze(){
	//printf("Initializing freeze\n");
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

	shuffle_freeze(freeze,MAX_POWERUP_SIZE);
}

int checkFreeze(struct Snake snake[], struct Snake other_snake[], int player, struct SnakeInfo * info){

	int j = freeze_index - 1;
	//for(j = 0; j < MAX_POWERUP_SIZE; j++){
		if(freeze[j].enable){
			//int xDiff = abs(snake[0].xCoord - freeze[j].xCoord*16);
			//int yDiff = abs(snake[0].yCoord - freeze[j].yCoord*16);
			////printf("snake x: %d y: %d\n",snake[0].xCoord, snake[0].yCoord);
			if(snake[0].xCoord == freeze[j].xCoord && snake[0].yCoord == freeze[j].yCoord){//if(xDiff <= col_offset && yDiff <= col_offset){
				//printf("Eating Freeze!\n");
				play_powerup_sound();
				removeFreeze(freeze,j);
				info->has_freeze = 1;
				//				if(freeze_index == MAX_POWERUP_SIZE){
				//					freeze_index = 0;
				//				}
				//while( !drawFreeze(freeze) );
				//break;
			}
		}
	//}
	////printf("count: %d drawn:%d", freeze_pow_count, freeze_drawn);
	if(freeze_pow_count == 400 && !freeze_drawn){
		int i;
		for(i = 0 ; i < 50; i++){
			if(drawFreeze(snake, other_snake)){
				break;
			}
		}
		//freeze_drawn = 1;
		freeze_pow_count  = 0;
	}
	if(freeze_pow_count == 300){
		freeze_pow_count  = 0;
	}
	freeze_pow_count++;
	return 0;
}

void apply_freeze(struct Snake snake[], int player, struct SnakeInfo * info){

	if( !info->has_freeze ){
		//printf("PLAYER%d DOESNT HAVE FREEZE\n", player);
		return;
	}

	//printf("PLAYER%d used his freeze\n",player);
	info->has_freeze = 0;
	info->freeze_enabled = 1;
	info->freeze_count = 0;
	if(player == PLAYER1){
		PLAYER2_SLEEP_CYCLES 	= FREEZE_SLEEP_CYCLE / SLEEP_TIME;
	} else{
		PLAYER1_SLEEP_CYCLES 	= FREEZE_SLEEP_CYCLE / SLEEP_TIME;
	}

}

int recalc_freeze_times(struct Snake snake[], int player, struct SnakeInfo * info){

	if(info->freeze_enabled){
		info->freeze_count++;
		if(info->freeze_count >=  FREEZE_TIME){
			info->freeze_enabled = 0;
			info->freeze_count = 0;
			if(player == PLAYER1){
				PLAYER2_SLEEP_CYCLES 	= DEFAULT_SLEEP_CYCLE / SLEEP_TIME;
			}else{
				PLAYER1_SLEEP_CYCLES 	= DEFAULT_SLEEP_CYCLE / SLEEP_TIME;
			}

		}
	}
	return 1;
}

int drawFreeze(struct Snake snake[], struct Snake other_snake[]){
	if(freeze_index == MAX_POWERUP_SIZE){
		freeze_index = 0;
	}
	if((freeze[freeze_index].xCoord <= 2 || freeze[freeze_index].xCoord >= X_LEN-1)
			|| (freeze[freeze_index].yCoord <= 2 || freeze[freeze_index].yCoord >= Y_LEN-1)){
		freeze_index++;
		return 0;
	}

	short t_xCoord = freeze[freeze_index].xCoord;
	short t_yCoord = freeze[freeze_index].yCoord;
	int i;
	for(i = 0; i < SNAKE_SIZE; i++){
		if(!(snake[i].enable || other_snake[i].enable)){
			break;
		}
		if(snake[i].enable){
			if(snake[i].xCoord == t_xCoord && snake[i].yCoord == t_yCoord){
				freeze_index++;
				return 0;
			}
		}
		if(other_snake[i].enable){
			if(other_snake[i].xCoord == t_xCoord && other_snake[i].yCoord == t_yCoord){
				freeze_index++;
				return 0;
			}
		}
	}
	if(brick_tiles[t_xCoord][t_yCoord]){
		freeze_index++;
		return 0;
	}

	if(food[freeze_index].enable || speed[freeze_index].enable || edwards[freeze_index].enable){
		freeze_index++;
		return 0;
	}
	freeze_drawn = 1;
	freeze[freeze_index].enable = 1;
	//printf("Freeze ENABLED at x: %d y: %d\n",freeze[freeze_index].xCoord, freeze[freeze_index].yCoord);
	addTilePiece(FREEZE_CODE,  freeze[freeze_index].xCoord,  freeze[freeze_index].yCoord);

	//printf("Freeze index: %d\n", freeze_index);
	freeze_index++;

	return 1;
}

void removeFreeze(struct Freeze freeze[], int index){
	//printf("Removing freeze\n");
	freeze[index].enable = 0;
	freeze_drawn = 0;
	removeTilePiece( freeze[index].xCoord,  freeze[index].yCoord);
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

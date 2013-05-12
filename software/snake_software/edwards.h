#ifndef EDWARDS_H_
#define EDWARDS_H_
#include "drop_brick.h"
#include "brick.h"
#include "audio.h"

void initEdwards(){
	initBrickTile();
	//printf("Initializing edwards\n");
	int t = 0;
	int i;
	int j;
	int count = 0;
	/* counters below used to "simulate" probability */
	int bss_count = 0;/* brick/switch snake counter */
	int bc_count = 0; /* border change counter */
	for(i = 0; i < X_LEN; i++){
		for(j = 0; j < Y_LEN; j++){
			if(board[i][j] == 3){
				edwards[count].enable = 0;
				edwards[count].type = t;
				edwards[count].xCoord = i;
				edwards[count].yCoord = j;
				if(bc_count == 20){
					t = 2;
					bc_count = 0;
				}else if(bss_count == 2){
					t = 1;
					bss_count = 0;
				}
				else {
					t = 0;
					bss_count++;
				}
				count++;
				bc_count++;
			}
		}
	}
	shuffle_edwards(MAX_POWERUP_SIZE);

}

int drawEdwards(struct Snake snake[], struct Snake other_snake[]){
	if(edwards_index == MAX_POWERUP_SIZE){
		edwards_index = 0;
	}
	if((edwards[edwards_index].xCoord <= 2 || edwards[edwards_index].xCoord >= X_LEN-1)
			|| (edwards[edwards_index].yCoord <= 2 || edwards[edwards_index].yCoord >= Y_LEN-1) ){
		edwards_index++;
		return 0;
	}
	short f_xCoord = edwards[edwards_index].xCoord;
	short f_yCoord = edwards[edwards_index].yCoord;
	int i;
	for(i = 0; i < SNAKE_SIZE; i++){
		if(!(snake[i].enable || other_snake[i].enable)){
			break;
		}
		if(snake[i].enable){
			if(snake[i].xCoord == f_xCoord && snake[i].yCoord == f_yCoord){
				edwards_index++;
				return 0;
			}
		}
		if(other_snake[i].enable){
			if(other_snake[i].xCoord == f_xCoord && other_snake[i].yCoord == f_yCoord){
				edwards_index++;
				return 0;
			}
		}
	}
	if(brick_tiles[f_xCoord][f_yCoord]){
		edwards_index++;
		return 0;
	}

	if(freeze[edwards_index].enable || speed[edwards_index].enable || food[edwards_index].enable){
		edwards_index++;
		return 0;
	}

	edwards[edwards_index].enable = 1;
	//if(edwards[edwards_index].type){
	//printf("added edwards at %d", edwards_index);
	addTilePiece(EDWARDS_CODE,  edwards[edwards_index].xCoord,  edwards[edwards_index].yCoord);
	//}else{
	//	addTilePiece(MOUSE_CODE,  edwards[index].xCoord,  edwards[index].yCoord);
	//}
	edwards_index++;
	edwards_drawn = 1;
	return 1;
}

void removeEdwards(int index){
	//printf("Removing edwards\n");
	//edwards[index].enable = 0;
	//removeTilePiece( edwards[index].xCoord,  edwards[index].yCoord);
	edwards[index].enable = 0;
	//printf("removing at %d x:%d, y:%d", index, edwards[index].xCoord, edwards[index].yCoord);
	removeTilePiece( edwards[index].xCoord,  edwards[index].yCoord);
	edwards_drawn = 0;
}

void shuffle_edwards(int n){
	int i;
	for(i = 0; i < n; i++){
		int index = PRNG(n);
		struct Edwards temp = edwards[index];
		edwards[index] = edwards[i];
		edwards[i] = temp;
	}
}

int checkEdwards(struct Snake snake[], struct Snake other_snake[], int player, struct SnakeInfo * info)
{
	int j = edwards_index - 1;
	//for(j = 0; j < MAX_POWERUP_SIZE; j++){
		if(edwards[j].enable){
			//int xDiff = abs(snake[0].xCoord - edwards[j].xCoord*16);
			//int yDiff = abs(snake[0].yCoord - edwards[j].yCoord*16);
			//printf("snake x: %d y: %d\n",snake[0].xCoord, snake[0].yCoord);
			if(snake[0].xCoord == edwards[j].xCoord && snake[0].yCoord == edwards[j].yCoord){//if(xDiff <= col_offset && yDiff <= col_offset){
				//printf("Eating Edwards!\n");
				//printf("x:%d, y:%d", edwards[j].xCoord, edwards[j].yCoord);
				play_powerup_sound();
				removeEdwards(j);
				info->has_edwards = 1;
				//				if(edwards_index == MAX_POWERUP_SIZE){
				//					edwards_index = 0;
				//				}
				//				while( !drawEdwards(snake, other_snake) ){
				//					printf("drawing edwards\n");
				//				}
				//break;
			}
		}
	//}
	if(edwards_pow_count == 300 && !edwards_drawn){
		int i;
		for(i = 0 ; i < 50; i++){
			if(drawEdwards(snake, other_snake)){
				break;
			}
		}
		//edwards_drawn = 1;
		edwards_pow_count  = 0;
	}
	if(edwards_pow_count == 300){
		edwards_pow_count  = 0;
	}
	edwards_pow_count++;
	return 0;
}

void apply_edwards(struct Snake snake[], struct Snake other_snake[], int player, struct SnakeInfo * info){

	if( !info->has_edwards ){
		//printf("PLAYER%d DOESNT HAVE EDWARDS\n", player);
		return;
	}

	//printf("PLAYER%d used his edwards\n",player);
	/*
	 * do this because edwards_index is one ahead
	 * since it is incremented in the draw()
	 */
	int remove_at = 0;
	if(edwards_index == 0){
		remove_at = MAX_POWERUP_SIZE-1;
	}else{
		remove_at = edwards_index - 1;
	}


	if(edwards[remove_at].type == 0){
		setBrickTile(snake, info->tail);
	}else if(edwards[remove_at].type == 1){
		if(PLAYER1 == 1 && PLAYER2 == 2){
			PLAYER1 = 2;
			PLAYER2 = 1;
		}else{
			PLAYER1 = 1;
			PLAYER2 = 2;
		}
	}else{
		updateBorder();
	}
	info->has_edwards = 0;
}

#endif /* EDWARDS_H_ */

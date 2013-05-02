#ifndef EDWARDS_H_
#define EDWARDS_H_
#include "drop_brick.h"

void initEdwards(struct Edwards edwards[], int board[X_LEN][Y_LEN]){
	initBrickTile();
	printf("Initializing edwards\n");
	int t = 1;
	int i;
	int j;
	int count = 0;
	for(i = 0; i < X_LEN; i++){
		for(j = 0; j < Y_LEN; j++){
			if(board[i][j] == 3){
				edwards[count].enable = 0;
				edwards[count].type = t;
				edwards[count].xCoord = i;
				edwards[count].yCoord = j;
				count++;
				//need to change types to indicate what edwards does
				/*if(t == 0){
					t = 1;
				}
				else {
					t = 0;
				}*/
			}
		}
	}
	shuffle_edwards(edwards, MAX_POWERUP_SIZE);

}

int drawEdwards(struct Edwards edwards[]){
	if((edwards[edwards_index].xCoord <= 2 || edwards[edwards_index].xCoord >= X_LEN-1)
			|| (edwards[edwards_index].yCoord <= 2 || edwards[edwards_index].yCoord >= Y_LEN-1) ){
		edwards_index++;
		return 0;
	}
	short f_xCoord = edwards[edwards_index].xCoord;
	short f_yCoord = edwards[edwards_index].yCoord;

	if(brick_tiles[f_xCoord][f_yCoord]){
		edwards_index++;
		return 0;
	}

	if(freeze[edwards_index].enable || speed[edwards_index].enable || food[edwards_index].enable){
		edwards_index++;
		return 0;
	}

	edwards[edwards_index].enable = 1;
	if(edwards[edwards_index].type){
		printf("added edwards at %d", edwards_index);
		addTilePiece(EDWARDS_CODE, (short) edwards[edwards_index].xCoord, (short) edwards[edwards_index].yCoord);
	}else{
		//addTilePiece(MOUSE_CODE, (short) edwards[index].xCoord, (short) edwards[index].yCoord);
	}
	edwards_index++;
	return 1;
}

void removeEdwards(struct Edwards edwards[], int index){
	printf("Removing edwards\n");
	//edwards[index].enable = 0;
	//removeTilePiece((short) edwards[index].xCoord, (short) edwards[index].yCoord);
	edwards[index].enable = 0;
	printf("removing at %d x:%d, y:%d", index, edwards[index].xCoord, edwards[index].yCoord);
	removeTilePiece((short) edwards[index].xCoord, (short) edwards[index].yCoord);
}

void shuffle_edwards(struct Edwards arr[], int n){
	int i;
	for(i = 0; i < n; i++){
		int index = PRNG(n);
		struct Edwards temp = arr[index];
		arr[index] = arr[i];
		arr[i] = temp;
	}
}

int checkEdwards(struct Snake snake[], struct Edwards edwards[], int player, struct SnakeInfo * info)
{
	int j;
	for(j = 0; j < MAX_POWERUP_SIZE; j++){
		if(edwards[j].enable){
			int xDiff = abs(snake[0].xCoord - edwards[j].xCoord*16);
			int yDiff = abs(snake[0].yCoord - edwards[j].yCoord*16);
			//printf("snake x: %d y: %d\n",snake[0].xCoord, snake[0].yCoord);
			if(xDiff <= col_offset && yDiff <= col_offset){
				printf("Eating Edwards!\n");
				printf("x:%d, y:%d", edwards[j].xCoord, edwards[j].yCoord);
				removeEdwards(edwards,j);
				info->has_edwards = 1;
				if(edwards_index == MAX_POWERUP_SIZE){
					edwards_index = 0;
				}
				while( !drawEdwards(edwards) );
				break;
			}
		}
	}
	return 0;
}

void apply_edwards(struct Snake snake[], struct  Edwards edwards[], int player, struct SnakeInfo * info){

	if( !info->has_edwards ){
		printf("PLAYER%d DOESNT HAVE EDWARDS\n", player);
		return;
	}

	printf("PLAYER%d used his edwards\n",player);
	setBrickTile(snake, info->tail);
	info->has_edwards = 0;
}

#endif /* EDWARDS_H_ */

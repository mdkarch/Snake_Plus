#ifndef _LLIST_H_
#define _LLIST_H_
#include "snake_io.h"


int SNAKE_SIZE = 100;

int head_snake1;
int tail_snake2;
int tail_snake1;
int tail_snake2;
int offset = 16;

struct Snake{
	int xCoord;
	int yCoord;
	int enable;
};

struct SnakeInfo{
	int head;
	int tail;
	int speed_count;
	int speed_enabled;
};

void initSnake(struct Snake snake[], int xCoord, int yCoord, int player, struct SnakeInfo * info){
	info->head = 0;
	info->tail = 2;
	snake[0].xCoord = xCoord;//16;
	snake[0].yCoord = yCoord;//8;
	snake[0].enable = 1;
	//printf("IN INIT xCoord: %d yCoord: %d\n", xCoord, yCoord);
	//printf("IN INIT x: %d y: %d\n",snake[0].xCoord, snake[0].yCoord);
	snake[1].xCoord = snake[0].xCoord - 16; //hardcoded to move right
	snake[1].yCoord = snake[0].yCoord;//8;
	snake[1].enable = 1;
	snake[info->tail].xCoord = snake[1].xCoord - 16; //hardcoded to move right
	snake[info->tail].yCoord = snake[1].yCoord;//8;
	snake[info->tail].enable = 1;
	int i;
	for(i = info->tail + 1; i < SNAKE_SIZE; i++){
		snake[i].enable = 0;
	}

	addSnakePiece(player, SNAKE_HEAD_RIGHT, (short)snake[0].xCoord/16, 	(short)snake[0].yCoord/16);
	addSnakePiece(player, SNAKE_BODY_RIGHT, (short)snake[1].xCoord/16, (short)snake[1].yCoord/16);
	addSnakePiece(player, SNAKE_TAIL_RIGHT, (short)snake[info->tail].xCoord/16, (short)snake[info->tail].yCoord/16);

	//print snake - for testing
	/*for(i = 0; i < SNAKE_SIZE; i++){
		if(snake[i].enable == 1){
			printf("snake part at x:%d, y%d\n", snake[i].xCoord, snake[i].yCoord);
		}
	}*/
}

int abs(int n)
{
    if (n < 0)
        n = -n;

    return n;
}

/*
 * check collision between head and other parts of body
 */
int traverseList(struct Snake snake[])
{
	int count = 1;
	/* collision offset - distance between two pieces to be considered a collision */
	int col_offset = 14;
	while(snake[count].enable)
	{
		int xDiff = abs(snake[0].xCoord - snake[count].xCoord);
		int yDiff = abs(snake[0].yCoord - snake[count].yCoord);
		//printf("traverse x:%d y:%d\n", snake[count].xCoord, snake[count].yCoord);
		//printf("diff xdiff:%d ydiff:%d\n", xDiff, yDiff);

		if(xDiff <= col_offset && yDiff <= col_offset){
			printf("Collision!");
			return 0;
		}
		count++;
	}
	return 1;
}

int snakeCol(struct Snake snake1[], struct Snake snake2[]){
	int i;
	int j;
	for(i = 0; i < SNAKE_SIZE; i++){
		if(!snake1[i].enable)
			break;
		for(j = 0; j < SNAKE_SIZE; j++){
			if(!snake2[j].enable)
				break;
			int xDiff = abs(snake1[i].xCoord - snake2[j].xCoord);
			int yDiff = abs(snake1[i].yCoord - snake2[j].yCoord);
			if(xDiff < offset && yDiff < offset){
				printf("Collision!");
				return 0;
			}
		}
	}
	return 1;
}

void addEnd(struct Snake snake[], int dir, int player, struct SnakeInfo * info)
{
	//printf("Adding to the end of the snake\n");
	//printf("original tail at x:%d, y%d\n", snake[tail].xCoord, snake[tail].yCoord);

	info->tail = info->tail + 1;
	snake[info->tail].enable = 1;

	int sprite = -1;
	if(dir == 0){//left
		snake[info->tail].xCoord = snake[info->tail-1].xCoord + offset;
		snake[info->tail].yCoord = snake[info->tail-1].yCoord;
	}else if(dir == 1){//right
		snake[info->tail].xCoord = snake[info->tail-1].xCoord - offset;
		snake[info->tail].yCoord = snake[info->tail-1].yCoord;
	}else if(dir == 2){//up
		snake[info->tail].xCoord = snake[info->tail-1].xCoord;
		snake[info->tail].yCoord = snake[info->tail-1].yCoord + offset;
	}else if(dir == 3){//down
		snake[info->tail].xCoord = snake[info->tail-1].xCoord;
		snake[info->tail].yCoord = snake[info->tail-1].yCoord - offset;
	}

}

void updateBody(struct Snake snake[], struct SnakeInfo *info){
	int i;
	for(i = info->tail; i >= 1; i--){
		if(snake[i].enable==1){
			//printf("snake before '=' at x:%d, y%d\n", snake[i].xCoord, snake[i].yCoord);
			snake[i] = snake[i-1];
			//printf("snake after '=' at x:%d, y%d\n", snake[i].xCoord, snake[i].yCoord);
		}
	}
}

void updateSnake(struct Snake snake[], int xCoord, int yCoord, int dir, int old_dir,
		int player, struct SnakeInfo * info){
	//printf("Updating snake\n");

	// Remove tail first
	removeSnakePiece(player,  (short)snake[info->tail].xCoord/16,  (short)snake[info->tail].yCoord/16);

	int tail_old_x = snake[info->tail].xCoord;
	int tail_old_y = snake[info->tail].yCoord;

	//Then update snake
	updateBody(snake, info);
	snake[0].xCoord = xCoord;
	snake[0].yCoord = yCoord;

	int tail_new_x = snake[info->tail].xCoord;
	int tail_new_y = snake[info->tail].yCoord;


	int tail_sprite = -1;
	if( tail_old_x != tail_new_x){
		if( tail_old_y > tail_new_y){
			//turned up
			tail_sprite = SNAKE_TAIL_UP;
		} else if( tail_old_y < tail_new_y ){
			//turned down
			tail_sprite = SNAKE_TAIL_DOWN;
		} else {
			//same direction, which way?
			tail_sprite = (tail_old_x < tail_new_x) ? SNAKE_TAIL_RIGHT: SNAKE_TAIL_LEFT;
		}
	}
	if( tail_old_y != tail_new_y){
		if( tail_old_x > tail_new_x){
			//turned left
			tail_sprite = SNAKE_TAIL_LEFT;
		} else if( tail_old_x < tail_new_x ){
			//turned down
			tail_sprite = SNAKE_TAIL_RIGHT;
		} else {
			//same direction, which way?
			tail_sprite = (tail_old_y < tail_new_y) ? SNAKE_TAIL_DOWN: SNAKE_TAIL_UP;
		}
	}

	// Then do new hardware display
	writeToHW(snake, dir, old_dir, player, xCoord, yCoord, info, tail_sprite);


	// print snake - for testing
	//printf("printing entire snake\n");
	int i;
	/*for(i = 0; i < SNAKE_SIZE; i++){
		if(snake[i].enable==1){
			printf("snake part at x:%d, y%d\n", snake[i].xCoord, snake[i].yCoord);
		}
	}*/

}


#endif /* #ifndef _LIST_H_ */


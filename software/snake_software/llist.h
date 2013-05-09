#ifndef _LLIST_H_
#define _LLIST_H_
#include "snake_io.h"
#include "constants.h"


int offset = 16;

void initSnake(struct Snake snake[], int xCoord, int yCoord, int player, struct SnakeInfo * info){
	info->head = 0;
	info->tail = 2;
	snake[0].xCoord = xCoord;//16;
	snake[0].yCoord = yCoord;//8;
	snake[0].enable = 1;
	//printf("IN INIT xCoord: %d yCoord: %d\n", xCoord, yCoord);
	//printf("IN INIT x: %d y: %d\n",snake[0].xCoord, snake[0].yCoord);
	snake[1].xCoord = snake[0].xCoord - 1; //hardcoded to move right -16
	snake[1].yCoord = snake[0].yCoord;//8;
	snake[1].enable = 1;
	snake[info->tail].xCoord = snake[1].xCoord - 1; //hardcoded to move right - 16
	snake[info->tail].yCoord = snake[1].yCoord;//8;
	snake[info->tail].enable = 1;
	int i;
	for(i = info->tail + 1; i < SNAKE_SIZE; i++){
		snake[i].enable = 0;
	}
	info->has_edwards = 0;
	info->has_freeze = 0;
	info->freeze_enabled = 0;
	info->speed_enabled = 0;
	/* originally had x and ys divided by 16 */
	addSnakePiece(player, SNAKE_HEAD_RIGHT, snake[0].xCoord, 	snake[0].yCoord);
	addSnakePiece(player, SNAKE_BODY_RIGHT, snake[1].xCoord, snake[1].yCoord);
	addSnakePiece(player, SNAKE_TAIL_RIGHT, snake[info->tail].xCoord, snake[info->tail].yCoord);

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
int traverseList(struct Snake snake[], int player)
{
	int count = 1;
	while(snake[count].enable)
	{
		//int xDiff = abs(snake[0].xCoord - snake[count].xCoord);
		//int yDiff = abs(snake[0].yCoord - snake[count].yCoord);
		//printf("traverse x:%d y:%d\n", snake[count].xCoord, snake[count].yCoord);
		//printf("diff xdiff:%d ydiff:%d\n", xDiff, yDiff);
		//printf("traverse x:%d y:%d\n", snake[0].xCoord, snake[0].yCoord);
		if(snake[0].xCoord == snake[count].xCoord && snake[0].yCoord == snake[count].yCoord){//if(xDiff <= col_offset && yDiff <= col_offset){
			printf("self Collision!");
			if(player == PLAYER1){
				/* snake1 collided with itself so snake2 wins */
				game_winner = 2;
			}else{
				/* snake2 collided with itself so snake1 wins */
				game_winner = 1;
			}
			//printf("traverse x:%d y:%d\n", snake[count].xCoord, snake[count].yCoord);
			return 1;
		}
		count++;
	}
	return 0;
}

int brickCol(struct Snake snake[], int player){
	short x = snake[0].xCoord;///16;
	short y = snake[0].yCoord;///16;
	printf("brick enable: %d", brick_tiles[x][y]);
	if(brick_tiles[x][y]){
		printf("brick col");
		if(player == PLAYER1){
			/* snake1 collided with itself so snake2 wins */
			game_winner = 2;
		}else{
			/* snake2 collided with itself so snake1 wins */
			game_winner = 1;
		}
		return 1;
	}
	return 0;
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
			//int xDiff = abs(snake1[i].xCoord - snake2[j].xCoord);
			//int yDiff = abs(snake1[i].yCoord - snake2[j].yCoord);
			if(snake1[i].xCoord == snake2[j].xCoord && snake1[i].yCoord == snake2[j].yCoord){//if(xDiff < offset && yDiff < offset){
				printf("2 snake Collision!");
				if(i == 0 && j == 0){
					/* head on collision, draw */
					game_winner = 3;
				}else if(i == 0 && j != 0){
					/* snake1 head collided with snake2's body*/
					game_winner = 2;
				}else if(i != 0 && j == 0){
					/* snake2 head collided with snake1's body*/
					game_winner = 1;
				}
				return 1;
			}
		}
	}
	return 0;
}

void addEnd(struct Snake snake[], int dir, int player, struct SnakeInfo * info)
{
	//printf("Adding to the end of the snake\n");
	//printf("original tail at x:%d, y%d\n", snake[tail].xCoord, snake[tail].yCoord);

	info->tail = info->tail + 1;
	snake[info->tail].enable = 1;

	if(dir == 0){//left
		snake[info->tail].xCoord = snake[info->tail-1].xCoord + 1;//offset;
		snake[info->tail].yCoord = snake[info->tail-1].yCoord;
	}else if(dir == 1){//right
		snake[info->tail].xCoord = snake[info->tail-1].xCoord - 1;//offset;
		snake[info->tail].yCoord = snake[info->tail-1].yCoord;
	}else if(dir == 2){//up
		snake[info->tail].xCoord = snake[info->tail-1].xCoord;
		snake[info->tail].yCoord = snake[info->tail-1].yCoord + 1;//offset;
	}else if(dir == 3){//down
		snake[info->tail].xCoord = snake[info->tail-1].xCoord;
		snake[info->tail].yCoord = snake[info->tail-1].yCoord - 1;//offset;
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
	removeSnakePiece(player,  snake[info->tail].xCoord,  snake[info->tail].yCoord);

	int tail_old_x = snake[info->tail-1].xCoord;
	int tail_old_y = snake[info->tail-1].yCoord;

	//Then update snake
	updateBody(snake, info);
	snake[0].xCoord = xCoord;
	snake[0].yCoord = yCoord;

	int tail_new_x = snake[info->tail-1].xCoord;
	int tail_new_y = snake[info->tail-1].yCoord;


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


}


#endif /* #ifndef _LIST_H_ */


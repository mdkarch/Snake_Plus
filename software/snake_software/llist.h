#ifndef _LLIST_H_
#define _LLIST_H_
#include "snake_io.h"
int SNAKE_SIZE = 100;

int head;
int tail;
int offset = 16;

struct Snake{
	int xCoord;
	int yCoord;
	int enable;
};

void initSnake(struct Snake snake[], int xCoord, int yCoord){
	head = 0;
	tail = 2;
	snake[0].xCoord = xCoord;//16;
	snake[0].yCoord = yCoord;//8;
	snake[0].enable = 1;
	//printf("IN INIT xCoord: %d yCoord: %d\n", xCoord, yCoord);
	//printf("IN INIT x: %d y: %d\n",snake[0].xCoord, snake[0].yCoord);
	snake[1].xCoord = snake[0].xCoord - 8; //hardcoded to move right
	snake[1].yCoord = snake[0].yCoord;//8;
	snake[1].enable = 1;
	snake[tail].xCoord = snake[1].xCoord - 8; //hardcoded to move right
	snake[tail].yCoord = snake[1].yCoord;//8;
	snake[tail].enable = 1;
	int i;
	for(i = tail + 1; i < SNAKE_SIZE; i++){
		snake[i].enable = 0;
	}

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
void traverseList(struct Snake snake[])
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
			while(1);
		}
		count++;
	}
}

void snakeCol(struct Snake snake1[], struct Snake snake2[]){
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
				while(1);
			}
		}
	}
}

void addEnd(struct Snake snake[], int dir, int player)
{
	//printf("Adding to the end of the snake\n");
	//printf("original tail at x:%d, y%d\n", snake[tail].xCoord, snake[tail].yCoord);

	tail++;
	snake[tail].enable = 1;

	if(dir == 0){//left
		snake[tail].xCoord = snake[tail-1].xCoord + offset;
		snake[tail].yCoord = snake[tail-1].yCoord;
		addSnakePiece(player, SEG_TAIL, SNAKE_TAIL_LEFT, (short) snake[tail].xCoord , (short) snake[tail].yCoord );
	}else if(dir == 1){//right
		snake[tail].xCoord = snake[tail-1].xCoord - offset;
		snake[tail].yCoord = snake[tail-1].yCoord;
		addSnakePiece(player, SEG_TAIL, SNAKE_TAIL_RIGHT,(short) snake[tail].xCoord , (short) snake[tail].yCoord );
	}else if(dir == 2){//up
		snake[tail].xCoord = snake[tail-1].xCoord;
		snake[tail].yCoord = snake[tail-1].yCoord + offset;
		addSnakePiece(player, SEG_TAIL, SNAKE_TAIL_UP, (short) snake[tail].xCoord , (short) snake[tail].yCoord );
	}else if(dir == 3){//down
		snake[tail].xCoord = snake[tail-1].xCoord;
		snake[tail].yCoord = snake[tail-1].yCoord - offset;
		addSnakePiece(player, SEG_TAIL, SNAKE_TAIL_DOWN, (short) snake[tail].xCoord , (short) snake[tail].yCoord );
	}
	//printf("new tail at x:%d, y%d\n", snake[tail].xCoord, snake[tail].yCoord);


}

void updateBody(struct Snake snake[]){
	int i;
	for(i = tail; i >= 1; i--){
		if(snake[i].enable==1){
			//printf("snake before '=' at x:%d, y%d\n", snake[i].xCoord, snake[i].yCoord);
			snake[i] = snake[i-1];
			//printf("snake after '=' at x:%d, y%d\n", snake[i].xCoord, snake[i].yCoord);
		}
	}
}

void updateSnake(struct Snake snake[], int xCoord, int yCoord, int dir, int old_dir, int player){
	//printf("Updating snake\n");
	updateBody(snake);
	snake[0].xCoord = xCoord;
	snake[0].yCoord = yCoord;

	// print snake - for testing
	//printf("printing entire snake\n");
	int i;
	/*for(i = 0; i < SNAKE_SIZE; i++){
		if(snake[i].enable==1){
			printf("snake part at x:%d, y%d\n", snake[i].xCoord, snake[i].yCoord);
		}
	}*/
	writeToHW(snake, dir, old_dir, player, xCoord, yCoord);
}


#endif /* #ifndef _LIST_H_ */


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

/*void initSnake(struct Snake *snake[]){
	int x = 50;
	int y = 50;
	snake[0].enable = 1;
	snake[0].xCoord = 16;
	snake[0].yCoord = 8;
	printf("snake x: %d y: %d\n",snake[0].xCoord, snake[0].yCoord);

}*/

void initSnake(struct Snake snake[], int xCoord, int yCoord){
	head = 0;
	tail = 1;
	snake[0].xCoord = xCoord;//16;
	snake[0].yCoord = yCoord;//8;
	snake[0].enable = 1;
	//printf("IN INIT xCoord: %d yCoord: %d\n", xCoord, yCoord);
	printf("IN INIT x: %d y: %d\n",snake[0].xCoord, snake[0].yCoord);

	snake[tail].xCoord = snake[0].xCoord - 8; //hardcoded to move right
	snake[tail].yCoord = snake[0].yCoord;//8;
	snake[tail].enable = 1;
	int i;
	for(i = 2; i < SNAKE_SIZE; i++){
		snake[i].enable = 0;
	}

	//print snake - for testing
	for(i = 0; i < SNAKE_SIZE; i++){
		if(snake[i].enable == 1){
			printf("snake part at x:%d, y%d\n", snake[i].xCoord, snake[i].yCoord);
		}
	}
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
		printf("traverse x:%d y:%d\n", snake[count].xCoord, snake[count].yCoord);

		if(xDiff <= col_offset && yDiff <= col_offset){
			printf("Collision!");
			while(1);
		}
		count++;
	}
};

void addEnd(struct Snake snake[], int dir)
{
	printf("Adding to the end of the snake\n");
	printf("original tail at x:%d, y%d\n", snake[tail].xCoord, snake[tail].yCoord);

	tail++;
	snake[tail].enable = 1;

	if(dir == 0){//left
		snake[tail].xCoord = snake[tail-1].xCoord + offset;
		snake[tail].yCoord = snake[tail-1].yCoord;
		addSnakePiece(PLAYER1, SNAKE_TAIL_LEFT, SEG_TAIL, (short) snake[tail].xCoord , (short) snake[tail].yCoord );
	}else if(dir == 1){//right
		snake[tail].xCoord = snake[tail-1].xCoord - offset;
		snake[tail].yCoord = snake[tail-1].yCoord;
		addSnakePiece(PLAYER1, SNAKE_TAIL_RIGHT, SEG_TAIL, (short) snake[tail].xCoord , (short) snake[tail].yCoord );
	}else if(dir == 2){//up
		snake[tail].xCoord = snake[tail-1].xCoord;
		snake[tail].yCoord = snake[tail-1].yCoord + offset;
		addSnakePiece(PLAYER1, SNAKE_TAIL_UP, SEG_TAIL, (short) snake[tail].xCoord , (short) snake[tail].yCoord );
	}else if(dir == 3){//down
		snake[tail].xCoord = snake[tail-1].xCoord;
		snake[tail].yCoord = snake[tail-1].yCoord - offset;
		addSnakePiece(PLAYER1, SNAKE_TAIL_DOWN, SEG_TAIL, (short) snake[tail].xCoord , (short) snake[tail].yCoord );
	}
	printf("new tail at x:%d, y%d\n", snake[tail].xCoord, snake[tail].yCoord);


}

void updateBody(struct Snake snake[]){
	int i;
	for(i = tail; i >= 1; i--){
		if(snake[i].enable==1){
			printf("snake before '=' at x:%d, y%d\n", snake[i].xCoord, snake[i].yCoord);
			snake[i] = snake[i-1];
			printf("snake after '=' at x:%d, y%d\n", snake[i].xCoord, snake[i].yCoord);
		}
	}
}

void updateSnake(struct Snake snake[], int xCoord, int yCoord, int dir, int old_dir){
	printf("Updating snake\n");
	updateBody(snake);
	snake[0].xCoord = xCoord;
	snake[0].yCoord = yCoord;

	// print snake - for testing
	printf("printing entire snake\n");
	int i;
	for(i = 0; i < SNAKE_SIZE; i++){
		if(snake[i].enable==1){
			printf("snake part at x:%d, y%d\n", snake[i].xCoord, snake[i].yCoord);
		}
	}
	writeToHW(snake, dir, old_dir);
}


#endif /* #ifndef _LIST_H_ */


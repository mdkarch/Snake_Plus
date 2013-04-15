#ifndef _LLIST_H_
#define _LLIST_H_
int SNAKE_SIZE = 1;

int head;
int tail;
int offset = 16;

struct Snake{
	int xCoord;
	int yCoord;
	int enable;
};

void initSnake(struct Snake *snake[]){
	int x = 50;
	int y = 50;
	snake[0]->enable = 1;
	snake[0]->xCoord = 16;
	snake[0]->yCoord = 8;
	printf("snake x: %d y: %d\n",snake[0]->xCoord, snake[0]->yCoord);

}
/*
void initSnake(struct Snake *snake[], int xCoord, int yCoord){
	head = 0;
	tail = 1;
	snake[0]->xCoord = 16;//xCoord;
	snake[0]->yCoord = 8;//yCoord;
	snake[0]->enable = 1;
	printf("IN INIT x: %d y: %d\n",snake[0]->xCoord, snake[0]->yCoord);

	snake[tail]->xCoord = 8;
	snake[tail]->yCoord = 8;
	snake[tail]->enable = 1;
	int i;
	for(i = 2; i < SNAKE_SIZE; i++){
		snake[i]->enable = 0;
	}
}
*/
int abs(int n)
{
    if (n < 0)
        n = -n;

    return n;
}

/*
 * check collision between head and other parts of body
 */
void traverseList(struct Snake *snake[])
{
	struct Snake *head = snake[0];
	int count = 1;
	/* collision offset - distance between two pieces to be considered a collision */
	int col_offset = 14;
	while(snake[count]->enable)
	{
		int xDiff = abs(head->xCoord - snake[count]->xCoord);
		int yDiff = abs(head->yCoord - snake[count]->yCoord);
		if(xDiff <= col_offset && yDiff <= col_offset){
			printf("Collision!");
		}
		count++;
	}
};

void addEnd(struct Snake *snake[], int dir)
{
	tail++;
	snake[tail]->enable = 1;

	if(dir == 0){//left
		snake[tail]->xCoord = snake[tail-1]->xCoord + offset;
		snake[tail]->yCoord = snake[tail-1]->yCoord;
	}else if(dir == 1){//right
		snake[tail]->xCoord = snake[tail-1]->xCoord - offset;
		snake[tail]->yCoord = snake[tail-1]->yCoord;
	}else if(dir == 2){//up
		snake[tail]->xCoord = snake[tail-1]->xCoord;
		snake[tail]->yCoord = snake[tail-1]->yCoord + offset;
	}else if(dir == 3){//down
		snake[tail]->xCoord = snake[tail-1]->xCoord;
		snake[tail]->yCoord = snake[tail-1]->yCoord - offset;
	}
}

void updateBody(struct Snake *snake[]){
	int i;
	for(i = 1; i <= tail; i++){
		snake[i] = snake[i-1];
	}
}

void updateSnake(struct Snake *snake[], int xCoord, int yCoord){
	updateBody(snake);
	snake[0]->xCoord = xCoord;
	snake[0]->yCoord = yCoord;
}


#endif /* #ifndef _LIST_H_ */

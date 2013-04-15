#ifndef _LIST_H_
#define _LIST_H_

int head;
int tail;
int SIZE = 1200;
int offset = 16;


struct Node {
	int xCoord;
	int yCoord;
	int enable; //if piece is active or not
};

void initSnake(struct Node *snake[]){
	head = 0;
	tail = 1;
	snake[head]->xCoord = 16;
	snake[head]->yCoord = 8;
	snake[head]->enable = 1;

	snake[tail]->xCoord = 8;
	snake[tail]->yCoord = 8;
	snake[tail]->enable = 1;

	for(int i = 1; i < SIZE; i++){
		snake[i]->enable = 0;
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
void traverseList(struct Node *snake[])
{
	struct Node *head = snake[0];
	int count = 1;
	while(snake[count]->enable)
	{
		int xDiff = abs(head->xCoord - snake[count]->xCoord);
		int yDiff = abs(head->yCoord - snake[count]->yCoord);
		if(xDiff <= offset && yDiff <= offset){
			printf("Collision!");
		}
		count++;
	}
};

void addEnd(struct Node *snake[], int dir)
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

void updateBody(struct Node *snake[]){
	for(int i = 1; i <= tail; i++){
		snake[i] = snake[i-1];
	}
}

void updateSnake(struct Node *snake[], int xCoord, int yCoord){
	updateBody(snake);
	snake[0]->xCoord = xCoord;
	snake[0]->yCoord = yCoord;
}


#endif /* #ifndef _LIST_H_ */

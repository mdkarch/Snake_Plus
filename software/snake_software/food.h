#ifndef _FOOD_H_
#define _FOOD_H_
int FOOD_SIZE = 1;

struct Food{
	int xCoord;
	int yCoord;
	int enable;
};

void initFood(struct Food *food[]){
	int x = 50;
	int y = 50;
	food[0]->enable = 1;
	food[0]->xCoord = 50;
	food[0]->yCoord = 50;
}

void removeFood(struct Food *food[], int index){
	food[index]->enable = 0;
}

#endif

#ifndef _FOOD_H_
#define _FOOD_H_
int SIZE = 5;

struct Food{
	int xCoord;
	int yCoord;
	int enable;
};

void initFood(struct Food *food[]){
	int x = 50;
	int y = 50;
	for(int i = 0; i < SIZE; i++){
		food[i]->enable = 1;
		food[i]->xCoord = x*(i+1);
		food[i]->yCoord = y*(i+1);
	}
}

void removeFood(struct Food *food[], int index){
	food[index]->enable = 0;
}

#endif

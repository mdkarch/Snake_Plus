#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

/*
int LEFT_BOUND = 0;
int RIGHT_BOUND = 10;//640;
int TOP_BOUND = 10;//480;
int BOT_BOUND = 0;

int xCoor = 0;
int yCoor = 0;

int left = 0;
int right = 1; //have snake start moving right first
int up = 0;
int down = 0;

static void kb_interrupt_handler() {




}

static void movement(){ //up,down,left, right will be set based on user input
	if(xCoor >= LEFT_BOUND && right){
		xCoor++;
		if(xCoor == RIGHT_BOUND){
			right = 0;
			left = 0;
			up = 1;
			down = 0;
		}
	}else if(xCoor <= RIGHT_BOUND && left){
		xCoor--;	
		if(xCoor == LEFT_BOUND){
			right = 0;
			left = 0;
			up = 0;
			down = 1;
		}
	}else if(yCoor >= BOT_BOUND && up){
		yCoor++;
		if(yCoor == TOP_BOUND){
			right = 0;	
			left = 1;
			up = 0;
			down = 0;
		}
	}else if(yCoor <= TOP_BOUND && down){
		yCoor--;
		if(yCoor == LEFT_BOUND){
			right = 1;
			left = 0;		
			up = 0;
			down = 0;
		}
	}
	printf("x: %d y: %d\n", xCoor, yCoor);
	usleep(500000);
}


int main(){
	//alt_irq_register(PS2_0_IRQ, NULL, (void*)kb_interrupt_handler);	
	while(1) {
		movement();
	}

	return 0;
}
*/
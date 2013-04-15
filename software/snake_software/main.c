#include "basic_io.h"
#include <alt_types.h>
#include "alt_up_ps2_port.h"
#include "ps2_keyboard.h"
#include "list.h"
#include "food.h"

#define WRITE_SPRITE(select,data) \
IOWR_32DIRECT(VGA_BASE, select * 2, data)


#define LEFT_BOUND	0
#define RIGHT_BOUND	640
#define TOP_BOUND	480
#define BOT_BOUND	0
#define LENGTH		1200
#define MAX_FOOD	5
#define col_offset  	14
#define left_dir	0
#define right_dir	1
#define up_dir		2
#define down_dir	3

/* will be put in a struct eventually*/
/* start at location (0,0) */
int xCoor = 0;
int yCoor = 0;

/* flags to determine the direction of the snake */
/* maybe put this init in an init func */
int left = 0;
int right = 1; //have snake start moving right first
int up = 0;
int down = 0;

/* used for kb input, removed eventually when nes controller is up and running */
int status = 0;
alt_u8 key = 0;
KB_CODE_TYPE decode_mode;


/*static void kb_interrupt_handler() {
	printf("HEEELLLLO\n");
	status = read_make_code(&decode_mode, &key);
	printf("Status: %d\n", status);
	if (status == PS2_SUCCESS) {
	      // print out the result
		printf("%c", key );
	}
}*/

/* should update snake when new direction is known*/

/* go left */
static void moveLeft(){
	right = 0;
	left = 1;
	up = 0;
	down = 0;
}

/* go right */
static void moveRight(){
	right = 1;
	left = 0;
	up = 0;
	down = 0;
}

/* go up */
static void moveUp(){
	right = 0;
	left = 0;
	up = 1;
	down = 0;
}

/* go down */
static void moveDown(){
	right = 0;
	left = 0;
	up = 0;
	down = 1;
}
/* track snake movement */
static void movement(alt_u8 key, struct Node *snake[], struct Node *food[]){
	/* put this case stmt in a function called setDirection()*/
	switch(key){
		case 0x1C://'a'
			moveLeft();
			break;
		case 0x1B://'s'
			moveDown();
			break;
		case 0x23://'d'
			moveRight();
			break;
		case 0x1D://'w'
			moveUp();
			break;
		default:
			break;
	}
	if(right){
		xCoor++;
		if(xCoor >= RIGHT_BOUND){
			/* collision */
		}
		updateSnake(snake, xCoor, yCoor);
		checkFood(snake, food, left_dir);
	}else if(left){
		xCoor--;
		if(xCoor <= LEFT_BOUND){
			/* collision */
		}
		updateSnake(snake, xCoor, yCoor);
		checkFood(snake, food, right_dir);
	}else if(up){
		yCoor++;
		if(yCoor <= TOP_BOUND){
			/* collision */
		}
		updateSnake(snake, xCoor, yCoor);
		checkFood(snake, food, up_dir);
	}else if(down){
		yCoor--;
		if(yCoor >= BOT_BOUND){
			/* collision */
		}
		updateSnake(snake, xCoor, yCoor);
		checkFood(snake, food, down_dir);
	}
	printf("x: %d y: %d\n", xCoor, yCoor);
	//usleep(500000);
}

typedef enum
  {
    STATE_INIT,
    STATE_LONG_BINARY_MAKE_CODE,
    STATE_BREAK_CODE ,
    STATE_DONE
  } DECODE_STATE;


/* "interrupt" */
int read_make_code_with_timeout(KB_CODE_TYPE *decode_mode, alt_u8 *buf) {
	alt_u8 byte = 0;
	int status_read =0;
	*decode_mode = KB_INVALID_CODE;
	DECODE_STATE state = STATE_INIT;
	do {
		status_read = read_data_byte_with_timeout(&byte, 10000);
		//FIXME: When the user press the keyboard extremely fast, data may get
		//occasionally get lost

	    if (status_read == PS2_ERROR)
			return PS2_ERROR;

		state = get_next_state(state, byte, decode_mode, buf);
  } while (state != STATE_DONE);

  return PS2_SUCCESS;
}

int checkFood(struct Node *snake[], struct Food *food[], int dir)
{
	struct Node *head = snake[0];

	for(int j = 0; j < MAX_FOOD; j++){
			int xDiff = abs(head->xCoord - food[j]->xCoord);
			int yDiff = abs(head->yCoord - food[j]->yCoord);
			if(xDiff <= col_offset && yDiff <= col_offset){
				printf("Eating Food!");
				removeFood(j);
				addEnd(snake, dir);
				break;
			}
	}
	return 0;
}

int main(){
	alt_u8 key = 0;
	/* Initialize the keyboard */
	printf("Pretty please wait three seconds to initialize keyboard\n");
	clear_FIFO();
	switch (get_mode()) {
		case PS2_KEYBOARD:
			break;
		case PS2_MOUSE:
			printf("Error: Mouse detected on PS/2 port\n");
			break;
		default:
			printf("Error: Unrecognized or no device on PS/2 port\n");
			break;
	}
	//alt_irq_register(PS2_0_IRQ, NULL, (void*)kb_interrupt_handler);

	WRITE_SPRITE(2,0xFFFFFFFF);

	struct Node snake[LENGTH];
	initSnake(snake);
	struct Food food[MAX_FOOD];
	initFood(food);

	while(1) {
		status = read_make_code_with_timeout(&decode_mode, &key);
		 if (status == PS2_SUCCESS && key != 0)
				printf("key:%c -- %x\n", key, key);
		movement(key, snake, food);
	}


	return 0;
}

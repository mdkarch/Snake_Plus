#include "basic_io.h"
#include <alt_types.h>
#include "alt_up_ps2_port.h"
#include "ps2_keyboard.h"
#include "ps2_mouse.h"
#include "LCD.h"
#include "VGA.h"

#define LEFT_BOUND	0
#define RIGHT_BOUND	640
#define TOP_BOUND	480
#define BOT_BOUND	0

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
static void movement(alt_u8 key){
	/* put this case stmt in a function called setDirection()*/
	switch(key){
		case 'a':
			moveLeft();
			break;
		case 's':
			moveDown();
			break;
		case 'd':
			moveRight();
			break;
		case 'w':
			moveUp();
			break;
		default:
			break;
	}
	if(xCoor >= LEFT_BOUND && right){
		xCoor++;
		if(xCoor == RIGHT_BOUND){
			/* collision */
		}
	}else if(xCoor <= RIGHT_BOUND && left){
		xCoor--;
		if(xCoor == LEFT_BOUND){
			/* collision */
		}
	}else if(yCoor >= BOT_BOUND && up){
		yCoor++;
		if(yCoor == TOP_BOUND){
			/* collision */
		}
	}else if(yCoor <= TOP_BOUND && down){
		yCoor--;
		if(yCoor == LEFT_BOUND){
			/* collision */
		}
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
int read_make_code(KB_CODE_TYPE *decode_mode, alt_u8 *buf) {
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

int main(){
	alt_u8 key = 0;
	/* Initialize the keyboard */
	printf("Please wait three seconds to initialize keyboard\n");
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
	

	while(1) {
		status = read_make_code(&decode_mode, &key);
		 if (status == PS2_SUCCESS && key != 0) 
				printf("key:%c -- %x\n", key, key);
		//movement(key);
	}

	return 0;
}

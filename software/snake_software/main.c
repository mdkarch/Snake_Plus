#include "basic_io.h"
#include <alt_types.h>
#include "alt_up_ps2_port.h"
#include "ps2_keyboard.h"
#include "llist.h"
#include "food.h"
#include <system.h>
#include <unistd.h>

#define WRITE_SPRITE(select,data) \
IOWR_32DIRECT(DE2_VGA_CONTROLLER_0_BASE, select * 4, data)

#define READ_SNAKE1_HEAD() \
IORD_32DIRECT(DE2_VGA_CONTROLLER_0_BASE, 0 * 4)

#define READ_SNAKE1_TAIL() \
IORD_32DIRECT(DE2_VGA_CONTROLLER_0_BASE, 1 * 4)

#define READ_SNAKE1_LENGTH() \
IORD_32DIRECT(DE2_VGA_CONTROLLER_0_BASE, 3 * 4)


#define LENGTH		1200
#define MAX_FOOD	1
#define col_offset  14
#define left_dir	0
#define right_dir	1
#define up_dir		2
#define down_dir	3

/* will be put in a struct eventually*/
/* start at location (0,0) */
int xCoor = 255;
int yCoor = 255;

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
	printf("Changed direction to left\n");
	right = 0;
	left = 1;
	up = 0;
	down = 0;
}

/* go right */
static void moveRight(){
	printf("Changed direction to right\n");
	right = 1;
	left = 0;
	up = 0;
	down = 0;
}

/* go up */
static void moveUp(){
	printf("Changed direction to up\n");
	right = 0;
	left = 0;
	up = 1;
	down = 0;
}

/* go down */
static void moveDown(){
	printf("Changed direction to down\n");
	right = 0;
	left = 0;
	up = 0;
	down = 1;
}

int checkFood(struct Snake *snake[], struct Food *food[], int dir)
{
	//struct Snake *head = snake[0];
	int j;
	for(j = 0; j < MAX_FOOD; j++){
			if(food[j]->enable){
				int xDiff = abs(snake[0]->xCoord - food[j]->xCoord);
				int yDiff = abs(snake[0]->yCoord - food[j]->yCoord);
				//printf("snake x: %d y: %d\n",snake[0]->xCoord, snake[0]->yCoord);
				//printf("food x: %d y: %d\n",food[j]->xCoord, food[j]->yCoord);
				if(xDiff <= col_offset && yDiff <= col_offset){
					printf("Eating Food!\n");
					removeFood(food,j);
					addEnd(snake, dir);
					//break;
				}
			}
	}
	return 0;
}

// track snake movement
static void movement(alt_u8 key, struct Snake *snake[], struct Food *food[]){
	switch(key){
		case 0x1C://'a'
			if(up || down)
				moveLeft();
			break;
		case 0x1D://'s'
			if(left || right)
				moveDown();
			break;
		case 0x23://'d'
			if(up || down)
				moveRight();
			break;
		case 0x1B://'w'
			if(left || right)
				moveUp();
			break;
		default:
			break;
	}
	if(right){
		xCoor+=16;
		if(xCoor >= RIGHT_BOUND - col_offset){
			printf("Collision with right boundary!\n");
			while(1)
				;
			// collision
		}
		updateSnake(snake, xCoor, yCoor, left_dir);
		checkFood(snake, food, left_dir);
	}else if(left){
		xCoor-=16;
		if(xCoor <= LEFT_BOUND){
			printf("Collision with left boundary!\n");			
			//collision
		}
		updateSnake(snake, xCoor, yCoor,right_dir);
		checkFood(snake, food, right_dir);
	}else if(up){
		yCoor+=16;
		if(yCoor <= TOP_BOUND){
			printf("Collision with up boundary!\n");
			//collision
		}
		updateSnake(snake, xCoor, yCoor, up_dir);
		checkFood(snake, food, up_dir);
	}else if(down){
		yCoor-=16;
		if(yCoor >= BOT_BOUND){
			printf("Collision with bot boundary!\n");
			//collision
		}
		updateSnake(snake, xCoor, yCoor, down_dir);
		checkFood(snake, food, down_dir);
	}
	printf("x: %d y: %d\n", xCoor, yCoor);
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
		status_read = read_data_byte_with_timeout(&byte, 1000);
		//FIXME: When the user press the keyboard extremely fast, data may get
		//occasionally get lost

	    if (status_read == PS2_ERROR)
			return PS2_ERROR;

		state = get_next_state(state, byte, decode_mode, buf);
  } while (state != STATE_DONE);

  return PS2_SUCCESS;
}

void writeToHW(struct Snake *snake[], int dir) {
	char unused = 0;
	char segment = 0;
	char add_remove = 1;
	char sprite = 1;
	short x = (short)xCoor;
	short y = (short)yCoor;

	if(dir == right_dir)
		sprite = 2;
	else if(dir == left_dir)
		sprite = 1;
	else if(dir == down_dir)
		sprite = 3;
	else if(dir == up_dir)
		sprite = 4;

	int code = (unused << 28) | (segment << 26) | (add_remove << 25) | (sprite << 20) |  ((x & 0x03FF) << 10) | (y & 0x03FF);

	WRITE_SPRITE(1,code);

	int code2 = (unused << 28) | (2 << 26) | (1 << 25) | (12 << 20) |  ((x & 0x03FF) << 10) | (y & 0x03FF);

	int code3 = (unused << 28) | (3 << 26) | (0 << 25) | (0 << 20) |  ((x & 0x03FF) << 10) | (y & 0x03FF);

	//WRITE_SPRITE(1,code2);
	WRITE_SPRITE(1,code3);

	//0000 00 1 00001 0101111111 0001111111
	//x and y for new head add
	//WRITE_SPRITE(1,0x215FC7F); // Add
	//WRITE_SPRITE(1,0x213FCFF); //Add
	//WRITE_SPRITE(1,0xC13FCFF); //Remove
	//WRITE_SPRITE(1,0x813FCFF);
}

int kb_input(){
	unsigned char code;
	int count = 0;
	while(!IORD_8DIRECT(PS2_BASE, 0) && count <= 1000){

		count++;
	}
	if(count >= 1000){
		return 0;
	}
	code = IORD_8DIRECT(PS2_BASE, 4);
	return code;
}

int main(){
	alt_u8 key = 0;
	/* Initialize the keyboard */
	printf("Pretty please wait three seconds to initialize keyboard\n");
	clear_FIFO();
	/*switch (get_mode()) {
		case PS2_KEYBOARD:
			break;
		case PS2_MOUSE:
			printf("Error: Mouse detected on PS/2 port\n");
			break;
		default:
			printf("Error: Unrecognized or no device on PS/2 port\n");
			break;
	}
	*/
	//alt_irq_register(PS2_0_IRQ, NULL, (void*)kb_interrupt_handler);

	//WRITE_SPRITE(0,0x2137CF0);
	//WRITE_SPRITE(0,0x2137C0F);

	struct Snake snake[100];
	initSnake(&snake, xCoor, yCoor);
	struct Food food[MAX_FOOD];
	initFood(&food);

	unsigned char code;

	while(1) {
		code = kb_input();
		movement(code, &snake, &food);
		printf("H: %d\n",READ_SNAKE1_HEAD() );
		printf("T: %d\n",READ_SNAKE1_TAIL() );
		printf("L: %d\n",READ_SNAKE1_LENGTH() );
		usleep(500*1000);
	}


	return 0;
}

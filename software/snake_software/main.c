#include "basic_io.h"
#include <alt_types.h>
#include "alt_up_ps2_port.h"
#include "ps2_keyboard.h"
#include "llist.h"
#include "food.h"
#include "speed.h"
#include "freeze.h"
#include <unistd.h>
#include "snake_io.h"

/*
 * I have a way to generate random numbers
 * assign every power up a random loc in 2d array
 * i need to keep track of two 2d array
 * one will contain type of power up stored there
 * other one will contain the actual struct of the power up
 * for collisions, if the snake currently occupies the same tile 
 * that an enableed power up is in activate it
 * to do this check:
 * 1. see what tile the snake is in
 * 2. check if the power up is enabled
 * 3. if not move one
 * 4. if so check what power up it is and apply it and remove it from the board
 * 5. eventually some algorithm will be created to determine when to display powerups or how many
 *
 * enable N randomly selected powers
 * after a snake eats a powerup, place a new randomly selected one on the board
 * assuming the power up can take up a free slot
 * do a for loop, once a free spot has been selected, break
 * worst case, go through the entire for loop and no power up enabled because entire board is occupied
 */

#define LENGTH		1200
#define MAX_FOOD	5
#define col_offset  14
#define left_dir	0
#define right_dir	1
#define up_dir		2
#define down_dir	3

unsigned int seed = 5323;
/* will be put in a struct eventually*/
/* start at location (0,0) */
int xCoor = 255;
int yCoor = 255;


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
static void moveLeft(int dir_array []){
	printf("Changed direction to left\n");
	dir_array[right_dir] 	= 0;
	dir_array[left_dir]  	= 1;
	dir_array[up_dir]  		= 0;
	dir_array[down_dir]  	= 0;
}

/* go right */
static void moveRight(int dir_array []){
	printf("Changed direction to right\n");
	dir_array[right_dir] 	= 1;
	dir_array[left_dir]  	= 0;
	dir_array[up_dir]  		= 0;
	dir_array[down_dir]  	= 0;
}

/* go up */
static void moveUp(int dir_array []){
	printf("Changed direction to up\n");
	dir_array[right_dir] 	= 0;
	dir_array[left_dir]  	= 0;
	dir_array[up_dir]  		= 1;
	dir_array[down_dir]  	= 0;
}

/* go down */
static void moveDown(int dir_array []){
	printf("Changed direction to down\n");
	dir_array[right_dir] 	= 0;
	dir_array[left_dir]  	= 0;
	dir_array[up_dir]  		= 0;
	dir_array[down_dir]  	= 1;
}

int checkFood(struct Snake snake[], struct Food food[], int dir)
{
	//struct Snake *head = snake[0];
	int j;
	for(j = 0; j < MAX_FOOD; j++){
			if(food[j].enable){
				int xDiff = abs(snake[0].xCoord - food[j].xCoord);
				int yDiff = abs(snake[0].yCoord - food[j].yCoord);
				//printf("snake x: %d y: %d\n",snake[0].xCoord, snake[0].yCoord);
				//printf("food x: %d y: %d\n",food[j].xCoord, food[j].yCoord);
				if(xDiff <= col_offset && yDiff <= col_offset){
					printf("Eating Food!\n");
					removeFood(food,j);
					addEnd(snake, dir);
					break;
				}
			}
	}
	return 0;
}


int checkSpeed(struct Snake snake[], struct Speed speed[], int dir){

	return 0;
}

int checkFreeze(struct Snake snake[], struct Freeze freeze[], int dir){

	return 0;
}

// track snake movement
static void movement(alt_u8 key, struct Snake snake[], int dir_array [], struct Food food[], int pressed){

	int old_dir = -1;
	if( dir_array[left_dir] )
		old_dir = left_dir;
	else if( dir_array[right_dir] )
		old_dir = right_dir;
	else if( dir_array[up_dir] )
		old_dir = up_dir;
	else if( dir_array[down_dir] )
		old_dir = down_dir;


	printf("Pressed: %d\n", pressed);
	switch(pressed){
		case 1://0x1C://'a'
			if( dir_array[up_dir] || dir_array[down_dir] )
				moveLeft(dir_array);
			break;
		case 2://0x1D://'w'
			if( dir_array[left_dir] || dir_array[right_dir] )
				moveUp(dir_array);
			break;
		case 0://0x23://'d'
			if( dir_array[up_dir] || dir_array[down_dir] )
				moveRight(dir_array);
			break;
		case 3://0x1B://'s'
			if( dir_array[left_dir] || dir_array[right_dir])
				moveDown(dir_array);
			break;
		default:
			break;
	}
	if(dir_array[right_dir]){
		xCoor+=16;
		if(xCoor > RIGHT_BOUND - col_offset){
			printf("Collision with right boundary!\n");
			while(1);
			// collision
		}
		updateSnake(snake, xCoor, yCoor, right_dir, old_dir);
		checkFood(snake, food, right_dir);
	}else if(dir_array[left_dir]){
		xCoor-=16;
		if(xCoor < LEFT_BOUND){
			printf("Collision with left boundary!\n");			
			while(1);
			//collision
		}
		updateSnake(snake, xCoor, yCoor, left_dir, old_dir);
		checkFood(snake, food, left_dir);
	}else if(dir_array[up_dir]){
		yCoor-=16;
		if(yCoor < TOP_BOUND){
			printf("Collision with up boundary!\n");
			while(1);
			//collision
		}
		updateSnake(snake, xCoor, yCoor, up_dir, old_dir);
		checkFood(snake, food, up_dir);
	}else if(dir_array[down_dir]){
		yCoor+=16;
		if(yCoor > BOT_BOUND - col_offset){
			printf("Collision with bot boundary!\n");
			while(1);
			//collision
		}
		updateSnake(snake, xCoor, yCoor, down_dir, old_dir);
		checkFood(snake, food, down_dir);
	}
	traverseList(snake);
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

void writeToHW(struct Snake snake[], int dir, int old_dir) {

	char segment = 0;
	char add_remove = 1;
	char sprite = 1;
	short x = (short)xCoor;
	short y = (short)yCoor;

	char sprite_second;

	/* Figure out head */
	if(dir == right_dir)
		sprite = SNAKE_HEAD_RIGHT;
	else if(dir == left_dir)
		sprite = SNAKE_HEAD_LEFT;
	else if(dir == down_dir)
		sprite = SNAKE_HEAD_DOWN;
	else if(dir == up_dir)
		sprite = SNAKE_HEAD_UP;

	if( dir == old_dir ){
		sprite_second = sprite + 8; //Trick bc head and body are offset by 8
	} else {
		/* Turn piece */
		if( dir == right_dir && old_dir == up_dir ||
			dir == down_dir && old_dir == left_dir){
			printf("old dir:%d new dir:%d", old_dir, dir);
			sprite_second = SNAKE_TURN_UP_RIGHT;
		}
		else if( (dir == down_dir) && (old_dir == right_dir) ||
				 (dir == left_dir) && (old_dir == up_dir)){
			sprite_second = SNAKE_TURN_RIGHT_DOWN;
		}
		else if( (dir == left_dir) && (old_dir == down_dir) ||
				 (dir == up_dir) && (old_dir == right_dir)){
			sprite_second = SNAKE_TURN_DOWN_LEFT;
		 }
		else if( (dir == up_dir) && (old_dir == left_dir) ||
				 (dir == right_dir) && (old_dir == down_dir)){
			 sprite_second = SNAKE_TURN_LEFT_UP;
		 }
	}

	//addSnakePiece(PLAYER1, SEG_SECOND_TAIL, )
	incrementSnake(PLAYER1, sprite, x, y);
	//addSnakePiece(PLAYER1, SEG_HEAD/*head*/	, sprite, x, y);
	addSnakePiece(PLAYER1, SEG_SECOND_HEAD, sprite_second, 0/*dontcare*/,0/*dontcare*/);
	//removeSnakeTail(PLAYER1);
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

int PRNG(int n){
	seed = (8253729 * seed + + 2396403);
	return seed % n;
}

void shuffle(int arr[], int n){
	int i;
	for(i = 0; i < n; i++){
		int index = PRNG(n);
		int temp = arr[index];
		arr[index] = arr[i];
		arr[i] = temp;
	}
}

int main(){
	alt_u8 key = 0;
	/* Initialize the keyboard */
	printf("Pretty please wait three seconds to initialize keyboard\n");
	clear_FIFO();

	reset_hardware();

	struct Snake snake_player1[100];
	initSnake(snake_player1, xCoor, yCoor);
	//struct Snake snake_player2[100];
	//initSnake(snake_player2, xCoor, yCoor);

	int player1_dir[4];
	int player2_dir[4];
	player1_dir[right_dir] = 1;
	//player2_dir[right_dir] = 1;

	struct Food food[MAX_FOOD];
	struct Speed speed[1];
	initFood(food);
	//initSpeed(speed);

	//addSnakePiece(PLAYER1, SEG_HEAD, SNAKE_HEAD_RIGHT, (short)xCoor, (short)yCoor);
	//addSnakePiece(PLAYER1, SEG_SECOND_HEAD, SNAKE_BODY_RIGHT, ((short)xCoor), (short)yCoor);

	unsigned char code;
	int count 					= 0;
	int SLEEP_TIME 				= 50; 							// milli
	int PLAYER1_SLEEP_CYCLES 	= 200 / SLEEP_TIME; 			// Original sleep time/SLEEP_TIME
	int PLAYER2_SLEEP_CYCLES 	= 200 / SLEEP_TIME; 			// Original sleep time/SLEEP_TIME

	int pressed_player1 		= getPlayer1Controller();
	int pressed_player2 		= getPlayer2Controller();
	int potential_pressed;

	while(0) {

		/* Move player 1 */
		if(count >= PLAYER1_SLEEP_CYCLES){
			//code = kb_input();
			movement(code, snake_player1, player1_dir, food, pressed_player1);
			count = 0;
			pressed_player1 = -1;
		}

		/* Move player 2 */
//		if(count >= PLAYER2_SLEEP_CYCLES){
//			//code = kb_input();
//			movement(code, snake_player2, player2_dir, food, pressed_player2);
//			count = 0;
//			pressed_player2 = -1;
//		}

		/* Get controls from player1 everytime and store control for later if pressed */
		potential_pressed = getPlayer1Controller();
		if( potential_pressed != -1){
			pressed_player1 = potential_pressed;
			printf("pressed player1: %d\n", pressed_player1);
		}

		/* Get controls from player2 everytime and store control for later if pressed */
//		potential_pressed = getPlayer2Controller();
//		if( potential_pressed != -1){
//			pressed_player2 = potential_pressed;
//		}

		//code = kb_input();
		//movement(code, snake, food);

		printf("H: %d\n",READ_SNAKE1_HEAD() );
		printf("T: %d\n",READ_SNAKE1_TAIL() );
		printf("L: %d\n",READ_SNAKE1_LENGTH() );
		//printf("Random: %d", PRNG(40));
		count++;
		usleep(SLEEP_TIME*1000);
	}


	return 0;
}

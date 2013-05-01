#include "basic_io.h"
#include <alt_types.h>
#include "llist.h"
#include "food.h"
#include "speed.h"
#include "freeze.h"
#include <unistd.h>
#include "snake_io.h"
#include "powboard.h"
#include "brick.h"

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
#define col_offset  14
#define left_dir	0
#define right_dir	1
#define up_dir		2
#define down_dir	3
#define LEFT_BOUND	0
#define RIGHT_BOUND	640
#define BOT_BOUND	480
#define TOP_BOUND	0

/* start at location (0,0) */
int board[X_LEN][Y_LEN];
int food_index = 1;




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

int checkFood(struct Snake snake[], struct Food food[], int dir, int player, struct SnakeInfo * info)
{
	//struct Snake *head = snake[0];
	int j;
	for(j = 0; j < MAX_FOOD; j++){
		if(food[j].enable){
			int xDiff = abs(snake[0].xCoord - food[j].xCoord*16);
			int yDiff = abs(snake[0].yCoord - food[j].yCoord*16);
			//printf("snake x: %d y: %d\n",snake[0].xCoord, snake[0].yCoord);
			//printf("food x: %d y: %d\n",food[j].xCoord, food[j].yCoord);
			if(xDiff <= col_offset && yDiff <= col_offset){
				printf("Eating Food!\n");
				removeFood(food,j);
				addEnd(snake, dir, player, info);
				if(food_index == MAX_FOOD){
					food_index = 0;
				}
				while( !drawFood(food, food_index++) );
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
static int movement(alt_u8 key, struct Snake snake[], int dir_array [],
		struct Food food[], int pressed, int player, struct SnakeInfo * info){

	int old_dir = -1;
	if( dir_array[left_dir] )
		old_dir = left_dir;
	else if( dir_array[right_dir] )
		old_dir = right_dir;
	else if( dir_array[up_dir] )
		old_dir = up_dir;
	else if( dir_array[down_dir] )
		old_dir = down_dir;

	int xCoor = snake[0].xCoord;
	int yCoor = snake[0].yCoord;

	int pressed_dir = get_dir_from_pressed(pressed);

	printf("Pressed: %d\n", pressed);
	switch(pressed_dir){
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
		if(xCoor > RIGHT_BOUND - 2*col_offset){
			printf("Collision with right boundary!\n");
			return 0;
		}
		updateSnake(snake, xCoor, yCoor, right_dir, old_dir, player, info);
		checkFood(snake, food, right_dir, player, info);
	}else if(dir_array[left_dir]){
		xCoor-=16;
		if(xCoor < (LEFT_BOUND+16)){
			printf("Collision with left boundary!\n");			
			return 0;
			//collision
		}
		updateSnake(snake, xCoor, yCoor, left_dir, old_dir, player, info);
		checkFood(snake, food, left_dir, player, info);
	}else if(dir_array[up_dir]){
		yCoor-=16;
		if(yCoor < (TOP_BOUND + 16)){
			printf("Collision with top boundary!\n");
			return 0;
			//collision
		}
		updateSnake(snake, xCoor, yCoor, up_dir, old_dir,player, info);
		checkFood(snake, food, up_dir, player, info);
	}else if(dir_array[down_dir]){
		yCoor+=16;
		if(yCoor > BOT_BOUND - 2*col_offset){
			printf("Collision with bottom boundary!\n");
			return 0;
			//collision
		}
		updateSnake(snake, xCoor, yCoor, down_dir, old_dir,player, info);
		checkFood(snake, food, down_dir, player, info);
	}
	return traverseList(snake);
	//printf("x: %d y: %d\n", xCoor, yCoor);
}



void writeToHW(struct Snake snake[], int dir, int old_dir, int player,
		int xCoord, int yCoord, struct SnakeInfo *info, int tail_sprite) {

	char sprite = 1;
	short x = (short)xCoord;
	short y = (short)yCoord;

	char sprite_second;
	char sprite_tail;

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
		if( (dir == right_dir && old_dir == up_dir) ||
				(dir == down_dir && old_dir == left_dir)){
			printf("old dir:%d new dir:%d", old_dir, dir);
			sprite_second = SNAKE_TURN_UP_RIGHT;
		}
		else if( ((dir == down_dir) && (old_dir == right_dir)) ||
				((dir == left_dir) && (old_dir == up_dir))){
			sprite_second = SNAKE_TURN_RIGHT_DOWN;
		}
		else if( ((dir == left_dir) && (old_dir == down_dir)) ||
				((dir == up_dir) && (old_dir == right_dir))){
			sprite_second = SNAKE_TURN_DOWN_LEFT;
		}
		else if( ((dir == up_dir) && (old_dir == left_dir)) ||
				((dir == right_dir) && (old_dir == down_dir))){
			sprite_second = SNAKE_TURN_LEFT_UP;
		}
	}




	addSnakePiece(player, sprite, (short)snake[0].xCoord/16, snake[0].yCoord/16);
	addSnakePiece(player, sprite_second, (short)snake[1].xCoord/16, snake[1].yCoord/16);
	addSnakePiece(player, tail_sprite, (short)snake[info->tail].xCoord/16,  (short)snake[info->tail].yCoord/16);
}


int main(){

	printf("Press start to begin the game\n");

	unsigned int seed = 0;

	while(1) {

		/* Reset display */
		reset_hardware();
		initPowBoard(board, seed);
		initBorder();

		/* Reset snakes and display them */
		struct Snake snake_player1[100];
		struct SnakeInfo info1;
		initSnake(snake_player1, 256, 256, PLAYER1, &info1);
		struct Snake snake_player2[100];
		struct SnakeInfo info2;
		initSnake(snake_player2, 256, 320, PLAYER2, &info2);

		printf("Press start!\n");
		while(1) {

			int pressed_player1 		= getPlayer1Controller();
			int pressed_player2 		= getPlayer2Controller();
			if (pressed_player1 == 16 || pressed_player2 != 0)
				break;
			seed++;
		}
		printf("Game is starting");


		int player1_dir[4];
		int player2_dir[4];

		player1_dir[right_dir] = 1;
		player1_dir[left_dir] = 0;
		player1_dir[up_dir] = 0;
		player1_dir[down_dir] = 0;

		player2_dir[right_dir] = 1;
		player2_dir[left_dir] = 0;
		player2_dir[up_dir] = 0;
		player2_dir[down_dir] = 0;

		struct Food food[MAX_FOOD];
		initFood(food, board);
		while( !drawFood(food, food_index++) ){
			printf("Attempting to Draw food\n");
		}
		//startFood(food);

		//struct Speed speed[1];
		//initSpeed(speed);



		int paused = 0;

		unsigned char code;
		int count_player1 			= 0;
		int count_player2 			= 0;
		int SLEEP_TIME 				= 50; 							// milliseconds
		int PLAYER1_SLEEP_CYCLES 	= 100 / SLEEP_TIME; 			// Original sleep time/SLEEP_TIME
		int PLAYER2_SLEEP_CYCLES 	= 100 / SLEEP_TIME; 			// Original sleep time/SLEEP_TIME

		int pressed_player1 		= getPlayer1Controller();
		int pressed_player2 		= getPlayer2Controller();
		int potential_pressed1;
		int potential_pressed2;
		int old_potential1;
		int old_potential2;
		int game = 1;
		int collision = 1;
		int p1_move_collision = 1;
		int p2_move_collision = 1;



		while(1) {

			collision = snakeCol(snake_player1, snake_player2);
			/*Check if paused button pushed*/
			if( (count_player1 >= PLAYER1_SLEEP_CYCLES && (check_paused(pressed_player1) != 0) ) ||
				(count_player2 >= PLAYER2_SLEEP_CYCLES && (check_paused(pressed_player2) != 0) ) ){
				pressed_player1 = 0;
				pressed_player2 = 0;
				count_player1 = 0;
				count_player2 = 0;
				paused = !paused;
				printf("Paused is now %d\n", paused);
			}

			/* Move player 1 */
			if(count_player1 >= PLAYER1_SLEEP_CYCLES && !paused ){
				//code = kb_input();
				p1_move_collision = movement(code, snake_player1, player1_dir, food, pressed_player1, PLAYER1, &info1);
				//movement(code, snake_player2, player2_dir, food, pressed_player1, PLAYER2);
				count_player1 = 0;
				pressed_player1 = 0;
				printf("Moving player1");
			}

			/* Move player 2 */
//			if(count_player2 >= PLAYER2_SLEEP_CYCLES && !paused){
//				//code = kb_input();
//				p2_move_collision = movement(code, snake_player2, player2_dir, food, pressed_player2, PLAYER2, info2);
//				count_player2 = 0;
//				pressed_player2 = 0;
//			}

			/* Get controls from player1 everytime and store control for later if pressed */
			old_potential1 = potential_pressed1;
			potential_pressed1 = getPlayer1Controller();
			if( potential_pressed1 != 0 && old_potential1 != potential_pressed1){
				pressed_player1 = potential_pressed1;
				printf("pressed player1: %d\n", pressed_player1);
			}

			/* Get controls from player2 everytime and store control for later if pressed */
			old_potential2 = potential_pressed2;
			potential_pressed2 = getPlayer2Controller();
			if( potential_pressed2 != 0 && old_potential2 != potential_pressed2){
				pressed_player2 = potential_pressed2;
			}


			if (!(collision && p1_move_collision && p2_move_collision))
				break;


			//printf("Random: %d", PRNG(40));
			count_player1++;
			count_player2++;
			usleep(SLEEP_TIME*1000);
		}
		printf("New Game starting\n");
	}

	printf("GAME OVER\n");

	return 0;
}

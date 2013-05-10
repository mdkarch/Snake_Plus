#include "basic_io.h"
#include <alt_types.h>
#include <unistd.h>
#include "snake_io.h"
#include "powboard.h"
#include "llist.h"
#include "food.h"
#include "speed.h"
#include "freeze.h"
#include "brick.h"
#include "drop_brick.h"
#include "edwards.h"
#include "constants.h"

/* should update snake when new direction is known*/
/* go left */
void moveLeft(int dir_array []){
	//printf("Changed direction to left\n");
	dir_array[right_dir] 	= 0;
	dir_array[left_dir]  	= 1;
	dir_array[up_dir]  		= 0;
	dir_array[down_dir]  	= 0;
}

/* go right */
void moveRight(int dir_array []){
	//printf("Changed direction to right\n");
	dir_array[right_dir] 	= 1;
	dir_array[left_dir]  	= 0;
	dir_array[up_dir]  		= 0;
	dir_array[down_dir]  	= 0;
}

/* go up */
void moveUp(int dir_array []){
	//printf("Changed direction to up\n");
	dir_array[right_dir] 	= 0;
	dir_array[left_dir]  	= 0;
	dir_array[up_dir]  		= 1;
	dir_array[down_dir]  	= 0;
}

/* go down */
void moveDown(int dir_array []){
	//printf("Changed direction to down\n");
	dir_array[right_dir] 	= 0;
	dir_array[left_dir]  	= 0;
	dir_array[up_dir]  		= 0;
	dir_array[down_dir]  	= 1;
}

// track snake movement
int movement(alt_u8 key, struct Snake snake[], int dir_array [],
		int pressed, int player, struct SnakeInfo * info){

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

	//printf("Pressed: %d\n", pressed);
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
		xCoor+= 1;//16;
		if(xCoor > RIGHT_BOUND - 2/**col_offset*/){
			//printf("Collision with right boundary!\n");
			return 0;
		}
		updateSnake(snake, xCoor, yCoor, right_dir, old_dir, player, info);
		dir_arg = right_dir;
		//checkFood(snake, right_dir, player, info);
	}else if(dir_array[left_dir]){
		xCoor-=1;//16;
		if(xCoor < (LEFT_BOUND+1)){//16
			//printf("Collision with left boundary!\n");
			return 0;
			//collision
		}
		updateSnake(snake, xCoor, yCoor, left_dir, old_dir, player, info);
		dir_arg = left_dir;
		//checkFood(snake, left_dir, player, info);
	}else if(dir_array[up_dir]){
		yCoor-=1;//16;
		if(yCoor < (TOP_BOUND + 1)){//16
			//printf("Collision with top boundary!\n");
			return 0;
			//collision
		}
		updateSnake(snake, xCoor, yCoor, up_dir, old_dir,player, info);
		dir_arg = up_dir;
		//checkFood(snake, up_dir, player, info);
	}else if(dir_array[down_dir]){
		yCoor+=1;//16;
		if(yCoor > BOT_BOUND - 2/**col_offset*/){
			//printf("Collision with bottom boundary!\n");
			return 0;
			//collision
		}
		updateSnake(snake, xCoor, yCoor, down_dir, old_dir,player, info);
		dir_arg = down_dir;
		//checkFood(snake, down_dir, player, info);
	}
	/*checkFood(snake, down_dir, player, info);
	checkSpeed(snake, player, info);
	checkFreeze(snake, player, info);
	recalc_freeze_times(snake, player,info);
	checkEdwards(snake, player, info);*/
	//PLAY_SOUND(1);
	int check_brick_col = brickCol(snake, player);
	int check_self_col = traverseList(snake, player);
	if(check_brick_col || check_self_col){
		return 1;
	}else{
		return 0;
	}

	//return traverseList(snake);
	//printf("x: %d y: %d\n", xCoor, yCoor);
}



void writeToHW(struct Snake snake[], int dir, int old_dir, int player,
		int xCoord, int yCoord, struct SnakeInfo *info, int tail_sprite) {

	char sprite = 1;

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
		if( (dir == right_dir && old_dir == up_dir) ||
				(dir == down_dir && old_dir == left_dir)){
			//printf("old dir:%d new dir:%d", old_dir, dir);
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

	/* originallly divided x and ys by 16 */
	addSnakePiece(player, sprite,  snake[0].xCoord, snake[0].yCoord);
	addSnakePiece(player, sprite_second, snake[1].xCoord, snake[1].yCoord);
	addSnakePiece(player, tail_sprite, snake[info->tail].xCoord,  snake[info->tail].yCoord);
}

void check_powerup_col(struct Snake snake[], struct Snake other_snake[], int dir_arg, int player, struct SnakeInfo * info){
	checkFood(snake, other_snake, dir_arg, player, info);
	checkSpeed(snake, other_snake, player, info);
	checkFreeze(snake,other_snake, player, info);
	recalc_freeze_times(snake, player,info);
	checkEdwards(snake, other_snake, player, info);
}


void check_powerup_buttons(int pressed,struct Snake snake[], struct Snake other_snake[], struct Freeze freeze[], int player, struct SnakeInfo * info){

	int button = get_button_from_pressed(pressed);
	if( button == A_CODE ){
		apply_freeze(snake, player, info);
	}
	if( button == B_CODE ){
		apply_edwards(snake, other_snake, player, info);
	}

}

void wait_for_continue(){
	while(1) {
		//printf("HIT ANY BUTTON TO RETURN TO MAIN MENU!\n");
		int pressed_player1 		= getPlayer1Controller();
		int pressed_player2 		= getPlayer2Controller();
		if (pressed_player1 != 0 || pressed_player2 != 0)
			break;
		seed++;
	}
}

void draw_P1_wins(){
	short y = 10;
	addTilePiece(P_CODE, 16, y);
	addTilePiece(ONE_CODE, 17, y);
	addTilePiece(W_CODE, 19, y);
	addTilePiece(I_CODE, 20, y);
	addTilePiece(N_CODE, 21, y);
	addTilePiece(S_CODE, 22, y);
	addTilePiece(EXC_CODE, 23,y);
}

void draw_P2_wins(){
	short y = 10;
	addTilePiece(P_CODE, 16, y);
	addTilePiece(TWO_CODE, 17, y);
	addTilePiece(W_CODE, 19, y);
	addTilePiece(I_CODE, 20, y);
	addTilePiece(N_CODE, 21, y);
	addTilePiece(S_CODE, 22, y);
	addTilePiece(EXC_CODE, 23,y);
}

void draw_tie(){
	/*short y = 10;
	addTilePiece(D_CODE, 17, y);
	addTilePiece(R_CODE, 19, y);
	addTilePiece(A_CODE, 20, y);
	addTilePiece(W_CODE, 21, y);
	addTilePiece(EXC_CODE, 22, y);*/
}

void draw_winner(int winner_id){
	short i;
	short y = 10;
	for(i = 15; i < 25; i ++){
		removeSnakePiece(PLAYER1, i, y);
		removeSnakePiece(PLAYER2, i, y);
		removeTilePiece(i, y);
	}
	if(winner_id == 1 && PLAYER1 == 1){
		draw_P1_wins();
	}else if(winner_id == 1 && PLAYER1 == 2){
		draw_P2_wins();
	}else if(winner_id == 2 && PLAYER2 == 2){
		draw_P2_wins();
	}else if(winner_id == 2 && PLAYER2 == 1){
		draw_P1_wins();
	}else if(winner_id == 3){
		draw_tie();
	}
}

void initPowUps(){
	initFood();
	initSpeed();
	initFreeze();
	initEdwards();
}

void drawStartPowUps(struct Snake snake_player1[], struct Snake snake_player2[]){
	while( !drawFood(snake_player1, snake_player2) ){
		//printf("Attempting to Draw food\n");
	}
	while( !drawFood(snake_player1, snake_player2) ){
		//printf("Attempting to Draw food\n");
	}
	while( !drawFood(snake_player1, snake_player2) ){
		//printf("Attempting to Draw food\n");
	}
	while( !drawSpeed(snake_player1, snake_player2) ){
		//printf("Attempting to Draw speed\n");
	}
	//speed_drawn = 1;
	while( !drawFreeze(snake_player1, snake_player2) ){
		//printf("Attempting to Draw freeze\n");
	}
	//freeze_drawn = 1;
	while( !drawEdwards(snake_player1, snake_player2) ){
		//printf("Attempting to Draw edwards\n");
	}
}

void reset_software(){
	/* index to know which sprite to draw from power up structs */
	food_index 				= 0;
	speed_index 			= 0;
	freeze_index 			= 0;
	edwards_index 			= 0;

	freeze_pow_count  		= 0;
	freeze_drawn 			= 0;
	speed_pow_count  		= 0;
	speed_drawn 			= 0;
	edwards_pow_count  		= 0;
	edwards_drawn 			= 0;
	dir_arg 				= 0;
	switch_snakes			= 0;
	food_count = 0;

	LEFT_BOUND				= 0;
	RIGHT_BOUND				= 40;
	BOT_BOUND				= 30;
	TOP_BOUND				= 0;
	/* used with edwards power up */
	NEW_BOT 				= 29;
	NEW_TOP 				= 0;
	NEW_LEFT 				= 0;
	NEW_RIGHT 				= 39;
	/*
	 * 0 -> nobody yet
	 * 1 -> snake1
	 * 2 -> snake2
	 * 3 -> draw
	 */
	game_winner				= 0;
	PLAYER1 				= 1;
	PLAYER2 				= 2;
	/* reinit border */
	//initBorder();
	/* reinit power up board */
	initPowBoard(board, seed);
}

void fancy_splash(){
	int i;
	int j;
	for(i = 1; i < X_LEN - 2; i++){
		for(j = 1; j < Y_LEN - 1; j++){
			addTilePiece(SPLASH_SNAKE_CODE,i,j);
			addTilePiece(SPLASH_SNAKE_CODE,i+1,j);
			addTilePiece(SPLASH_SNAKE_CODE,i+2,j);
		}
		usleep(2*30000);
		for(j = 1; j < Y_LEN - 1; j++){
			removeTilePiece(i,j);
			removeTilePiece(i+1,j);
			removeTilePiece(i+2,j);
		}
	}
	for(i = X_LEN - 2; i > 1; i--){
		for(j = Y_LEN - 1; j > 1; j--){
			addTilePiece(SPLASH_SNAKE_CODE,i+2,j);
			addTilePiece(SPLASH_SNAKE_CODE,i+1,j);
			addTilePiece(SPLASH_SNAKE_CODE,i,j);
		}
		usleep(2*30000);
		for(j = Y_LEN -1; j > 1; j--){
			removeTilePiece(i+2,j);
			removeTilePiece(i+1,j);
			removeTilePiece(i,j);
		}
	}
}

int main(){

	//printf("Press start to begin the game\n");
	int set = 1;
	while(1) {

		/* Reset display */
		reset_hardware();
		reset_software();
		//initBorder();
		if(set){
			fancy_splash();
			enable_splash_screen();
			set = 0;
		}
		//printf("Press any button to start!\n");
		wait_for_continue();
		initBorder();

		disable_splash_screen();

		/* init border */
		//initPowBoard(board, seed);
		/* Reset snakes and display them */
		//PLAYER1 = 1;
		//PLAYER2 = 2;
		struct Snake snake_player1[SNAKE_SIZE];
		struct SnakeInfo info1;
		initSnake(snake_player1, 256/16, 256/16, PLAYER1, &info1);
		struct Snake snake_player2[SNAKE_SIZE];
		struct SnakeInfo info2;
		initSnake(snake_player2, 256/16, 320/16, PLAYER2, &info2);

		PLAYER1_SLEEP_CYCLES = DEFAULT_SLEEP_CYCLE / SLEEP_TIME;
		PLAYER2_SLEEP_CYCLES = DEFAULT_SLEEP_CYCLE / SLEEP_TIME;


		//printf("Game is starting");


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

		initPowUps();
		drawStartPowUps(snake_player1, snake_player2);



		int paused = 0;

		unsigned char code;
		int count_player1 			= 0;
		int count_player2 			= 0;

		int pressed_player1 		= getPlayer1Controller();
		int pressed_player2 		= getPlayer2Controller();
		int potential_pressed1;
		int potential_pressed2;
		int old_potential1;
		int old_potential2;
		int game = 1;
		int collision = 0;
		int p1_move_collision = 0;
		int p2_move_collision = 0;
		while(1) {
			if(count_player1 >= PLAYER1_SLEEP_CYCLES || count_player2 >= PLAYER2_SLEEP_CYCLES){
				collision = snakeCol(snake_player1, snake_player2);
			}
			/*Check if paused button pushed*/
			if( (count_player1 >= PLAYER1_SLEEP_CYCLES && (check_paused(pressed_player1) != 0) ) ||
					(count_player2 >= PLAYER2_SLEEP_CYCLES && (check_paused(pressed_player2) != 0) ) ){
				pressed_player1 = 0;
				pressed_player2 = 0;
				count_player1 = 0;
				count_player2 = 0;
				paused = !paused;
				//printf("Paused is now %d\n", paused);
			}

			/* Move player 1 */
			if(count_player1 >= PLAYER1_SLEEP_CYCLES && !paused ){
				p1_move_collision = movement(code, snake_player1, player1_dir, pressed_player1, PLAYER1, &info1);
				check_powerup_col(snake_player1, snake_player2, player1_dir, PLAYER1, &info1);
				//movement(code, snake_player2, player2_dir, food, pressed_player1, PLAYER2);
				check_powerup_buttons(pressed_player1, snake_player1, snake_player2, freeze, PLAYER1, &info1);
				count_player1 = 0;
				pressed_player1 = 0;
				//printf("Moving player1");
			}

			/* Move player 2 */
			if(count_player2 >= PLAYER2_SLEEP_CYCLES && !paused){
				p2_move_collision = movement(code, snake_player2, player2_dir, pressed_player2, PLAYER2, &info2);
				check_powerup_col(snake_player2, snake_player1, player2_dir, PLAYER2, &info2);
				check_powerup_buttons(pressed_player2, snake_player2, snake_player1,freeze, PLAYER2, &info2);
				count_player2 = 0;
				pressed_player2 = 0;
			}

			/* Get controls from player1 everytime and store control for later if pressed */
			old_potential1 = potential_pressed1;
			potential_pressed1 = getPlayer1Controller();
			if( potential_pressed1 != 0 && old_potential1 != potential_pressed1){
				pressed_player1 = potential_pressed1;
				//printf("pressed player1: %d\n", pressed_player1);
			}

			/* Get controls from player2 everytime and store control for later if pressed */
			old_potential2 = potential_pressed2;
			potential_pressed2 = getPlayer2Controller();
			if( potential_pressed2 != 0 && old_potential2 != potential_pressed2){
				pressed_player2 = potential_pressed2;
			}


			if (collision || p1_move_collision || p2_move_collision){
				//printf("breaking");
				draw_winner(game_winner);
				wait_for_continue();
				break;
			}


			//printf("Random: %d", PRNG(40));
			count_player1++;
			count_player2++;
			usleep(SLEEP_TIME*1000);
		}
		//printf("New Game starting\n");
	}

	//printf("GAME OVER\n");

	return 0;
}

#ifndef _CONSTANTS_H_
#define _CONSTANTS_H_

#define LENGTH		1200
#define col_offset  14
#define left_dir	0
#define right_dir	1
#define up_dir		2
#define down_dir	3
//#define LEFT_BOUND	0
//#define RIGHT_BOUND	40//640
//#define BOT_BOUND	30//480
//#define TOP_BOUND	0

#define X_LEN		40
#define Y_LEN		30
#define MAX_POWERUP_SIZE	300

#define SNAKE_SIZE 				1200
#define SLEEP_TIME 				2 	// milliseconds
#define SPEED_TIME 				50
#define FREEZE_TIME 			50
int DEFAULT_SLEEP_CYCLE	 = 	60;
int SPEED_SLEEP_CYCLE	 =	30;
int FREEZE_SLEEP_CYCLE	 =	150;

unsigned int n_seed = 5323;
unsigned int seed = 0;

int PLAYER1_SLEEP_CYCLES; 			// Original sleep time/SLEEP_TIME
int PLAYER2_SLEEP_CYCLES; 			// Original sleep time/SLEEP_TIME

/* index to know which sprite to draw from power up structs */
int food_index 				= 1;
int speed_index 			= 1;
int freeze_index 			= 1;
int edwards_index 			= 1;
int alt_powups 				= 0;

/* keeps track of current power ups spawn locations */
int board[X_LEN][Y_LEN];
/* keeps track of where a brick was placed */
short brick_tiles[X_LEN][Y_LEN];

int freeze_pow_count  		= 0;
int freeze_drawn 			= 0;
int speed_pow_count  		= 0;
int speed_drawn 			= 0;
int edwards_pow_count  		= 0;
int edwards_drawn 			= 0;
int dir_arg 				= 0;
int switch_snakes			= 0;
int food_count = 0;
int player1_food_eaten = 0;
int player2_food_eaten = 0;


int LEFT_BOUND	=0;
int RIGHT_BOUND	=40;
int BOT_BOUND	=30;
int TOP_BOUND	=0;
/* used with edwards power up */
int NEW_BOT = 29;
int NEW_TOP = 0;
int NEW_LEFT = 0;
int NEW_RIGHT = 39;
/*
 * 0 -> nobody yet
 * 1 -> snake1
 * 2 -> snake2
 * 3 -> draw
 */
int game_winner				= 0;

/* struct defs for snake and power ups */
struct Snake{
	short xCoord;
	short yCoord;
	short enable;
};

struct SnakeInfo{
	short head;
	short tail;
	short speed_count;
	short speed_enabled;
	short freeze_count;
	short freeze_enabled;
	short has_edwards;
	short has_freeze;
};

struct Food{
	short xCoord;
	short yCoord;
	short enable;
	short type;
};

struct Speed{
	short xCoord;
	short yCoord;
	short enable;
};

struct Freeze{
	short xCoord;
	short yCoord;
	short enable;
};

struct Edwards{
	short xCoord;
	short yCoord;
	short enable;
	short type;
};

/* gloabl structs */
struct Food food[MAX_POWERUP_SIZE];
struct Speed speed[MAX_POWERUP_SIZE];
struct Freeze freeze[MAX_POWERUP_SIZE];
struct Edwards edwards[MAX_POWERUP_SIZE];

#endif /* #ifndef _CONSTANTS_H_ */

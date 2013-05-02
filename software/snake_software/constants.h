#ifndef _CONSTANTS_H_
#define _CONSTANTS_H_


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

#define X_LEN		40
#define Y_LEN		30
#define MAX_POWERUP_SIZE	600

unsigned int n_seed = 5323;

int SNAKE_SIZE = 1200;


int SLEEP_TIME 				= 10; 							// milliseconds
int DEFAULT_SLEEP_CYCLE		= 60;
int SPEED_SLEEP_CYCLE		= 40;
int FREEZE_SLEEP_CYCLE		= 150;
int SPEED_TIME 				= 50;
int FREEZE_TIME 			= 50;

int PLAYER1_SLEEP_CYCLES; 			// Original sleep time/SLEEP_TIME
int PLAYER2_SLEEP_CYCLES; 			// Original sleep time/SLEEP_TIME

/* index to know which sprite to draw from power up structs */
int food_index = 1;
int speed_index = 1;
int freeze_index = 1;
int edwards_index = 1;
int alt_powups = 0;
/* keeps track of current power ups spwan locations */
int board[X_LEN][Y_LEN];
/* keeps track of where a brick was placed */
short brick_tiles[X_LEN][Y_LEN];
int freeze_pow_count  = 0;
int freeze_drawn = 0;
int speed_pow_count  = 0;
int speed_drawn = 0;

struct Snake{
	int xCoord;
	int yCoord;
	int enable;
};

struct SnakeInfo{
	int head;
	int tail;
	int speed_count;
	int speed_enabled;
	int freeze_count;
	int freeze_enabled;
	int has_edwards;
	int has_freeze;
};

struct Food{
	int xCoord;
	int yCoord;
	int enable;
	int type;
};


struct Speed{
	int xCoord;
	int yCoord;
	int enable;
};

struct Freeze{
	int xCoord;
	int yCoord;
	int enable;
};

struct Edwards{
	int xCoord;
	int yCoord;
	int enable;
	int type;
};


struct Food food[MAX_POWERUP_SIZE];
struct Speed speed[MAX_POWERUP_SIZE];
struct Freeze freeze[MAX_POWERUP_SIZE];
struct Edwards edwards[MAX_POWERUP_SIZE];

#endif /* #ifndef _CONSTANTS_H_ */

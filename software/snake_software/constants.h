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
#define MAX_POWERUP_SIZE	400

int SNAKE_SIZE = 1200;


int SLEEP_TIME 				= 10; 							// milliseconds
int DEFAULT_SLEEP_CYCLE		= 60;
int SPEED_SLEEP_CYCLE		= 40;
int FREEZE_SLEEP_CYCLE		= 150;
int SPEED_TIME 				= 50;
int FREEZE_TIME 			= 50;

int PLAYER1_SLEEP_CYCLES; 			// Original sleep time/SLEEP_TIME
int PLAYER2_SLEEP_CYCLES; 			// Original sleep time/SLEEP_TIME

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

#endif /* #ifndef _CONSTANTS_H_ */

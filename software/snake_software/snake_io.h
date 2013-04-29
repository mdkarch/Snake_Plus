#ifndef _SNAKE_IO_H_
#define _SNAKE_IO_H_

#include <system.h>

#define WRITE_SPRITE(select,data) \
IOWR_32DIRECT(DE2_VGA_CONTROLLER_0_BASE, select * 4, data)

#define READ_SNAKE1_HEAD() \
IORD_32DIRECT(DE2_VGA_CONTROLLER_0_BASE, 0 * 4)

#define READ_SNAKE1_TAIL() \
IORD_32DIRECT(DE2_VGA_CONTROLLER_0_BASE, 1 * 4)

#define READ_SNAKE1_LENGTH() \
IORD_32DIRECT(DE2_VGA_CONTROLLER_0_BASE, 3 * 4)

#define SOFT_RESET() \
IOWR_32DIRECT(DE2_VGA_CONTROLLER_0_BASE, 4 * 4, 0);

#define READ_PLAYER_CONTROLLER(player) \
IORD_32DIRECT(NES_CONTROLLER_BASE, player * 4);




/* Player/Tile/Address codes */
const char PLAYER1 	= 1;
const char PLAYER2 	= 2;
const char TILES	= 3;


/* Snake sprite codes */
const char SNAKE_HEAD_RIGHT 		= 1;
const char SNAKE_HEAD_LEFT 			= 2;
const char SNAKE_HEAD_UP 			= 3;
const char SNAKE_HEAD_DOWN 			= 4;
const char SNAKE_TAIL_RIGHT			= 5;
const char SNAKE_TAIL_LEFT			= 6;
const char SNAKE_TAIL_UP			= 7;
const char SNAKE_TAIL_DOWN			= 8;
const char SNAKE_BODY_RIGHT			= 9;
const char SNAKE_BODY_LEFT			= 10;
const char SNAKE_BODY_UP			= 11;
const char SNAKE_BODY_DOWN			= 12;
const char SNAKE_TURN_UP_RIGHT		= 13;
const char SNAKE_TURN_RIGHT_DOWN	= 14;
const char SNAKE_TURN_DOWN_LEFT		= 15;
const char SNAKE_TURN_LEFT_UP		= 16;

/* Tile sprite codes */
const char RABBIT_CODE 				= 1;
const char MOUSE_CODE				= 2;
const char EDWARDS_CODE  			= 3;
const char WALL_CODE 				= 4;
const char SPEED_CODE 				= 5;
const char FREEZE_CODE 				= 6;
const char GROWTH_CODE				= 7;
const char ONE_CODE					= 8;
const char TWO_CODE					= 9;
const char P_CODE					= 10;
const char W_CODE 					= 11;
const char I_CODE 					= 12;
const char N_CODE 					= 13;
const char S_CODE 					= 14;
const char EXC_CODE					= 15;
const char PLAY_CODE 				= 16;
const char PAUSE_CODE				= 17;

/* Segment codes */
const char SEG_HEAD					= 0;
const char SEG_SECOND_HEAD			= 1;
const char SEG_SECOND_TAIL			= 2;
const char SEG_TAIL					= 3;

/* Add/Remove codes */
const char REMOVE_CODE				= 0;
const char ADD_CODE					= 1;

/* Button codes */
const int RIGHT_CODE 				= 	(0x00000001);
const int LEFT_CODE 				= 	(0x00000002);
const int DOWN_CODE 				= 	(0x00000004);
const int UP_CODE 					= 	(0x00000008);
const int START_CODE				= 	(0x00000010);
const int SELECT_CODE 				= 	(0x00000020);
const int B_CODE 					= 	(0x00000040);
const int A_CODE 					= 	(0x00000080);



void inline incrementSnake(int player, char sprite, short x, short y){
	char unused = 0;
	char increment = 1; // Increment flag is set high
	char segment = 0; // Head
	char add_remove = ADD_CODE; // Add
	int code = (unused << 29) | (increment << 28) | (segment << 26) | (add_remove << 25) | (sprite << 20) |  ((x & 0x03FF) << 10) | (y & 0x03FF);
	WRITE_SPRITE(player,code);
}

/*
 * 	Player : 1 = player1, 2 = player2
 * 	Segment 0=head, 1= second to head, 2 = second to tail 3 = tail
 * 	Sprite: Choose sprite constant
 */
void inline addSnakePiece(int player, char segment, char sprite, short x, short y){
	char unused = 0;
	char add_remove = ADD_CODE;
	int code = (unused << 28) | (segment << 26) | (add_remove << 25) | (sprite << 20) |  ((x & 0x03FF) << 10) | (y & 0x03FF);
	WRITE_SPRITE(player,code);
}

void inline removeSnakeTail(int player){
	char unused = 0;
	char segment = SEG_TAIL; // Must be tail
	char add_remove = REMOVE_CODE; // Remove
	char sprite = 0; //Dont care
	short x = 0; // Dont care
	short y = 0; // Dont care
	int code = (unused << 28) | (segment << 26) | (add_remove << 25) | (sprite << 20) |  ((x & 0x03FF) << 10) | (y & 0x03FF);
	WRITE_SPRITE(player,code);
}


/*
 * NOTE: The tile_x and tile_y are NOT x and y coordinatees.
 * 		They are the tile numbers (X:0-40, Y:0-30).
 * 		Please keep track of their actual x,y locations in software
 */
void inline addTilePiece(char sprite, short tile_x, short tile_y){
	char unused = 0;
	char segment = 0; // Dont care
	char add_remove = ADD_CODE;
	int code = (unused << 28) | (segment << 26) | (add_remove << 25) | (sprite << 20) |  ((tile_x & 0x03FF) << 10) | (tile_y & 0x03FF);
	WRITE_SPRITE(TILES,code);
}

void inline removeTilePiece(short tile_x, short tile_y){
	char unused = 0;
	char segment = 0; // Dont care
	char add_remove = REMOVE_CODE;
	char sprite = 0; // Dont care
	int code = (unused << 28) | (segment << 26) | (add_remove << 25) | (sprite << 20) |  ((tile_x & 0x03FF) << 10) | (tile_y & 0x03FF);
	WRITE_SPRITE(TILES,code);
}

int inline getController(player){

	int controls = READ_PLAYER_CONTROLLER(player);
//	int right = controls 	& (0x00000001);
//	int left = controls 	& (0x00000002);
//	int down = controls 	& (0x00000004);
//	int up = controls 		& (0x00000008);
//	int start = controls 	& (0x00000010);
//	int select = controls 	& (0x00000020);
//	int b = controls 		& (0x00000040);
//	int a = controls 		& (0x00000080);
//	printf("%d-%d-%d-%d-%d-%d-%d-%d\n",a,b,select,start,up,down,left,right);
//	if( right )
//		return 0;
//	if( left )
//		return 1;
//	if( up )
//		return 2;
//	if( down )
//		return 3;

	return controls;
}

int inline getPlayer1Controller(){

	int c = getController(PLAYER1);
	return c;
}

int inline getPlayer2Controller(){

	int c = getController(PLAYER2);
	return c;
}

int get_dir_from_pressed(int pressed){
	int right 	= pressed 	& RIGHT_CODE;
	int left 	= pressed 	& LEFT_CODE;
	int down 	= pressed	& DOWN_CODE;
	int up 		= pressed 	& UP_CODE;
	if( right )
		return 0;
	if( left )
		return 1;
	if( up )
		return 2;
	if( down )
		return 3;

	return -1;
}

int check_paused(int pressed){

	return pressed & SELECT_CODE;
}

void reset_hardware(){
	SOFT_RESET();
}


#endif

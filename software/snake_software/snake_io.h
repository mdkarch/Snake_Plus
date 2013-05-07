#ifndef _SNAKE_IO_H_
#define _SNAKE_IO_H_

#include "../snake_software_bsp/system.h"

#define WRITE_SPRITE(select,data) \
IOWR_32DIRECT(DE2_VGA_CONTROLLER_0_BASE, select * 4, data)

#define READ_SNAKE() \
IORD_32DIRECT(DE2_VGA_CONTROLLER_0_BASE, 0 * 4)
//
//#define READ_SNAKE1_TAIL() \
//IORD_32DIRECT(DE2_VGA_CONTROLLER_0_BASE, 1 * 4)
//
//#define READ_SNAKE1_LENGTH() \
//IORD_32DIRECT(DE2_VGA_CONTROLLER_0_BASE, 3 * 4)

#define SOFT_RESET() \
IOWR_32DIRECT(DE2_VGA_CONTROLLER_0_BASE, 3 * 4, 0);

#define ENABLE_SPLASH_SCREEN() \
IOWR_32DIRECT(DE2_VGA_CONTROLLER_0_BASE, 4 * 4, 0);

#define DISABLE_SPLASH_SCREEN() \
IOWR_32DIRECT(DE2_VGA_CONTROLLER_0_BASE, 5 * 4, 0);

#define READ_PLAYER_CONTROLLER(player) \
IORD_32DIRECT(NES_CONTROLLER_BASE, player * 4);

#define PLAY_SOUND(sound_id) \
IORD_32DIRECT(DE2_AUDIO_CONTROLLER_0_BASE, sound_id * 4);

#define CHANGE_DIVIDER(divider) \
IOWR_32DIRECT(DE2_AUDIO_CONTROLLER_0_BASE, 0, divider);



/* Player/Tile/Address codes */
const char SNAKE_ADDR 	= 1;
const char TILES_ADDR 	= 2;


char PLAYER1 	= 1;
char PLAYER2 	= 2;


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


/*
 * 	Player : 1 = player1, 2 = player2d
 * 	Sprite: Choose sprite constant
 * NOTE: The snake_x and snake_y are NOT x and y coordinatees.
 * 		They are the tile numbers (X:0-40, Y:0-30).
 * 		Please keep track of their actual x,y locations in software
 */
void inline addSnakePiece(int player, char sprite, short snake_x, short snake_y){
	char unused = 0;
	char add_remove = ADD_CODE;
	player = player - 1; // For controller, it expects 0 or 1
	int code = (unused << 27) | (player << 26) | (add_remove << 25) | (sprite << 20) | (unused << 11) | ((snake_x & 0x03F) << 5) | (snake_y & 0x01F);
	WRITE_SPRITE(SNAKE_ADDR,code);
}

void inline removeSnakePiece(int player, short tile_x, short tile_y){
	char unused = 0;
	char add_remove = REMOVE_CODE;
	char sprite = 0; // Dont care
	player = player - 1; // For controller, it expects 0 or 1
	int code = (unused << 27) | (player << 26) | (add_remove << 25) | (sprite << 20) | (unused << 11) | ((tile_x & 0x03F) << 5) | (tile_y & 0x01F);
	WRITE_SPRITE(SNAKE_ADDR,code);
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
	int code = (unused << 28) | (segment << 26) | (add_remove << 25) | (sprite << 20) | (unused << 11) | ((tile_x & 0x03F) << 5) | (tile_y & 0x01F);;
	WRITE_SPRITE(TILES_ADDR,code);
}

void inline removeTilePiece(short tile_x, short tile_y){
	char unused = 0;
	char segment = 0; // Dont care
	char add_remove = REMOVE_CODE;
	char sprite = 0; // Dont care
	int code = (unused << 28) | (segment << 26) | (add_remove << 25) | (sprite << 20) | (unused << 11) | ((tile_x & 0x03F) << 5) | (tile_y & 0x01F);
	WRITE_SPRITE(TILES_ADDR,code);
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

int get_button_from_pressed(int pressed){
	int a 		= pressed 	& A_CODE;
	int b	 	= pressed 	& B_CODE;
	if( a )
		return A_CODE;
	if( b )
		return B_CODE;
	return -1;
}

int check_paused(int pressed){

	return pressed & SELECT_CODE;
}

void enable_splash_screen(){

	ENABLE_SPLASH_SCREEN();
}

void disable_splash_screen(){

	DISABLE_SPLASH_SCREEN();
}

void reset_hardware(){
	int x = 0;
	int y = 0;
	for(x = 0; x < 40; x++){
		for(y = 0; y < 30; y++){
			addSnakePiece(0, 0, x, y);
			addTilePiece(0, x, y);
		}
	}
	SOFT_RESET();
}


#endif

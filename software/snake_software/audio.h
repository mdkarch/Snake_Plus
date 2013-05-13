#ifndef _AUDIO_H_
#define _AUDIO_H_

int sound_to_be_played 		= -1;
int sound_divider		 	= -1;

#include "../snake_software_bsp/system.h"

#define PLAY_SOUND(sound_id) \
IORD_32DIRECT(DE2_AUDIO_CONTROLLER_0_BASE, sound_id * 4);

#define CHANGE_DIVIDER(divider) \
IOWR_32DIRECT(DE2_AUDIO_CONTROLLER_0_BASE, 0, divider);

const int move_sound_code = 0;
const int move_sound_divider = 3125;

const int powerup_sound_code = 1;
const int powerup_sound_divider = 3125;

const int gameover_sound_code = 2;
const int gameover_sound_divider = 3125;

const int splash_sound_code = 3;
const int splash_sound_divider = 3125;

void inline play_move_sound() {
	if (sound_to_be_played == -1) {
		sound_to_be_played = move_sound_code;
		sound_divider = move_sound_divider;
	}
}

void inline play_powerup_sound() {
	sound_to_be_played = powerup_sound_code;
	sound_divider = powerup_sound_divider;
}

void inline play_gameover_sound() {
	sound_to_be_played = gameover_sound_code;
	sound_divider = gameover_sound_divider;
}

void inline play_splash_sound() {
	sound_to_be_played = splash_sound_code;
	sound_divider = splash_sound_divider;
}


void play_sound(){

	if( sound_to_be_played == -1)
		return;

	PLAY_SOUND(sound_to_be_played);
	PLAY_SOUND(sound_to_be_played);

	sound_to_be_played = -1;
}

#endif

#include "basic_io.h"
#include <alt_types.h>
#include "alt_up_ps2_port.h"
#include "ps2_keyboard.h"
#include "ps2_mouse.h"
#include "LCD.h"
#include "VGA.h"
//#include <stdio.h>
//#include <stdlib.h>
//#include <unistd.h>

int LEFT_BOUND = 0;
int RIGHT_BOUND = 10;//640;
int TOP_BOUND = 10;//480;
int BOT_BOUND = 0;

int xCoor = 0;
int yCoor = 0;

int left = 0;
int right = 1; //have snake start moving right first
int up = 0;
int down = 0;

  int status = 0;
  alt_u8 key = 0;
KB_CODE_TYPE decode_mode;


static void kb_interrupt_handler() {
	printf("HEEELLLLO\n");
	status = read_make_code(&decode_mode, &key);
	printf("Status: %d\n", status);
	if (status == PS2_SUCCESS) {
	      // print out the result
		printf("%c", key );
	}
}


static void movement(){ //up,down,left, right will be set based on user input
	if(xCoor >= LEFT_BOUND && right){
		xCoor++;
		if(xCoor == RIGHT_BOUND){
			right = 0;
			left = 0;
			up = 1;
			down = 0;
		}
	}else if(xCoor <= RIGHT_BOUND && left){
		xCoor--;
		if(xCoor == LEFT_BOUND){
			right = 0;
			left = 0;
			up = 0;
			down = 1;
		}
	}else if(yCoor >= BOT_BOUND && up){
		yCoor++;
		if(yCoor == TOP_BOUND){
			right = 0;
			left = 1;
			up = 0;
			down = 0;
		}
	}else if(yCoor <= TOP_BOUND && down){
		yCoor--;
		if(yCoor == LEFT_BOUND){
			right = 1;
			left = 0;
			up = 0;
			down = 0;
		}
	}
	printf("x: %d y: %d\n", xCoor, yCoor);
	usleep(500000);
}

typedef enum
  {
    STATE_INIT,
    STATE_LONG_BINARY_MAKE_CODE,
    STATE_BREAK_CODE ,
    STATE_DONE
  } DECODE_STATE;


int read_make_code(KB_CODE_TYPE *decode_mode, alt_u8 *buf)
{
  alt_u8 byte = 0;
  int status_read =0;
  *decode_mode = KB_INVALID_CODE;
  DECODE_STATE state = STATE_INIT;
  do {
    status_read = read_data_byte_with_timeout(&byte, 10000);
    //FIXME: When the user press the keyboard extremely fast, data may get
    //occasionally get lost

    if (status_read == PS2_ERROR)
      return PS2_ERROR;

    state = get_next_state(state, byte, decode_mode, buf);
  } while (state != STATE_DONE);

  return PS2_SUCCESS;
}

int main(){
	alt_u8 key = 0;
// Initialize the keyboard
  printf("Please wait three seconds to initialize keyboard\n");
  clear_FIFO();
  switch (get_mode()) {
  case PS2_KEYBOARD:
    break;
  case PS2_MOUSE:
    printf("Error: Mouse detected on PS/2 port\n");
    break;
  default:
    printf("Error: Unrecognized or no device on PS/2 port\n");
    break;
  }
		//alt_irq_register(PS2_0_IRQ, NULL, (void*)kb_interrupt_handler);
	while(1) {

		status = read_make_code(&decode_mode, &key);
		 if (status == PS2_SUCCESS && key != 0) printf("key:%c -- %x\n", key, key);
		//movement();
	}

	return 0;
}

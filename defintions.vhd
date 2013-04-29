library ieee;
use ieee.std_logic_1164.all;

package DEFINITIONS is

	--Type Definitions
	  type tiles_ram is array(39 downto 0, 29 downto 0) of
							std_logic_vector(7 downto 0);

	   type snake_ram is array(1200 downto 0) of
							std_logic_vector(31 downto 0);
	
	--Snake constants
		constant MAX_SNAKE_SIZE	: integer := 10;	
		
	--Sprite Constants
		constant SPRITE_LEN: integer := 15; 
	
	
	-- Color declarations
		constant BLACK	: STD_LOGIC_VECTOR 	:= "000";
		constant WHITE	: STD_LOGIC_VECTOR 	:= "001";
		constant RED	: STD_LOGIC_VECTOR 	:= "010";
		constant GREEN : STD_LOGIC_VECTOR 	:= "011";
		constant BLUE	: STD_LOGIC_VECTOR 	:= "100";
		constant YELLOW: STD_LOGIC_VECTOR 	:= "101";
		constant GRAY	: STD_LOGIC_VECTOR 	:= "110";
		constant PINK	: STD_LOGIC_VECTOR 	:= "111";
		
		
		-- Sprite Select Codes
		constant UNUSED_CODE					: STD_LOGIC_VECTOR(4 downto 0)	:= "00000";
		constant SNAKE_HEAD_RIGHT			: STD_LOGIC_VECTOR(4 downto 0) 	:= "00001";
		constant SNAKE_HEAD_LEFT			: STD_LOGIC_VECTOR(4 downto 0) 	:= "00010";
		constant SNAKE_HEAD_UP				: STD_LOGIC_VECTOR(4 downto 0) 	:= "00011";
		constant SNAKE_HEAD_DOWN			: STD_LOGIC_VECTOR(4 downto 0) 	:= "00100";
		constant SNAKE_TAIL_RIGHT			: STD_LOGIC_VECTOR(4 downto 0) 	:= "00101";
		constant SNAKE_TAIL_LEFT			: STD_LOGIC_VECTOR(4 downto 0) 	:= "00110";
		constant SNAKE_TAIL_UP				: STD_LOGIC_VECTOR(4 downto 0) 	:= "00111";
		constant SNAKE_TAIL_DOWN			: STD_LOGIC_VECTOR(4 downto 0) 	:= "01000";
		constant SNAKE_BODY_RIGHT			: STD_LOGIC_VECTOR(4 downto 0) 	:= "01001";
		constant SNAKE_BODY_LEFT			: STD_LOGIC_VECTOR(4 downto 0) 	:= "01010";
		constant SNAKE_BODY_UP				: STD_LOGIC_VECTOR(4 downto 0) 	:= "01011";
		constant SNAKE_BODY_DOWN			: STD_LOGIC_VECTOR(4 downto 0) 	:= "01100";
		
		constant SNAKE_TURN_UP_RIGHT		: STD_LOGIC_VECTOR(4 downto 0) 	:= "01101";
		constant SNAKE_TURN_RIGHT_DOWN	: STD_LOGIC_VECTOR(4 downto 0) 	:= "01110";
		constant SNAKE_TURN_DOWN_LEFT		: STD_LOGIC_VECTOR(4 downto 0) 	:= "01111";
		constant SNAKE_TURN_LEFT_UP		: STD_LOGIC_VECTOR(4 downto 0) 	:= "10000";
		
		
		-- Reuse codes for other sprites
		constant RABBIT_CODE 		: STD_LOGIC_VECTOR(4 downto 0) 	:= "00001";
		constant MOUSE_CODE 			: STD_LOGIC_VECTOR(4 downto 0) 	:= "00010";
		constant EDWARDS_CODE 		: STD_LOGIC_VECTOR(4 downto 0) 	:= "00011";
		constant WALL_CODE 			: STD_LOGIC_VECTOR(4 downto 0) 	:= "00100";
		constant SPEED_CODE 			: STD_LOGIC_VECTOR(4 downto 0) 	:= "00101";
		constant FREEZE_CODE 		: STD_LOGIC_VECTOR(4 downto 0) 	:= "00110";
		constant GROWTH_CODE 		: STD_LOGIC_VECTOR(4 downto 0) 	:= "00111";
		constant ONE_CODE 			: STD_LOGIC_VECTOR(4 downto 0) 	:= "01000";
		constant TWO_CODE 			: STD_LOGIC_VECTOR(4 downto 0) 	:= "01001";
		constant P_CODE 				: STD_LOGIC_VECTOR(4 downto 0) 	:= "01010";
		constant W_CODE 				: STD_LOGIC_VECTOR(4 downto 0) 	:= "01011";
		constant I_CODE 				: STD_LOGIC_VECTOR(4 downto 0) 	:= "01100";
		constant N_CODE 				: STD_LOGIC_VECTOR(4 downto 0) 	:= "01101";
		constant S_CODE 				: STD_LOGIC_VECTOR(4 downto 0) 	:= "01110";
		constant EXC_CODE 			: STD_LOGIC_VECTOR(4 downto 0) 	:= "01111";
		constant PLAY_CODE 			: STD_LOGIC_VECTOR(4 downto 0) 	:= "10000";
		constant PAUSE_CODE 			: STD_LOGIC_VECTOR(4 downto 0) 	:= "10001";
							
end package DEFINITIONS;
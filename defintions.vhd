library ieee;
use ieee.std_logic_1164.all;

package DEFINITIONS is

	--Type Definitions
	  type tiles_ram is array(39 downto 0, 29 downto 0) of
							std_logic_vector(7 downto 0);

	   type snake_ram is array(1200 downto 0) of
							std_logic_vector(31 downto 0);
	
	--Snake constants
		constant MAX_SNAKE_SIZE	: integer := 1200;	
	
	
	-- Color declarations
		constant BLACK	: STD_LOGIC_VECTOR 	:= "000";
		constant WHITE	: STD_LOGIC_VECTOR 	:= "001";
		constant RED	: STD_LOGIC_VECTOR 	:= "010";
		constant GREEN : STD_LOGIC_VECTOR 	:= "011";
		constant BLUE	: STD_LOGIC_VECTOR 	:= "100";
		constant YELLOW: STD_LOGIC_VECTOR 	:= "101";
		constant GRAY	: STD_LOGIC_VECTOR 	:= "110";
		constant PINK	: STD_LOGIC_VECTOR 	:= "111";
							
end package DEFINITIONS;
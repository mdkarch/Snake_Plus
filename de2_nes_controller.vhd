
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Address:		1 = player1, 2= player2
--
-- Writedata: 	8 bits of controller value in this order
--					A-B-Se-St-Up-Down-Left-Right			

entity de2_nes_controller is

	port (

		clk        	: in  std_logic;
		reset    	: in  std_logic;
		read       	: in  std_logic;
		write      	: in  std_logic;
		chipselect 	: in  std_logic;
		address    	: in  std_logic_vector(7 downto 0);
		readdata   	: out std_logic_vector(15 downto 0);
		writedata  	: in  std_logic_vector(15 downto 0);	
		
		latch1		: out std_logic;
		pulse1		: out std_logic;
		data1			: in std_logic;
		latch2		: out std_logic;
		pulse2		: out std_logic;
		data2			: in std_logic
	  
	);
  
end de2_nes_controller;

architecture datapath of de2_nes_controller is

	signal buttons1	: std_logic_vector(7 downto 0);
	signal buttons2	: std_logic_vector(7 downto 0);

begin

	
	
	DD1: entity work.nes_fsm port map(

		clk 					=> clk,
		reset					=> reset,
		latch1				=> latch1,
		pulse1				=> pulse1,
		data1					=> data1,
		latch2				=> latch2,
		pulse2				=> pulse2,
		data2					=> data2,
		buttons1_out		=> buttons1,
		buttons2_out		=> buttons2
);
	
end datapath;
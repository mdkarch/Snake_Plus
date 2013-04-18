library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controller_tb is
end controller_tb;

architecture a1 of controller_tb is

component controller is 
	port (
		clk	: in std_logic;
		latch	: out std_logic;
		pulse	: out std_logic;
		data	: in std_logic;
		leds	: out std_logic_vector(15 downto 0);
		counter_c : out integer
	);
end component;

signal clk 	: std_logic  	:= '0';
signal latch : std_logic 	:= '0';
signal pulse : std_logic	:= '0';
signal data : std_logic		:= '0';
signal leds : std_logic_vector(15 downto 0);
signal counter : integer;


begin

	UTB : controller port map( 
		clk => clk,
		latch => latch,
		pulse => pulse,
		data => data,
		leds => leds,
		counter_c => counter
		);
			
		clk <= not clk after 10ns;
		
		process
		begin
			

		wait;
		end process;

end a1;


	

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
		reset_n    	: in  std_logic;
		read       	: in  std_logic;
		write      	: in  std_logic;
		chipselect 	: in  std_logic;
		address    	: in  std_logic_vector(3 downto 0);
		readdata   	: out std_logic_vector(7 downto 0);
		writedata  	: in  std_logic_vector(7 downto 0);	
		
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
	
	signal reset 		: std_logic;
	
	
	component nes_fsm is
		port (
			clk			: in std_logic;
			reset			: in std_logic;
			latch1		: out std_logic;
			pulse1		: out std_logic;
			data1			: in std_logic;
			latch2		: out std_logic;
			pulse2		: out std_logic;
			data2			: in std_logic;
			buttons1_out: out std_logic_vector(7 downto 0);
			buttons2_out: out std_logic_vector(7 downto 0)
		);
	end component;

begin
	
	reset <= not(reset_n);
	
	process (clk)
	begin
		if rising_edge(clk) then

			if reset = '1' then
				readdata <= (others => '0');
				
			else
			
				if chipselect = '1' then -- This chip is right one
					-- Read --
					if read = '1' then
						if address = "0001" then -- First player
							readdata <= buttons1;
						elsif address = "0010" then -- Second player
							readdata <= buttons2;
						end if; -- end address
					end if; -- end read
				end if; --end chipselect
				
			end if; -- reset 
		end if;	-- end rising edge
	end process;
	
	NES1: nes_fsm port map(

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
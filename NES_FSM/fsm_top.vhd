--
-- DE2 top-level module that includes the simple audio component
--
-- Stephen A. Edwards, Columbia University, sedwards@cs.columbia.edu
--
-- From an original by Terasic Technology, Inc.
-- (DE2_TOP.v, part of the DE2 system board CD supplied by Altera)
--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fsm_top is

  port (
    -- Clocks

    CLOCK_50	: in std_logic;	                   -- 50 MHz

    LEDR : out std_logic_vector(17 downto 0);      -- Red LEDs
    
    -- General-purpose I/O
    
    GPIO_0,                                      -- GPIO Connection 0
    GPIO_1 : inout std_logic_vector(35 downto 0) -- GPIO Connection 1   
    ); 
  
end fsm_top;

architecture datapath of fsm_top is

	signal counter : integer;

begin


	controller : entity work.controller port map(
		clk			=> CLOCK_50,
		latch1	 	=> GPIO_0(2), 
		pulse1		=> GPIO_0(4),	
		data1			=> GPIO_0(6),	
		latch2	 	=> GPIO_0(28), 
		pulse2		=> GPIO_0(30),	
		data2			=> GPIO_0(32),	
	  );
	

end datapath;

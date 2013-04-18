
library ieee;
use ieee.std_logic_1164.all;

entity controller is
    port (
		clk			: in std_logic;
		latch			: out std_logic;
		pulse			: out std_logic;
		data			: in std_logic;
		leds			: out std_logic_vector(15 downto 0);
		counter_c	: out integer
	  );


end controller;

architecture arch of controller is

	type states is (latch_state, p0, p1, p2, p3, p4, p5, p6, p7,
								 l0, l1, l2, l3, l4, l5, l6, l7, done );
	signal p_s, n_s 				: states;
	
	signal buttons					: std_logic_vector(7 downto 0);
	
	signal counter					: integer 	:= 0;			--Clock for latch/pulse
	signal clock_60hz 			: std_logic := '0';		-- Clock for polling controller
	signal clock_60hz_counter	: integer 	:= 0;		
	
	signal in_state_machine		: std_logic	:= '0';		-- Flag for state machine
	
	constant MICRO_6				: integer 	:= 300;
	constant MICRO_12				: integer 	:= 600;
	constant MILLI_8P3			: integer 	:= 833333;

begin  -- arch

	
	-- Generate 60HZ clock to poll controllers
	clockprocess_60hz : process(clk)
	begin
		if rising_edge(clk) then
			
			clock_60hz_counter <= clock_60hz_counter + 1;
			
			clock_60hz <= '0'; -- Always zero except for the one cycle it isnt
			
			if clock_60hz_counter >= MILLI_8P3  then
				clock_60hz_counter <= 0;
				clock_60hz <= '1'; -- Set clock HIGH here
			end if;
			
			
		end if; -- rising edge clk
	end process clockprocess_60hz;
	
		
		-- Go through state machine to retrieve values
    fsm_like_things:process(clk, clock_60hz, n_s)
    begin
		if rising_edge(clk) then
		
			counter_c <= counter;
			 
			latch <= '0';
			pulse <= '0';
			
			leds(15) <= clock_60hz;
			leds(0) 	<= in_state_machine;
		 
			if clock_60hz = '0' and in_state_machine = '0' then
				-- Do nothing
			else
				
				-- Only increment the latch/pulse clock while in the state machine
				counter <= counter + 1;
				
				-- Set signal so next time around, regardless of 60hz clock, enter in here
				in_state_machine <= '1';
				
				-- Ask controllers for data nicely with please and thank you
				case p_s is
				 
					-- Host sending request to controller
					when latch_state =>
						if counter > MICRO_12 then
							 n_s <= l0;
							 counter <= 0;
							 latch <= '0';
							 leds(1) <= '0';
						else
							 n_s <= latch_state;
							 latch <= '1';
							 leds(1) <= '1';
						end if;
						
						
					-- Wait 6us
					when l0 =>
						if counter > MICRO_6 then
							 n_s <= p0;
							 counter <= 0;
							 leds(2) <= '0';
						else
							 n_s <= l0;
							 leds(2) <= '1';
						end if;
						
					-- Get A button
					when p0 =>
						if counter > MICRO_6 then
							 n_s <= l1;
							 counter <= 0;
							 pulse <= '0';
							 buttons(0) <= not data;
							 leds(3) <= '0';
						else
							 n_s <= p0;
							 pulse <= '1';
							 leds(3) <= '1';
						end if;
			  
			  
					-- Wait 6us
					when l1 =>
						if counter > MICRO_6 then
							 n_s <= p1;
							 counter <= 0;
							 leds(4) <= '0';
						else
							 n_s <= l1;
							 leds(4) <= '1';
						end if;
				
					-- Get B button
					when p1 =>
						if counter > MICRO_6 then
							 n_s <= l2;
							 counter <= 0;
							 pulse <= '0';
							 buttons(1) <= not data;
							 leds(5) <= '0';
						else
							 n_s <= p1;
							 pulse <= '1';
							 leds(5) <= '1';
						end if;
						
					
					-- Wait 6us
					when l2 =>
						if counter > MICRO_6 then
							 n_s <= p2;
							 counter <= 0;
							 leds(6) <= '0';
						else
							 n_s <= l2;
							 leds(6) <= '1';
						end if;
				
				-- Get SELECT button
					when p2 =>
						if counter > MICRO_6 then
							 n_s <= l3;
							 counter <= 0;
							 pulse <= '0';
							 buttons(2) <= data;
							 leds(7) <= '0';
						else
							 n_s <= p2;
							 pulse <= '1';
							 leds(7) <= '1';
						end if;
						
						
					-- Wait 6us
					when l3 =>
						if counter > MICRO_6 then
							 n_s <= p3;
							 counter <= 0;
							 leds(8) <= '0';
						else
							 n_s <= l3;
							 leds(8) <= '1';
						end if;
				
					-- Get START button
					when p3 =>
						if counter > MICRO_6 then
							 n_s <= l4;
							 counter <= 0;
							 pulse <= '0';
							 buttons(3) <= not data;
							 leds(9) <= '0';
						else
							 n_s <= p3;
							 pulse <= '1';
							 leds(9) <= '1';
						end if;
						
						
					-- Wait 6us	
					when l4 =>
						if counter > MICRO_6 then
							 n_s <= p4;
							 counter <= 0;
							 leds(10) <= '0';
						else
							 n_s <= l4;
							 leds(10) <= '1';
						end if;
				
					-- Get UP button
					when p4 =>
						if counter > MICRO_6 then
							 n_s <= l5;
							 counter <= 0;
							 pulse <= '0';
							 buttons(4) <= not data;
							 leds(11) <= '0';
						else
							 n_s <= p4;
							 pulse <= '1';
							 leds(11) <= '1';
						end if;
						
						
					-- Wait 6us	
					when l5 =>
						if counter > MICRO_6 then
							 n_s <= p5;
							 counter <= 0;
							 leds(12) <= '0';
						else
							 n_s <= l5;
							 leds(12) <= '1';
						end if;
				
				
					-- Get DOWN button
					when p5 =>
						if counter > MICRO_6 then
							 n_s <= l6;
							 counter <= 0;
							 pulse <= '0';
							 buttons(5) <= not data;
							 leds(13) <= '0';
						else
							 n_s <= p5;
							 pulse <= '1';
							 leds(13) <= '1';
						end if;
						
						
					-- Wait 6us	
					when l6 =>
						if counter > MICRO_6 then
							 n_s <= p6;
							 counter <= 0;
						else
							 n_s <= l6;
						end if;
				
					-- Get LEFT button
					when p6 =>
						if counter > MICRO_6 then
							 n_s <= l7;
							 counter <= 0;
							 pulse <= '0';
							 buttons(6) <= not data;
						else
							 n_s <= p6;
							 pulse <= '1';
						end if;
						
						
					-- Wait 6us	
					when l7 =>
						if counter > MICRO_6 then
							 n_s <= p7;
							 counter <= 0;
						else
							 n_s <= l7;
						end if;
				
					-- Get RIGHT button
					when p7 =>
						if counter > MICRO_6 then
							 n_s <= done;
							 counter <= 0;
							 pulse <= '0';
							 buttons(7) <= not data;
						else
							 n_s <= p7;
							 pulse <= '1';
						end if;
						
					
					when done =>
						if counter > MICRO_6 then
							 n_s <= latch_state;
							 counter <= 0;
							 in_state_machine <= '0'; -- Reset flag
							 leds(14) <= '0';
						else
							 n_s <= done;
							 leds(14) <= '1';
						end if;
						
					
					when others =>
						counter <= 0;
						n_s <= latch_state;
						pulse <= '0';
						latch <= '0';
						in_state_machine <= '0';
					
					end case;
					
				end if; -- clock_60hz
		end if; -- rising edge clk
		
		---------------------------
		-- Set the new state to p_s
		p_s <= n_s;
		---------------------------

	end process fsm_like_things;
 end arch;
    



library ieee;
use ieee.std_logic_1164.all;

entity nes_fsm is
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


end nes_fsm;

architecture arch of nes_fsm is

	signal latch					:	std_logic	:= '0';
	signal pulse					:	std_logic	:= '0';

	type states is (latch_state, p0, p1, p2, p3, p4, p5, p6, p7,
								 l0, l1, l2, l3, l4, l5, l6, l7, done );
	signal p_s, n_s 				: states;
	
	signal buttons1				: std_logic_vector(7 downto 0);
	signal buttons2				: std_logic_vector(7 downto 0);
	
	signal counter					: integer 	:= 0;			--Clock for latch/pulse
	signal clock_60hz 			: std_logic := '0';		-- Clock for polling controller
	signal clock_60hz_counter	: integer 	:= 0;		
	
	signal in_state_machine		: std_logic	:= '0';		-- Flag for state machine
	
	constant MICRO_6				: integer 	:= 300;
	constant MICRO_12				: integer 	:= 600;
	constant MILLI_8P3			: integer 	:= 300000;

begin  -- arch

	latch1 <= latch;
	latch2 <= latch;
	pulse1 <= pulse;
	pulse2 <= pulse;
	
	buttons1_out <= buttons1;
	buttons2_out <= buttons2;
	
	-- Generate 60HZ clock to poll controllers
	clockprocess_60hz : process(clk)
	begin
		if rising_edge(clk) then
			
			if reset = '1' then
				clock_60hz_counter <= 0;
				clock_60hz <= '0';
			else
				clock_60hz_counter <= clock_60hz_counter + 1;
				
				clock_60hz <= '0'; -- Always zero except for the one cycle it isnt
				
				if clock_60hz_counter >= MILLI_8P3  then
					clock_60hz_counter <= 0;
					clock_60hz <= '1'; -- Set clock HIGH here
				end if;
				
			end if; -- end reset
			
			
		end if; -- rising edge clk
	end process clockprocess_60hz;
	
		
		-- Go through state machine to retrieve values
    fsm_like_things:process(clk, clock_60hz, n_s)
    begin
		if rising_edge(clk) then
			 
			latch <= '0';
			pulse <= '0';
			
			if reset = '1' then
				counter <= 0;
				in_state_machine <= '0';
				n_s <= latch_state;
				pulse <= '0';
				latch <= '0';
				buttons1 <= (others => '0');
				buttons2 <= (others => '0');
				
			elsif clock_60hz = '0' and in_state_machine = '0' then
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
						else
							 n_s <= latch_state;
							 latch <= '1';
						end if;
						
					
					-- Get A button
					-- Wait 6us
					when l0 =>
						if counter > MICRO_6 then
							 n_s <= p0;
							 counter <= 0;
						else
							 n_s <= l0;
							 buttons1(0) <= not data1;
							 buttons2(0) <= not data2;
						end if;
						
					-- Pulse
					when p0 =>
						if counter > MICRO_6 then
							 n_s <= l1;
							 counter <= 0;
							 pulse <= '0';
						else
							 n_s <= p0;
							 pulse <= '1';
						end if;
			  
			  
					-- Get B button
					-- Wait 6us
					when l1 =>
						if counter > MICRO_6 then
							 n_s <= p1;
							 counter <= 0;
						else
							 n_s <= l1;
							 buttons1(1) <= not data1;
							 buttons2(1) <= not data2;
						end if;
				
					-- Pulse
					when p1 =>
						if counter > MICRO_6 then
							 n_s <= l2;
							 counter <= 0;
							 pulse <= '0';
							
						else
							 n_s <= p1;
							 pulse <= '1';
						end if;
						
					-- Get SELECT button
					-- Wait 6us
					when l2 =>
						if counter > MICRO_6 then
							 n_s <= p2;
							 counter <= 0;
						else
							 n_s <= l2;
							 buttons1(2) <= not data1;
							 buttons2(2) <= not data2;
						end if;
				
					-- Pulse
					when p2 =>
						if counter > MICRO_6 then
							 n_s <= l3;
							 counter <= 0;
							 pulse <= '0';
							 
						else
							 n_s <= p2;
							 pulse <= '1';
						end if;
						
					-- Get START button
					-- Wait 6us
					when l3 =>
						if counter > MICRO_6 then
							 n_s <= p3;
							 counter <= 0;
						else
							 n_s <= l3;
							 buttons1(3) <= not data1;
							 buttons2(3) <= not data2;
						end if;
				
					-- Pulse
					when p3 =>
						if counter > MICRO_6 then
							 n_s <= l4;
							 counter <= 0;
							 pulse <= '0';
						else
							 n_s <= p3;
							 pulse <= '1';
						end if;
						
					-- Get UP button	
					-- Wait 6us	
					when l4 =>
						if counter > MICRO_6 then
							 n_s <= p4;
							 counter <= 0;
						else
							 n_s <= l4;
							 buttons1(4) <= not data1;
							 buttons2(4) <= not data2;
						end if;
				
					-- Pulse
					when p4 =>
						if counter > MICRO_6 then
							 n_s <= l5;
							 counter <= 0;
							 pulse <= '0';
							 
						else
							 n_s <= p4;
							 pulse <= '1';
						end if;
						
						
					-- Get DOWN button
					-- Wait 6us	
					when l5 =>
						if counter > MICRO_6 then
							 n_s <= p5;
							 counter <= 0;
						else
							 n_s <= l5;
							 buttons1(5) <= not data1;
							 buttons2(5) <= not data2;
						end if;
				
				
					-- Pulse
					when p5 =>
						if counter > MICRO_6 then
							 n_s <= l6;
							 counter <= 0;
							 pulse <= '0';
							 
						else
							 n_s <= p5;
							 pulse <= '1';
						end if;
						
					
					-- Get LEFT button
					-- Wait 6us	
					when l6 =>
						if counter > MICRO_6 then
							 n_s <= p6;
							 counter <= 0;
						else
							 n_s <= l6;
							 buttons1(6) <= not data1;
							 buttons2(6) <= not data2;
						end if;
				
					-- Pulse
					when p6 =>
						if counter > MICRO_6 then
							 n_s <= l7;
							 counter <= 0;
							 pulse <= '0';
							 
						else
							 n_s <= p6;
							 pulse <= '1';
						end if;
						
					
					-- Get RIGHT button
					-- Wait 6us	
					when l7 =>
						if counter > MICRO_6 then
							 n_s <= p7;
							 counter <= 0;
						else
							 n_s <= l7;
							 buttons1(7) <= not data1;
							 buttons2(7) <= not data2;
						end if;
				
					-- Pulse
					when p7 =>
						if counter > MICRO_6 then
							 n_s <= done;
							 counter <= 0;
							 pulse <= '0';
							 
						else
							 n_s <= p7;
							 pulse <= '1';
						end if;
						
					
					when done =>
						if counter > MICRO_6 then
							 n_s <= latch_state;
							 counter <= 0;
							 in_state_machine <= '0'; -- Reset flag
						else
							 n_s <= done;
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
    


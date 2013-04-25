library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
----use work.definitions.all;
--
---- PROTOCOL:
--		-- ADDRESS
--			-- 0001 = SNAKE1
--			-- 0010 = SNAKE2
--			-- 0011 = TILES
--		
--		--WRITEDATA
--			--9-0: Y (LSB)
--			--19-10: X
--			--24-20: SPRITE SELECT
--			--25: 1=ADD, 0=REMOVE
--			--26-27: Which segment referring to
--			--			00=head, 01=second to head
--			--			10=second to tail 11=tail
--			--			( only used for snakes, not tiles )
--			--28: increment flag, move all pieces, move head to new x & y
--			--29-31: UNUSED (MSB)
--			
--		--Tiles protocol ( in tiles_ram, from controller to raster)
--			-- 8 bits
--			-- 4-0: Sprite select
--			-- 6-5: unused
--			-- 7	: Enabled/Active signal 
--			
---- On Add:
---- 	Adding to head or tail
----		NEED to send second change for second to head
---- On Remove:
----		Can only happen on tail
----		Must send second change to second to tail, with correct tail
----
--
entity snake_plus_vga is
  
  port (
    clk        : in  std_logic;
    reset_n    : in  std_logic;
    read       : in  std_logic;
    write      : in  std_logic;
    chipselect : in  std_logic;
    address    : in  std_logic_vector(3 downto 0);
    readdata   : out std_logic_vector(31 downto 0);
    writedata  : in  std_logic_vector(31 downto 0);
	 
	 VGA_CLK,                         	-- Clock
    VGA_HS,                          	-- H_SYNC
    VGA_VS,                          	-- V_SYNC
    VGA_BLANK,                       	-- BLANK
    VGA_SYNC 	: out std_logic;        	-- SYNC
    VGA_R,                           	-- Red[9:0]
    VGA_G,                           	-- Green[9:0]
    VGA_B 		: out std_logic_vector(9 downto 0); 	-- Blue[9:0]

    leds       : out std_logic_vector(15 downto 0);
	 sw			: in std_logic_vector(17 downto 0)
    );
  
end snake_plus_vga;
--
architecture rtl of snake_plus_vga is

	signal reset				: std_logic;

  -- Main memory elements
  --signal tiles 				: tiles_ram;
  --signal snake1 				: snake_ram;
  --signal snake2  				: snake_ram;
  
  --Tile signals 
  signal tiles_enabled		: std_logic				:= '0';
  
  -- Snake signals
  signal snake1_enabled		: std_logic				:= '0';
  signal snake1_head_index : integer;
  signal snake1_tail_index : integer;
  signal snake1_length		: integer;
  signal snake2_enabled 	: std_logic				:= '0';
  signal snake2_head_index : integer;
  signal snake2_tail_index : integer;
  signal snake2_length		: integer;
  
  -- For VGA
  signal clk25 				: std_logic 			:= '0';
  
	--- Constants ---
		-- Write -- 
  constant W_SNAKE1_SELECT	: std_logic_vector	:= "0001"; -- Write only
  constant W_SNAKE2_SELECT	: std_logic_vector	:= "0010"; -- Write only
  constant W_TILES_SELECT	: std_logic_vector	:= "0011"; -- Write only
		-- Read -- 	
  constant R_SNAKE1_HEAD	: std_logic_vector	:= "0000"; -- Read only
  constant R_SNAKE1_TAIL	: std_logic_vector	:= "0001"; -- Read only
  constant R_SNAKE1_LENGTH	: std_logic_vector	:= "0011"; -- Read only
  constant R_SNAKE2_HEAD	: std_logic_vector	:= "0100"; -- Read only
  constant R_SNAKE2_TAIL	: std_logic_vector	:= "0101"; -- Read only
--
begin
--  
--  reset <= not(reset_n);
--  
--  --VGA stuff
--  
--  process (clk)
--  begin
--    if rising_edge(clk) then
--      clk25 <= not clk25;
--    end if;
--  end process;
--  
--
--  -- Memory stuff/ LEDS 
--  
--  process (clk)
--  begin
--    if rising_edge(clk) then
--		
--		snake1_enabled <= '0';
--		snake2_enabled <= '0';
--		tiles_enabled 	<= '0';
--		
--		if sw(3 downto 0) = "0000" then
--			leds(9 downto 0) <= snake1(1)(9 downto 0);
--		elsif sw(3 downto 0) = "0001" then
--			leds(9 downto 0) <= snake1(2)(9 downto 0);
--		elsif sw(3 downto 0) = "0010" then
--			leds(9 downto 0) <= snake1(3)(9 downto 0);
--		elsif sw(3 downto 0) = "1000" then
--			leds(9 downto 0) <= snake1(1)(19 downto 10);
--		elsif sw(3 downto 0) = "1001" then
--			leds(9 downto 0) <= snake1(2)(19 downto 10);
--		elsif sw(3 downto 0) = "1010" then
--			leds(9 downto 0) <= snake1(3)(19 downto 10);
--		end if;
--		
--		if sw(5 downto 4) = "01" then
--			leds(10) <= snake1(1)(25);
--		elsif sw(5 downto 4) = "10" then
--			leds(10) <= snake1(2)(25);
--		elsif sw(5 downto 4) = "11" then
--			leds(10) <= snake1(3)(25);
--		end if;
--		
--		if sw(7 downto 6) = "01" then
--			leds(15 downto 11) <= snake1(1)(24 downto 20);
--		elsif sw(7 downto 6) = "10" then
--			leds(15 downto 11) <= snake1(2)(24 downto 20);
--		elsif sw(7 downto 6) = "11" then
--			leds(15 downto 11) <= snake1(3)(24 downto 20);
--		end if;
--		
--		
--      if reset = '1' then
--			readdata <= (others => '0');
--      else
--			
--			if chipselect = '1' then -- This chip is right one
--				
--				-- Write --
--				if write = '1' then
--					
--					-- Select snake1 --
--					if address = W_SNAKE1_SELECT then
--						snake1_enabled <= '1';		
--					end if;
--						
--					-- Select snake2 --
--					if address = W_SNAKE2_SELECT then
--						snake2_enabled <= '1';
--					end if;
--					
--					-- Select tiles --
--					if address = W_TILES_SELECT then
--						tiles_enabled <= '1';
--					end if;
--				
--				-- Read --
--				elsif read = '1' then
--					
--					if address = R_SNAKE1_HEAD then
--						readdata <= std_logic_vector( to_unsigned(snake1_head_index, readdata'length) );
--					elsif address = R_SNAKE1_TAIL then
--						readdata <= std_logic_vector( to_unsigned(snake1_tail_index, readdata'length) );
--					elsif address = R_SNAKE1_LENGTH then
--						readdata <= std_logic_vector( to_unsigned(snake1_length, readdata'length) );
--					elsif address = R_SNAKE2_HEAD then
--						readdata <= std_logic_vector( to_unsigned(snake2_head_index, readdata'length) );
--					elsif address = R_SNAKE1_TAIL then
--						readdata <= std_logic_vector( to_unsigned(snake2_head_index, readdata'length) );
--					elsif address = R_SNAKE1_LENGTH then
--						readdata <= std_logic_vector( to_unsigned(snake2_length, readdata'length) );
--					end if;
--					
--				end if; -- end write/read
--				
--          end if; -- end chipselect
--        end if; --end reset
--      end if; --end rising edge
--  end process;
--
--  
-- 
----VGA stuff
--
--V1: entity work.de2_vga_raster port map (
--    reset => reset,
--    clk => clk25,
--    VGA_CLK => VGA_CLK,
--    VGA_HS => VGA_HS,
--    VGA_VS => VGA_VS,
--    VGA_BLANK => VGA_BLANK,
--    VGA_SYNC => VGA_SYNC,
--    VGA_R => VGA_R,
--    VGA_G => VGA_G,
--    VGA_B => VGA_B,
--	 
--	 TILES_IN => tiles,
--	 SNAKE1_IN => snake1,
--	 SNAKE2_IN => snake2
--  );
--
--  
--  
--DD1: entity work.manage_tiles port map(
--
--		clk 					=> clk,
--		reset					=> reset,
--		enabled 				=> tiles_enabled,
--		data_in 				=> writedata,
--		tiles 				=> tiles
--);
--  
--AD1: entity work.add_remove_snake_part port map (
--
--		clk 					=> clk,
--		reset					=> reset,
--		enabled 				=> snake1_enabled,
--		data_in 				=> writedata,
--		snake 				=> snake1,
--		head_index_out		=> snake1_head_index,
--		tail_index_out		=> snake1_tail_index,
--		snake_length_out	=> snake1_length
--);
--
----AD2: entity work.add_remove_snake_part port map (
----
----		clk 					=> clk,
----		reset					=> reset,
----		enabled 				=> snake2_enabled,
----		data_in 				=> writedata,
----		snake 				=> snake2,
----		head_index_out		=> snake2_head_index,
----		tail_index_out		=> snake2_tail_index,
----		snake_length_out	=> snake2_length
----);
----
end rtl;
--
--
---------------------------------------------------------------------------------------------
------------------------------- SUBCOMPONENTS FOR VGA CONTROLLER ----------------------------
---------------------------------------------------------------------------------------------
----
----
----
------------------------------------
--------------- Tiles --------------
------------------------------------
--
--library ieee;
--use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;
--use work.definitions.all;
--
--
--entity manage_tiles is
--
--	port(
--		clk					: in std_logic;
--		reset 				: in std_logic;
--		enabled				: in std_logic;
--		data_in				: in std_logic_vector(31 downto 0);
--		tiles					: out tiles_ram
--	);
--
--
--end manage_tiles;
--
--architecture mt of manage_tiles is
--
--signal y_val			: std_logic_vector(9 downto 0); 	-- 10 bits --
--signal x_val			: std_logic_vector(9 downto 0); 	-- 10 bits --
--signal sprite_select	: std_logic_vector(4 downto 0); 	-- 5 bits ---
--signal add_remove		: std_logic;							-- 1 bit  ---
--
--begin
--
--
--	y_val 			<= 	data_in(9 downto 0);
--	x_val 			<= 	data_in(19 downto 10);
--	add_remove 		<= 	data_in(25);
--	sprite_select 	<= 	data_in(24 downto 20);
--
--	process (clk)
--	begin
--	if rising_edge(clk) then
--	
--		-- Reset --
--		if reset = '1' then
--			tiles <= (others=>(others=>(others=>'0')));
--			
--		-- Enabled --
--		elsif enabled = '1' then
--															--1=active	-Unused	-Check definitions file
--			tiles( to_integer( unsigned( x_val ) ), 
--					 to_integer( unsigned( y_val ) ) ) <= add_remove & "00" & sprite_select;
--		end if; -- reset/ enabled
--		
--		tiles( 30, 1 ) 	<= '1' & "00" & RABBIT_CODE;
--		tiles( 10, 1 ) 	<= '1' & "00" & MOUSE_CODE;
--		tiles( 15, 20 ) 	<= '1' & "00" & WALL_CODE;
--
--		
--	end if; -- rising edge
--	end process; -- end clk
--
--
--end mt;
--
--
--
--
--
---------------------------------------------
------------ Add Remove Snake Part ----------
---------------------------------------------
--
--library ieee;
--use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;
--use work.definitions.all;
--
--
--entity add_remove_snake_part is
--
--	port(
--		clk					: in std_logic;
--		reset 				: in std_logic;
--		enabled				: in std_logic;
--		data_in				: in std_logic_vector(31 downto 0);
--		snake 				: buffer snake_ram;
--		head_index_out		: out integer;
--		tail_index_out		: out integer;
--		snake_length_out	: out integer
--	);
--
--end add_remove_snake_part;
--
--architecture arsp of add_remove_snake_part is
--
--signal y_val			: std_logic_vector(9 downto 0); 	-- 10 bits --
--signal x_val			: std_logic_vector(9 downto 0); 	-- 10 bits --
--signal sprite_select	: std_logic_vector(4 downto 0); 	-- 5 bits ---
--signal add_remove		: std_logic;							-- 1 bit  ---
--signal segment			: std_logic_vector(1 downto 0);	-- 2 bits ---
--signal increment		: std_logic;							-- 1 bit
--signal unused			: std_logic_vector(2 downto 0);	-- 3 bits ---
--
--signal head_index		: integer		:= 0;
--signal tail_index		: integer		:= 0;
--signal snake_length	: integer		:= 1;
--
----Index that new value will assigned to: head, second head, second tail, tail --
--signal seg_index		: integer;
--
--begin
--
--	head_index_out <= head_index;
--	tail_index_out <= tail_index;
--	snake_length_out <= snake_length;
--	
--	increment 	<= 	data_in(28);
--	segment 		<= 	data_in(27 downto 26);
--	add_remove 	<= 	data_in(25);
--
--	process (clk)
--	begin
--	if rising_edge(clk) then
--	
--		-- Reset --
--		if reset = '1' then
--			snake <= (others=>(others=>'0'));
--			snake(0) <=  "0000" & "00" & "1" & SNAKE_HEAD_RIGHT 
--											& "0100001111" & "0011111111";
--			snake(1) <=  "0000" & "00" & "1" & SNAKE_BODY_RIGHT 
--											& "0011111111" & "0011111111";
--			snake(2) <=  "0000" & "00" & "1" & SNAKE_TAIL_RIGHT 
--											& "0011101111" & "0011111111";
--			head_index		<= 0;
--			tail_index		<= 2;
--			snake_length	<= 3; 
--		
--		-- Only do something if it was directed at this snake	--
--		elsif enabled = '1' then
--		
--			-- Move all pieces, head moves to new location
--			if increment = '1' then
--				for i in MAX_SNAKE_SIZE downto 1 loop
--					if i <= tail_index then
--						snake(i) <= snake(i-1);
--					end if;
--				end loop;
--				snake(0) <= data_in;
--		
--			---- Add situation -----
--			elsif add_remove = '1' then
--			
--				if segment = "00" then
--					-- Do nothing, not allowed
--				
--				-- Second to head
--				elsif segment = "01" then
--						snake(1)(24 downto 20) <= data_in(24 downto 20);
--					
--				-- Second to tail
--				elsif segment = "10" then
--						snake(tail_index - 1)(24 downto 20) <= data_in(24 downto 20);
--					
--				-- Tail
--				elsif segment = "11" then
--
--					--Overflow case
--					if tail_index + 1 > MAX_SNAKE_SIZE then
--						-- Do nothing
--					else
--						--Increment snake length
--						snake_length <= snake_length + 1;
--						-- Update index
--						tail_index <= tail_index + 1;
--						-- Set actual snake
--						snake(tail_index + 1) <= data_in;
--					end if;
--					
--				end if; -- segments
--										
--										
--			-----------------------------------------
--			-- Remove situation --
--			elsif add_remove = '0' then 
--			
--				if segment = "00" or segment = "01" or segment = "10"  then
--					-- CANT DO THIS
--				elsif segment = "11" then
--					if tail_index - 1 <= 0 then
--						-- Do nothing
--					else
--						snake(tail_index)(25) <= '0';
--						tail_index <= tail_index -1;
--						snake_length <= snake_length - 1;
--					end if;
--				end if;
--					
--			end if; --add remove situation
--			
--		end if; -- end if reset/enabled --
--		
--	end if; -- end rising edge --
--	end process;
--
--end arsp;
--
--
--
--
--

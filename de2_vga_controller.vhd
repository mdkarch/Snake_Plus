library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions.all;
--
---- PROTOCOL:
--		-- ADDRESS
--			-- 0001 = SNAKE1
--			-- 0010 = TILES
--			-- 0011 = RESET
--		
--		--WRITEDATA
--			--9-0: Y (LSB)
--			--19-10: X
--			--24-20: SPRITE SELECT
--			--25: 1=ADD, 0=REMOVE
--			--26: 0=PLAYER1, 1= PLAYER2
--			--27-31: UNUSED (MSB)
--			
--		--Tiles/Snakes protocol (in tiles_ram, from controller to raster)
--			-- 8 bits
--			-- 4-0: Sprite select
--			-- 5	: Player select (0 for player1, 1 for player2)
--			-- 6  : unused
--			-- 7	: Enabled/Active signal 
--			
---- On Add:
---- 	Only to tail
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

    --leds       : out std_logic_vector(15 downto 0); 
	 sw			: in std_logic_vector(17 downto 0)
    );
  
end snake_plus_vga;
--
architecture rtl of snake_plus_vga is

	signal reset				: std_logic;
	signal soft_reset			: std_logic				:= '0';

  -- Main memory elements
  signal tiles 				: tiles_ram;
  signal snake 				: tiles_ram;
  
  --Tile signals 
	signal tiles_enabled		: std_logic				:= '0';
	signal snake_enabled		: std_logic				:= '0';
  
  -- Snake signals
--  signal snake1_head_index : integer;
--  signal snake1_tail_index : integer;
--  signal snake1_length		: integer;
--  signal snake2_head_index : integer;
--  signal snake2_tail_index : integer;
--  signal snake2_length		: integer;
  
  -- For VGA
  signal clk25 				: std_logic 			:= '0';
  
	--- Constants ---
		-- Write -- 
  constant W_SNAKE_SELECT	: std_logic_vector	:= "0001"; -- Write only
  constant W_TILES_SELECT	: std_logic_vector	:= "0010"; -- Write only
  constant W_SOFT_RESET		: std_logic_vector	:= "0011"; -- Write only
--		-- Read -- 	
--  constant R_SNAKE1_HEAD	: std_logic_vector	:= "0000"; -- Read only
--  constant R_SNAKE1_TAIL	: std_logic_vector	:= "0001"; -- Read only
--  constant R_SNAKE1_LENGTH	: std_logic_vector	:= "0011"; -- Read only
--  constant R_SNAKE2_HEAD	: std_logic_vector	:= "0100"; -- Read only
--  constant R_SNAKE2_TAIL	: std_logic_vector	:= "0101"; -- Read only
--
begin
  
  reset <= not(reset_n);
  
  --VGA stuff
  
  process (clk)
  begin
    if rising_edge(clk) then
      clk25 <= not clk25;
    end if;
  end process;
  

  -- Memory stuff/ LEDS 
  
  process (clk)
  begin
    if rising_edge(clk) then
		
		snake_enabled <= '0';
		tiles_enabled 	<= '0';
		
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
		
      if reset = '1' or soft_reset = '1' then
			readdata <= (others => '0');
			soft_reset <= '0';
      else
			
			if chipselect = '1' then -- This chip is right one
				
				-- Write --
				if write = '1' then
					
					-- Select snake1 --
					if address = W_SNAKE_SELECT then
						snake_enabled <= '1';		
					end if;
					
					-- Select tiles --
					if address = W_TILES_SELECT then
						tiles_enabled <= '1';
					end if;
					
					if address = W_SOFT_RESET then
						soft_reset <= '1';
					end if;
				
				-- Read --
				elsif read = '1' then
					
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
					
					readdata <= (others => '0');
					
				end if; -- end write/read
				
          end if; -- end chipselect
        end if; --end reset
      end if; --end rising edge
  end process;

  
 
--VGA stuff

V1: entity work.de2_vga_raster port map (
    reset => reset,
    clk => clk25,
    VGA_CLK => VGA_CLK,
    VGA_HS => VGA_HS,
    VGA_VS => VGA_VS,
    VGA_BLANK => VGA_BLANK,
    VGA_SYNC => VGA_SYNC,
    VGA_R => VGA_R,
    VGA_G => VGA_G,
    VGA_B => VGA_B,
	 
	 TILES_IN => tiles,
	 SNAKE_IN => snake
  );

  
  
DD1: entity work.manage_tiles port map(

		clk 					=> clk,
		reset					=> (reset or soft_reset),
		enabled 				=> tiles_enabled,
		data_in 				=> writedata,
		tiles 				=> tiles
);
  
AD1: entity work.add_remove_snake_part port map (

		clk 					=> clk,
		reset					=> (reset or soft_reset),
		enabled 				=> snake_enabled,
		data_in 				=> writedata,
		snake 				=> snake
);


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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions.all;


entity manage_tiles is

	port(
		clk					: in std_logic;
		reset 				: in std_logic;
		enabled				: in std_logic;
		data_in				: in std_logic_vector(31 downto 0);
		tiles					: out tiles_ram
	);


end manage_tiles;

architecture mt of manage_tiles is

signal y_val			: std_logic_vector(9 downto 0); 	-- 10 bits --
signal x_val			: std_logic_vector(9 downto 0); 	-- 10 bits --
signal sprite_select	: std_logic_vector(4 downto 0); 	-- 5 bits ---
signal add_remove		: std_logic;							-- 1 bit  ---

begin


	y_val 			<= 	data_in(9 downto 0);
	x_val 			<= 	data_in(19 downto 10);
	add_remove 		<= 	data_in(25);
	sprite_select 	<= 	data_in(24 downto 20);

	process (clk)
	begin
	if rising_edge(clk) then
	
		-- Reset --
		if reset = '1' then
			tiles <= (others=>(others=>(others=>'0')));
			
		-- Enabled --
		elsif enabled = '1' then
															--1=active	-Unused	-Check definitions file
			tiles( to_integer( unsigned( x_val ) ), 
					 to_integer( unsigned( y_val ) ) ) <= add_remove & "00" & sprite_select;
		end if; -- reset/ enabled
		
		--tiles( 30, 1 ) 	<= '1' & "00" & RABBIT_CODE;
		--tiles( 10, 1 ) 	<= '1' & "00" & MOUSE_CODE;
		--tiles( 15, 20 ) 	<= '1' & "00" & WALL_CODE;

		
	end if; -- rising edge
	end process; -- end clk


end mt;


--
--
--
---------------------------------------------
------------ Add Remove Snake Part ----------
---------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions.all;


entity add_remove_snake_part is

	port(
		clk					: in std_logic;
		reset 				: in std_logic;
		enabled				: in std_logic;
		data_in				: in std_logic_vector(31 downto 0);
		snake 				: buffer tiles_ram
	);

end add_remove_snake_part;

architecture arsp of add_remove_snake_part is

signal y_val			: std_logic_vector(9 downto 0); 	-- 10 bits --
signal x_val			: std_logic_vector(9 downto 0); 	-- 10 bits --
signal sprite_select	: std_logic_vector(4 downto 0); 	-- 5 bits ---
signal add_remove		: std_logic;							-- 1 bit  ---
signal player_select : std_logic;							-- 1 bit  ---

begin


	y_val 			<= 	data_in(9 downto 0);
	x_val 			<= 	data_in(19 downto 10);
	sprite_select 	<= 	data_in(24 downto 20);
	add_remove 		<= 	data_in(25);
	player_select 	<= 	data_in(26);

	process (clk)
	begin
	if rising_edge(clk) then
	
		-- Reset --
		if reset = '1' then
			snake <= (others=>(others=>(others=>'0')));
			
		-- Enabled --
		elsif enabled = '1' then
																--1=active	-Unused		0=player1 	-Check definitions file
			snake( to_integer( unsigned( x_val ) ), 
					 to_integer( unsigned( y_val ) ) ) <= add_remove & "0" & player_select & sprite_select;
		end if; -- reset/ enabled

		
	end if; -- rising edge
	end process; -- end clk

end arsp;






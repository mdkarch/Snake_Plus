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
			-- 0100 = SPLASH SCREEN
--		
--		--WRITEDATA
--			--4-0: Y (LSB) -- must be ONLY 5 bits
--			--10-5: X		-- must be at least 6 bits
			--11-19: unused
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
  -- To/From manage_tiles, add_remove_snake
	signal tiles_write_data				: std_logic_vector(7 downto 0);
	signal snake_write_data				: std_logic_vector(7 downto 0);
	signal tiles_write_address			: std_logic_vector(10 downto 0);
	signal snake_write_address			: std_logic_vector(10 downto 0);
	signal tiles_write_enable			: std_logic		:= '0';
	signal snake_write_enable			: std_logic		:= '0';
	
	-- To/From vga_raster
	signal tiles_read_address			: std_logic_vector(10 downto 0);
	signal snake_read_address			: std_logic_vector(10 downto 0);
	signal tiles_read_data				: std_logic_vector(7 downto 0);
	signal snake_read_data				: std_logic_vector(7 downto 0);
	signal enable_splash_screen		: std_logic := '0';
  
  --Tile signals 
	signal tiles_enabled		: std_logic				:= '0';
	signal snake_enabled		: std_logic				:= '0';
  
  
  -- For VGA
  signal clk25 				: std_logic 			:= '0';
  
	--- Constants ---
		-- Write -- 
  constant W_SNAKE_SELECT					: std_logic_vector	:= "0001"; -- Write only
  constant W_TILES_SELECT					: std_logic_vector	:= "0010"; -- Write only
  constant W_SOFT_RESET						: std_logic_vector	:= "0011"; -- Write only
  constant W_ENABLE_SPLASH_SCREEN		: std_logic_vector	:= "0100"; -- Write only


component tiles_ram is
	port (
		aclr			: IN STD_LOGIC	 := '0';
		clock			: IN STD_LOGIC  := '1';
		data			: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		rdaddress	: IN STD_LOGIC_VECTOR (10 DOWNTO 0);
		wraddress	: IN STD_LOGIC_VECTOR (10 DOWNTO 0);
		wren			: IN STD_LOGIC  := '0';
		q				: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
end component;
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
					
					if address = W_ENABLE_SPLASH_SCREEN then
						enable_splash_screen <= '1';
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
					
					readdata <= "000000000000000000000" & tiles_read_address;
					
				end if; -- end write/read
				
          end if; -- end chipselect
        end if; --end reset
      end if; --end rising edge
  end process;

  
  
  
  	snake_store : tiles_ram port map (
		aclr			=> (reset or soft_reset),
		clock			=> clk,
		data			=> snake_write_data,
		rdaddress	=> snake_read_address,	
		wraddress	=> snake_write_address,
		wren			=> snake_write_enable,
		q				=> snake_read_data
	);
	
	tiles_store : tiles_ram port map (
		aclr			=> (reset or soft_reset),
		clock			=> clk,
		data			=> tiles_write_data,
		rdaddress	=> tiles_read_address,	
		wraddress	=> tiles_write_address,
		wren			=> tiles_write_enable,
		q				=> tiles_read_data
	);
  
 
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
	 
	 tiles_address => tiles_read_address,
	 tiles_data		=> tiles_read_data,
	 snake_address => snake_read_address,
	 snake_data		=> snake_read_data,
	 controller_enable_splash_screen => enable_splash_screen
	 
  );

  
  
DD1: entity work.manage_tiles port map(

		clk 					=> clk,
		reset					=> (reset or soft_reset),
		enabled 				=> tiles_enabled,
		data_in 				=> writedata,
		data_out				=> tiles_write_data,
		address_out			=> tiles_write_address,
		enable_out			=> tiles_write_enable
);
  
AD1: entity work.add_remove_snake_part port map (

		clk 					=> clk,
		reset					=> (reset or soft_reset),
		enabled 				=> snake_enabled,
		data_in 				=> writedata,
		data_out				=> snake_write_data,
		address_out			=> snake_write_address,
		enable_out			=> snake_write_enable
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
		data_out				: out std_logic_vector(7 downto 0);
		address_out			: out std_logic_vector(10 downto 0);
		enable_out			: out std_logic
	);


end manage_tiles;

architecture mt of manage_tiles is

signal y_val			: std_logic_vector(4 downto 0); 	-- 5 bits --
signal x_val			: std_logic_vector(5 downto 0); 	-- 6 bits --
signal sprite_select	: std_logic_vector(4 downto 0); 	-- 5 bits ---
signal add_remove		: std_logic;							-- 1 bit  ---

signal y_32				: std_logic_vector(10 downto 0);
signal y_8				: std_logic_vector(10 downto 0);
signal x_11				: std_logic_vector(10 downto 0);

begin


	y_val 			<= 	data_in(4 downto 0);
	x_val 			<= 	data_in(10 downto 5);
	add_remove 		<= 	data_in(25);
	sprite_select 	<= 	data_in(24 downto 20);
	
	y_32 				<= 	"0" 		& data_in(4 downto 0) & "00000";
	y_8 				<= 	"000" 	& data_in(4 downto 0) & "000";
	x_11 				<= 	"00000" 	& data_in(10 downto 5);

	process (clk)
	begin
	if rising_edge(clk) then
	
		enable_out <= '0';
	
		-- Reset --
		if reset = '1' then
			data_out <= (others => '0');
			address_out <= (others => '0');
			enable_out <= '0';
			
		-- Enabled --
		elsif enabled = '1' then
				data_out <= add_remove & "00" & sprite_select;
				address_out <= std_logic_vector( unsigned(y_32) + unsigned(y_8) + unsigned(x_11) );
				enable_out <= '1';
		end if; -- reset/ enabled
		

		
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
		data_out				: out std_logic_vector(7 downto 0);
		address_out			: out std_logic_vector(10 downto 0);
		enable_out			: out std_logic
	);

end add_remove_snake_part;

architecture arsp of add_remove_snake_part is

signal y_val			: std_logic_vector(4 downto 0); 	-- 5 bits --
signal x_val			: std_logic_vector(5 downto 0); 	-- 6 bits --
signal sprite_select	: std_logic_vector(4 downto 0); 	-- 5 bits ---
signal add_remove		: std_logic;							-- 1 bit  ---
signal player_select : std_logic;							-- 1 bit  ---

signal y_32				: std_logic_vector(10 downto 0);
signal y_8				: std_logic_vector(10 downto 0);
signal x_11				: std_logic_vector(10 downto 0);

begin


	y_val 			<= 	data_in(4 downto 0);
	x_val 			<= 	data_in(10 downto 5);
	sprite_select 	<= 	data_in(24 downto 20);
	add_remove 		<= 	data_in(25);
	player_select 	<= 	data_in(26);
	
	y_32 				<= 	"0" 		& data_in(4 downto 0) & "00000";
	y_8 				<= 	"000" 	& data_in(4 downto 0) & "000";
	x_11 				<= 	"00000" 	& data_in(10 downto 5);
	
	process (clk)
	begin
	if rising_edge(clk) then
	
		enable_out <= '0';
	
		-- Reset --
		if reset = '1' then
			data_out <= (others => '0');
			address_out <= (others => '0');
			enable_out <= '0';
			
		-- Enabled --
		elsif enabled = '1' then
				data_out <= add_remove & "0" & player_select & sprite_select;
				address_out <= std_logic_vector( unsigned(y_32) + unsigned(y_8) + unsigned(x_11) );
				enable_out <= '1';
		end if; -- reset/ enabled

		
	end if; -- rising edge
	end process; -- end clk

end arsp;






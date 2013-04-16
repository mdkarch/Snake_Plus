library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions.all;

-- PROTOCOL:
		-- ADDRESS
			-- 0000 = SNAKE1
			-- 0001 = SNAKE2
			-- 0002 = TILES
		
		--WRITEDATA
			--9-0: Y (LSB)
			--19-10: X
			--24-20: SPRITE SELECT
			--25: 1=ADD, 0=REMOVE
			--26-27: Which segment referring to
			--			00=head, 01=second to head
			--			10=second to tail 11=tail
			--			( only used for snakes, not tiles )
			--28-31: UNUSED (MSB)
			
		--Tiles protocol ( in tiles_ram, from controller to raster)
			-- 8 bits
			-- 4-0: Sprite select
			-- 6-5: unused
			-- 7	: Enabled/Active signal 
			
-- On Add:
-- 	Adding to head or tail, the hardware automatically changes second to head/tail
--		No need to send second change
-- On Remove:
--		Can only happen on tail
--		Must send second change to second to tail, with correct tail
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
    VGA_SYNC : out std_logic;        	-- SYNC
    VGA_R,                           	-- Red[9:0]
    VGA_G,                           	-- Green[9:0]
    VGA_B : out std_logic_vector(9 downto 0); 	-- Blue[9:0]

    leds       : out std_logic_vector(15 downto 0)
    );
  
end snake_plus_vga;

architecture rtl of snake_plus_vga is

	signal reset				: std_logic;

  -- Main memory elements
  signal tiles 				: tiles_ram;
  signal snake1 				: snake_ram;
  signal snake2  				: snake_ram;
  
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
  
  -- Temp signals
  signal readdata_temp		: integer;
  
	--- Constants ---
		-- Write -- 
  constant W_SNAKE1_SELECT	: std_logic_vector	:= "0000"; -- Write only
  constant W_SNAKE2_SELECT	: std_logic_vector	:= "0001"; -- Write only
  constant W_TILES_SELECT	: std_logic_vector	:= "0010"; -- Write only
		-- Read -- 	
  constant R_SNAKE1_HEAD	: std_logic_vector	:= "0000"; -- Read only
  constant R_SNAKE1_TAIL	: std_logic_vector	:= "0001"; -- Read only
  constant R_SNAKE1_LENGTH	: std_logic_vector	:= "0011"; -- Read only
  constant R_SNAKE2_HEAD	: std_logic_vector	:= "0100"; -- Read only
  constant R_SNAKE2_TAIL	: std_logic_vector	:= "0101"; -- Read only

begin
  
  reset <= not(reset_n);
  leds(14) <= reset;
  
  leds(4 downto 0) <= snake1(1)(24 downto 20);
  
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
	 
      if reset = '1' then
			readdata <= (others => '0');
      else
        if chipselect = '1' then -- This chip is right one
		  
				-- Write --
				if write = '1' then
				
					-- Select snake1 --
					if address = W_SNAKE1_SELECT then
						snake1_enabled <= '1';
					else
						snake1_enabled <= '0';
					end if;
						
					-- Select snake2 --
					if address = W_SNAKE2_SELECT then
						snake2_enabled <= '1';
					else
						snake2_enabled <= '0';
					end if;
					
					-- Select tiles --
					if address = W_TILES_SELECT then
						tiles_enabled <= '1';
					else
						tiles_enabled <= '0';
					end if;
					
					leds(10 downto 7) <= address;
				
				-- Read --
				elsif read = '1' then
					
					if address = R_SNAKE1_HEAD then
						readdata_temp <= snake1_head_index;
					elsif address = R_SNAKE1_TAIL then
						readdata_temp <= snake1_tail_index;
					elsif address = R_SNAKE1_LENGTH then
						readdata_temp <= snake1_length;
					elsif address = R_SNAKE2_HEAD then
						readdata_temp <= snake2_head_index;
					elsif address = R_SNAKE1_TAIL then
						readdata_temp <= snake2_head_index;
					elsif address = R_SNAKE1_LENGTH then
						readdata_temp <= snake2_length;
					end if;
					
					
					readdata <= std_logic_vector( to_unsigned( readdata_temp, readdata'length ) );
					
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
	 SNAKE1_IN => snake1,
	 SNAKE2_IN => snake2
  );

  
  
DD1: entity work.manage_tiles port map(

		clk 					=> clk,
		reset					=> reset,
		enabled 				=> tiles_enabled,
		data_in 				=> writedata,
		tiles 				=> tiles
);

  
AD1: entity work.add_remove_snake_part port map (

		clk 					=> clk,
		reset					=> reset,
		enabled 				=> snake1_enabled,
		data_in 				=> writedata,
		snake 				=> snake1,
		head_index_out		=> snake1_head_index,
		tail_index_out		=> snake1_tail_index,
		snake_length_out	=> snake1_length
);

AD2: entity work.add_remove_snake_part port map (

		clk 					=> clk,
		reset					=> reset,
		enabled 				=> snake2_enabled,
		data_in 				=> writedata,
		snake 				=> snake2,
		head_index_out		=> snake2_head_index,
		tail_index_out		=> snake2_tail_index,
		snake_length_out	=> snake2_length
);


end rtl;




-----------------------------------------------------------------------------------------
--------------------------- SUBCOMPONENTS FOR VGA CONTROLLER ----------------------------
-----------------------------------------------------------------------------------------



--------------------------------
----------- Tiles --------------
--------------------------------

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
signal segment			: std_logic_vector(1 downto 0);	-- 2 bits ---
signal unused			: std_logic_vector(3 downto 0);	-- 4 bits ---

signal y_index			: integer;
signal x_index			: integer;

begin

	process (clk)
	begin
	if rising_edge(clk) then
	
		-- Reset --
		if reset = '1' then
			tiles <= (others=>(others=>(others=>'0')));
			
		-- Enabled --
		elsif enabled = '1' then
		
			y_val 			<= 	data_in(9 downto 0);
			x_val 			<= 	data_in(19 downto 10);
			sprite_select 	<= 	data_in(24 downto 20);
			add_remove 		<= 	data_in(25);
			segment			<= 	data_in(27 downto 26);
			unused			<= 	data_in(31 downto 28);
			
			-- Temp signals for conversion purposes
			y_index <= to_integer( unsigned( y_val ) );
			x_index <= to_integer( unsigned( x_val ) );
			
												--1=active	-Unused	-Check definitions file
			tiles( x_index, y_index ) <= add_remove & "00" & sprite_select;
		
		end if; -- reset/ enabled
		
		tiles( 30, 1 ) <= '1' & "00" & RABBIT_CODE;
		tiles( 10, 1 ) <= '1' & "00" & MOUSE_CODE;
		tiles( 15, 20 ) <= '1' & "00" & WALL_CODE;

		
	end if; -- rising edge
	end process; -- end clk


end mt;





-------------------------------------------
---------- Add Remove Snake Part ----------
-------------------------------------------

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
		snake 				: out snake_ram;
		head_index_out		: out integer;
		tail_index_out		: out integer;
		snake_length_out	: out integer
	);

end add_remove_snake_part;

architecture arsp of add_remove_snake_part is

signal y_val			: std_logic_vector(9 downto 0); 	-- 10 bits --
signal x_val			: std_logic_vector(9 downto 0); 	-- 10 bits --
signal sprite_select	: std_logic_vector(4 downto 0); 	-- 5 bits ---
signal add_remove		: std_logic;							-- 1 bit  ---
signal segment			: std_logic_vector(1 downto 0);	-- 2 bits ---
signal unused			: std_logic_vector(3 downto 0);	-- 4 bits ---

signal head_index		: integer		:= 0;
signal tail_index		: integer		:= 0;
signal snake_length	: integer		:= 0;

--Index that new value will assigned to: head, second head, second tail, tail --
signal seg_index		: integer;

begin

	head_index_out <= head_index;
	tail_index_out <= tail_index;
	snake_length_out <= snake_length;

	process (clk)
	begin
	if rising_edge(clk) then
	
		-- Reset --
		if reset = '1' then
			snake <= (others=>(others=>'0'));
		
		-- Only do something if it was directed at this snake	--
		elsif enabled = '1' then

			y_val 			<= 	data_in(9 downto 0);
			x_val 			<= 	data_in(19 downto 10);
			sprite_select 	<= 	data_in(24 downto 20);
			add_remove 		<= 	data_in(25);
			segment			<= 	data_in(27 downto 26);
			unused			<= 	data_in(31 downto 28);
			

			---- Add situation -----
			if add_remove = '1' then
			
				if segment = "00" then
					--Automatically change second to new head
					snake(head_index)(24 downto 20) <= SNAKE_BODY_SELECT;
					--Increment head pointer --
					head_index <= head_index + 1;
					if head_index >= MAX_SNAKE_SIZE - 1 then
						head_index <= 0;
					end if;
					--Increment snake length
					snake_length <= snake_length + 1;
					--Set Index to correct value for later changing
					seg_index <= head_index;
			
			
				elsif segment = "01" then
					seg_index <= head_index - 1;
					if seg_index < 0 then
						seg_index <= MAX_SNAKE_SIZE - 1;
					end if;
					
					
				elsif segment = "10" then
					seg_index <= tail_index + 1;
					if seg_index >= MAX_SNAKE_SIZE - 1 then
						seg_index <= 0;
					end if;
					
					
				elsif segment = "11" then
					--Automatically change old tail to body
					snake(tail_index)(24 downto 20) <= SNAKE_BODY_SELECT;
					tail_index <= tail_index - 1;
					if tail_index < 0 then
						tail_index <= MAX_SNAKE_SIZE - 1;
					end if;
					--Increment snake length
					snake_length <= snake_length + 1;
					--Set Index to correct value for later changing
					seg_index <= tail_index;
					
				end if; -- segments
				
			-- In all cases, set new value to snake(seg_index) --
			snake(seg_index) <= 	unused & segment 
										& add_remove & sprite_select
										& x_val & y_val; 
										
										
			-----------------------------------------
			-- Remove situation --
			elsif add_remove = '0' then 
			
				if segment = "00" or segment = "01" or segment = "10"  then
					-- CANT DO THIS
				elsif segment = "11" then
					snake(tail_index)(25) <= '0';
					tail_index <= tail_index + 1;
					if tail_index > MAX_SNAKE_SIZE - 1 then
						tail_index <= 0;
					end if;
				end if;
					
			end if; --add remove situation
			
		end if; -- end if reset/enabled --
		
		
	snake(1) <=  unused & segment & add_remove & SNAKE_HEAD_RIGHT 
													& "0011111111" & "0011111111";
													
	head_index <= to_integer( unsigned( data_in ) );
		
	end if; -- end rising edge --
	end process;

end arsp;






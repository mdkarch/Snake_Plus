-------------------------------------------------------------------------------
--
-- Simple VGA raster display
--
-- Stephen A. Edwards
-- sedwards@cs.columbia.edu




-- PROTOCOL:
			--9-0: Y (LSB)
			--19-10: X
			--24-20: SPRITE SELECT
			--25: 1=ADD, 0=REMOVE
			--26-27: Which segment referring to
			--			00=head, 01=second to head
			--			10=second to tail 11=tail
			--26-31: UNUSED (MSB)
--
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions.all;

entity de2_vga_raster is
  
  port (
    reset 					: in std_logic;
    clk   					: in std_logic;                    -- Should be 25.125 MHz
	 
	 TILES_IN 				: in tiles_ram;
	 SNAKE1_IN 				: in snake_ram;
	 SNAKE2_IN 				: in snake_ram;

    VGA_CLK,                         				-- Clock
    VGA_HS,                          				-- H_SYNC
    VGA_VS,                          				-- V_SYNC
    VGA_BLANK,                       				-- BLANK
    VGA_SYNC 				: out std_logic;        -- SYNC
    VGA_R,                           				-- Red[9:0]
    VGA_G,                           				-- Green[9:0]
    VGA_B 					: out std_logic_vector(9 downto 0) -- Blue[9:0]
    );

end de2_vga_raster;

architecture rtl of de2_vga_raster is
  
  -- Video parameters
  
  constant HTOTAL       : integer := 800;
  constant HSYNC        : integer := 96;
  constant HBACK_PORCH  : integer := 48;
  constant HACTIVE      : integer := 640;
  constant HFRONT_PORCH : integer := 16;
  
  constant VTOTAL       : integer := 525;
  constant VSYNC        : integer := 2;
  constant VBACK_PORCH  : integer := 33;
  constant VACTIVE      : integer := 480;
  constant VFRONT_PORCH : integer := 10;

  -- Signals for the video controller
  signal Hcount : unsigned(9 downto 0);  -- Horizontal position (0-800)
  signal Vcount : unsigned(9 downto 0);  -- Vertical position (0-524)
  signal EndOfLine, EndOfField : std_logic;

  signal vga_hblank, vga_hsync,
    vga_vblank, vga_vsync : std_logic;  -- Sync. signals

	signal snake1_segment			: integer;
	signal inner_tile_h_pos			: integer;
	signal inner_tile_v_pos			: integer;
	signal tiles_h_pos				: integer;
	signal tiles_v_pos				: integer;
	signal sprite_select				: std_logic_vector(7 downto 0);
	
	
	
	
			-- process signals
	signal green, blue, red, black, tan 										: std_logic;
	signal white, pink, gray, yellow, brown									: std_logic;
	signal snake_head_orange, snake_head_black 								: std_logic;
	signal snake_body_black, snake_body_grey, 
					snake_body_orange, snake_body_white							: std_logic;
	signal snake_turn_black, snake_turn_grey,
					snake_turn_orange, snake_turn_white							: std_logic;
	signal snake_tail_black, snake_tail_orange, snake_tail_yellow		: std_logic;
	signal rabbit_y, rabbit_b, rabbit_w, rabbit_p							: std_logic;
	signal mouse_y, mouse_p, mouse_l, mouse_b_eye, mouse_w_eye			: std_logic;
	signal edwards_t, edwards_br, edwards_bl, edwards_p, ed_b_eye, ed_w_eye	: std_logic;
	signal speed, growth_y, growth_r, freeze									: std_logic;
	signal wall																			: std_logic;
	signal P, one, two, W, I, N, S, exclam										: std_logic;
	signal pause, play																: std_logic;
	
		-- sprites
	type array_type_16x16 is array (0 to 15) of unsigned (0 to 15);
	
-- snake head sprites
	signal sprite_head_right_black 	: array_type_16x16;
	signal sprite_head_right_orange  : array_type_16x16;
	signal sprite_head_left_black 	: array_type_16x16;
	signal sprite_head_left_orange  	: array_type_16x16;
	signal sprite_head_up_black 		: array_type_16x16;
	signal sprite_head_up_orange  	: array_type_16x16;
	signal sprite_head_down_black 	: array_type_16x16;
	signal sprite_head_down_orange  	: array_type_16x16;

	-- snake body colorings
	signal sprite_body_right_black	: array_type_16x16;
	signal sprite_body_right_grey		: array_type_16x16;
	signal sprite_body_right_orange	: array_type_16x16;
	signal sprite_body_right_white	: array_type_16x16;
	signal sprite_body_left_black		: array_type_16x16;
	signal sprite_body_left_grey		: array_type_16x16;
	signal sprite_body_left_orange	: array_type_16x16;
	signal sprite_body_left_white		: array_type_16x16;
	signal sprite_body_up_black		: array_type_16x16;
	signal sprite_body_up_grey			: array_type_16x16;
	signal sprite_body_up_orange		: array_type_16x16;
	signal sprite_body_up_white		: array_type_16x16;
	signal sprite_body_down_black		: array_type_16x16;
	signal sprite_body_down_grey		: array_type_16x16;
	signal sprite_body_down_orange	: array_type_16x16;
	signal sprite_body_down_white		: array_type_16x16;
	
	--snake turn colorings
	signal sprite_turn_up_right_black	: array_type_16x16;
	signal sprite_turn_up_right_grey		: array_type_16x16;
	signal sprite_turn_up_right_orange	: array_type_16x16;
	signal sprite_turn_up_right_white	: array_type_16x16;
	signal sprite_turn_right_down_black	: array_type_16x16;
	signal sprite_turn_right_down_grey	: array_type_16x16;
	signal sprite_turn_right_down_orange: array_type_16x16;
	signal sprite_turn_right_down_white	: array_type_16x16;
	signal sprite_turn_down_left_black	: array_type_16x16;
	signal sprite_turn_down_left_grey	: array_type_16x16;
	signal sprite_turn_down_left_orange	: array_type_16x16;
	signal sprite_turn_down_left_white	: array_type_16x16;
	signal sprite_turn_left_up_black		: array_type_16x16;
	signal sprite_turn_left_up_grey		: array_type_16x16;
	signal sprite_turn_left_up_orange	: array_type_16x16;
	signal sprite_turn_left_up_white		: array_type_16x16;
	
-- snake tail colorings
	signal sprite_tail_right_black	: array_type_16x16;
	signal sprite_tail_right_orange	: array_type_16x16;
	signal sprite_tail_right_yellow	: array_type_16x16;
	signal sprite_tail_left_black		: array_type_16x16;
	signal sprite_tail_left_orange	: array_type_16x16;
	signal sprite_tail_left_yellow	: array_type_16x16;
	signal sprite_tail_up_black		: array_type_16x16;
	signal sprite_tail_up_orange		: array_type_16x16;
	signal sprite_tail_up_yellow		: array_type_16x16;
	signal sprite_tail_down_black		: array_type_16x16;
	signal sprite_tail_down_orange	: array_type_16x16;
	signal sprite_tail_down_yellow	: array_type_16x16;
	
	-- rabbit colorings
	signal sprite_food_rabbit_y	: array_type_16x16;
	signal sprite_food_rabbit_p	: array_type_16x16;
	signal sprite_food_rabbit_b	: array_type_16x16;
	signal sprite_food_rabbit_w	: array_type_16x16;
	
	-- mouse colorings, rabbit eyes can be used for mouse eyes
	signal sprite_food_mouse_y	: array_type_16x16;
	signal sprite_food_mouse_p	: array_type_16x16;
	signal sprite_food_mouse_l	: array_type_16x16;
	
	-- edwards colorings
	signal sprite_food_edwards_n	: array_type_16x16;
	signal sprite_food_edwards_t	: array_type_16x16;
	signal sprite_food_edwards_l	: array_type_16x16;
	signal sprite_food_edwards_p	: array_type_16x16;
	
	-- needle growth coloring
	signal sprite_powup_growth_r	: array_type_16x16;
	signal sprite_powup_growth_y	: array_type_16x16;
	
	-- lightning speed coloring
	signal sprite_powup_speed	: array_type_16x16;
	
	-- ice freeze coloring
	signal sprite_powup_freeze	: array_type_16x16;
	
	-- wall obstacle coloring
	signal sprite_wall			: array_type_16x16;
	
	-- letter colorings
	signal sprite_P				: array_type_16x16;
	signal sprite_1				: array_type_16x16;
	signal sprite_2				: array_type_16x16;
	signal sprite_W				: array_type_16x16;
	signal sprite_I				: array_type_16x16;
	signal sprite_N				: array_type_16x16;
	signal sprite_S				: array_type_16x16;
	signal sprite_exclam			: array_type_16x16;
	
	-- pause and play colorings
	signal sprite_pause			: array_type_16x16;
	signal sprite_play			: array_type_16x16;
	
	
begin
  
    -- Horizontal and vertical counters
  
  HCounter : process (clk)
  begin
    if rising_edge(clk) then      
      if reset = '1' then
        Hcount <= (others => '0');
      elsif EndOfLine = '1' then
        Hcount <= (others => '0');
      else
        Hcount <= Hcount + 1;
      end if;      
    end if;
  end process HCounter;

  EndOfLine <= '1' when Hcount = HTOTAL - 1 else '0';
  
  VCounter: process (clk)
  begin
    if rising_edge(clk) then      
      if reset = '1' then
        Vcount <= (others => '0');
      elsif EndOfLine = '1' then
        if EndOfField = '1' then
          Vcount <= (others => '0');
        else
          Vcount <= Vcount + 1;
        end if;
      end if;
    end if;
  end process VCounter;

  EndOfField <= '1' when Vcount = VTOTAL - 1 else '0';

  -- State machines to generate HSYNC, VSYNC, HBLANK, and VBLANK

  HSyncGen : process (clk)
  begin
    if rising_edge(clk) then     
      if reset = '1' or EndOfLine = '1' then
        vga_hsync <= '1';
      elsif Hcount = HSYNC - 1 then
        vga_hsync <= '0';
      end if;
    end if;
  end process HSyncGen;
  
  HBlankGen : process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        vga_hblank <= '1';
      elsif Hcount = HSYNC + HBACK_PORCH then
        vga_hblank <= '0';
      elsif Hcount = HSYNC + HBACK_PORCH + HACTIVE then
        vga_hblank <= '1';
      end if;      
    end if;
  end process HBlankGen;

  VSyncGen : process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        vga_vsync <= '1';
      elsif EndOfLine ='1' then
        if EndOfField = '1' then
          vga_vsync <= '1';
        elsif Vcount = VSYNC - 1 then
          vga_vsync <= '0';
        end if;
      end if;      
    end if;
  end process VSyncGen;

  VBlankGen : process (clk)
  begin
    if rising_edge(clk) then    
      if reset = '1' then
        vga_vblank <= '1';
      elsif EndOfLine = '1' then
        if Vcount = VSYNC + VBACK_PORCH - 1 then
          vga_vblank <= '0';
        elsif Vcount = VSYNC + VBACK_PORCH + VACTIVE - 1 then
          vga_vblank <= '1';
        end if;
      end if;
    end if;
  end process VBlankGen;
  
  
  
  
  
  ----------------------------------------------------------------------
  ------------- Special Snake_Plus Tile Calculation Logic --------------
  ----------------------------------------------------------------------
  
  InnerTileH : process (clk)
  begin
		if rising_edge(clk) then
			if reset = '1' then
				inner_tile_h_pos <= 0;
				tiles_h_pos <= 0;
			elsif EndOfLine = '1' then
				inner_tile_h_pos <= 0;
				tiles_h_pos <= 0;
			elsif 	HCount >= HSYNC + HBACK_PORCH - 1 and 
						HCount <= HSYNC + HBACK_PORCH + HACTIVE - 1 then
				inner_tile_h_pos <= inner_tile_h_pos + 1;
				if inner_tile_h_pos >= 15 then -- 0-15 should be used
					inner_tile_h_pos <= 0;
					tiles_h_pos <= tiles_h_pos + 1;
				end if;--end inner_tile_h_pos
			end if; -- reset/endofline/hcount
		end if; --end clk
  end process InnerTileH;
  
  
  InnerTileV : process (clk)
  begin
		if rising_edge(clk) then
			if reset = '1' then
				inner_tile_v_pos <= 0;
				tiles_v_pos <= 0;
			elsif EndOfField = '1' then
				inner_tile_v_pos <= 0;
				tiles_v_pos <= 0;
			elsif 	VCount >= VSYNC + VBACK_PORCH - 1 and 
						VCount <= VSYNC + VBACK_PORCH + VACTIVE - 1 and
						EndOfLine = '1' then
				inner_tile_v_pos <= inner_tile_v_pos + 1;
				if inner_tile_v_pos >= 15 then -- 0-15 should be used
					inner_tile_v_pos <= 0;
					tiles_v_pos <= tiles_v_pos + 1;
				end if;--end inner_tile_v_pos
			end if; -- reset/endofline/hcount
		end if; --end clk
  end process InnerTileV;
  
  sprite_select <= TILES_IN(tiles_h_pos,tiles_v_pos);
  
  
  --This is garbage right now
  SpriteSelect : process(clk)
  begin
		if rising_edge(clk) then
			if reset = '1' then
				--sprite_select <= (others => '0');
			else
				
			end if; --reset
		end if; --reset
  end process SpriteSelect;
  
  
  
  ---------------------------------------------------------------
  ------------ End Tile Calculation Logic -----------------------
  ---------------------------------------------------------------
  
  
  
  
  
  
  
  
  
  

  ---------------------------------------------------------------
  ----------- Begin Sprite Display Logic ------------------------
  ---------------------------------------------------------------
  
	FindSnake1: process(clk)
	variable x, y : integer;
	begin
  
  	snake1_segment <= -1;
	for i in MAX_SNAKE_SIZE downto 0 loop
		y := to_integer(UNSIGNED(SNAKE1_IN(i)(9 downto 0)));
		x := to_integer(UNSIGNED(SNAKE1_IN(i)(19 downto 10)));
		
		if (to_integer(Hcount) >= HSYNC + HBACK_PORCH + x) 
			and (to_integer(Hcount) <= HSYNC + HBACK_PORCH + x + SPRITE_LEN) 
			and (to_integer(Vcount) >= VSYNC + VBACK_PORCH + y) 
			and (to_integer(Vcount) <= VSYNC + VBACK_PORCH + y + SPRITE_LEN) then
		
			if(SNAKE1_IN(i)(25) = '1') then
				snake1_segment <= i;
			end if;
		
		end if;
	end loop;
  end process FindSnake1;
  
  
	-- snake sprite head generation
  SnakeSpriteGen : process (clk)
  variable sprite_h_pos, sprite_v_pos : integer;
  variable x, y 	: integer;
  variable orient : std_logic_vector(4 downto 0);
  begin
	if rising_edge(clk) then	
		if reset = '1' then
			snake_head_black 		<= '0';
			snake_head_orange 	<= '0';
			
			snake_body_black 		<= '0';
			snake_body_grey		<= '0';
			snake_body_orange		<= '0';
			snake_body_white		<= '0';
			
			snake_turn_black		<= '0';
			snake_turn_grey		<= '0';
			snake_turn_orange		<= '0';
			snake_turn_white		<= '0';
			
			snake_tail_black 		<= '0';
			snake_tail_orange 	<= '0';
			snake_tail_yellow 	<= '0';
		else
			if snake1_segment /= -1 then
			
					y := to_integer(UNSIGNED(SNAKE1_IN(snake1_segment)(9 downto 0)));
					x := to_integer(UNSIGNED(SNAKE1_IN(snake1_segment)(19 downto 10)));
					orient := SNAKE1_IN(snake1_segment)(24 downto 20);
					
					sprite_h_pos := to_integer(Hcount) - (HSYNC + HBACK_PORCH + x);
					sprite_v_pos := to_integer(Vcount) - (VSYNC + VBACK_PORCH + y);
				 
					-- Snake head color signals
					snake_head_black 		<= '0';
					snake_head_orange 	<= '0';
					
					-- Snake body color signals
					snake_body_black 		<= '0';
					snake_body_grey		<= '0';
					snake_body_orange		<= '0';
					snake_body_white		<= '0';
					
					--Snake body turn
					snake_turn_black		<= '0';
					snake_turn_grey		<= '0';
					snake_turn_orange		<= '0';
					snake_turn_white		<= '0';
					
					-- Snake tail color signals
					snake_tail_black 		<= '0';
					snake_tail_orange 	<= '0';
					snake_tail_yellow 	<= '0';
					
					-- HEAD ORIENTATIONS
					if orient = SNAKE_HEAD_RIGHT then 
						 if sprite_head_right_black(sprite_v_pos)(sprite_h_pos) = '1' then
							snake_head_black <= '1';
						 elsif sprite_head_right_orange(sprite_v_pos)(sprite_h_pos) = '1' then
							snake_head_orange <= '1';
						 end if; -- end sprite snake head
						 
					elsif orient = SNAKE_HEAD_LEFT then
							if sprite_head_left_black(sprite_v_pos)(sprite_h_pos) = '1' then
								snake_head_black <= '1';
							elsif sprite_head_left_orange(sprite_v_pos)(sprite_h_pos) = '1' then
								snake_head_orange <= '1';
						 end if; -- end sprite snake head
						
					elsif orient = SNAKE_HEAD_UP then
							if sprite_head_up_black(sprite_v_pos)(sprite_h_pos) = '1' then
								snake_head_black <= '1';
							elsif sprite_head_up_orange(sprite_v_pos)(sprite_h_pos) = '1' then
								snake_head_orange <= '1';
						 end if; -- end sprite snake head					
						
					elsif orient = SNAKE_HEAD_DOWN then
							if sprite_head_down_black(sprite_v_pos)(sprite_h_pos) = '1' then
								snake_head_black <= '1';
							elsif sprite_head_down_orange(sprite_v_pos)(sprite_h_pos) = '1' then
								snake_head_orange <= '1';
						 end if; -- end sprite snake head	
							
					
					--BODY ORIENTATIONS
					elsif orient = SNAKE_BODY_RIGHT then 
						  if sprite_body_right_black(sprite_v_pos)(sprite_h_pos) = '1' then
								snake_body_black <= '1';
							elsif sprite_body_right_grey(sprite_v_pos)(sprite_h_pos) = '1' then
								snake_body_grey <= '1';
							elsif sprite_body_right_orange(sprite_v_pos)(sprite_h_pos) = '1' then
								snake_body_orange <= '1';
							elsif sprite_body_right_white(sprite_v_pos)(sprite_h_pos) = '1' then
								snake_body_white <= '1';
						 end if; -- end sprite snake tail
						 
					elsif orient = SNAKE_BODY_LEFT then 
						  if sprite_body_left_black(sprite_v_pos)(sprite_h_pos) = '1' then
								snake_body_black <= '1';
							elsif sprite_body_left_grey(sprite_v_pos)(sprite_h_pos) = '1' then
								snake_body_grey <= '1';
							elsif sprite_body_left_orange(sprite_v_pos)(sprite_h_pos) = '1' then
								snake_body_orange <= '1';
							elsif sprite_body_left_white(sprite_v_pos)(sprite_h_pos) = '1' then
								snake_body_white <= '1';
						 end if; -- end sprite snake tail
					
					elsif orient = SNAKE_BODY_UP then 
						  if sprite_body_up_black(sprite_v_pos)(sprite_h_pos) = '1' then
								snake_body_black <= '1';
							elsif sprite_body_up_grey(sprite_v_pos)(sprite_h_pos) = '1' then
								snake_body_grey <= '1';
							elsif sprite_body_up_orange(sprite_v_pos)(sprite_h_pos) = '1' then
								snake_body_orange <= '1';
							elsif sprite_body_up_white(sprite_v_pos)(sprite_h_pos) = '1' then
								snake_body_white <= '1';
						 end if; -- end sprite snake tail
					
					elsif orient = SNAKE_BODY_DOWN then 
						  if sprite_body_down_black(sprite_v_pos)(sprite_h_pos) = '1' then
								snake_body_black <= '1';
							elsif sprite_body_down_grey(sprite_v_pos)(sprite_h_pos) = '1' then
								snake_body_grey <= '1';
							elsif sprite_body_down_orange(sprite_v_pos)(sprite_h_pos) = '1' then
								snake_body_orange <= '1';
							elsif sprite_body_down_white(sprite_v_pos)(sprite_h_pos) = '1' then
								snake_body_white <= '1';
						 end if; -- end sprite snake tail
					
					
					
					--TURN ORIENTATIONS
					elsif orient = SNAKE_TURN_UP_RIGHT then 
						  if sprite_turn_up_right_black(sprite_v_pos)(sprite_h_pos) = '1' then
								snake_turn_black <= '1';
							elsif sprite_turn_up_right_grey(sprite_v_pos)(sprite_h_pos) = '1' then
								snake_turn_grey <= '1';
							elsif sprite_turn_up_right_orange(sprite_v_pos)(sprite_h_pos) = '1' then
								snake_turn_orange <= '1';
							elsif sprite_turn_up_right_white(sprite_v_pos)(sprite_h_pos) = '1' then
								snake_body_white <= '1';
						 end if; -- end sprite snake tail
						 
					elsif orient = SNAKE_TURN_RIGHT_DOWN then 
						  if sprite_turn_right_down_black(sprite_v_pos)(sprite_h_pos) = '1' then
								snake_turn_black <= '1';
							elsif sprite_turn_right_down_grey(sprite_v_pos)(sprite_h_pos) = '1' then
								snake_turn_grey <= '1';
							elsif sprite_turn_right_down_orange(sprite_v_pos)(sprite_h_pos) = '1' then
								snake_turn_orange <= '1';
							elsif sprite_turn_right_down_white(sprite_v_pos)(sprite_h_pos) = '1' then
								snake_body_white <= '1';
						 end if; -- end sprite snake tail
					
					elsif orient = SNAKE_TURN_DOWN_LEFT then 
						  if sprite_turn_down_left_black(sprite_v_pos)(sprite_h_pos) = '1' then
								snake_turn_black <= '1';
							elsif sprite_turn_down_left_grey(sprite_v_pos)(sprite_h_pos) = '1' then
								snake_turn_grey <= '1';
							elsif sprite_turn_down_left_orange(sprite_v_pos)(sprite_h_pos) = '1' then
								snake_turn_orange <= '1';
							elsif sprite_turn_down_left_white(sprite_v_pos)(sprite_h_pos) = '1' then
								snake_body_white <= '1';
						 end if; -- end sprite snake tail
					
					elsif orient = SNAKE_TURN_LEFT_UP then 
						  if sprite_turn_left_up_black(sprite_v_pos)(sprite_h_pos) = '1' then
								snake_turn_black <= '1';
							elsif sprite_turn_left_up_grey(sprite_v_pos)(sprite_h_pos) = '1' then
								snake_turn_grey <= '1';
							elsif sprite_turn_left_up_orange(sprite_v_pos)(sprite_h_pos) = '1' then
								snake_turn_orange <= '1';
							elsif sprite_turn_left_up_white(sprite_v_pos)(sprite_h_pos) = '1' then
								snake_body_white <= '1';
						 end if; -- end sprite snake tail
					
					
					
					--TAIL ORIENTATIONS
					-- Right orientation for snake tail
					elsif orient = SNAKE_TAIL_RIGHT then 
						 if sprite_tail_right_black(sprite_v_pos)(sprite_h_pos) = '1' then
							snake_tail_black <= '1';
						 elsif sprite_tail_right_orange(sprite_v_pos)(sprite_h_pos) = '1' then
							snake_tail_orange <= '1';
						 elsif sprite_tail_right_yellow(sprite_v_pos)(sprite_h_pos) = '1' then
							snake_tail_yellow <= '1';
						 end if; -- end sprite snake tail
						 
					elsif orient = SNAKE_TAIL_LEFT then
						 if sprite_tail_left_black(sprite_v_pos)(sprite_h_pos) = '1' then
							snake_tail_black <= '1';
						 elsif sprite_tail_left_orange(sprite_v_pos)(sprite_h_pos) = '1' then
							snake_tail_orange <= '1';
						 elsif sprite_tail_left_yellow(sprite_v_pos)(sprite_h_pos) = '1' then
							snake_tail_yellow <= '1';
						 end if; -- end sprite snake tail
					
					elsif orient = SNAKE_TAIL_UP then
						 if sprite_tail_up_black(sprite_v_pos)(sprite_h_pos) = '1' then
							snake_tail_black <= '1';
						 elsif sprite_tail_up_orange(sprite_v_pos)(sprite_h_pos) = '1' then
							snake_tail_orange <= '1';
						 elsif sprite_tail_up_yellow(sprite_v_pos)(sprite_h_pos) = '1' then
							snake_tail_yellow <= '1';
						 end if; -- end sprite snake tail
					
					elsif orient = SNAKE_TAIL_DOWN then
						 if sprite_tail_down_black(sprite_v_pos)(sprite_h_pos) = '1' then
							snake_tail_black <= '1';
						 elsif sprite_tail_down_orange(sprite_v_pos)(sprite_h_pos) = '1' then
							snake_tail_orange <= '1';
						 elsif sprite_tail_down_yellow(sprite_v_pos)(sprite_h_pos) = '1' then
							snake_tail_yellow <= '1';
						 end if; -- end sprite snake tail
					end if; -- orient


			else
				snake_head_black 		<= '0';
				snake_head_orange 	<= '0';
				snake_body_black 		<= '0';
				snake_body_grey		<= '0';
				snake_body_orange		<= '0';
				snake_body_white		<= '0';
				snake_turn_black		<= '0';
				snake_turn_grey		<= '0';
				snake_turn_orange		<= '0';
				snake_turn_white		<= '0';
				snake_tail_black 		<= '0';
				snake_tail_orange 	<= '0';
				snake_tail_yellow 	<= '0';
			end if;
		end if;
	end if;		
  end process SnakeSpriteGen;
  
  
 
 
   -- rabbit sprite generation
  RabbitSpriteGen : process (clk)
  variable sprite_h_pos, sprite_v_pos : integer;
  begin
	if rising_edge(clk) then	
		if reset = '1' then
			rabbit_y <= '0';
			rabbit_b <= '0';
			rabbit_w <= '0';
			rabbit_p <= '0';
			
		elsif sprite_select(7) = '1' and sprite_select(4 downto 0) = RABBIT_CODE then
		
			sprite_h_pos := inner_tile_h_pos; 
			sprite_v_pos := inner_tile_v_pos;
			 
			rabbit_y <= '0';
			rabbit_b <= '0';
			rabbit_w <= '0';
			rabbit_p <= '0';
			 
			if sprite_food_rabbit_y(sprite_v_pos)(sprite_h_pos) = '1' then
				rabbit_y <= '1';
			elsif sprite_food_rabbit_b(sprite_v_pos)(sprite_h_pos) = '1' then
				rabbit_b <= '1';
			elsif sprite_food_rabbit_p(sprite_v_pos)(sprite_h_pos) = '1' then
				rabbit_p <= '1';
			elsif sprite_food_rabbit_w(sprite_v_pos)(sprite_h_pos) = '1' then
				rabbit_w <= '1';
			end if;
		else
			rabbit_y <= '0';
			rabbit_p <= '0';
			rabbit_w <= '0';
			rabbit_b <= '0';
		end if;
	end if;		
  end process RabbitSpriteGen;
  
  -- mouse sprite generation
  MouseSpriteGen : process (clk)
  variable sprite_h_pos, sprite_v_pos : integer;
  begin
	if rising_edge(clk) then	
		if reset = '1' then
			mouse_y <= '0';
			mouse_l <= '0';
			mouse_p <= '0';
			mouse_b_eye <= '0';
			mouse_w_eye <= '0';
		elsif sprite_select(7) = '1' and sprite_select(4 downto 0) = MOUSE_CODE  then
		
			sprite_h_pos := inner_tile_h_pos; 
			sprite_v_pos := inner_tile_v_pos;
			
			mouse_y <= '0';
			mouse_l <= '0';
			mouse_p <= '0';
			mouse_b_eye <= '0';
			mouse_w_eye <= '0';
			
			if sprite_food_mouse_y(sprite_v_pos)(sprite_h_pos) = '1' then
				mouse_y <= '1';
			elsif sprite_food_mouse_l(sprite_v_pos)(sprite_h_pos) = '1' then
				mouse_l <= '1';
			elsif sprite_food_mouse_p(sprite_v_pos)(sprite_h_pos) = '1' then
				mouse_p <= '1';
			elsif sprite_food_rabbit_b(sprite_v_pos)(sprite_h_pos) = '1' then
				mouse_b_eye <= '1';
			elsif sprite_food_rabbit_w(sprite_v_pos)(sprite_h_pos) = '1' then
				mouse_w_eye <= '1';
			end if;
		else
			mouse_y <= '0';
			mouse_l <= '0';
			mouse_p <= '0';
			mouse_b_eye <= '0';
			mouse_w_eye <= '0';
		end if; --
	end if;		
  end process MouseSpriteGen;
  
  -- edwards sprite generation
  EdwardsSpriteGen : process (clk)
  variable sprite_h_pos, sprite_v_pos : integer;
  begin
	if rising_edge(clk) then	
		if reset = '1' then
			edwards_t <= '0';
			edwards_bl <= '0';
			edwards_br <= '0';
			edwards_p <= '0';
			ed_w_eye <= '0';
			ed_b_eye <= '0';
		elsif sprite_select(7) = '1' and sprite_select(4 downto 0) = EDWARDS_CODE then
				
				sprite_h_pos := inner_tile_h_pos; 
				sprite_v_pos := inner_tile_v_pos;
				
				edwards_t <= '0';
				edwards_bl <= '0';
				edwards_br <= '0';
				edwards_p <= '0';
				ed_w_eye <= '0';
				ed_b_eye <= '0';
				
			 if sprite_food_edwards_t(sprite_v_pos)(sprite_h_pos) = '1' then
				edwards_t <= '1';
			 elsif sprite_food_edwards_l(sprite_v_pos)(sprite_h_pos) = '1' then
				edwards_bl <= '1';
			 elsif sprite_food_edwards_n(sprite_v_pos)(sprite_h_pos) = '1' then
				edwards_br <= '1';
			 elsif sprite_food_edwards_p(sprite_v_pos)(sprite_h_pos) = '1' then
				edwards_p <= '1';
			elsif sprite_food_rabbit_w(sprite_v_pos)(sprite_h_pos) = '1' then
				ed_w_eye <= '1';
			elsif sprite_food_rabbit_b(sprite_v_pos)(sprite_h_pos) = '1' then
				ed_b_eye <= '1';
			end if;
		else
			edwards_t <= '0';
			edwards_bl <= '0';
			edwards_br <= '0';
			edwards_p <= '0';
			ed_w_eye <= '0';
			ed_b_eye <= '0';
		end if;
	end if;		
  end process EdwardsSpriteGen;
  
  
     -- brick wall sprite generation
	BrickWallSpriteGen : process (clk)
	  variable sprite_h_pos, sprite_v_pos : integer;
	  begin
		if rising_edge(clk) then	
			if reset = '1' then
				wall <= '0';
			elsif sprite_select(7) = '1' and sprite_select(4 downto 0) = WALL_CODE then
			
				sprite_h_pos := inner_tile_h_pos; 
				sprite_v_pos := inner_tile_v_pos;
				 
				 if sprite_wall(sprite_v_pos)(sprite_h_pos) = '1' then
					wall <= '1';
				 else
					wall <= '0';
				 end if;
			else
				wall <= '0';
			end if;
		end if;		
  end process BrickWallSpriteGen;
  
   -- speed powerup sprite generation
	SpeedSpriteGen : process (clk)
	  variable sprite_h_pos, sprite_v_pos : integer;
	  begin
		if rising_edge(clk) then	
			if reset = '1' then
				speed <= '0';
			elsif sprite_select(7) = '1' and sprite_select(4 downto 0) = SPEED_CODE then
					sprite_h_pos := inner_tile_h_pos; 
					sprite_v_pos := inner_tile_v_pos;
				 if sprite_powup_speed(sprite_v_pos)(sprite_h_pos) = '1' then
					speed <= '1';
				 else
					speed <= '0';
				 end if;
			else
				speed <= '0';
			end if;
		end if;		
  end process SpeedSpriteGen;
  
   -- freeze powerup sprite generation
	FreezeSpriteGen : process (clk)
	  variable sprite_h_pos, sprite_v_pos : integer;
	  begin
		if rising_edge(clk) then	
			if reset = '1' then
				freeze <= '0';
			elsif sprite_select(7) = '1' and sprite_select(4 downto 0) = FREEZE_CODE  then
					sprite_h_pos := inner_tile_h_pos; 
					sprite_v_pos := inner_tile_v_pos;
				 if sprite_powup_freeze(sprite_v_pos)(sprite_h_pos) = '1' then
					freeze <= '1';
				 else
					freeze <= '0';
				 end if;
			else
				freeze <= '0';
			end if;
		end if;		
  end process FreezeSpriteGen;
	
	
  -- growth power up generation
  GrowthSpriteGen : process (clk)
  variable sprite_h_pos, sprite_v_pos : integer;
  begin
	if rising_edge(clk) then	
		if reset = '1' then
			growth_y <= '0';
			growth_r <= '0';
		elsif sprite_select(7) = '1' and sprite_select(4 downto 0) = GROWTH_CODE then
				
				sprite_h_pos := inner_tile_h_pos; 
				sprite_v_pos := inner_tile_v_pos;
				
				growth_y <= '0';
				growth_r <= '0';
				
			 if sprite_powup_growth_y(sprite_v_pos)(sprite_h_pos) = '1' then
				growth_y <= '1';
			 elsif sprite_powup_growth_r(sprite_v_pos)(sprite_h_pos) = '1' then
				growth_r <= '1';
			 else
				growth_y <= '0';
				growth_r <= '0';
			 end if;
		else
			growth_y <= '0';
			growth_r <= '0';
		end if;
	end if;		
  end process GrowthSpriteGen;
  
  
  	-- Number 1 generation
	Number1Gen : process (clk)
	  variable sprite_h_pos, sprite_v_pos : integer;
	  begin
		if rising_edge(clk) then	
			if reset = '1' then
				one <= '0';
			elsif sprite_select(7) = '1' and sprite_select(4 downto 0) = ONE_CODE then
			
					sprite_h_pos := inner_tile_h_pos; 
					sprite_v_pos := inner_tile_v_pos;
				
				 if sprite_1(sprite_v_pos)(sprite_h_pos) = '1' then
					one <= '1';
				 else
					one <= '0';
				 end if;
			else
				one <= '0';
			end if;
		end if;		
  end process Number1Gen;
  
   -- Number 2 generation
	Number2Gen : process (clk)
	  variable sprite_h_pos, sprite_v_pos : integer;
	  begin
		if rising_edge(clk) then	
			if reset = '1' then
				two <= '0';
			elsif sprite_select(7) = '1' and sprite_select(4 downto 0) = TWO_CODE then
				 
					sprite_h_pos := inner_tile_h_pos; 
					sprite_v_pos := inner_tile_v_pos;
					
				 if sprite_2(sprite_v_pos)(sprite_h_pos) = '1' then
					two <= '1';
				 else
					two <= '0';
				 end if;
			else
				two <= '0';
			end if;
		end if;		
  end process Number2Gen;
  
  	-- letter P generation
	LetterPGen : process (clk)
	  variable sprite_h_pos, sprite_v_pos : integer;
	  begin
		if rising_edge(clk) then	
			if reset = '1' then
				P <= '0';
			elsif sprite_select(7) = '1' and sprite_select(4 downto 0) = P_CODE then
			
					sprite_h_pos := inner_tile_h_pos; 
					sprite_v_pos := inner_tile_v_pos;
					
				 if sprite_P(sprite_v_pos)(sprite_h_pos) = '1' then
					P <= '1';
				 else
					P <= '0';
				 end if;
			else
				P <= '0';
			end if;
		end if;		
  end process LetterPGen;
  
   -- Letter W generation
	LetterWGen : process (clk)
	  variable sprite_h_pos, sprite_v_pos : integer;
	  begin
		if rising_edge(clk) then	
			if reset = '1' then
				W <= '0';
			elsif sprite_select(7) = '1' and sprite_select(4 downto 0) = W_CODE then
				 
					sprite_h_pos := inner_tile_h_pos; 
					sprite_v_pos := inner_tile_v_pos;
					
				 if sprite_W(sprite_v_pos)(sprite_h_pos) = '1' then
					W <= '1';
				 else
					W <= '0';
				 end if;
			else
				W <= '0';
			end if;
		end if;		
  end process LetterWGen;
  
   -- Letter I generation
	LetterIGen : process (clk)
	  variable sprite_h_pos, sprite_v_pos : integer;
	  begin
		if rising_edge(clk) then	
			if reset = '1' then
				I <= '0';
			elsif sprite_select(7) = '1' and sprite_select(4 downto 0) = I_CODE then
				 
					sprite_h_pos := inner_tile_h_pos; 
					sprite_v_pos := inner_tile_v_pos;
					
				 if sprite_I(sprite_v_pos)(sprite_h_pos) = '1' then
					I <= '1';
				 else
					I <= '0';
				 end if;
			else
				I <= '0';
			end if;
		end if;		
  end process LetterIGen;
  
   -- Letter N generation
	LetterNGen : process (clk)
	  variable sprite_h_pos, sprite_v_pos : integer;
	  begin
		if rising_edge(clk) then	
			if reset = '1' then
				N <= '0';
			elsif sprite_select(7) = '1' and sprite_select(4 downto 0) = N_CODE then
				 
					sprite_h_pos := inner_tile_h_pos; 
					sprite_v_pos := inner_tile_v_pos;
					
				 if sprite_N(sprite_v_pos)(sprite_h_pos) = '1' then
					N <= '1';
				 else
					N <= '0';
				 end if;
			else
				N <= '0';
			end if;
		end if;		
  end process LetterNGen;
  
   -- Letter S generation
	LetterSGen : process (clk)
	  variable sprite_h_pos, sprite_v_pos : integer;
	  begin
		if rising_edge(clk) then	
			if reset = '1' then
				S <= '0';
			elsif sprite_select(7) = '1' and sprite_select(4 downto 0) = S_CODE then
				 
					sprite_h_pos := inner_tile_h_pos; 
					sprite_v_pos := inner_tile_v_pos;
					
				 if sprite_S(sprite_v_pos)(sprite_h_pos) = '1' then
					S <= '1';
				 else
					S <= '0';
				 end if;
			else
				S <= '0';
			end if;
		end if;		
  end process LetterSGen;
  
   -- Exclamation point generation
	ExclamGen : process (clk)
	  variable sprite_h_pos, sprite_v_pos : integer;
	  begin
		if rising_edge(clk) then	
			if reset = '1' then
				exclam <= '0';
			elsif sprite_select(7) = '1' and sprite_select(4 downto 0) = EXC_CODE then
				 
					sprite_h_pos := inner_tile_h_pos; 
					sprite_v_pos := inner_tile_v_pos;
					
				 if sprite_exclam(sprite_v_pos)(sprite_h_pos) = '1' then
					exclam <= '1';
				 else
					exclam <= '0';
				 end if;
			else
				exclam <= '0';
			end if;
		end if;		
  end process ExclamGen;
  
   -- Play button sprite generation
	PlayButtonSpriteGen : process (clk)
	  variable sprite_h_pos, sprite_v_pos : integer;
	  begin
		if rising_edge(clk) then	
			if reset = '1' then
				play <= '0';
			elsif sprite_select(7) = '1' and sprite_select(4 downto 0) = PLAY_CODE then
				 
					sprite_h_pos := inner_tile_h_pos; 
					sprite_v_pos := inner_tile_v_pos;
					
				 if sprite_play(sprite_v_pos)(sprite_h_pos) = '1' then
					play <= '1';
				 else
					play <= '0';
				 end if;
			else
				play <= '0';
			end if;
		end if;		
  end process PlayButtonSpriteGen;
  
   -- Pause button sprite generation
	PauseButtonSpriteGen : process (clk)
	  variable sprite_h_pos, sprite_v_pos : integer;
	  begin
		if rising_edge(clk) then	
			if reset = '1' then
				pause <= '0';
			elsif sprite_select(7) = '1' and sprite_select(4 downto 0) = PAUSE_CODE then
				 
					sprite_h_pos := inner_tile_h_pos; 
					sprite_v_pos := inner_tile_v_pos;
					
				 if sprite_pause(sprite_v_pos)(sprite_h_pos) = '1' then
					pause <= '1';
				 else
					pause <= '0';
				 end if;
			else
				pause <= '0';
			end if;
		end if;		
  end process PauseButtonSpriteGen;
  
	
  -- Registered video signals going to the video DAC
  VideoOut: process (clk, reset)
  begin
    if reset = '1' then
      VGA_R <= "0000000000";
      VGA_G <= "0000000000";
      VGA_B <= "0000000000";
    elsif clk'event and clk = '1' then
		if blue = '1' or rabbit_b = '1'  or freeze = '1' 
							or mouse_b_eye = '1' then
		  VGA_R <= "0011100000";
		  VGA_G <= "0010100000";
		  VGA_B <= "1111111111";
		 
		--This got changed to orange, was green, now its orange
		elsif green = '1' or snake_body_orange = '1' or snake_head_orange = '1' or snake_turn_orange = '1'
								or snake_tail_orange = '1' or ed_b_eye = '1' then
		  VGA_R <= "1111111111";
		  VGA_G <= "0010100000";
		  VGA_B <= "0000000000";
		elsif red = '1' or wall = '1' 
								or growth_r = '1' then
		  VGA_R <= "1111111111";
		  VGA_G <= "0000000000";
		  VGA_B <= "0000000000";
		elsif black = '1' or snake_head_black = '1' or snake_tail_black = '1' or snake_body_black ='1' 
								or snake_turn_black = '1' or mouse_l = '1' or edwards_bl = '1' then
		  VGA_R <= "0000000000";
		  VGA_G <= "0000000000";
		  VGA_B <= "0000000000";
		elsif white = '1' or rabbit_w = '1' or snake_body_white = '1' or snake_turn_white = '1'
								or one = '1' or P = '1' or two = '1' 
								or I = '1' or N = '1' or S = '1' 
								or exclam = '1' or pause = '1' or ed_w_eye = '1'
								or play = '1'  or W = '1' or mouse_w_eye = '1' then
		  VGA_R <= "1111111111";
		  VGA_G <= "1111111111";
		  VGA_B <= "1111111111";
		elsif pink = '1' or rabbit_p = '1' or mouse_p = '1' 
								or edwards_p = '1' then
		  VGA_R <= "1111111111";
		  VGA_G <= "0110000000";
		  VGA_B <= "0110100000";
		elsif gray = '1'  or snake_body_grey = '1' or snake_turn_grey = '1' or rabbit_y = '1' or growth_y = '1'  
								or mouse_y = '1' then
		  VGA_R <= "1100000000";
		  VGA_G <= "1100000000";
		  VGA_B <= "1100000000";
		elsif yellow = '1' or speed = '1' or snake_tail_yellow = '1' then
		  VGA_R <= "1111111111";
		  VGA_G <= "1111111111";
		  VGA_B <= "0000000000";
		elsif brown = '1' or edwards_br = '1' then
		  VGA_R <= "0100001001";
		  VGA_G <= "0010000100";
		  VGA_B <= "0000010011";
		elsif tan = '1' or edwards_t = '1' then
		  VGA_R <= "0011111111";
		  VGA_G <= "0011101111";
		  VGA_B <= "0011010101";
      elsif vga_hblank = '0' and vga_vblank ='0' then -- blue background
        VGA_R <= "0000000000";
        VGA_G <= "0000000000";
        VGA_B <= "0000000000";
      else -- black
        VGA_R <= "0000000000";
        VGA_G <= "0000000000";
        VGA_B <= "0000000000";    
      end if;
    end if;
  end process VideoOut;

  VGA_CLK <= clk;
  VGA_HS <= not vga_hsync;
  VGA_VS <= not vga_vsync;
  VGA_SYNC <= '0';
  VGA_BLANK <= not (vga_hsync or vga_vsync);


  
  
  
  -- Sprite Definitions

  --Snake head
sprite_head_down_black(0)			<=      "1000000000111000";
sprite_head_down_black(1)			<=      "1000000000001100";
sprite_head_down_black(2)			<=      "1000000000001000";
sprite_head_down_black(3)			<=      "1000000000001000";
sprite_head_down_black(4)			<=      "1000000001001110";
sprite_head_down_black(5)			<=      "1000000000101110";
sprite_head_down_black(6)			<=      "1000001000110000";
sprite_head_down_black(7)			<=      "0100001000111011";
sprite_head_down_black(8)			<=      "0100001000011111";
sprite_head_down_black(9)			<=      "0000001000011101";
sprite_head_down_black(10)			<=      "0010010000001001";
sprite_head_down_black(11)			<=      "0001000000001101";
sprite_head_down_black(12)			<=      "0000010000100100";
sprite_head_down_black(13)			<=      "0000001000000100";
sprite_head_down_black(14)			<=      "0000000010001000";
sprite_head_down_black(15)			<=      "0000000000000000";

sprite_head_down_orange(0)			<=      "0111111111000100";
sprite_head_down_orange(1)			<=      "0111111111110000";
sprite_head_down_orange(2)			<=      "0111111111110100";
sprite_head_down_orange(3)			<=      "0111111111110100";
sprite_head_down_orange(4)			<=      "0111111110110000";
sprite_head_down_orange(5)			<=      "0111111111010000";
sprite_head_down_orange(6)			<=      "0111110111001110";
sprite_head_down_orange(7)			<=      "0011110111000100";
sprite_head_down_orange(8)			<=      "0011110111100000";
sprite_head_down_orange(9)			<=      "0011110111100010";
sprite_head_down_orange(10)		<=      "0001101111110010";
sprite_head_down_orange(11)		<=      "0000111111110010";
sprite_head_down_orange(12)		<=      "0000001111011010";
sprite_head_down_orange(13)		<=      "0000000111111000";
sprite_head_down_orange(14)		<=      "0000000001110000";
sprite_head_down_orange(15)		<=      "0000000000000000";


sprite_head_right_black(0)			<=      "1111111000000000";
sprite_head_right_black(1)			<=      "0000000110000000";
sprite_head_right_black(2)			<=      "0000000000100000";
sprite_head_right_black(3)			<=      "0000000000010000";
sprite_head_right_black(4)			<=      "0000000000000000";
sprite_head_right_black(5)			<=      "0000000000101000";
sprite_head_right_black(6)			<=      "0000001111000100";
sprite_head_right_black(7)			<=      "0000000000000000";
sprite_head_right_black(8)			<=      "0000000000000010";
sprite_head_right_black(9)			<=      "0000100000000000";
sprite_head_right_black(10)		<=      "1000011100001000";
sprite_head_right_black(11)		<=      "1000001111000000";
sprite_head_right_black(12)		<=      "1111110111110010";
sprite_head_right_black(13)		<=      "0100110011011100";
sprite_head_right_black(14)		<=      "0000110110000000";
sprite_head_right_black(15)		<=      "0000000111110000";	

sprite_head_right_orange(0)		<=      "0000000000000000";
sprite_head_right_orange(1)		<=      "1111111000000000";
sprite_head_right_orange(2)		<=      "1111111111000000";
sprite_head_right_orange(3)		<=      "1111111111100000";
sprite_head_right_orange(4)		<=      "1111111111110000";
sprite_head_right_orange(5)		<=      "1111111111010000";
sprite_head_right_orange(6)		<=      "1111110000111000";
sprite_head_right_orange(7)		<=      "1111111111111100";
sprite_head_right_orange(8)		<=      "1111111111111100";
sprite_head_right_orange(9)		<=      "1111011111111110";
sprite_head_right_orange(10)		<=      "0111100011110110";
sprite_head_right_orange(11)		<=      "0111110000111110";
sprite_head_right_orange(12)		<=      "0000001000001100";
sprite_head_right_orange(13)		<=      "1011001100000000";
sprite_head_right_orange(14)		<=      "0000001001111000";
sprite_head_right_orange(15)		<=      "0000000000000000";

sprite_head_up_black(0)				<=      "0000000000000000";
sprite_head_up_black(1)				<=      "0000000010001000";
sprite_head_up_black(2)				<=      "0000001000000100";
sprite_head_up_black(3)				<=      "0000010000100100";
sprite_head_up_black(4)				<=      "0001000000001101";
sprite_head_up_black(5)				<=      "0010010000001001";
sprite_head_up_black(6)				<=      "0000001000011101";
sprite_head_up_black(7)				<=      "0100001000011111";
sprite_head_up_black(8)				<=      "0100001000111011";
sprite_head_up_black(9)				<=      "1000001000110000";
sprite_head_up_black(10)			<=      "1000000000101110";
sprite_head_up_black(11)			<=      "1000000001001110";
sprite_head_up_black(12)			<=      "1000000000001000";
sprite_head_up_black(13)			<=      "1000000000001000";
sprite_head_up_black(14)			<=      "1000000000001100";
sprite_head_up_black(15)			<=      "1000000000111000";

sprite_head_up_orange(0)			<=      "0000000000000000";
sprite_head_up_orange(1)			<=      "0000000001110000";
sprite_head_up_orange(2)			<=      "0000000111111000";
sprite_head_up_orange(3)			<=      "0000001111011010";
sprite_head_up_orange(4)			<=      "0000111111110010";
sprite_head_up_orange(5)			<=      "0001101111110010";
sprite_head_up_orange(6)			<=      "0011110111100010";
sprite_head_up_orange(7)			<=      "0011110111100000";
sprite_head_up_orange(8)			<=      "0011110111000100";
sprite_head_up_orange(9)			<=      "0111110111001110";
sprite_head_up_orange(10)			<=      "0111111111010000";
sprite_head_up_orange(11)			<=      "0111111110110000";
sprite_head_up_orange(12)			<=      "0111111111110100";
sprite_head_up_orange(13)			<=      "0111111111110100";
sprite_head_up_orange(14)			<=      "0111111111110000";
sprite_head_up_orange(15)			<=      "0111111111000100";

sprite_head_left_black(0)			<=      "0000000001111111";
sprite_head_left_black(1)			<=      "0000000110000000";
sprite_head_left_black(2)			<=      "0000010000000000";
sprite_head_left_black(3)			<=      "0000100000000000";
sprite_head_left_black(4)			<=      "0000000000000000";
sprite_head_left_black(5)			<=      "0001010000000000";
sprite_head_left_black(6)			<=      "0010001111000000";
sprite_head_left_black(7)			<=      "0000000000000000";
sprite_head_left_black(8)			<=      "0100000000000000";
sprite_head_left_black(9)			<=      "0000000000010000";
sprite_head_left_black(10)			<=      "0001000011100001";
sprite_head_left_black(11)			<=      "0000001111000001";
sprite_head_left_black(12)			<=      "0100111110111111";
sprite_head_left_black(13)			<=      "0011101100110010";
sprite_head_left_black(14)			<=      "0000000110110000";
sprite_head_left_black(15)			<=      "0000111110000000";

sprite_head_left_orange(0)			<=      "0000000000000000";
sprite_head_left_orange(1)			<=      "0000000001111111";
sprite_head_left_orange(2)			<=      "0000001111111111";
sprite_head_left_orange(3)			<=      "0000011111111111";
sprite_head_left_orange(4)			<=      "0000111111111111";
sprite_head_left_orange(5)			<=      "0000101111111111";
sprite_head_left_orange(6)			<=      "0001110000111111";
sprite_head_left_orange(7)			<=      "0011111111111111";
sprite_head_left_orange(8)			<=      "0011111111111111";
sprite_head_left_orange(9)			<=      "0111111111101111";
sprite_head_left_orange(10)		<=      "0110111100011110";
sprite_head_left_orange(11)		<=      "0111110000111110";
sprite_head_left_orange(12)		<=      "0011000001000000";
sprite_head_left_orange(13)		<=      "0000000011001101";
sprite_head_left_orange(14)		<=      "0001111001000000";
sprite_head_left_orange(15)		<=      "0000000000000000";





--sprite body coloring
sprite_body_right_black(0)			<=      "0000000110000000";
sprite_body_right_black(1)			<=      "0000000000000000";
sprite_body_right_black(2)			<=      "0000000000000000";
sprite_body_right_black(3)			<=      "0000000000000000";
sprite_body_right_black(4)			<=      "0000000000000000";
sprite_body_right_black(5)			<=      "0000000000000000";
sprite_body_right_black(6)			<=      "0000000000000000";
sprite_body_right_black(7)			<=      "0000000000000000";
sprite_body_right_black(8)			<=      "0000000000000000";
sprite_body_right_black(9)			<=      "0000000000000000";
sprite_body_right_black(10)		<=      "0000000000000000";
sprite_body_right_black(11)		<=      "0000000000000000";
sprite_body_right_black(12)		<=      "1111111111111111";
sprite_body_right_black(13)		<=      "1111111111111111";
sprite_body_right_black(14)		<=      "0000000000000000";
sprite_body_right_black(15)		<=      "1111111111111111";

sprite_body_right_grey(0)			<=      "1111111000000000";
sprite_body_right_grey(1)			<=      "0000000000000000";
sprite_body_right_grey(2)			<=      "1111111100000000";
sprite_body_right_grey(3)			<=      "1111111100000000";
sprite_body_right_grey(4)			<=      "1111111100000000";
sprite_body_right_grey(5)			<=      "1111111100000000";
sprite_body_right_grey(6)			<=      "1111111100000000";
sprite_body_right_grey(7)			<=      "1111111100000000";
sprite_body_right_grey(8)			<=      "1111111100000000";
sprite_body_right_grey(9)			<=      "1111111100000000";
sprite_body_right_grey(10)			<=      "1111111100000000";
sprite_body_right_grey(11)			<=      "1111111100000000";
sprite_body_right_grey(12)			<=      "0000000000000000";
sprite_body_right_grey(13)			<=      "0000000000000000";
sprite_body_right_grey(14)			<=      "1111111100000000";
sprite_body_right_grey(15)			<=      "0000000000000000";

sprite_body_right_orange(0)		<=      "0000000001111111";
sprite_body_right_orange(1)		<=      "0000000000000000";
sprite_body_right_orange(2)		<=      "0000000011111111";
sprite_body_right_orange(3)		<=      "0000000011111111";
sprite_body_right_orange(4)		<=      "0000000011111111";
sprite_body_right_orange(5)		<=      "0000000011111111";
sprite_body_right_orange(6)		<=      "0000000011111111";
sprite_body_right_orange(7)		<=      "0000000011111111";
sprite_body_right_orange(8)		<=      "0000000011111111";
sprite_body_right_orange(9)		<=      "0000000011111111";
sprite_body_right_orange(10)		<=      "0000000011111111";
sprite_body_right_orange(11)		<=      "0000000011111111";
sprite_body_right_orange(12)		<=      "0000000000000000";
sprite_body_right_orange(13)		<=      "0000000000000000";
sprite_body_right_orange(14)		<=      "0000000011111111";
sprite_body_right_orange(15)		<=      "0000000000000000";

sprite_body_right_white(0)			<=      "0000000000000000";
sprite_body_right_white(1)			<=      "1111111111111111";
sprite_body_right_white(2)			<=      "0000000000000000";
sprite_body_right_white(3)			<=      "0000000000000000";
sprite_body_right_white(4)			<=      "0000000000000000";
sprite_body_right_white(5)			<=      "0000000000000000";
sprite_body_right_white(6)			<=      "0000000000000000";
sprite_body_right_white(7)			<=      "0000000000000000";
sprite_body_right_white(8)			<=      "0000000000000000";
sprite_body_right_white(9)			<=      "0000000000000000";
sprite_body_right_white(10)		<=      "0000000000000000";
sprite_body_right_white(11)		<=      "0000000000000000";
sprite_body_right_white(12)		<=      "0000000000000000";
sprite_body_right_white(13)		<=      "0000000000000000";
sprite_body_right_white(14)		<=      "0000000000000000";
sprite_body_right_white(15)		<=      "0000000000000000";


sprite_body_up_black(0)				<=      "0000000000001101";
sprite_body_up_black(1)				<=      "0000000000001101";
sprite_body_up_black(2)				<=      "0000000000001101";
sprite_body_up_black(3)				<=      "0000000000001101";
sprite_body_up_black(4)				<=      "0000000000001101";
sprite_body_up_black(5)				<=      "0000000000001101";
sprite_body_up_black(6)				<=      "0000000000001101";
sprite_body_up_black(7)				<=      "1000000000001101";
sprite_body_up_black(8)				<=      "1000000000001101";
sprite_body_up_black(9)				<=      "0000000000001101";
sprite_body_up_black(10)			<=      "0000000000001101";
sprite_body_up_black(11)			<=      "0000000000001101";
sprite_body_up_black(12)			<=      "0000000000001101";
sprite_body_up_black(13)			<=      "0000000000001101";
sprite_body_up_black(14)			<=      "0000000000001101";
sprite_body_up_black(15)			<=      "0000000000001101";

sprite_body_up_grey(0)				<=      "0000000000000000";
sprite_body_up_grey(1)				<=      "0000000000000000";
sprite_body_up_grey(2)				<=      "0000000000000000";
sprite_body_up_grey(3)				<=      "0000000000000000";
sprite_body_up_grey(4)				<=      "0000000000000000";
sprite_body_up_grey(5)				<=      "0000000000000000";
sprite_body_up_grey(6)				<=      "0000000000000000";
sprite_body_up_grey(7)				<=      "0000000000000000";
sprite_body_up_grey(8)				<=      "0011111111110010";
sprite_body_up_grey(9)				<=      "1011111111110010";
sprite_body_up_grey(10)				<=      "1011111111110010";
sprite_body_up_grey(11)				<=      "1011111111110010";
sprite_body_up_grey(12)				<=      "1011111111110010";
sprite_body_up_grey(13)				<=      "1011111111110010";
sprite_body_up_grey(14)				<=      "1011111111110010";
sprite_body_up_grey(15)				<=      "1011111111110010";

sprite_body_up_orange(0)			<=      "1011111111110010";
sprite_body_up_orange(1)			<=      "1011111111110010";
sprite_body_up_orange(2)			<=      "1011111111110010";
sprite_body_up_orange(3)			<=      "1011111111110010";
sprite_body_up_orange(4)			<=      "1011111111110010";
sprite_body_up_orange(5)			<=      "1011111111110010";
sprite_body_up_orange(6)			<=      "1011111111110010";
sprite_body_up_orange(7)			<=      "0011111111110010";
sprite_body_up_orange(8)			<=      "0000000000000000";
sprite_body_up_orange(9)			<=      "0000000000000000";
sprite_body_up_orange(10)			<=      "0000000000000000";
sprite_body_up_orange(11)			<=      "0000000000000000";
sprite_body_up_orange(12)			<=      "0000000000000000";
sprite_body_up_orange(13)			<=      "0000000000000000";
sprite_body_up_orange(14)			<=      "0000000000000000";
sprite_body_up_orange(15)			<=      "0000000000000000";

sprite_body_up_white(0)				<=      "0100000000000000";
sprite_body_up_white(1)				<=      "0100000000000000";
sprite_body_up_white(2)				<=      "0100000000000000";
sprite_body_up_white(3)				<=      "0100000000000000";
sprite_body_up_white(4)				<=      "0100000000000000";
sprite_body_up_white(5)				<=      "0100000000000000";
sprite_body_up_white(6)				<=      "0100000000000000";
sprite_body_up_white(7)				<=      "0100000000000000";
sprite_body_up_white(8)				<=      "0100000000000000";
sprite_body_up_white(9)				<=      "0100000000000000";
sprite_body_up_white(10)			<=      "0100000000000000";
sprite_body_up_white(11)			<=      "0100000000000000";
sprite_body_up_white(12)			<=      "0100000000000000";
sprite_body_up_white(13)			<=      "0100000000000000";
sprite_body_up_white(14)			<=      "0100000000000000";
sprite_body_up_white(15)			<=      "0100000000000000";

sprite_body_left_black(0)			<=      "1111111111111111";
sprite_body_left_black(1)			<=      "0000000000000000";
sprite_body_left_black(2)			<=      "1111111111111111";
sprite_body_left_black(3)			<=      "1111111111111111";
sprite_body_left_black(4)			<=      "0000000000000000";
sprite_body_left_black(5)			<=      "0000000000000000";
sprite_body_left_black(6)			<=      "0000000000000000";
sprite_body_left_black(7)			<=      "0000000000000000";
sprite_body_left_black(8)			<=      "0000000000000000";
sprite_body_left_black(9)			<=      "0000000000000000";
sprite_body_left_black(10)			<=      "0000000000000000";
sprite_body_left_black(11)			<=      "0000000000000000";
sprite_body_left_black(12)			<=      "0000000000000000";
sprite_body_left_black(13)			<=      "0000000000000000";
sprite_body_left_black(14)			<=      "0000000000000000";
sprite_body_left_black(15)			<=      "0000000110000000";

sprite_body_left_grey(0)			<=      "0000000000000000";
sprite_body_left_grey(1)			<=      "0000000011111111";
sprite_body_left_grey(2)			<=      "0000000000000000";
sprite_body_left_grey(3)			<=      "0000000000000000";
sprite_body_left_grey(4)			<=      "0000000011111111";
sprite_body_left_grey(5)			<=      "0000000011111111";
sprite_body_left_grey(6)			<=      "0000000011111111";
sprite_body_left_grey(7)			<=      "0000000011111111";
sprite_body_left_grey(8)			<=      "0000000011111111";
sprite_body_left_grey(9)			<=      "0000000011111111";
sprite_body_left_grey(10)			<=      "0000000011111111";
sprite_body_left_grey(11)			<=      "0000000011111111";
sprite_body_left_grey(12)			<=      "0000000011111111";
sprite_body_left_grey(13)			<=      "0000000011111111";
sprite_body_left_grey(14)			<=      "0000000000000000";
sprite_body_left_grey(15)			<=      "0000000001111111";

sprite_body_left_orange(0)			<=      "0000000000000000";
sprite_body_left_orange(1)			<=      "1111111100000000";
sprite_body_left_orange(2)			<=      "0000000000000000";
sprite_body_left_orange(3)			<=      "0000000000000000";
sprite_body_left_orange(4)			<=      "1111111100000000";
sprite_body_left_orange(5)			<=      "1111111100000000";
sprite_body_left_orange(6)			<=      "1111111100000000";
sprite_body_left_orange(7)			<=      "1111111100000000";
sprite_body_left_orange(8)			<=      "1111111100000000";
sprite_body_left_orange(9)			<=      "1111111100000000";
sprite_body_left_orange(10)		<=      "1111111100000000";
sprite_body_left_orange(11)		<=      "1111111100000000";
sprite_body_left_orange(12)		<=      "1111111100000000";
sprite_body_left_orange(13)		<=      "1111111100000000";
sprite_body_left_orange(14)		<=      "0000000000000000";
sprite_body_left_orange(15)		<=      "1111111000000000";

sprite_body_left_white(0)			<=      "0000000000000000";
sprite_body_left_white(1)			<=      "0000000000000000";
sprite_body_left_white(2)			<=      "0000000000000000";
sprite_body_left_white(3)			<=      "0000000000000000";
sprite_body_left_white(4)			<=      "0000000000000000";
sprite_body_left_white(5)			<=      "0000000000000000";
sprite_body_left_white(6)			<=      "0000000000000000";
sprite_body_left_white(7)			<=      "0000000000000000";
sprite_body_left_white(8)			<=      "0000000000000000";
sprite_body_left_white(9)			<=      "0000000000000000";
sprite_body_left_white(10)			<=      "0000000000000000";
sprite_body_left_white(11)			<=      "0000000000000000";
sprite_body_left_white(12)			<=      "0000000000000000";
sprite_body_left_white(13)			<=      "0000000000000000";
sprite_body_left_white(14)			<=      "1111111111111111";
sprite_body_left_white(15)			<=      "0000000000000000";

sprite_body_down_black(0)			<=      "1011000000000000";
sprite_body_down_black(1)			<=      "1011000000000000";
sprite_body_down_black(2)			<=      "1011000000000000";
sprite_body_down_black(3)			<=      "1011000000000000";
sprite_body_down_black(4)			<=      "1011000000000000";
sprite_body_down_black(5)			<=      "1011000000000000";
sprite_body_down_black(6)			<=      "1011000000000000";
sprite_body_down_black(7)			<=      "1011000000000001";
sprite_body_down_black(8)			<=      "1011000000000001";
sprite_body_down_black(9)			<=      "1011000000000000";
sprite_body_down_black(10)			<=      "1011000000000000";
sprite_body_down_black(11)			<=      "1011000000000000";
sprite_body_down_black(12)			<=      "1011000000000000";
sprite_body_down_black(13)			<=      "1011000000000000";
sprite_body_down_black(14)			<=      "1011000000000000";
sprite_body_down_black(15)			<=      "1011000000000000";

sprite_body_down_grey(0)			<=      "0100111111111101";
sprite_body_down_grey(1)			<=      "0100111111111101";
sprite_body_down_grey(2)			<=      "0100111111111101";
sprite_body_down_grey(3)			<=      "0100111111111101";
sprite_body_down_grey(4)			<=      "0100111111111101";
sprite_body_down_grey(5)			<=      "0100111111111101";
sprite_body_down_grey(6)			<=      "0100111111111101";
sprite_body_down_grey(7)			<=      "0100111111111100";
sprite_body_down_grey(8)			<=      "0000000000000000";
sprite_body_down_grey(9)			<=      "0000000000000000";
sprite_body_down_grey(10)			<=      "0000000000000000";
sprite_body_down_grey(11)			<=      "0000000000000000";
sprite_body_down_grey(12)			<=      "0000000000000000";
sprite_body_down_grey(13)			<=      "0000000000000000";
sprite_body_down_grey(14)			<=      "0000000000000000";
sprite_body_down_grey(15)			<=      "0000000000000000";

sprite_body_down_orange(0)			<=      "0000000000000000";
sprite_body_down_orange(1)			<=      "0000000000000000";
sprite_body_down_orange(2)			<=      "0000000000000000";
sprite_body_down_orange(3)			<=      "0000000000000000";
sprite_body_down_orange(4)			<=      "0000000000000000";
sprite_body_down_orange(5)			<=      "0000000000000000";
sprite_body_down_orange(6)			<=      "0000000000000000";
sprite_body_down_orange(7)			<=      "0000000000000000";
sprite_body_down_orange(8)			<=      "0100111111111100";
sprite_body_down_orange(9)			<=      "0100111111111101";
sprite_body_down_orange(10)			<=      "0100111111111101";
sprite_body_down_orange(11)			<=      "0100111111111101";
sprite_body_down_orange(12)			<=      "0100111111111101";
sprite_body_down_orange(13)			<=      "0100111111111101";
sprite_body_down_orange(14)			<=      "0100111111111101";
sprite_body_down_orange(15)			<=      "0100111111111101";

sprite_body_down_white(0)			<=      "0000000000000010";
sprite_body_down_white(1)			<=      "0000000000000010";
sprite_body_down_white(2)			<=      "0000000000000010";
sprite_body_down_white(3)			<=      "0000000000000010";
sprite_body_down_white(4)			<=      "0000000000000010";
sprite_body_down_white(5)			<=      "0000000000000010";
sprite_body_down_white(6)			<=      "0000000000000010";
sprite_body_down_white(7)			<=      "0000000000000010";
sprite_body_down_white(8)			<=      "0000000000000010";
sprite_body_down_white(9)			<=      "0000000000000010";
sprite_body_down_white(10)			<=      "0000000000000010";
sprite_body_down_white(11)			<=      "0000000000000010";
sprite_body_down_white(12)			<=      "0000000000000010";
sprite_body_down_white(13)			<=      "0000000000000010";
sprite_body_down_white(14)			<=      "0000000000000010";
sprite_body_down_white(15)			<=      "0000000000000010";

  
  
  
--sprite turning coloring
sprite_turn_down_left_black(0)			<=      "0000000000000110";
sprite_turn_down_left_black(1)			<=      "0000000000000110";
sprite_turn_down_left_black(2)			<=      "0000000000000010";
sprite_turn_down_left_black(3)			<=      "0000000000000010";
sprite_turn_down_left_black(4)			<=      "0000100000000110";
sprite_turn_down_left_black(5)			<=      "1111000000000010";
sprite_turn_down_left_black(6)			<=      "0011000111111111";
sprite_turn_down_left_black(7)			<=      "0000001000000110";
sprite_turn_down_left_black(8)			<=      "0000001000000110";
sprite_turn_down_left_black(9)			<=      "0000001000000010";
sprite_turn_down_left_black(10)			<=      "0000001000000010";
sprite_turn_down_left_black(11)			<=      "0000001000000110";
sprite_turn_down_left_black(12)			<=      "0000001000000111";
sprite_turn_down_left_black(13)			<=      "0000001000001100";
sprite_turn_down_left_black(14)			<=      "0000001000001001";
sprite_turn_down_left_black(15)			<=      "1000001000001111";

sprite_turn_down_left_grey(0)			<=      "0000011111111001";
sprite_turn_down_left_grey(1)			<=      "0000011111111001";
sprite_turn_down_left_grey(2)			<=      "0000011111111101";
sprite_turn_down_left_grey(3)			<=      "0000011111111101";
sprite_turn_down_left_grey(4)			<=      "0000000111111001";
sprite_turn_down_left_grey(5)			<=      "0000000111111101";
sprite_turn_down_left_grey(6)			<=      "0000000000000000";
sprite_turn_down_left_grey(7)			<=      "0000000001000000";
sprite_turn_down_left_grey(8)			<=      "0000000001000000";
sprite_turn_down_left_grey(9)			<=      "0000000110000000";
sprite_turn_down_left_grey(10)			<=      "0000000111101000";
sprite_turn_down_left_grey(11)			<=      "0000000111010000";
sprite_turn_down_left_grey(12)			<=      "0000000111101000";
sprite_turn_down_left_grey(13)			<=      "0000000111110011";
sprite_turn_down_left_grey(14)			<=      "0000000000000110";
sprite_turn_down_left_grey(15)			<=      "0000000111110000";

sprite_turn_down_left_orange(0)			<=      "0000000000000000";
sprite_turn_down_left_orange(1)			<=      "0000000000000000";
sprite_turn_down_left_orange(2)			<=      "0000000000000000";
sprite_turn_down_left_orange(3)			<=      "0000000000000000";
sprite_turn_down_left_orange(4)			<=      "1111011000000000";
sprite_turn_down_left_orange(5)			<=      "0000111000000000";
sprite_turn_down_left_orange(6)			<=      "1100111000000000";
sprite_turn_down_left_orange(7)			<=      "1111110110111001";
sprite_turn_down_left_orange(8)			<=      "1111110110111001";
sprite_turn_down_left_orange(9)			<=      "1111110001111101";
sprite_turn_down_left_orange(10)		<=      "1111110000010101";
sprite_turn_down_left_orange(11)		<=      "1111110000101001";
sprite_turn_down_left_orange(12)		<=      "1111110000010000";
sprite_turn_down_left_orange(13)		<=      "1111110000000000";
sprite_turn_down_left_orange(14)		<=      "0000000000000000";
sprite_turn_down_left_orange(15)		<=      "0111110000000000";

sprite_turn_down_left_white(0)			<=      "0000000000000000";
sprite_turn_down_left_white(1)			<=      "0000000000000000";
sprite_turn_down_left_white(2)			<=      "0000000000000000";
sprite_turn_down_left_white(3)			<=      "0000000000000000";
sprite_turn_down_left_white(4)			<=      "0000000000000000";
sprite_turn_down_left_white(5)			<=      "0000000000000000";
sprite_turn_down_left_white(6)			<=      "0000000000000000";
sprite_turn_down_left_white(7)			<=      "0000000000000000";
sprite_turn_down_left_white(8)			<=      "0000000000000000";
sprite_turn_down_left_white(9)			<=      "0000000000000000";
sprite_turn_down_left_white(10)			<=      "0000000000000000";
sprite_turn_down_left_white(11)			<=      "0000000000000000";
sprite_turn_down_left_white(12)			<=      "0000000000000000";
sprite_turn_down_left_white(13)			<=      "0000000000000000";
sprite_turn_down_left_white(14)			<=      "1111110111110000";
sprite_turn_down_left_white(15)			<=      "0000000000000000";

sprite_turn_left_up_black(0)			<=      "1000000000100000";
sprite_turn_left_up_black(1)			<=      "0000000000100000";
sprite_turn_left_up_black(2)			<=      "0000000001100000";
sprite_turn_left_up_black(3)			<=      "0000000001100000";
sprite_turn_left_up_black(4)			<=      "0000000000010000";
sprite_turn_left_up_black(5)			<=      "0000000000000000";
sprite_turn_left_up_black(6)			<=      "1111111110000000";
sprite_turn_left_up_black(7)			<=      "0000000001000000";
sprite_turn_left_up_black(8)			<=      "0000000001000000";
sprite_turn_left_up_black(9)			<=      "0000000001000000";
sprite_turn_left_up_black(10)			<=      "0000000001000000";
sprite_turn_left_up_black(11)			<=      "0000000001000000";
sprite_turn_left_up_black(12)			<=      "1110000001000000";
sprite_turn_left_up_black(13)			<=      "1011100111010011";
sprite_turn_left_up_black(14)			<=      "1001111111111111";
sprite_turn_left_up_black(15)			<=      "1101000001000000";

sprite_turn_left_up_grey(0)			<=      "0000000000000000";
sprite_turn_left_up_grey(1)			<=      "0000000000000000";
sprite_turn_left_up_grey(2)			<=      "0000000000000000";
sprite_turn_left_up_grey(3)			<=      "0000000000000000";
sprite_turn_left_up_grey(4)			<=      "0000000000000000";
sprite_turn_left_up_grey(5)			<=      "0000000000001111";
sprite_turn_left_up_grey(6)			<=      "0000000000001111";
sprite_turn_left_up_grey(7)			<=      "1011111000111111";
sprite_turn_left_up_grey(8)			<=      "1011111000111111";
sprite_turn_left_up_grey(9)			<=      "1011110110111111";
sprite_turn_left_up_grey(10)			<=      "1011010000111111";
sprite_turn_left_up_grey(11)			<=      "1010100000111111";
sprite_turn_left_up_grey(12)			<=      "0001010000111111";
sprite_turn_left_up_grey(13)			<=      "0100000000101100";
sprite_turn_left_up_grey(14)			<=      "0110000000000000";
sprite_turn_left_up_grey(15)			<=      "0010000000111111";

sprite_turn_left_up_orange(0)			<=      "0011111111010000";
sprite_turn_left_up_orange(1)			<=      "1011111111010000";
sprite_turn_left_up_orange(2)			<=      "1011111110010000";
sprite_turn_left_up_orange(3)			<=      "1011111110010000";
sprite_turn_left_up_orange(4)			<=      "1011111111100000";
sprite_turn_left_up_orange(5)			<=      "1011111111110000";
sprite_turn_left_up_orange(6)			<=      "0000000001110000";
sprite_turn_left_up_orange(7)			<=      "0000000110000000";
sprite_turn_left_up_orange(8)			<=      "0000000110000000";
sprite_turn_left_up_orange(9)			<=      "0000001000000000";
sprite_turn_left_up_orange(10)			<=      "0000101110000000";
sprite_turn_left_up_orange(11)			<=      "0001011110000000";
sprite_turn_left_up_orange(12)			<=      "0000101110000000";
sprite_turn_left_up_orange(13)			<=      "0000011000000000";
sprite_turn_left_up_orange(14)			<=      "0000000000000000";
sprite_turn_left_up_orange(15)			<=      "0000111110000000";

sprite_turn_left_up_white(0)			<=      "0100000000000000";
sprite_turn_left_up_white(1)			<=      "0100000000000000";
sprite_turn_left_up_white(2)			<=      "0100000000000000";
sprite_turn_left_up_white(3)			<=      "0100000000000000";
sprite_turn_left_up_white(4)			<=      "0100000000000000";
sprite_turn_left_up_white(5)			<=      "0100000000000000";
sprite_turn_left_up_white(6)			<=      "0000000000000000";
sprite_turn_left_up_white(7)			<=      "0100000000000000";
sprite_turn_left_up_white(8)			<=      "0100000000000000";
sprite_turn_left_up_white(9)			<=      "0100000000000000";
sprite_turn_left_up_white(10)			<=      "0100000000000000";
sprite_turn_left_up_white(11)			<=      "0100000000000000";
sprite_turn_left_up_white(12)			<=      "0000000000000000";
sprite_turn_left_up_white(13)			<=      "0000000000000000";
sprite_turn_left_up_white(14)			<=      "0000000000000000";
sprite_turn_left_up_white(15)			<=      "0000000000000000";

sprite_turn_right_down_black(0)			<=      "0000001000001011";
sprite_turn_right_down_black(1)			<=      "1111111111111001";
sprite_turn_right_down_black(2)			<=      "1100101110011101";
sprite_turn_right_down_black(3)			<=      "0000001000000111";
sprite_turn_right_down_black(4)			<=      "0000001000000000";
sprite_turn_right_down_black(5)			<=      "0000001000000000";
sprite_turn_right_down_black(6)			<=      "0000001000000000";
sprite_turn_right_down_black(7)			<=      "0000001000000000";
sprite_turn_right_down_black(8)			<=      "0000001000000000";
sprite_turn_right_down_black(9)			<=      "0000000111111111";
sprite_turn_right_down_black(10)		<=      "0000000000000000";
sprite_turn_right_down_black(11)		<=      "0000100000000000";
sprite_turn_right_down_black(12)		<=      "0000011000000000";
sprite_turn_right_down_black(13)		<=      "0000011000000000";
sprite_turn_right_down_black(14)		<=      "0000010000000000";
sprite_turn_right_down_black(15)		<=      "0000010000000001";

sprite_turn_right_down_grey(0)			<=      "1111110000000100";
sprite_turn_right_down_grey(1)			<=      "0000000000000110";
sprite_turn_right_down_grey(2)			<=      "0011010000000010";
sprite_turn_right_down_grey(3)			<=      "1111110000101000";
sprite_turn_right_down_grey(4)			<=      "1111110000010101";
sprite_turn_right_down_grey(5)			<=      "1111110000101101";
sprite_turn_right_down_grey(6)			<=      "1111110110111101";
sprite_turn_right_down_grey(7)			<=      "1111110001111101";
sprite_turn_right_down_grey(8)			<=      "1111110001111101";
sprite_turn_right_down_grey(9)			<=      "1111000000000000";
sprite_turn_right_down_grey(10)			<=      "1111000000000000";
sprite_turn_right_down_grey(11)			<=      "0000000000000000";
sprite_turn_right_down_grey(12)			<=      "0000000000000000";
sprite_turn_right_down_grey(13)			<=      "0000000000000000";
sprite_turn_right_down_grey(14)			<=      "0000000000000000";
sprite_turn_right_down_grey(15)			<=      "0000000000000000";

sprite_turn_right_down_orange(0)		<=      "0000000111110000";
sprite_turn_right_down_orange(1)		<=      "0000000000000000";
sprite_turn_right_down_orange(2)		<=      "0000000001100000";
sprite_turn_right_down_orange(3)		<=      "0000000111010000";
sprite_turn_right_down_orange(4)		<=      "0000000111101000";
sprite_turn_right_down_orange(5)		<=      "0000000111010000";
sprite_turn_right_down_orange(6)		<=      "0000000001000000";
sprite_turn_right_down_orange(7)		<=      "0000000110000000";
sprite_turn_right_down_orange(8)		<=      "0000000110000000";
sprite_turn_right_down_orange(9)		<=      "0000111000000000";
sprite_turn_right_down_orange(10)		<=      "0000111111111101";
sprite_turn_right_down_orange(11)		<=      "0000011111111101";
sprite_turn_right_down_orange(12)		<=      "0000100111111101";
sprite_turn_right_down_orange(13)		<=      "0000100111111101";
sprite_turn_right_down_orange(14)		<=      "0000101111111101";
sprite_turn_right_down_orange(15)		<=      "0000101111111100";

sprite_turn_right_down_white(0)			<=      "0000000000000000";
sprite_turn_right_down_white(1)			<=      "0000000000000000";
sprite_turn_right_down_white(2)			<=      "0000000000000000";
sprite_turn_right_down_white(3)			<=      "0000000000000000";
sprite_turn_right_down_white(4)			<=      "0000000000000010";
sprite_turn_right_down_white(5)			<=      "0000000000000010";
sprite_turn_right_down_white(6)			<=      "0000000000000010";
sprite_turn_right_down_white(7)			<=      "0000000000000010";
sprite_turn_right_down_white(8)			<=      "0000000000000010";
sprite_turn_right_down_white(9)			<=      "0000000000000000";
sprite_turn_right_down_white(10)		<=      "0000000000000010";
sprite_turn_right_down_white(11)		<=      "0000000000000010";
sprite_turn_right_down_white(12)		<=      "0000000000000010";
sprite_turn_right_down_white(13)		<=      "0000000000000010";
sprite_turn_right_down_white(14)		<=      "0000000000000010";
sprite_turn_right_down_white(15)		<=      "0000000000000010";

sprite_turn_up_right_black(0)			<=      "1111000001000001";
sprite_turn_up_right_black(1)			<=      "1001000001000000";
sprite_turn_up_right_black(2)			<=      "0011000001000000";
sprite_turn_up_right_black(3)			<=      "1110000001000000";
sprite_turn_up_right_black(4)			<=      "0110000001000000";
sprite_turn_up_right_black(5)			<=      "0100000001000000";
sprite_turn_up_right_black(6)			<=      "0100000001000000";
sprite_turn_up_right_black(7)			<=      "0110000001000000";
sprite_turn_up_right_black(8)			<=      "0110000001000000";
sprite_turn_up_right_black(9)			<=      "1111111110001100";
sprite_turn_up_right_black(10)		<=      "0100000000001111";
sprite_turn_up_right_black(11)		<=      "0110000000010000";
sprite_turn_up_right_black(12)		<=      "0100000000000000";
sprite_turn_up_right_black(13)		<=      "0100000000000000";
sprite_turn_up_right_black(14)		<=      "0110000000000000";
sprite_turn_up_right_black(15)		<=      "0110000000000000";

sprite_turn_up_right_grey(0)			<=      "0000111110000000";
sprite_turn_up_right_grey(1)			<=      "0110000000000000";
sprite_turn_up_right_grey(2)			<=      "1100111110000000";
sprite_turn_up_right_grey(3)			<=      "0001011110000000";
sprite_turn_up_right_grey(4)			<=      "0000101110000000";
sprite_turn_up_right_grey(5)			<=      "0001011110000000";
sprite_turn_up_right_grey(6)			<=      "0000000110000000";
sprite_turn_up_right_grey(7)			<=      "0000001000000000";
sprite_turn_up_right_grey(8)			<=      "0000001000000000";
sprite_turn_up_right_grey(9)			<=      "0000000000000000";
sprite_turn_up_right_grey(10)			<=      "1011111110000000";
sprite_turn_up_right_grey(11)			<=      "1001111110000000";
sprite_turn_up_right_grey(12)			<=      "1011111111100000";
sprite_turn_up_right_grey(13)			<=      "1011111111100000";
sprite_turn_up_right_grey(14)			<=      "1001111111100000";
sprite_turn_up_right_grey(15)			<=      "1001111111100000";

sprite_turn_up_right_orange(0)		<=      "0000000000111110";
sprite_turn_up_right_orange(1)		<=      "0000000000000000";
sprite_turn_up_right_orange(2)		<=      "0000000000111111";
sprite_turn_up_right_orange(3)		<=      "0000100000111111";
sprite_turn_up_right_orange(4)		<=      "1001010000111111";
sprite_turn_up_right_orange(5)		<=      "1010100000111111";
sprite_turn_up_right_orange(6)		<=      "1011111000111111";
sprite_turn_up_right_orange(7)		<=      "1001110110111111";
sprite_turn_up_right_orange(8)		<=      "1001110110111111";
sprite_turn_up_right_orange(9)		<=      "0000000001110011";
sprite_turn_up_right_orange(10)		<=      "0000000001110000";
sprite_turn_up_right_orange(11)		<=      "0000000001101111";
sprite_turn_up_right_orange(12)		<=      "0000000000000000";
sprite_turn_up_right_orange(13)		<=      "0000000000000000";
sprite_turn_up_right_orange(14)		<=      "0000000000000000";
sprite_turn_up_right_orange(15)		<=      "0000000000000000";

sprite_turn_up_right_white(0)			<=      "0000000000000000";
sprite_turn_up_right_white(1)			<=      "0000111110111111";
sprite_turn_up_right_white(2)			<=      "0000000000000000";
sprite_turn_up_right_white(3)			<=      "0000000000000000";
sprite_turn_up_right_white(4)			<=      "0000000000000000";
sprite_turn_up_right_white(5)			<=      "0000000000000000";
sprite_turn_up_right_white(6)			<=      "0000000000000000";
sprite_turn_up_right_white(7)			<=      "0000000000000000";
sprite_turn_up_right_white(8)			<=      "0000000000000000";
sprite_turn_up_right_white(9)			<=      "0000000000000000";
sprite_turn_up_right_white(10)		<=      "0000000000000000";
sprite_turn_up_right_white(11)		<=      "0000000000000000";
sprite_turn_up_right_white(12)		<=      "0000000000000000";
sprite_turn_up_right_white(13)		<=      "0000000000000000";
sprite_turn_up_right_white(14)		<=      "0000000000000000";
sprite_turn_up_right_white(15)		<=      "0000000000000000";






-- sprite tail coloring
sprite_tail_down_black(0)			<=      "0000000000000000";
sprite_tail_down_black(1)			<=      "0000000000000000";
sprite_tail_down_black(2)			<=      "0000000000000000";
sprite_tail_down_black(3)			<=      "0000000000000000";
sprite_tail_down_black(4)			<=      "0000000000000000";
sprite_tail_down_black(5)			<=      "0000000000000000";
sprite_tail_down_black(6)			<=      "0000000000000000";
sprite_tail_down_black(7)			<=      "0000000000000000";
sprite_tail_down_black(8)			<=      "1110000010011011";
sprite_tail_down_black(9)			<=      "1000000100111010";
sprite_tail_down_black(10)			<=      "1001001101000101";
sprite_tail_down_black(11)			<=      "1010001101000101";
sprite_tail_down_black(12)			<=      "1000000000000110";
sprite_tail_down_black(13)			<=      "1000000000000110";
sprite_tail_down_black(14)			<=      "1000000000000110";
sprite_tail_down_black(15)			<=      "1000000000000111";

sprite_tail_down_orange(0)			<=      "0000000000000000";
sprite_tail_down_orange(1)			<=      "0000000000000000";
sprite_tail_down_orange(2)			<=      "0000000000000000";
sprite_tail_down_orange(3)			<=      "0000000000000000";
sprite_tail_down_orange(4)			<=      "0000000000000000";
sprite_tail_down_orange(5)			<=      "0000000000000000";
sprite_tail_down_orange(6)			<=      "0000000000000000";
sprite_tail_down_orange(7)			<=      "0000000000000000";
sprite_tail_down_orange(8)			<=      "0001111101100100";
sprite_tail_down_orange(9)			<=      "0111111011000101";
sprite_tail_down_orange(10)			<=      "0110110010111010";
sprite_tail_down_orange(11)			<=      "0101110010111010";
sprite_tail_down_orange(12)			<=      "0111111111111001";
sprite_tail_down_orange(13)			<=      "0111111111111001";
sprite_tail_down_orange(14)			<=      "0111111111111001";
sprite_tail_down_orange(15)			<=      "0111111111111000";

sprite_tail_down_yellow(0)			<=      "0000000000000000";
sprite_tail_down_yellow(1)			<=      "0000000000000000";
sprite_tail_down_yellow(2)			<=      "0000000000000000";
sprite_tail_down_yellow(3)			<=      "0000000000000000";
sprite_tail_down_yellow(4)			<=      "0000000110000000";
sprite_tail_down_yellow(5)			<=      "0000011111100000";
sprite_tail_down_yellow(6)			<=      "0000111111110000";
sprite_tail_down_yellow(7)			<=      "0001111111111000";
sprite_tail_down_yellow(8)			<=      "0000000000000000";
sprite_tail_down_yellow(9)			<=      "0000000000000000";
sprite_tail_down_yellow(10)			<=      "0000000000000000";
sprite_tail_down_yellow(11)			<=      "0000000000000000";
sprite_tail_down_yellow(12)			<=      "0000000000000000";
sprite_tail_down_yellow(13)			<=      "0000000000000000";
sprite_tail_down_yellow(14)			<=      "0000000000000000";
sprite_tail_down_yellow(15)			<=      "0000000000000000";




sprite_tail_left_black(0)			<=      "1111111100000000";
sprite_tail_left_black(1)			<=      "0000000100000000";
sprite_tail_left_black(2)			<=      "0000100100000000";
sprite_tail_left_black(3)			<=      "0000010000000000";
sprite_tail_left_black(4)			<=      "0000000000000000";
sprite_tail_left_black(5)			<=      "0000000000000000";
sprite_tail_left_black(6)			<=      "0000110000000000";
sprite_tail_left_black(7)			<=      "0000111000000000";
sprite_tail_left_black(8)			<=      "0000000100000000";
sprite_tail_left_black(9)			<=      "0000110000000000";
sprite_tail_left_black(10)			<=      "0000001000000000";
sprite_tail_left_black(11)			<=      "0000001100000000";
sprite_tail_left_black(12)			<=      "0000001100000000";
sprite_tail_left_black(13)			<=      "1111110000000000";
sprite_tail_left_black(14)			<=      "1111001100000000";
sprite_tail_left_black(15)			<=      "1000110100000000";

sprite_tail_left_orange(0)			<=      "0000000000000000";
sprite_tail_left_orange(1)			<=      "1111111000000000";
sprite_tail_left_orange(2)			<=      "1111011000000000";
sprite_tail_left_orange(3)			<=      "1111101100000000";
sprite_tail_left_orange(4)			<=      "1111111100000000";
sprite_tail_left_orange(5)			<=      "1111111100000000";
sprite_tail_left_orange(6)			<=      "1111001100000000";
sprite_tail_left_orange(7)			<=      "1111000100000000";
sprite_tail_left_orange(8)			<=      "1111111000000000";
sprite_tail_left_orange(9)			<=      "1111001100000000";
sprite_tail_left_orange(10)			<=      "1111110100000000";
sprite_tail_left_orange(11)			<=      "1111110000000000";
sprite_tail_left_orange(12)			<=      "1111110000000000";
sprite_tail_left_orange(13)			<=      "0000001100000000";
sprite_tail_left_orange(14)			<=      "0000110000000000";
sprite_tail_left_orange(15)			<=      "0111001000000000";

sprite_tail_left_yellow(0)			<=      "0000000000000000";
sprite_tail_left_yellow(1)			<=      "0000000000000000";
sprite_tail_left_yellow(2)			<=      "0000000000000000";
sprite_tail_left_yellow(3)			<=      "0000000010000000";
sprite_tail_left_yellow(4)			<=      "0000000011000000";
sprite_tail_left_yellow(5)			<=      "0000000011100000";
sprite_tail_left_yellow(6)			<=      "0000000011100000";
sprite_tail_left_yellow(7)			<=      "0000000011110000";
sprite_tail_left_yellow(8)			<=      "0000000011110000";
sprite_tail_left_yellow(9)			<=      "0000000011100000";
sprite_tail_left_yellow(10)			<=      "0000000011100000";
sprite_tail_left_yellow(11)			<=      "0000000011000000";
sprite_tail_left_yellow(12)			<=      "0000000010000000";
sprite_tail_left_yellow(13)			<=      "0000000000000000";
sprite_tail_left_yellow(14)			<=      "0000000000000000";
sprite_tail_left_yellow(15)			<=      "0000000000000000";




sprite_tail_right_black(0)			<=      "0000000010110001";
sprite_tail_right_black(1)			<=      "0000000011001111";
sprite_tail_right_black(2)			<=      "0000000000111111";
sprite_tail_right_black(3)			<=      "0000000011000000";
sprite_tail_right_black(4)			<=      "0000000011000000";
sprite_tail_right_black(5)			<=      "0000000001000000";
sprite_tail_right_black(6)			<=      "0000000000110000";
sprite_tail_right_black(7)			<=      "0000000010000000";
sprite_tail_right_black(8)			<=      "0000000001110000";
sprite_tail_right_black(9)			<=      "0000000000110000";
sprite_tail_right_black(10)			<=      "0000000000000000";
sprite_tail_right_black(11)			<=      "0000000000000000";
sprite_tail_right_black(12)			<=      "0000000000100000";
sprite_tail_right_black(13)			<=      "0000000010010000";
sprite_tail_right_black(14)			<=      "0000000010000000";
sprite_tail_right_black(15)			<=      "0000000011111111";

sprite_tail_right_orange(0)			<=      "0000000001001110";
sprite_tail_right_orange(1)			<=      "0000000000110000";
sprite_tail_right_orange(2)			<=      "0000000011000000";
sprite_tail_right_orange(3)			<=      "0000000000111111";
sprite_tail_right_orange(4)			<=      "0000000000111111";
sprite_tail_right_orange(5)			<=      "0000000010111111";
sprite_tail_right_orange(6)			<=      "0000000011001111";
sprite_tail_right_orange(7)			<=      "0000000001111111";
sprite_tail_right_orange(8)			<=      "0000000010001111";
sprite_tail_right_orange(9)			<=      "0000000011001111";
sprite_tail_right_orange(10)			<=      "0000000011111111";
sprite_tail_right_orange(11)			<=      "0000000011111111";
sprite_tail_right_orange(12)			<=      "0000000011011111";
sprite_tail_right_orange(13)			<=      "0000000001101111";
sprite_tail_right_orange(14)			<=      "0000000001111111";
sprite_tail_right_orange(15)			<=      "0000000000000000";

sprite_tail_right_yellow(0)			<=      "0000000000000000";
sprite_tail_right_yellow(1)			<=      "0000000000000000";
sprite_tail_right_yellow(2)			<=      "0000000000000000";
sprite_tail_right_yellow(3)			<=      "0000000100000000";
sprite_tail_right_yellow(4)			<=      "0000001100000000";
sprite_tail_right_yellow(5)			<=      "0000011100000000";
sprite_tail_right_yellow(6)			<=      "0000011100000000";
sprite_tail_right_yellow(7)			<=      "0000111100000000";
sprite_tail_right_yellow(8)			<=      "0000111100000000";
sprite_tail_right_yellow(9)			<=      "0000011100000000";
sprite_tail_right_yellow(10)			<=      "0000011100000000";
sprite_tail_right_yellow(11)			<=      "0000001100000000";
sprite_tail_right_yellow(12)			<=      "0000000100000000";
sprite_tail_right_yellow(13)			<=      "0000000000000000";
sprite_tail_right_yellow(14)			<=      "0000000000000000";





sprite_tail_up_black(0)				<=      "1110000000000001";
sprite_tail_up_black(1)				<=      "0110000000000001";
sprite_tail_up_black(2)				<=      "0110000000000001";
sprite_tail_up_black(3)				<=      "0110000000000001";
sprite_tail_up_black(4)				<=      "1010001011000101";
sprite_tail_up_black(5)				<=      "1010001011001001";
sprite_tail_up_black(6)				<=      "0101110010000001";
sprite_tail_up_black(7)				<=      "1101100100000111";
sprite_tail_up_black(8)				<=      "0000000000000000";
sprite_tail_up_black(9)				<=      "0000000000000000";
sprite_tail_up_black(10)			<=      "0000000000000000";
sprite_tail_up_black(11)			<=      "0000000000000000";
sprite_tail_up_black(12)			<=      "0000000000000000";
sprite_tail_up_black(13)			<=      "0000000000000000";
sprite_tail_up_black(14)			<=      "0000000000000000";
sprite_tail_up_black(15)			<=      "0000000000000000";

sprite_tail_up_orange(0)			<=      "0001111111111110";
sprite_tail_up_orange(1)			<=      "1001111111111110";
sprite_tail_up_orange(2)			<=      "1001111111111110";
sprite_tail_up_orange(3)			<=      "1001111111111110";
sprite_tail_up_orange(4)			<=      "0101110100111010";
sprite_tail_up_orange(5)			<=      "0101110100110110";
sprite_tail_up_orange(6)			<=      "1010001101111110";
sprite_tail_up_orange(7)			<=      "0010011011111000";
sprite_tail_up_orange(8)			<=      "0000000000000000";
sprite_tail_up_orange(9)			<=      "0000000000000000";
sprite_tail_up_orange(10)			<=      "0000000000000000";
sprite_tail_up_orange(11)			<=      "0000000000000000";
sprite_tail_up_orange(12)			<=      "0000000000000000";
sprite_tail_up_orange(13)			<=      "0000000000000000";
sprite_tail_up_orange(14)			<=      "0000000000000000";
sprite_tail_up_orange(15)			<=      "0000000000000000";

sprite_tail_up_yellow(0)			<=      "0000000000000000";
sprite_tail_up_yellow(1)			<=      "0000000000000000";
sprite_tail_up_yellow(2)			<=      "0000000000000000";
sprite_tail_up_yellow(3)			<=      "0000000000000000";
sprite_tail_up_yellow(4)			<=      "0000000000000000";
sprite_tail_up_yellow(5)			<=      "0000000000000000";
sprite_tail_up_yellow(6)			<=      "0000000000000000";
sprite_tail_up_yellow(7)			<=      "0000000000000000";
sprite_tail_up_yellow(8)			<=      "0001111111111000";
sprite_tail_up_yellow(9)			<=      "0000111111110000";
sprite_tail_up_yellow(10)			<=      "0000011111100000";
sprite_tail_up_yellow(11)			<=      "0000000110000000";
sprite_tail_up_yellow(12)			<=      "0000000000000000";
sprite_tail_up_yellow(13)			<=      "0000000000000000";
sprite_tail_up_yellow(14)			<=      "0000000000000000";
sprite_tail_up_yellow(15)			<=      "0000000000000000";
  

  -- sprite rabbit gray body coloring
  sprite_food_rabbit_y(0) 		<=	"0000100000010000";
  sprite_food_rabbit_y(1) 		<=	"0000110000110000";
  sprite_food_rabbit_y(2) 		<=	"0000111001110000";
  sprite_food_rabbit_y(3) 		<=	"0000101001010000";
  sprite_food_rabbit_y(4) 		<=	"0000101001010000";
  sprite_food_rabbit_y(5) 		<=	"0000101001010000";
  sprite_food_rabbit_y(6) 		<=	"0000111111110000";
  sprite_food_rabbit_y(7) 		<=	"0001100110011000";
  sprite_food_rabbit_y(8) 		<=	"0001100110011000";
  sprite_food_rabbit_y(9) 		<=	"0001100110011000";
  sprite_food_rabbit_y(10) 	<=	"0001111111111000";
  sprite_food_rabbit_y(11) 	<=	"0001111111111000";
  sprite_food_rabbit_y(12) 	<=	"0001110000111000";
  sprite_food_rabbit_y(13) 	<=	"0001111001111000";
  sprite_food_rabbit_y(14) 	<=	"0000111111110000";
  sprite_food_rabbit_y(15) 	<=	"0000011111100000";
  
    -- sprite rabbit blue eyeball coloring
  sprite_food_rabbit_b(0) 			<=	"0000000000000000";
  sprite_food_rabbit_b(1) 			<=	"0000000000000000";
  sprite_food_rabbit_b(2) 			<=	"0000000000000000";
  sprite_food_rabbit_b(3) 			<=	"0000000000000000";
  sprite_food_rabbit_b(4) 			<=	"0000000000000000";
  sprite_food_rabbit_b(5) 			<=	"0000000000000000";
  sprite_food_rabbit_b(6) 			<=	"0000000000000000";
  sprite_food_rabbit_b(7) 			<=	"0000000000000000";
  sprite_food_rabbit_b(8) 			<=	"0000001000100000";
  sprite_food_rabbit_b(9) 			<=	"0000001000100000";
  sprite_food_rabbit_b(10) 		<=	"0000000000000000";
  sprite_food_rabbit_b(11) 		<=	"0000000000000000";
  sprite_food_rabbit_b(12) 	   <=	"0000000000000000";
  sprite_food_rabbit_b(13) 	   <=	"0000000000000000";
  sprite_food_rabbit_b(14) 	   <=	"0000000000000000";
  sprite_food_rabbit_b(15) 	   <=	"0000000000000000";
  
  -- sprite rabbit pink nose coloring
  sprite_food_rabbit_p(0) 			<=	"0000000000000000";
  sprite_food_rabbit_p(1) 			<=	"0000000000000000";
  sprite_food_rabbit_p(2) 			<=	"0000010000100000";
  sprite_food_rabbit_p(3) 			<=	"0000010000100000";
  sprite_food_rabbit_p(4) 			<=	"0000010000100000";
  sprite_food_rabbit_p(5) 			<=	"0000000000000000";
  sprite_food_rabbit_p(6) 			<=	"0000000000000000";
  sprite_food_rabbit_p(7) 			<=	"0000000000000000";
  sprite_food_rabbit_p(8) 			<=	"0000000000000000";
  sprite_food_rabbit_p(9) 			<=	"0000000000000000";
  sprite_food_rabbit_p(10) 		<=	"0000000000000000";
  sprite_food_rabbit_p(11) 		<=	"0000000000000000";
  sprite_food_rabbit_p(12) 	   <=	"0000001111000000";
  sprite_food_rabbit_p(13) 	   <=	"0000000110000000";
  sprite_food_rabbit_p(14) 	   <=	"0000000000000000";
  sprite_food_rabbit_p(15) 	   <=	"0000000000000000";
  
   -- sprite rabbit eye white coloring
  sprite_food_rabbit_w(0) 			<=	"0000000000000000";
  sprite_food_rabbit_w(1) 			<=	"0000000000000000";
  sprite_food_rabbit_w(2) 			<=	"0000000000000000";
  sprite_food_rabbit_w(3) 			<=	"0000000000000000";
  sprite_food_rabbit_w(4) 			<=	"0000000000000000";
  sprite_food_rabbit_w(5) 			<=	"0000000000000000";
  sprite_food_rabbit_w(6) 			<=	"0000000000000000";
  sprite_food_rabbit_w(7) 			<=	"0000011001100000";
  sprite_food_rabbit_w(8) 			<=	"0000010001000000";
  sprite_food_rabbit_w(9) 			<=	"0000010001000000";
  sprite_food_rabbit_w(10) 		<=	"0000000000000000";
  sprite_food_rabbit_w(11) 		<=	"0000000000000000";
  sprite_food_rabbit_w(12) 	   <=	"0000000000000000";
  sprite_food_rabbit_w(13) 	   <=	"0000000000000000";
  sprite_food_rabbit_w(14) 	   <=	"0000000000000000";
  sprite_food_rabbit_w(15) 	   <=	"0000000000000000";
  
  -- sprite mouse gray body coloring
	sprite_food_mouse_y(0) 			<=	"0000100000010000";
	sprite_food_mouse_y(1) 			<=	"0001110000111000";
	sprite_food_mouse_y(2) 			<=	"0011111001111100";
	sprite_food_mouse_y(3) 			<=	"0110001001000110";
	sprite_food_mouse_y(4) 			<=	"0110001001000110";
	sprite_food_mouse_y(5) 			<=	"0110001001000110";
	sprite_food_mouse_y(6) 			<=	"0011111111111100";
	sprite_food_mouse_y(7) 			<=	"0011100110011000";
	sprite_food_mouse_y(8) 			<=	"0001100110011000";
	sprite_food_mouse_y(9) 			<=	"0001100110011000";
	sprite_food_mouse_y(10) 		<=	"0001111111111000";
	sprite_food_mouse_y(11) 		<=	"0001111111111000";
	sprite_food_mouse_y(12) 	  	<=	"0001000110001000";
	sprite_food_mouse_y(13) 	   <=	"0001111001111000";
	sprite_food_mouse_y(14) 	  	<=	"0000100110010000";
	sprite_food_mouse_y(15)			<=	"0000011111100000";

	-- sprite mouse pink coloring
	sprite_food_mouse_p(0) 			<=	"0000000000000000";
	sprite_food_mouse_p(1) 			<=	"0000000000000000";
	sprite_food_mouse_p(2) 			<=	"0000000000000000";
	sprite_food_mouse_p(3) 			<=	"0001110000111000";
	sprite_food_mouse_p(4) 			<=	"0001110000111000";
	sprite_food_mouse_p(5) 			<=	"0001110000111000";
	sprite_food_mouse_p(6) 			<=	"0000000000000000";
	sprite_food_mouse_p(7) 			<=	"0000000000000000";
	sprite_food_mouse_p(8) 			<=	"0000000000000000";
	sprite_food_mouse_p(9) 			<=	"0000000000000000";
	sprite_food_mouse_p(10) 		<=	"0000000000000000";
	sprite_food_mouse_p(11) 		<=	"0000000000000000";
	sprite_food_mouse_p(12) 	  	<=	"0000000000000000";
	sprite_food_mouse_p(13) 	   <=	"0000000000000000";
	sprite_food_mouse_p(14) 	  	<=	"0000000000000000";
	sprite_food_mouse_p(15)			<=	"0000000000000000";

	-- sprite mouse whisker black coloring
	sprite_food_mouse_l(0) 			<=	"0000000000000000";
	sprite_food_mouse_l(1) 			<=	"0000000000000000";
	sprite_food_mouse_l(2) 			<=	"0000000000000000";
	sprite_food_mouse_l(3) 			<=	"0000000000000000";
	sprite_food_mouse_l(4) 			<=	"0000000000000000";
	sprite_food_mouse_l(5) 			<=	"0000000000000000";
	sprite_food_mouse_l(6) 			<=	"0000000000000000";
	sprite_food_mouse_l(7) 			<=	"0000000000000000";
	sprite_food_mouse_l(8) 			<=	"0000000000000000";
	sprite_food_mouse_l(9) 			<=	"0000000000000000";
	sprite_food_mouse_l(10) 		<=	"0000000000000000";
	sprite_food_mouse_l(11) 		<=	"0000000000000000";
	sprite_food_mouse_l(12) 	  	<=	"0000111001110000";
	sprite_food_mouse_l(13) 	   <=	"0000000110000000";
	sprite_food_mouse_l(14) 	  	<=	"0000011001100000";
	sprite_food_mouse_l(15)			<=	"0000000000000000";
  
	-- sprite food edwards hair coloring
	sprite_food_edwards_n(0) 			<=	"0000000000000000";
	sprite_food_edwards_n(1) 			<=	"0000011111100000";
	sprite_food_edwards_n(2) 			<=	"0000111111110000";
	sprite_food_edwards_n(3) 			<=	"0001111111111000";
	sprite_food_edwards_n(4) 			<=	"0001111111111000";
	sprite_food_edwards_n(5) 			<=	"0001000000001000";
	sprite_food_edwards_n(6) 			<=	"0000000000000000";
	sprite_food_edwards_n(7) 			<=	"0000000000000000";
	sprite_food_edwards_n(8) 			<=	"0000000000000000";
	sprite_food_edwards_n(9) 			<=	"0000000000000000";
	sprite_food_edwards_n(10) 			<=	"0000000000000000";
	sprite_food_edwards_n(11) 			<=	"0000000000000000";
	sprite_food_edwards_n(12) 	  		<=	"0000000000000000";
	sprite_food_edwards_n(13) 	   		<=	"0000000000000000";
	sprite_food_edwards_n(14) 	  		<=	"0000000000000000";
	sprite_food_edwards_n(15)			<=	"0000000000000000";

	-- sprite food edwards skin coloring
	sprite_food_edwards_t(0) 			<=	"0000000000000000";
	sprite_food_edwards_t(1) 			<=	"0000000000000000";
	sprite_food_edwards_t(2) 			<=	"0000000000000000";
	sprite_food_edwards_t(3) 			<=	"0000000000000000";
	sprite_food_edwards_t(4) 			<=	"0000000000000000";
	sprite_food_edwards_t(5) 			<=	"0000111111110000";
	sprite_food_edwards_t(6) 			<=	"0001100110011000";
	sprite_food_edwards_t(7) 			<=	"0010000000000100";
	sprite_food_edwards_t(8) 			<=	"0011000000001100";
	sprite_food_edwards_t(9) 			<=	"0011000000001100";
	sprite_food_edwards_t(10) 			<=	"0001100110011000";
	sprite_food_edwards_t(11) 			<=	"0001111111111000";
	sprite_food_edwards_t(12) 	  		<=	"0001111001111000";
	sprite_food_edwards_t(13) 	   	<=	"0001111001111000";
	sprite_food_edwards_t(14) 	  		<=	"0000111111110000";
	sprite_food_edwards_t(15)			<=	"0000011111100000";

	-- sprite food edwards lips coloring
	sprite_food_edwards_p(0) 			<=	"0000000000000000";
	sprite_food_edwards_p(1) 			<=	"0000000000000000";
	sprite_food_edwards_p(2) 			<=	"0000000000000000";
	sprite_food_edwards_p(3) 			<=	"0000000000000000";
	sprite_food_edwards_p(4) 			<=	"0000000000000000";
	sprite_food_edwards_p(5) 			<=	"0000000000000000";
	sprite_food_edwards_p(6) 			<=	"0000000000000000";
	sprite_food_edwards_p(7) 			<=	"0000000000000000";
	sprite_food_edwards_p(8) 			<=	"0000000000000000";
	sprite_food_edwards_p(9) 			<=	"0000000000000000";
	sprite_food_edwards_p(10) 			<=	"0000000000000000";
	sprite_food_edwards_p(11) 			<=	"0000000000000000";
	sprite_food_edwards_p(12) 	  		<=	"0000000110000000";
	sprite_food_edwards_p(13) 	   	<=	"0000000110000000";
	sprite_food_edwards_p(14) 	  		<=	"0000000000000000";
	sprite_food_edwards_p(15)			<=	"0000000000000000";


	-- sprite food edwards glasses black coloring
	sprite_food_edwards_l(0) 			<=	"0000000000000000";
	sprite_food_edwards_l(1) 			<=	"0000000000000000";
	sprite_food_edwards_l(2) 			<=	"0000000000000000";
	sprite_food_edwards_l(3) 			<=	"0000000000000000";
	sprite_food_edwards_l(4) 			<=	"0000000000000000";
	sprite_food_edwards_l(5) 			<=	"0000000000000000";
	sprite_food_edwards_l(6) 			<=	"0010011001100100";
	sprite_food_edwards_l(7) 			<=	"0001100110011000";
	sprite_food_edwards_l(8) 			<=	"0000100110010000";
	sprite_food_edwards_l(9) 			<=	"0000100110010000";
	sprite_food_edwards_l(10) 			<=	"0000011001100000";
	sprite_food_edwards_l(11) 			<=	"0000000000000000";
	sprite_food_edwards_l(12) 	  		<=	"0000000000000000";
	sprite_food_edwards_l(13) 	   	<=	"0000000000000000";
	sprite_food_edwards_l(14) 	  		<=	"0000000000000000";
	sprite_food_edwards_l(15)			<=	"0000000000000000";

  
	-- sprite needle growth blood coloring
	sprite_powup_growth_r(0) 			<=	"0000000000000000";
	sprite_powup_growth_r(1) 			<=	"0000000000000000";
	sprite_powup_growth_r(2) 			<=	"0000000000000000";
	sprite_powup_growth_r(3) 			<=	"0000000000000000";
	sprite_powup_growth_r(4) 			<=	"0000000000000000";
	sprite_powup_growth_r(5) 			<=	"0000011000000000";
	sprite_powup_growth_r(6) 			<=	"0000011100000000";
	sprite_powup_growth_r(7) 			<=	"0000001110000000";
	sprite_powup_growth_r(8) 			<=	"0000000111000000";
	sprite_powup_growth_r(9) 			<=	"0000000011100000";
	sprite_powup_growth_r(10) 			<=	"0000000001100000";
	sprite_powup_growth_r(11) 			<=	"0000000000000000";
	sprite_powup_growth_r(12) 	  		<=	"0000000000000000";
	sprite_powup_growth_r(13) 	   	<=	"0000000000000000";
	sprite_powup_growth_r(14) 	  		<=	"0000000000000000";
	sprite_powup_growth_r(15)			<=	"0000000000000000";

	-- sprite needle growth gray coloring
	sprite_powup_growth_y(0) 			<=	"1000000000000000";
	sprite_powup_growth_y(1) 			<=	"0100000000000000";
	sprite_powup_growth_y(2) 			<=	"0010000000000000";
	sprite_powup_growth_y(3) 			<=	"0001000000000000";
	sprite_powup_growth_y(4) 			<=	"0000111000000000";
	sprite_powup_growth_y(5) 			<=	"0000100100000000";
	sprite_powup_growth_y(6) 			<=	"0000100010000000";
	sprite_powup_growth_y(7) 			<=	"0000010001000000";
	sprite_powup_growth_y(8) 			<=	"0000001000100000";
	sprite_powup_growth_y(9) 			<=	"0000000100010100";
	sprite_powup_growth_y(10) 			<=	"0000000010011000";
	sprite_powup_growth_y(11) 			<=	"0000000001110000";
	sprite_powup_growth_y(12) 	  		<=	"0000000000101000";
	sprite_powup_growth_y(13) 	   	<=	"0000000001000111";
	sprite_powup_growth_y(14) 	  		<=	"0000000000000110";
	sprite_powup_growth_y(15)			<=	"0000000000000100";

	-- sprite lightning coloring
	sprite_powup_speed(0) 			<=	"0000000011111111";
	sprite_powup_speed(1) 			<=	"0000000111111110";
	sprite_powup_speed(2) 			<=	"0000001111111100";
	sprite_powup_speed(3) 			<=	"0000011111111000";
	sprite_powup_speed(4) 			<=	"0000111111110000";
	sprite_powup_speed(5) 			<=	"0001111111100000";
	sprite_powup_speed(6) 			<=	"0011111111111110";
	sprite_powup_speed(7) 			<=	"0011111111111100";
	sprite_powup_speed(8) 			<=	"0011111111111000";
	sprite_powup_speed(9) 			<=	"0000011111110000";
	sprite_powup_speed(10) 			<=	"0000011111100000";
	sprite_powup_speed(11) 			<=	"0000111111000000";
	sprite_powup_speed(12) 	  		<=	"0000111111000000";
	sprite_powup_speed(13) 	   	<=	"0000111110000000";
	sprite_powup_speed(14) 	  		<=	"0001111000000000";
	sprite_powup_speed(15)			<=	"0001110000000000";

	-- sprite ice freeze coloring
	sprite_powup_freeze(0) 			<=	"1100001000100011";
	sprite_powup_freeze(1) 			<=	"0110011000110110";
	sprite_powup_freeze(2) 			<=	"0011110000011100";
	sprite_powup_freeze(3) 			<=	"0001100000011110";
	sprite_powup_freeze(4) 			<=	"0011110000110011";
	sprite_powup_freeze(5) 			<=	"0110011001100000";
	sprite_powup_freeze(6) 			<=	"1100001111000000";
	sprite_powup_freeze(7) 			<=	"0000000110000000";
	sprite_powup_freeze(8) 			<=	"0000000110000000";
	sprite_powup_freeze(9) 			<=	"0000001111000000";
	sprite_powup_freeze(10) 		<=	"0000011001100000";
	sprite_powup_freeze(11) 		<=	"1100110000110011";
	sprite_powup_freeze(12) 	  	<=	"0111100000011110";
	sprite_powup_freeze(13) 	   <=	"0011100000011100";
	sprite_powup_freeze(14) 	  	<=	"0110110000110110";
	sprite_powup_freeze(15)			<=	"1100010000100011";

	
		-- sprite brick wall coloring
	sprite_wall(0) 			<=	"1111101111101111";
	sprite_wall(1) 			<=	"1111101111101111";
	sprite_wall(2) 			<=	"1111101111101111";
	sprite_wall(3) 			<=	"1111101111101111";
	sprite_wall(4) 			<=	"0000000000000000";
	sprite_wall(5) 			<=	"1011111011111011";
	sprite_wall(6) 			<=	"1011111011111011";
	sprite_wall(7) 			<=	"1011111011111011";
	sprite_wall(8) 			<=	"0000000000000000";
	sprite_wall(9) 			<=	"1111011111011111";
	sprite_wall(10) 			<=	"1111011111011111";
	sprite_wall(11) 			<=	"1111011111011111";
	sprite_wall(12) 	  		<=	"0000000000000000";
	sprite_wall(13) 	   	<=	"1111101111101111";
	sprite_wall(14) 	  		<=	"1111101111101111";
	sprite_wall(15)			<=	"1111101111101111";

	-- sprite letter p
	sprite_P(0) 			<=	"0000000000000000";
	sprite_P(1) 			<=	"0000011111100000";
	sprite_P(2) 			<=	"0000111111110000";
	sprite_P(3) 			<=	"0000110001110000";
	sprite_P(4) 			<=	"0000110000110000";
	sprite_P(5) 			<=	"0000110000110000";
	sprite_P(6) 			<=	"0000110001110000";
	sprite_P(7) 			<=	"0000110011110000";
	sprite_P(8) 			<=	"0000111111100000";
	sprite_P(9) 			<=	"0000111111000000";
	sprite_P(10) 			<=	"0000110000000000";
	sprite_P(11) 			<=	"0000110000000000";
	sprite_P(12) 	  		<=	"0000110000000000";
	sprite_P(13) 	   	<=	"0000110000000000";
	sprite_P(14) 	  		<=	"0000110000000000";
	sprite_P(15)			<=	"0000000000000000";

	-- sprite number 1
	sprite_1(0) 			<=	"0000000000000000";
	sprite_1(1) 			<=	"0000001111000000";
	sprite_1(2) 			<=	"0000011111000000";
	sprite_1(3) 			<=	"0000111111000000";
	sprite_1(4) 			<=	"0000110111000000";
	sprite_1(5) 			<=	"0000000111000000";
	sprite_1(6) 			<=	"0000000111000000";
	sprite_1(7) 			<=	"0000000111000000";
	sprite_1(8) 			<=	"0000000111000000";
	sprite_1(9) 			<=	"0000000111000000";
	sprite_1(10) 			<=	"0000000111000000";
	sprite_1(11) 			<=	"0000000111000000";
	sprite_1(12) 	  		<=	"0000011111110000";
	sprite_1(13) 	   	<=	"0000011111110000";
	sprite_1(14) 	  		<=	"0000011111110000";
	sprite_1(15)			<=	"0000000000000000";

	-- sprite number 2
	sprite_2(0) 			<=	"0000000000000000";
	sprite_2(1) 			<=	"0000001111100000";
	sprite_2(2) 			<=	"0000011111110000";
	sprite_2(3) 			<=	"0000111000110000";
	sprite_2(4) 			<=	"0000110000110000";
	sprite_2(5) 			<=	"0000000001110000";
	sprite_2(6) 			<=	"0000000001110000";
	sprite_2(7) 			<=	"0000000011100000";
	sprite_2(8) 			<=	"0000000111000000";
	sprite_2(9) 			<=	"0000001110000000";
	sprite_2(10) 			<=	"0000001110000000";
	sprite_2(11) 			<=	"0000011100000000";
	sprite_2(12) 	  		<=	"0000111000000000";
	sprite_2(13) 	   	<=	"0000111111110000";
	sprite_2(14) 	  		<=	"0000111111110000";
	sprite_2(15)			<=	"0000000000000000";

	-- sprite letter W
	sprite_W(0) 			<=	"0000000000000000";
	sprite_W(1) 			<=	"0010000000001000";
	sprite_W(2) 			<=	"0110000000001100";
	sprite_W(3) 			<=	"0110000100001100";
	sprite_W(4) 			<=	"0110001110001100";
	sprite_W(5) 			<=	"0110001110001100";
	sprite_W(6) 			<=	"0110001110001100";
	sprite_W(7) 			<=	"0110011111001100";
	sprite_W(8) 			<=	"0110011011001100";
	sprite_W(9) 			<=	"0110011011001100";
	sprite_W(10) 			<=	"0111011011011100";
	sprite_W(11) 			<=	"0111111011111100";
	sprite_W(12) 	  		<=	"0111111011111100";
	sprite_W(13) 	   	<=	"0011110001111000";
	sprite_W(14) 	  		<=	"0001100000110000";
	sprite_W(15)			<=	"0000000000000000";

	-- sprite letter I
	sprite_I(0) 			<=	"0000000000000000";
	sprite_I(1) 			<=	"0000111111110000";
	sprite_I(2) 			<=	"0000111111110000";
	sprite_I(3) 			<=	"0000000110000000";
	sprite_I(4) 			<=	"0000000110000000";
	sprite_I(5) 			<=	"0000000110000000";
	sprite_I(6) 			<=	"0000000110000000";
	sprite_I(7) 			<=	"0000000110000000";
	sprite_I(8) 			<=	"0000000110000000";
	sprite_I(9) 			<=	"0000000110000000";
	sprite_I(10) 			<=	"0000000110000000";
	sprite_I(11) 			<=	"0000000110000000";
	sprite_I(12) 	  		<=	"0000000110000000";
	sprite_I(13) 	   	<=	"0000111111110000";
	sprite_I(14) 	  		<=	"0000111111110000";
	sprite_I(15)			<=	"0000000000000000";

	-- sprite letter N
	sprite_N(0) 			<=	"0000000000000000";
	sprite_N(1) 			<=	"0001100000011000";
	sprite_N(2) 			<=	"0001110000011000";
	sprite_N(3) 			<=	"0001110000011000";
	sprite_N(4) 			<=	"0001111000011000";
	sprite_N(5) 			<=	"0001111100011000";
	sprite_N(6) 			<=	"0001101110011000";
	sprite_N(7) 			<=	"0001101110011000";
	sprite_N(8) 			<=	"0001100111011000";
	sprite_N(9) 			<=	"0001100011111000";
	sprite_N(10) 			<=	"0001100011111000";
	sprite_N(11) 			<=	"0001100001111000";
	sprite_N(12) 	  		<=	"0001100000111000";
	sprite_N(13) 	   	<=	"0001100000011000";
	sprite_N(14) 	  		<=	"0000000000000000";
	sprite_N(15)			<=	"0000000000000000";

	-- sprite letter S
	sprite_S(0) 			<=	"0000011111000000";
	sprite_S(1) 			<=	"0000111111110000";
	sprite_S(2) 			<=	"0001110011111000";
	sprite_S(3) 			<=	"0011100000111000";
	sprite_S(4) 			<=	"0011100000000000";
	sprite_S(5) 			<=	"0001110000000000";
	sprite_S(6) 			<=	"0000111000000000";
	sprite_S(7) 			<=	"0000111110000000";
	sprite_S(8) 			<=	"0000001111100000";
	sprite_S(9) 			<=	"0000000001110000";
	sprite_S(10) 			<=	"0000000000111000";
	sprite_S(11) 			<=	"0011100000111000";
	sprite_S(12) 	  		<=	"0011100001110000";
	sprite_S(13) 	   	<=	"0001110011100000";
	sprite_S(14) 	  		<=	"0000111111000000";
	sprite_S(15)			<=	"0000011110000000";

	-- sprite exclamation point
	sprite_exclam(0) 			<=	"0000000110000000";
	sprite_exclam(1) 			<=	"0000001111000000";
	sprite_exclam(2) 			<=	"0000001111000000";
	sprite_exclam(3) 			<=	"0000001111000000";
	sprite_exclam(4) 			<=	"0000001111000000";
	sprite_exclam(5) 			<=	"0000001111000000";
	sprite_exclam(6) 			<=	"0000001111000000";
	sprite_exclam(7) 			<=	"0000001111000000";
	sprite_exclam(8) 			<=	"0000001111000000";
	sprite_exclam(9) 			<=	"0000000110000000";
	sprite_exclam(10) 		<=	"0000000110000000";
	sprite_exclam(11) 		<=	"0000000000000000";
	sprite_exclam(12) 	  	<=	"0000000110000000";
	sprite_exclam(13) 	   <=	"0000001111000000";
	sprite_exclam(14) 	  	<=	"0000001111000000";
	sprite_exclam(15)			<=	"0000000110000000";

	-- sprite pause button
	sprite_pause(0) 			<=	"0000000000000000";
	sprite_pause(1) 			<=	"0001110000111000";
	sprite_pause(2) 			<=	"0001110000111000";
	sprite_pause(3) 			<=	"0001110000111000";
	sprite_pause(4) 			<=	"0001110000111000";
	sprite_pause(5) 			<=	"0001110000111000";
	sprite_pause(6) 			<=	"0001110000111000";
	sprite_pause(7) 			<=	"0001110000111000";
	sprite_pause(8) 			<=	"0001110000111000";
	sprite_pause(9) 			<=	"0001110000111000";
	sprite_pause(10) 			<=	"0001110000111000";
	sprite_pause(11) 			<=	"0001110000111000";
	sprite_pause(12) 	  		<=	"0001110000111000";
	sprite_pause(13) 	   	<=	"0001110000111000";
	sprite_pause(14) 	  		<=	"0001110000111000";
	sprite_pause(15)			<=	"0000000000000000";

	-- sprite play button
	sprite_play(0) 			<=	"0001100000000000";
	sprite_play(1) 			<=	"0001110000000000";
	sprite_play(2) 			<=	"0001111000000000";
	sprite_play(3) 			<=	"0001111100000000";
	sprite_play(4) 			<=	"0001111110000000";
	sprite_play(5) 			<=	"0001111111000000";
	sprite_play(6) 			<=	"0001111111100000";
	sprite_play(7) 			<=	"0001111111110000";
	sprite_play(8) 			<=	"0001111111110000";
	sprite_play(9) 			<=	"0001111111100000";
	sprite_play(10) 			<=	"0001111111000000";
	sprite_play(11) 			<=	"0001111110000000";
	sprite_play(12) 	  		<=	"0001111100000000";
	sprite_play(13) 	   	<=	"0001111000000000";
	sprite_play(14) 	  		<=	"0001110000000000";
	sprite_play(15)			<=	"0001100000000000";
	  
  
  end rtl;
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
--  	-- sprite snake head coloring
--  sprite_snake_head_g(0) 			<=	"0000111100000000";
--  sprite_snake_head_g(1) 			<=	"0001111111000000";
--  sprite_snake_head_g(2) 			<=	"0011111111110000";
--  sprite_snake_head_g(3) 			<=	"0111111111111000";
--  sprite_snake_head_g(4) 			<=	"0111111111111100";
--  sprite_snake_head_g(5) 			<=	"1111100011111100";
--  sprite_snake_head_g(6) 			<=	"1111100011111110";
--  sprite_snake_head_g(7) 			<=	"1111100011111100";
--  sprite_snake_head_g(8) 			<=	"1111111111100000";
--  sprite_snake_head_g(9) 			<=	"1111111111100000";
--  sprite_snake_head_g(10) 			<=	"1111111111111100";
--  sprite_snake_head_g(11) 			<=	"0111111111111110";
--  sprite_snake_head_g(12) 	   	<=	"0111111111111000";
--  sprite_snake_head_g(13) 	   	<=	"0011111111110000";
--  sprite_snake_head_g(14) 	   	<=	"0001111111000000";
--  sprite_snake_head_g(15) 	   	<=	"0000111100000000";
--  
--  -- sprite snake head tongue coloring
--  sprite_snake_head_r(0) 			<=	"0000000000000000";
--  sprite_snake_head_r(1) 			<=	"0000000000000000";
--  sprite_snake_head_r(2) 			<=	"0000000000000000";
--  sprite_snake_head_r(3) 			<=	"0000000000000000";
--  sprite_snake_head_r(4) 	  		<=	"0000000000000000";
--  sprite_snake_head_r(5) 			<=	"0000000000000000";
--  sprite_snake_head_r(6) 			<=	"0000000000000000";
--  sprite_snake_head_r(7) 			<=	"0000000000000011";
--  sprite_snake_head_r(8) 			<=	"0000000000011110";
--  sprite_snake_head_r(9) 			<=	"0000000000011110";
--  sprite_snake_head_r(10) 			<=	"0000000000000011";
--  sprite_snake_head_r(11) 			<=	"0000000000000000";
--  sprite_snake_head_r(12) 	   	<=	"0000000000000000";
--  sprite_snake_head_r(13) 	   	<=	"0000000000000000";
--  sprite_snake_head_r(14) 	   	<=	"0000000000000000";
--  sprite_snake_head_r(15) 	  	 	<= "0000000000000000";
--  
--  -- sprite snake head eye white coloring
--  sprite_snake_head_w(0) 			<=	"0000000000000000";
--  sprite_snake_head_w(1) 			<=	"0000000000000000";
--  sprite_snake_head_w(2) 			<=	"0000000000000000";
--  sprite_snake_head_w(3) 			<=	"0000000000000000";
--  sprite_snake_head_w(4) 			<= "0000000000000000";
--  sprite_snake_head_w(5) 			<=	"0000011100000000";
--  sprite_snake_head_w(6) 			<=	"0000010000000000";
--  sprite_snake_head_w(7) 			<=	"0000010000000000";
--  sprite_snake_head_w(8) 			<=	"0000000000000000";
--  sprite_snake_head_w(9) 			<=	"0000000000000000";
--  sprite_snake_head_w(10) 			<=	"0000000000000000";
--  sprite_snake_head_w(11) 			<=	"0000000000000000";
--  sprite_snake_head_w(12) 	  	 	<=	"0000000000000000";
--  sprite_snake_head_w(13) 	  	 	<=	"0000000000000000";
--  sprite_snake_head_w(14) 	  	 	<=	"0000000000000000";
--  sprite_snake_head_w(15) 	  	 	<=	"0000000000000000";
--  
--    -- sprite snake head eye black coloring
--  sprite_snake_head_b(0) 			<=	"0000000000000000";
--  sprite_snake_head_b(1) 			<=	"0000000000000000";
--  sprite_snake_head_b(2) 			<=	"0000000000000000";
--  sprite_snake_head_b(3) 			<=	"0000000000000000";
--  sprite_snake_head_b(4) 			<=	"0000000000000000";
--  sprite_snake_head_b(5) 			<=	"0000000000000000";
--  sprite_snake_head_b(6) 			<=	"0000001100000000";
--  sprite_snake_head_b(7) 			<=	"0000001100000000";
--  sprite_snake_head_b(8) 			<=	"0000000000000000";
--  sprite_snake_head_b(9) 			<=	"0000000000000000";
--  sprite_snake_head_b(10) 			<=	"0000000000000000";
--  sprite_snake_head_b(11) 			<=	"0000000000000000";
--  sprite_snake_head_b(12) 	  	 	<=	"0000000000000000";
--  sprite_snake_head_b(13) 	  	 	<=	"0000000000000000";
--  sprite_snake_head_b(14) 	  	 	<=	"0000000000000000";
--  sprite_snake_head_b(15) 	  	 	<=	"0000000000000000";
--  
--  	-- sprite snake head left facing coloring
--  sprite_snake_head_g_left(0) 			<=	"0000000011110000";
--  sprite_snake_head_g_left(1) 			<=	"0000001111111000";
--  sprite_snake_head_g_left(2)				<= "0000111111111100";
--  sprite_snake_head_g_left(3) 			<=	"0001111111111110";
--  sprite_snake_head_g_left(4) 			<=	"0011111111111110";
--  sprite_snake_head_g_left(5) 			<=	"0011111100011111";
--  sprite_snake_head_g_left(6) 			<=	"0111111100011111";
--  sprite_snake_head_g_left(7) 			<=	"0011111100011111";
--  sprite_snake_head_g_left(8) 			<=	"0000011111111111";
--  sprite_snake_head_g_left(9) 			<=	"0000011111111111";
--  sprite_snake_head_g_left(10) 			<=	"0011111111111111";
--  sprite_snake_head_g_left(11) 			<=	"0111111111111110";
--  sprite_snake_head_g_left(12) 	   	<=	"0001111111111110";
--  sprite_snake_head_g_left(13) 	   	<=	"0000111111111100";
--  sprite_snake_head_g_left(14) 	   	<=	"0000001111111000";
--  sprite_snake_head_g_left(15) 	   	<=	"0000000011110000";
--  
--  -- sprite snake head left facing tongue coloring
--  sprite_snake_head_r_left(0) 			<=	"0000000000000000";
--  sprite_snake_head_r_left(1) 			<=	"0000000000000000";
--  sprite_snake_head_r_left(2) 			<=	"0000000000000000";
--  sprite_snake_head_r_left(3) 			<=	"0000000000000000";
--  sprite_snake_head_r_left(4) 	  		<=	"0000000000000000";
--  sprite_snake_head_r_left(5) 			<=	"0000000000000000";
--  sprite_snake_head_r_left(6) 			<=	"0000000000000000";
--  sprite_snake_head_r_left(7) 			<=	"1100000000000000";
--  sprite_snake_head_r_left(8) 			<=	"0111100000000000";
--  sprite_snake_head_r_left(9) 			<=	"0111100000000000";
--  sprite_snake_head_r_left(10) 			<=	"1100000000000000";
--  sprite_snake_head_r_left(11) 			<=	"0000000000000000";
--  sprite_snake_head_r_left(12) 	   	<=	"0000000000000000";
--  sprite_snake_head_r_left(13) 	   	<=	"0000000000000000";
--  sprite_snake_head_r_left(14) 	   	<=	"0000000000000000";
--  sprite_snake_head_r_left(15) 	  	 	<= "0000000000000000";
--  
--  -- sprite snake head left facing eye white coloring
--  sprite_snake_head_w_left(0) 			<=	"0000000000000000";
--  sprite_snake_head_w_left(1) 			<=	"0000000000000000";
--  sprite_snake_head_w_left(2) 			<=	"0000000000000000";
--  sprite_snake_head_w_left(3) 			<=	"0000000000000000";
--  sprite_snake_head_w_left(4) 			<= "0000000000000000";
--  sprite_snake_head_w_left(5) 			<=	"0000000011100000";
--  sprite_snake_head_w_left(6) 			<=	"0000000000100000";
--  sprite_snake_head_w_left(7) 			<=	"0000000000100000";
--  sprite_snake_head_w_left(8) 			<=	"0000000000000000";
--  sprite_snake_head_w_left(9) 			<=	"0000000000000000";
--  sprite_snake_head_w_left(10) 			<=	"0000000000000000";
--  sprite_snake_head_w_left(11) 			<=	"0000000000000000";
--  sprite_snake_head_w_left(12) 	  	 	<=	"0000000000000000";
--  sprite_snake_head_w_left(13) 	  	 	<=	"0000000000000000";
--  sprite_snake_head_w_left(14) 	  	 	<=	"0000000000000000";
--  sprite_snake_head_w_left(15) 	  	 	<=	"0000000000000000";
--  
--    -- sprite snake head left facing eye black coloring
--  sprite_snake_head_b_left(0) 			<=	"0000000000000000";
--  sprite_snake_head_b_left(1) 			<=	"0000000000000000";
--  sprite_snake_head_b_left(2) 			<=	"0000000000000000";
--  sprite_snake_head_b_left(3) 			<=	"0000000000000000";
--  sprite_snake_head_b_left(4) 			<=	"0000000000000000";
--  sprite_snake_head_b_left(5) 			<=	"0000000000000000";
--  sprite_snake_head_b_left(6) 			<=	"0000000011000000";
--  sprite_snake_head_b_left(7) 			<=	"0000000011000000";
--  sprite_snake_head_b_left(8) 			<=	"0000000000000000";
--  sprite_snake_head_b_left(9) 			<=	"0000000000000000";
--  sprite_snake_head_b_left(10) 			<=	"0000000000000000";
--  sprite_snake_head_b_left(11) 			<=	"0000000000000000";
--  sprite_snake_head_b_left(12) 	  	 	<=	"0000000000000000";
--  sprite_snake_head_b_left(13) 	  	 	<=	"0000000000000000";
--  sprite_snake_head_b_left(14) 	  	 	<=	"0000000000000000";
--  sprite_snake_head_b_left(15) 	  	 	<=	"0000000000000000";
--  
--    	-- sprite snake head upwards facing coloring
--  sprite_snake_head_g_up(0) 			<=	"0000000000000000";
--  sprite_snake_head_g_up(1) 			<=	"0000001000010000";
--  sprite_snake_head_g_up(2) 			<=	"0000111100110000";
--  sprite_snake_head_g_up(3) 			<=	"0001111100111000";
--  sprite_snake_head_g_up(4) 			<=	"0011111100111100";
--  sprite_snake_head_g_up(5) 			<=	"0011111111111100";
--  sprite_snake_head_g_up(6) 			<=	"0111111111111110";
--  sprite_snake_head_g_up(7) 			<=	"0111111111111110";
--  sprite_snake_head_g_up(8) 			<=	"1111100011111111";
--  sprite_snake_head_g_up(9) 			<=	"1111100011111111";
--  sprite_snake_head_g_up(10) 			<=	"1111100011111111";
--  sprite_snake_head_g_up(11) 			<=	"1111111111111111";
--  sprite_snake_head_g_up(12) 	   	<=	"0111111111111110";
--  sprite_snake_head_g_up(13) 	   	<=	"0011111111111100";
--  sprite_snake_head_g_up(14) 	   	<=	"0001111111111000";
--  sprite_snake_head_g_up(15) 	   	<=	"0000011111100000";
--  
--  -- sprite snake head upwards facing tongue coloring
--  sprite_snake_head_r_up(0) 			<=	"0000000100100000";
--  sprite_snake_head_r_up(1) 			<=	"0000000111100000";
--  sprite_snake_head_r_up(2) 			<=	"0000000011000000";
--  sprite_snake_head_r_up(3) 			<=	"0000000011000000";
--  sprite_snake_head_r_up(4) 	  		<=	"0000000011000000";
--  sprite_snake_head_r_up(5) 			<=	"0000000000000000";
--  sprite_snake_head_r_up(6) 			<=	"0000000000000000";
--  sprite_snake_head_r_up(7) 			<=	"0000000000000000";
--  sprite_snake_head_r_up(8) 			<=	"0000000000000000";
--  sprite_snake_head_r_up(9) 			<=	"0000000000000000";
--  sprite_snake_head_r_up(10) 			<=	"0000000000000000";
--  sprite_snake_head_r_up(11) 			<=	"0000000000000000";
--  sprite_snake_head_r_up(12) 	   	<=	"0000000000000000";
--  sprite_snake_head_r_up(13) 	   	<=	"0000000000000000";
--  sprite_snake_head_r_up(14) 	   	<=	"0000000000000000";
--  sprite_snake_head_r_up(15) 	  	 	<= "0000000000000000";
--  
--  -- sprite snake head upwards facing eye white coloring
--  sprite_snake_head_w_up(0) 			<=	"0000000000000000";
--  sprite_snake_head_w_up(1) 			<=	"0000000000000000";
--  sprite_snake_head_w_up(2) 			<=	"0000000000000000";
--  sprite_snake_head_w_up(3) 			<=	"0000000000000000";
--  sprite_snake_head_w_up(4) 			<= "0000000000000000";
--  sprite_snake_head_w_up(5) 			<=	"0000000000000000";
--  sprite_snake_head_w_up(6) 			<=	"0000000000000000";
--  sprite_snake_head_w_up(7) 			<=	"0000010000000000";
--  sprite_snake_head_w_up(8) 			<=	"0000010000000000";
--  sprite_snake_head_w_up(9) 			<=	"0000011100000000";
--  sprite_snake_head_w_up(10) 			<=	"0000000000000000";
--  sprite_snake_head_w_up(11) 			<=	"0000000000000000";
--  sprite_snake_head_w_up(12) 	  	 	<=	"0000000000000000";
--  sprite_snake_head_w_up(13) 	  	 	<=	"0000000000000000";
--  sprite_snake_head_w_up(14) 	  	 	<=	"0000000000000000";
--  sprite_snake_head_w_up(15) 	  	 	<=	"0000000000000000";
--  
--    -- sprite snake head upwards facing eye black coloring
--  sprite_snake_head_b_up(0) 			<=	"0000000000000000";
--  sprite_snake_head_b_up(1) 			<=	"0000000000000000";
--  sprite_snake_head_b_up(2) 			<=	"0000000000000000";
--  sprite_snake_head_b_up(3) 			<=	"0000000000000000";
--  sprite_snake_head_b_up(4) 			<=	"0000000000000000";
--  sprite_snake_head_b_up(5) 			<=	"0000000000000000";
--  sprite_snake_head_b_up(6) 			<=	"0000000000000000";
--  sprite_snake_head_b_up(7) 			<=	"0000000000000000";
--  sprite_snake_head_b_up(8) 			<=	"0000001100000000";
--  sprite_snake_head_b_up(9) 			<=	"0000001100000000";
--  sprite_snake_head_b_up(10) 			<=	"0000000000000000";
--  sprite_snake_head_b_up(11) 			<=	"0000000000000000";
--  sprite_snake_head_b_up(12) 	  	 	<=	"0000000000000000";
--  sprite_snake_head_b_up(13) 	  	 	<=	"0000000000000000";
--  sprite_snake_head_b_up(14) 	  	 	<=	"0000000000000000";
--  sprite_snake_head_b_up(15) 	  	 	<=	"0000000000000000";
--  
--      	-- sprite snake head downwards facing coloring
--  sprite_snake_head_g_down(0) 			<=	"0000011111100000";
--  sprite_snake_head_g_down(1) 			<=	"0001111111111000";
--  sprite_snake_head_g_down(2) 			<=	"0011111111111100";
--  sprite_snake_head_g_down(3) 			<=	"0111111111111110";
--  sprite_snake_head_g_down(4) 			<=	"1111111111111111";
--  sprite_snake_head_g_down(5) 			<=	"1111100011111111";
--  sprite_snake_head_g_down(6) 			<=	"1111100011111111";
--  sprite_snake_head_g_down(7) 			<=	"1111100011111111";
--  sprite_snake_head_g_down(8) 			<=	"0111111111111110";
--  sprite_snake_head_g_down(9) 			<=	"0111111111111110";
--  sprite_snake_head_g_down(10) 			<=	"0011111111111100";
--  sprite_snake_head_g_down(11) 			<=	"0011111100111100";
--  sprite_snake_head_g_down(12) 	   	<=	"0001111100111000";
--  sprite_snake_head_g_down(13) 	   	<=	"0000111100110000";
--  sprite_snake_head_g_down(14) 	   	<=	"0000001000010000";
--  sprite_snake_head_g_down(15) 	   	<=	"0000000000000000";
--  
--  -- sprite snake head downwards facing tongue coloring
--  sprite_snake_head_r_down(0) 			<=	"0000000000000000";
--  sprite_snake_head_r_down(1) 			<=	"0000000000000000";
--  sprite_snake_head_r_down(2) 			<=	"0000000000000000";
--  sprite_snake_head_r_down(3) 			<=	"0000000000000000";
--  sprite_snake_head_r_down(4) 	  		<=	"0000000000000000";
--  sprite_snake_head_r_down(5) 			<=	"0000000000000000";
--  sprite_snake_head_r_down(6) 			<=	"0000000000000000";
--  sprite_snake_head_r_down(7) 			<=	"0000000000000000";
--  sprite_snake_head_r_down(8) 			<=	"0000000000000000";
--  sprite_snake_head_r_down(9) 			<=	"0000000000000000";
--  sprite_snake_head_r_down(10) 			<=	"0000000000000000";
--  sprite_snake_head_r_down(11) 			<=	"0000001100000000";
--  sprite_snake_head_r_down(12) 	   	<=	"0000001100000000";
--  sprite_snake_head_r_down(13) 	   	<=	"0000001100000000";
--  sprite_snake_head_r_down(14) 	   	<=	"0000011110000000";
--  sprite_snake_head_r_down(15) 	  	 	<= "0000010010000000";
--  
--  -- sprite snake head downwards facing eye white coloring
--  sprite_snake_head_w_down(0) 			<=	"0000000000000000";
--  sprite_snake_head_w_down(1) 			<=	"0000000000000000";
--  sprite_snake_head_w_down(2) 			<=	"0000000000000000";
--  sprite_snake_head_w_down(3) 			<=	"0000000000000000";
--  sprite_snake_head_w_down(4) 			<= "0000000000000000";
--  sprite_snake_head_w_down(5) 			<=	"0000011100000000";
--  sprite_snake_head_w_down(6) 			<=	"0000000100000000";
--  sprite_snake_head_w_down(7) 			<=	"0000000100000000";
--  sprite_snake_head_w_down(8) 			<=	"0000000000000000";
--  sprite_snake_head_w_down(9) 			<=	"0000000000000000";
--  sprite_snake_head_w_down(10) 			<=	"0000000000000000";
--  sprite_snake_head_w_down(11) 			<=	"0000000000000000";
--  sprite_snake_head_w_down(12) 	  	 	<=	"0000000000000000";
--  sprite_snake_head_w_down(13) 	  	 	<=	"0000000000000000";
--  sprite_snake_head_w_down(14) 	  	 	<=	"0000000000000000";
--  sprite_snake_head_w_down(15) 	  	 	<=	"0000000000000000";
--  
--    -- sprite snake head downwards facing eye black coloring
--  sprite_snake_head_b_down(0) 			<=	"0000000000000000";
--  sprite_snake_head_b_down(1) 			<=	"0000000000000000";
--  sprite_snake_head_b_down(2) 			<=	"0000000000000000";
--  sprite_snake_head_b_down(3) 			<=	"0000000000000000";
--  sprite_snake_head_b_down(4) 			<=	"0000000000000000";
--  sprite_snake_head_b_down(5) 			<=	"0000000000000000";
--  sprite_snake_head_b_down(6) 			<=	"0000011000000000";
--  sprite_snake_head_b_down(7) 			<=	"0000011000000000";
--  sprite_snake_head_b_down(8) 			<=	"0000000000000000";
--  sprite_snake_head_b_down(9) 			<=	"0000000000000000";
--  sprite_snake_head_b_down(10) 			<=	"0000000000000000";
--  sprite_snake_head_b_down(11) 			<=	"0000000000000000";
--  sprite_snake_head_b_down(12) 	  	 	<=	"0000000000000000";
--  sprite_snake_head_b_down(13) 	  	 	<=	"0000000000000000";
--  sprite_snake_head_b_down(14) 	  	 	<=	"0000000000000000";
--  sprite_snake_head_b_down(15) 	  	 	<=	"0000000000000000";


--  -- sprite snake tail coloring
--  sprite_snake_tail(0) 			<=	"0000000000110000";
--  sprite_snake_tail(1) 			<=	"0000000011111000";
--  sprite_snake_tail(2) 			<=	"0000001111111100";
--  sprite_snake_tail(3) 			<=	"0000111111111100";
--  sprite_snake_tail(4) 			<=	"0001111111111110";
--  sprite_snake_tail(5) 			<=	"0011111111111110";
--  sprite_snake_tail(6) 			<=	"0111111111111111";
--  sprite_snake_tail(7) 			<=	"1111111111111111";
--  sprite_snake_tail(8) 			<=	"1111111111111111";
--  sprite_snake_tail(9) 			<=	"0111111111111111";
--  sprite_snake_tail(10) 		<=	"0011111111111110";
--  sprite_snake_tail(11) 		<=	"0001111111111110";
--  sprite_snake_tail(12) 	   <=	"0000111111111100";
--  sprite_snake_tail(13) 	   <=	"0000001111111100";
--  sprite_snake_tail(14) 	   <=	"0000000011111000";
--  sprite_snake_tail(15) 	   <=	"0000000000110000";
--  
--   -- sprite snake tail left facing coloring
--  sprite_snake_tail_left(0) 			<=	"0000110000000000";
--  sprite_snake_tail_left(1) 			<=	"0001111100000000";
--  sprite_snake_tail_left(2) 			<=	"0011111111000000";
--  sprite_snake_tail_left(3) 			<=	"0011111111110000";
--  sprite_snake_tail_left(4) 			<=	"0111111111111000";
--  sprite_snake_tail_left(5) 			<=	"0111111111111100";
--  sprite_snake_tail_left(6) 			<=	"1111111111111110";
--  sprite_snake_tail_left(7) 			<=	"1111111111111111";
--  sprite_snake_tail_left(8) 			<=	"1111111111111111";
--  sprite_snake_tail_left(9) 			<=	"1111111111111110";
--  sprite_snake_tail_left(10) 			<=	"0111111111111100";
--  sprite_snake_tail_left(11) 			<=	"0111111111111000";
--  sprite_snake_tail_left(12) 	 	  	<=	"0011111111110000";
--  sprite_snake_tail_left(13) 	  	 	<=	"0011111111000000";
--  sprite_snake_tail_left(14) 	 	  	<=	"0001111100000000";
--  sprite_snake_tail_left(15) 	  	 	<=	"0000110000000000";
--  
--    -- sprite snake tail upwards facing coloring
--  sprite_snake_tail_up(0) 			<=	"0000001111000000";
--  sprite_snake_tail_up(1) 			<=	"0000111111110000";
--  sprite_snake_tail_up(2) 			<=	"0011111111111100";
--  sprite_snake_tail_up(3) 			<=	"0111111111111110";
--  sprite_snake_tail_up(4) 			<=	"1111111111111111";
--  sprite_snake_tail_up(5) 			<=	"1111111111111111";
--  sprite_snake_tail_up(6) 			<=	"0111111111111110";
--  sprite_snake_tail_up(7) 			<=	"0111111111111110";
--  sprite_snake_tail_up(8) 			<=	"0011111111111100";
--  sprite_snake_tail_up(9) 			<=	"0011111111111100";
--  sprite_snake_tail_up(10) 		<=	"0001111111111000";
--  sprite_snake_tail_up(11) 		<=	"0001111111111000";
--  sprite_snake_tail_up(12) 	   <=	"0000111111110000";
--  sprite_snake_tail_up(13) 	   <=	"0000011111100000";
--  sprite_snake_tail_up(14) 	   <=	"0000001111000000";
--  sprite_snake_tail_up(15) 	   <=	"0000000110000000";
--  
--    -- sprite snake tail downwards facing coloring
--  sprite_snake_tail_down(0) 			<=	"0000000110000000";
--  sprite_snake_tail_down(1) 			<=	"0000001111000000";
--  sprite_snake_tail_down(2) 			<=	"0000011111100000";
--  sprite_snake_tail_down(3) 			<=	"0000111111110000";
--  sprite_snake_tail_down(4) 			<=	"0001111111111000";
--  sprite_snake_tail_down(5) 			<=	"0001111111111000";
--  sprite_snake_tail_down(6) 			<=	"0011111111111100";
--  sprite_snake_tail_down(7) 			<=	"0011111111111100";
--  sprite_snake_tail_down(8) 			<=	"0111111111111110";
--  sprite_snake_tail_down(9) 			<=	"0111111111111110";
--  sprite_snake_tail_down(10) 			<=	"1111111111111111";
--  sprite_snake_tail_down(11) 			<=	"1111111111111111";
--  sprite_snake_tail_down(12) 	   	<=	"0111111111111110";
--  sprite_snake_tail_down(13) 	   	<=	"0011111111111100";
--  sprite_snake_tail_down(14) 	   	<=	"0000111111110000";
--  sprite_snake_tail_down(15) 	   	<=	"0000001111000000";


--  
--    -- sprite snake body coloring
--  sprite_snake_body(0) 			<=	"0000111111110000";
--  sprite_snake_body(1) 			<=	"0001111111111000";
--  sprite_snake_body(2) 			<=	"0011111111111100";
--  sprite_snake_body(3) 			<=	"0011111111111100";
--  sprite_snake_body(4) 			<=	"0111111111111110";
--  sprite_snake_body(5) 			<=	"1111111111111111";
--  sprite_snake_body(6) 			<=	"1111111111111111";
--  sprite_snake_body(7) 			<=	"1111111111111111";
--  sprite_snake_body(8) 			<=	"1111111111111111";
--  sprite_snake_body(9) 			<=	"1111111111111111";
--  sprite_snake_body(10) 		<=	"1111111111111111";
--  sprite_snake_body(11) 		<=	"0111111111111110";
--  sprite_snake_body(12) 	   <=	"0011111111111100";
--  sprite_snake_body(13) 	   <=	"0011111111111100";
--  sprite_snake_body(14) 	   <=	"0001111111111000";
--  sprite_snake_body(15) 	   <=	"0000111111110000";
--  
  
  
  

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
    reset : in std_logic;
    clk   : in std_logic;                    -- Should be 25.125 MHz
	 
	 TILES_IN : in tiles_ram;
	 SNAKE1_IN : in snake_ram;
	 SNAKE2_IN : in snake_ram;

    VGA_CLK,                         -- Clock
    VGA_HS,                          -- H_SYNC
    VGA_VS,                          -- V_SYNC
    VGA_BLANK,                       -- BLANK
    VGA_SYNC : out std_logic;        -- SYNC
    VGA_R,                           -- Red[9:0]
    VGA_G,                           -- Green[9:0]
    VGA_B : out std_logic_vector(9 downto 0) -- Blue[9:0]
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

  constant RECTANGLE_HSTART : integer := 100;
  constant RECTANGLE_HEND   : integer := 540;
  constant RECTANGLE_VSTART : integer := 100;
  constant RECTANGLE_VEND   : integer := 380;
  
  constant CIRCLE_RADIUS	: integer := 50;
  constant CIRCLE_RSQUARED : integer := CIRCLE_RADIUS * CIRCLE_RADIUS;

  -- Signals for the video controller
  signal Hcount : unsigned(9 downto 0);  -- Horizontal position (0-800)
  signal Vcount : unsigned(9 downto 0);  -- Vertical position (0-524)
  signal EndOfLine, EndOfField : std_logic;

  signal vga_hblank, vga_hsync,
    vga_vblank, vga_vsync : std_logic;  -- Sync. signals

  signal rectangle_h, rectangle_v, rectangle : std_logic;  -- rectangle area
  
	signal circle_center_h : integer;
	signal circle_center_v : integer;
	signal circle_hsquared : integer;
	signal circle_vsquared : integer;
	signal hcount_temp, vcount_temp : integer;
	signal circle_h, circle_v, circle : std_logic; -- circle area
	
	type ram_type is array(5 downto 0) of std_logic_vector(255 downto 0);
	signal SPRITES : ram_type;

	-- sprites
	type array_type_16x16 is array (15 downto 0) of unsigned (15 downto 0);
	
	-- snake head colorings
	signal sprite_snake_head_g 	: array_type_16x16;
	signal sprite_snake_head_r 	: array_type_16x16;
	signal sprite_snake_head_w 	: array_type_16x16;
	signal sprite_snake_head_b 	: array_type_16x16;

	-- snake body colorings
	signal sprite_snake_body	: array_type_16x16;
	
	-- snake tail colorings
	signal sprite_snake_tail	: array_type_16x16;
	
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
	signal sprite_food_edwards	: array_type_16x16;
	
	signal sprite_powup_growth	: array_type_16x16;
	
	signal sprite_powup_speed	: array_type_16x16;
	
	signal sprite_powup_freeze	: array_type_16x16;
	
	signal sprite_wall			: array_type_16x16;
	
	signal sprite_P				: array_type_16x16;
	signal sprite_1				: array_type_16x16;
	signal sprite_2				: array_type_16x16;
	signal sprite_W				: array_type_16x16;
	signal sprite_I				: array_type_16x16;
	signal sprite_N				: array_type_16x16;
	signal sprite_S				: array_type_16x16;
	signal sprite_exclam			: array_type_16x16;
	signal sprite_pause			: array_type_16x16;
	signal sprite_play			: array_type_16x16;
	
begin
  
  -- sprite definitions
  
  -- sprite snake head coloring
  sprite_snake_head_g(0) 			<=	"0000111100000000";
  sprite_snake_head_g(1) 			<=	"0001111111000000";
  sprite_snake_head_g(2) 			<=	"0011111111110000";
  sprite_snake_head_g(3) 			<=	"0111111111111000";
  sprite_snake_head_g(4) 			<=	"0111111111111100";
  sprite_snake_head_g(5) 			<=	"1111100011111100";
  sprite_snake_head_g(6) 			<=	"1111100011111110";
  sprite_snake_head_g(7) 			<=	"1111100011111100";
  sprite_snake_head_g(8) 			<=	"1111111111100000";
  sprite_snake_head_g(9) 			<=	"1111111111100000";
  sprite_snake_head_g(10) 			<=	"1111111111111100";
  sprite_snake_head_g(11) 			<=	"0111111111111110";
  sprite_snake_head_g(12) 	   	<=	"0111111111111000";
  sprite_snake_head_g(13) 	   	<=	"0011111111110000";
  sprite_snake_head_g(14) 	   	<=	"0001111111000000";
  sprite_snake_head_g(15) 	   	<=	"0000111100000000";
  
  -- sprite snake head tongue coloring
  sprite_snake_head_r(0) 			<=	"0000000000000000";
  sprite_snake_head_r(1) 			<=	"0000000000000000";
  sprite_snake_head_r(2) 			<=	"0000000000000000";
  sprite_snake_head_r(3) 			<=	"0000000000000000";
  sprite_snake_head_r(4) 	  		<=	"0000000000000000";
  sprite_snake_head_r(5) 			<=	"0000000000000000";
  sprite_snake_head_r(6) 			<=	"0000000000000000";
  sprite_snake_head_r(7) 			<=	"0000000000000011";
  sprite_snake_head_r(8) 			<=	"0000000000011110";
  sprite_snake_head_r(9) 			<=	"0000000000011110";
  sprite_snake_head_r(10) 			<=	"0000000000000011";
  sprite_snake_head_r(11) 			<=	"0000000000000000";
  sprite_snake_head_r(12) 	   	<=	"0000000000000000";
  sprite_snake_head_r(13) 	   	<=	"0000000000000000";
  sprite_snake_head_r(14) 	   	<=	"0000000000000000";
  sprite_snake_head_r(15) 	  	 	<= "0000000000000000";
  
  -- sprite snake head eye white coloring
  sprite_snake_head_w(0) 			<=	"0000000000000000";
  sprite_snake_head_w(1) 			<=	"0000000000000000";
  sprite_snake_head_w(2) 			<=	"0000000000000000";
  sprite_snake_head_w(3) 			<=	"0000000000000000";
  sprite_snake_head_w(4) 			<= "0000000000000000";
  sprite_snake_head_w(5) 			<=	"0000011100000000";
  sprite_snake_head_w(6) 			<=	"0000010000000000";
  sprite_snake_head_w(7) 			<=	"0000010000000000";
  sprite_snake_head_w(8) 			<=	"0000000000000000";
  sprite_snake_head_w(9) 			<=	"0000000000000000";
  sprite_snake_head_w(10) 			<=	"0000000000000000";
  sprite_snake_head_w(11) 			<=	"0000000000000000";
  sprite_snake_head_w(12) 	  	 	<=	"0000000000000000";
  sprite_snake_head_w(13) 	  	 	<=	"0000000000000000";
  sprite_snake_head_w(14) 	  	 	<=	"0000000000000000";
  sprite_snake_head_w(15) 	  	 	<=	"0000000000000000";
  
    -- sprite snake head eye black coloring
  sprite_snake_head_b(0) 			<=	"0000000000000000";
  sprite_snake_head_b(1) 			<=	"0000000000000000";
  sprite_snake_head_b(2) 			<=	"0000000000000000";
  sprite_snake_head_b(3) 			<=	"0000000000000000";
  sprite_snake_head_b(4) 			<=	"0000000000000000";
  sprite_snake_head_b(5) 			<=	"0000000000000000";
  sprite_snake_head_b(6) 			<=	"0000001100000000";
  sprite_snake_head_b(7) 			<=	"0000001100000000";
  sprite_snake_head_b(8) 			<=	"0000000000000000";
  sprite_snake_head_b(9) 			<=	"0000000000000000";
  sprite_snake_head_b(10) 			<=	"0000000000000000";
  sprite_snake_head_b(11) 			<=	"0000000000000000";
  sprite_snake_head_b(12) 	  	 	<=	"0000000000000000";
  sprite_snake_head_b(13) 	  	 	<=	"0000000000000000";
  sprite_snake_head_b(14) 	  	 	<=	"0000000000000000";
  sprite_snake_head_b(15) 	  	 	<=	"0000000000000000";
  
    -- sprite snake body coloring
  sprite_snake_body(0) 			<=	"0000111111110000";
  sprite_snake_body(1) 			<=	"0001111111111000";
  sprite_snake_body(2) 			<=	"0011111111111100";
  sprite_snake_body(3) 			<=	"0011111111111100";
  sprite_snake_body(4) 			<=	"0111111111111110";
  sprite_snake_body(5) 			<=	"1111111111111111";
  sprite_snake_body(6) 			<=	"1111111111111111";
  sprite_snake_body(7) 			<=	"1111111111111111";
  sprite_snake_body(8) 			<=	"1111111111111111";
  sprite_snake_body(9) 			<=	"1111111111111111";
  sprite_snake_body(10) 		<=	"1111111111111111";
  sprite_snake_body(11) 		<=	"0111111111111110";
  sprite_snake_body(12) 	   <=	"0011111111111100";
  sprite_snake_body(13) 	   <=	"0011111111111100";
  sprite_snake_body(14) 	   <=	"0001111111111000";
  sprite_snake_body(15) 	   <=	"0000111111110000";
  
  -- sprite snake tail coloring
  sprite_snake_tail(0) 			<=	"0000000000110000";
  sprite_snake_tail(1) 			<=	"0000000011111000";
  sprite_snake_tail(2) 			<=	"0000001111111100";
  sprite_snake_tail(3) 			<=	"0000111111111100";
  sprite_snake_tail(4) 			<=	"0001111111111110";
  sprite_snake_tail(5) 			<=	"0011111111111110";
  sprite_snake_tail(6) 			<=	"0111111111111111";
  sprite_snake_tail(7) 			<=	"1111111111111111";
  sprite_snake_tail(8) 			<=	"1111111111111111";
  sprite_snake_tail(9) 			<=	"0111111111111111";
  sprite_snake_tail(10) 		<=	"0011111111111110";
  sprite_snake_tail(11) 		<=	"0001111111111110";
  sprite_snake_tail(12) 	   <=	"0000111111111100";
  sprite_snake_tail(13) 	   <=	"0000001111111100";
  sprite_snake_tail(14) 	   <=	"0000000011111000";
  sprite_snake_tail(15) 	   <=	"0000000000110000";
  
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
  sprite_food_rabbit_p(5) 			<=	"0000010000100000";
  sprite_food_rabbit_p(6) 			<=	"0000010000100000";
  sprite_food_rabbit_p(7) 			<=	"0000010000100000";
  sprite_food_rabbit_p(8) 			<=	"0000010000100000";
  sprite_food_rabbit_p(9) 			<=	"0000010000100000";
  sprite_food_rabbit_p(10) 		<=	"0000010000100000";
  sprite_food_rabbit_p(11) 		<=	"0000010000100000";
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
  

  
  circle_center_h <= 350;
  circle_center_v <= 240;

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

  -- Rectangle generator

  RectangleHGen : process (clk)
  begin
    if rising_edge(clk) then     
      if reset = '1' or Hcount = HSYNC + HBACK_PORCH + RECTANGLE_HSTART then
        rectangle_h <= '1';
      elsif Hcount = HSYNC + HBACK_PORCH + RECTANGLE_HEND then
        rectangle_h <= '0';
      end if;      
    end if;
  end process RectangleHGen;

  RectangleVGen : process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then       
        rectangle_v <= '0';
      elsif EndOfLine = '1' then
        if Vcount = VSYNC + VBACK_PORCH - 1 + RECTANGLE_VSTART then
          rectangle_v <= '1';
        elsif Vcount = VSYNC + VBACK_PORCH - 1 + RECTANGLE_VEND then
          rectangle_v <= '0';
        end if;
      end if;      
    end if;
  end process RectangleVGen;

  rectangle <= rectangle_h and rectangle_v;
  
  
  -- Circle Generator
  
  CircleHGen : process (clk)
  begin
    if rising_edge(clk) then
		if Hcount  >= (circle_center_h - CIRCLE_RADIUS + HSYNC + HBACK_PORCH - 1) and
			Hcount  <= (circle_center_h + CIRCLE_RADIUS + HSYNC + HBACK_PORCH - 1) then
			
				hcount_temp <= to_integer(Hcount) - circle_center_h - HSYNC - HBACK_PORCH - 1;
				circle_hsquared <= (hcount_temp) * (hcount_temp);
				if reset = '1' or circle_hsquared + circle_vsquared < CIRCLE_RSQUARED then
				  circle_h <= '1';
				else
				  circle_h <= '0';
				end if;
		else
			circle_h <= '0';
		end if;
    end if;
  end process CircleHGen;

  CircleVGen : process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then       
        circle_v <= '0';
		  vcount_temp <= 0;
      elsif EndOfLine = '1' then
			if Vcount >= circle_center_v - CIRCLE_RADIUS + VSYNC + VBACK_PORCH - 1  and
				Vcount <= circle_center_v + CIRCLE_RADIUS + VSYNC + VBACK_PORCH - 1  then
					
					vcount_temp <= to_integer(Vcount) - circle_center_v - VSYNC - VBACK_PORCH - 1;
					circle_vsquared <= (vcount_temp) * (vcount_temp);
					circle_v <= '1';
			else
					circle_v <= '0';
			end if;
      end if;      
    end if;
  end process CircleVGen;
  
  circle <= circle_v and circle_h;

  -- Registered video signals going to the video DAC

  VideoOut: process (clk, reset)
  begin
    if reset = '1' then
      VGA_R <= "0000000000";
      VGA_G <= "0000000000";
      VGA_B <= "0000000000";
    elsif clk'event and clk = '1' then
      if rectangle = '1' then
        VGA_R <= "1111111111";
        VGA_G <= "1111111111";
        VGA_B <= "1111111111";
      elsif vga_hblank = '0' and vga_vblank ='0' then
        VGA_R <= "0000000000";
        VGA_G <= "0000000000";
        VGA_B <= "1111111111";
      else
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

	
	SPRITES(0) <= (others => '0');
  
  end rtl;


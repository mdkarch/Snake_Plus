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
	type array_type_16x16 is array (0 to 15) of unsigned (0 to 15);
	
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
	
	-- process signals
	signal green, blue, red, black, tan 		: std_logic;
	signal white, pink, gray, yellow, brown	: std_logic;
	signal snake_head_g, snake_head_r, snake_head_w, snake_head_b : std_logic;
	signal snake_body, snake_tail					: std_logic;
	signal rabbit_y, rabbit_b, rabbit_w, rabbit_p	:std_logic;
	signal mouse_y, mouse_p, mouse_l, mouse_b			: std_logic;
	signal edwards_t, edwards_br, edwards_bl, edwards_p	: std_logic;
	signal speed, growth, freeze					: std_logic;
	signal wall											: std_logic;
	signal P, one, two, W, I, N, S, exclam			: std_logic;
	signal pause, play								: std_logic;
	
	
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
  
  -- snake sprite head generation
  SnakeHeadSpriteGen : process (clk)
  variable sprite_h_pos, sprite_v_pos : integer;
  begin
	if rising_edge(clk) then	
		if reset = '1' then
			snake_head_g <= '0';
			snake_head_r <= '0';
			snake_head_w <= '0';
			snake_head_b <= '0';
		elsif (to_integer(Hcount) >= HSYNC + HBACK_PORCH + 55) 
				and (to_integer(Hcount) <= HSYNC + HBACK_PORCH + 70) 
				and (to_integer(Vcount) >= VSYNC + VBACK_PORCH + 78) 
				and (to_integer(Vcount) <= VSYNC + VBACK_PORCH - 1 + 94) then
			 sprite_h_pos := to_integer(Hcount) - (HSYNC + HBACK_PORCH + 55);
			 sprite_v_pos := to_integer(Vcount) - (VSYNC + VBACK_PORCH + 78);
			 if sprite_snake_head_g(sprite_v_pos)(sprite_h_pos) = '1' then
				snake_head_g <= '1';
				snake_head_r <= '0';
				snake_head_w <= '0';
				snake_head_b <= '0';
			 elsif sprite_snake_head_b(sprite_v_pos)(sprite_h_pos) = '1' then
			   snake_head_g <= '0';
				snake_head_r <= '0';
				snake_head_w <= '0';
				snake_head_b <= '1';
			 elsif sprite_snake_head_r(sprite_v_pos)(sprite_h_pos) = '1' then
			   snake_head_g <= '0';
				snake_head_r <= '1';
				snake_head_w <= '0';
				snake_head_b <= '0';
			 elsif sprite_snake_head_w(sprite_v_pos)(sprite_h_pos) = '1' then
			   snake_head_g <= '0';
				snake_head_r <= '0';
				snake_head_w <= '1';
				snake_head_b <= '0';
			 else
				snake_head_g <= '0';
				snake_head_r <= '0';
				snake_head_w <= '0';
				snake_head_b <= '0';
			 end if;
		else
			snake_head_g <= '0';
			snake_head_r <= '0';
			snake_head_w <= '0';
			snake_head_b <= '0';
		end if;
	end if;		
  end process SnakeHeadSpriteGen;
  
  -- snake sprite body generation
  SnakeBodySpriteGen : process (clk)
  variable sprite_h_pos, sprite_v_pos : integer;
  begin
	if rising_edge(clk) then	
		if reset = '1' then
			snake_body <= '0';
		elsif (to_integer(Hcount) >= HSYNC + HBACK_PORCH + 95) 
				and (to_integer(Hcount) < HSYNC + HBACK_PORCH + 111) 
				and (to_integer(Vcount) >= VSYNC + VBACK_PORCH + 400) 
				and (to_integer(Vcount) <= VSYNC + VBACK_PORCH - 1 + 416) then
			 sprite_h_pos := to_integer(Hcount) - (HSYNC + HBACK_PORCH + 95);
			 sprite_v_pos := to_integer(Vcount) - (VSYNC + VBACK_PORCH + 400);
			 if sprite_snake_body(sprite_v_pos)(sprite_h_pos) = '1' then
				snake_body <= '1';
			 else
				snake_body <= '0';
			 end if;
		else
			snake_body <= '0';
		end if;
	end if;		
  end process SnakeBodySpriteGen;
  
  
	-- snake sprite tail generation
	SnakeTailSpriteGen : process (clk)
	  variable sprite_h_pos, sprite_v_pos : integer;
	  begin
		if rising_edge(clk) then	
			if reset = '1' then
				snake_tail <= '0';
			elsif (to_integer(Hcount) >= HSYNC + HBACK_PORCH + 95) 
					and (to_integer(Hcount) < HSYNC + HBACK_PORCH + 111) 
					and (to_integer(Vcount) >= VSYNC + VBACK_PORCH + 300) 
					and (to_integer(Vcount) <= VSYNC + VBACK_PORCH - 1 + 316) then
				 sprite_h_pos := to_integer(Hcount) - (HSYNC + HBACK_PORCH + 95);
				 sprite_v_pos := to_integer(Vcount) - (VSYNC + VBACK_PORCH + 300);
				 if sprite_snake_tail(sprite_v_pos)(sprite_h_pos) = '1' then
					snake_tail <= '1';
				 else
					snake_tail <= '0';
				 end if;
			else
				snake_tail <= '0';
			end if;
		end if;		
  end process SnakeTailSpriteGen;

	
--	-- rabbit sprite generation
--  RabbitSpriteGen : process (clk)
--  variable sprite_h_pos, sprite_v_pos : integer;
--  begin
--	if rising_edge(clk) then	
--		if reset = '1' then
--			rabbit_y <= '0';
--			rabbit_b <= '0';
--			rabbit_w <= '0';
--			rabbit_p <= '0';
--		elsif (to_integer(Hcount) >= HSYNC + HBACK_PORCH + 95) 
--				and (to_integer(Hcount) <= HSYNC + HBACK_PORCH + 90) 
--				and (to_integer(Vcount) >= VSYNC + VBACK_PORCH + 78) 
--				and (to_integer(Vcount) <= VSYNC + VBACK_PORCH - 1 + 94) then
--			 sprite_h_pos := to_integer(Hcount) - (HSYNC + HBACK_PORCH + 95);
--			 sprite_v_pos := to_integer(Vcount) - (VSYNC + VBACK_PORCH + 78);
--			 if sprite_food_rabbit_y(sprite_v_pos)(sprite_h_pos) = '1' then
--				rabbit_y <= '1';
--				rabbit_p <= '0';
--				rabbit_w <= '0';
--				rabbit_b <= '0';
--			 elsif sprite_food_rabbit_b(sprite_v_pos)(sprite_h_pos) = '1' then
--			   rabbit_y <= '0';
--				rabbit_p <= '0';
--				rabbit_w <= '0';
--				rabbit_b <= '1';
--			 elsif sprite_food_rabbit_p(sprite_v_pos)(sprite_h_pos) = '1' then
--			   rabbit_y <= '0';
--				rabbit_p <= '1';
--				rabbit_w <= '0';
--				rabbit_b <= '0';
--			 elsif sprite_food_rabbit_w(sprite_v_pos)(sprite_h_pos) = '1' then
--			   rabbit_y <= '0';
--				rabbit_p <= '0';
--				rabbit_w <= '1';
--				rabbit_b <= '0';
--			 else
--				rabbit_y <= '0';
--				rabbit_p <= '0';
--				rabbit_w <= '0';
--				rabbit_b <= '0';
--			 end if;
--		else
--			rabbit_y <= '0';
--			rabbit_p <= '0';
--			rabbit_w <= '0';
--			rabbit_b <= '0';
--		end if;
--	end if;		
--  end process RabbitSpriteGen;
	
	
--	-- mouse sprite generation
--  MouseSpriteGen : process (clk)
--  variable sprite_h_pos, sprite_v_pos : integer;
--  begin
--	if rising_edge(clk) then	
--		if reset = '1' then
--			mouse_y <= '0';
--			mouse_b <= '0';
--			mouse_l <= '0';
--			mouse_p <= '0';
--		elsif (to_integer(Hcount) >= HSYNC + HBACK_PORCH + 15) 
--				and (to_integer(Hcount) <= HSYNC + HBACK_PORCH + 10) 
--				and (to_integer(Vcount) >= VSYNC + VBACK_PORCH + 78) 
--				and (to_integer(Vcount) <= VSYNC + VBACK_PORCH - 1 + 94) then
--			 sprite_h_pos := to_integer(Hcount) - (HSYNC + HBACK_PORCH + 15);
--			 sprite_v_pos := to_integer(Vcount) - (VSYNC + VBACK_PORCH + 78);
--			 if sprite_food_mouse_y(sprite_v_pos)(sprite_h_pos) = '1' then
--				mouse_y <= '1';
--				rabbit_p <= '0';
--				rabbit_w <= '0';
--				rabbit_b <= '0';
--			 elsif sprite_food_rabbit_b(sprite_v_pos)(sprite_h_pos) = '1' then
--			   rabbit_y <= '0';
--				rabbit_p <= '0';
--				rabbit_w <= '0';
--				rabbit_b <= '1';
--			 elsif sprite_food_rabbit_p(sprite_v_pos)(sprite_h_pos) = '1' then
--			   rabbit_y <= '0';
--				rabbit_p <= '1';
--				rabbit_w <= '0';
--				rabbit_b <= '0';
--			 elsif sprite_food_rabbit_w(sprite_v_pos)(sprite_h_pos) = '1' then
--			   rabbit_y <= '0';
--				rabbit_p <= '0';
--				rabbit_w <= '1';
--				rabbit_b <= '0';
--			 else
--				rabbit_y <= '0';
--				rabbit_p <= '0';
--				rabbit_w <= '0';
--				rabbit_b <= '0';
--			 end if;
--		else
--			rabbit_y <= '0';
--			rabbit_p <= '0';
--			rabbit_w <= '0';
--			rabbit_b <= '0';
--		end if;
--	end if;		
--  end process MouseSpriteGen;

	-- letter P generation
	LetterPGen : process (clk)
	  variable sprite_h_pos, sprite_v_pos : integer;
	  begin
		if rising_edge(clk) then	
			if reset = '1' then
				P <= '0';
			elsif (to_integer(Hcount) >= HSYNC + HBACK_PORCH + 95) 
					and (to_integer(Hcount) < HSYNC + HBACK_PORCH + 111) 
					and (to_integer(Vcount) >= VSYNC + VBACK_PORCH + 200) 
					and (to_integer(Vcount) <= VSYNC + VBACK_PORCH - 1 + 216) then
				 sprite_h_pos := to_integer(Hcount) - (HSYNC + HBACK_PORCH + 95);
				 sprite_v_pos := to_integer(Vcount) - (VSYNC + VBACK_PORCH + 200);
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
  
  	-- Number 1 generation
	Number1Gen : process (clk)
	  variable sprite_h_pos, sprite_v_pos : integer;
	  begin
		if rising_edge(clk) then	
			if reset = '1' then
				one <= '0';
			elsif (to_integer(Hcount) >= HSYNC + HBACK_PORCH + 95) 
					and (to_integer(Hcount) < HSYNC + HBACK_PORCH + 111) 
					and (to_integer(Vcount) >= VSYNC + VBACK_PORCH + 100) 
					and (to_integer(Vcount) <= VSYNC + VBACK_PORCH - 1 + 116) then
				 sprite_h_pos := to_integer(Hcount) - (HSYNC + HBACK_PORCH + 95);
				 sprite_v_pos := to_integer(Vcount) - (VSYNC + VBACK_PORCH + 100);
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
			elsif (to_integer(Hcount) >= HSYNC + HBACK_PORCH + 200) 
					and (to_integer(Hcount) < HSYNC + HBACK_PORCH + 216) 
					and (to_integer(Vcount) >= VSYNC + VBACK_PORCH + 100) 
					and (to_integer(Vcount) <= VSYNC + VBACK_PORCH - 1 + 116) then
				 sprite_h_pos := to_integer(Hcount) - (HSYNC + HBACK_PORCH + 200);
				 sprite_v_pos := to_integer(Vcount) - (VSYNC + VBACK_PORCH + 100);
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
  
   -- Letter W generation
	LetterWGen : process (clk)
	  variable sprite_h_pos, sprite_v_pos : integer;
	  begin
		if rising_edge(clk) then	
			if reset = '1' then
				W <= '0';
			elsif (to_integer(Hcount) >= HSYNC + HBACK_PORCH + 280) 
					and (to_integer(Hcount) < HSYNC + HBACK_PORCH + 296) 
					and (to_integer(Vcount) >= VSYNC + VBACK_PORCH + 100) 
					and (to_integer(Vcount) <= VSYNC + VBACK_PORCH - 1 + 116) then
				 sprite_h_pos := to_integer(Hcount) - (HSYNC + HBACK_PORCH + 280);
				 sprite_v_pos := to_integer(Vcount) - (VSYNC + VBACK_PORCH + 100);
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
			elsif (to_integer(Hcount) >= HSYNC + HBACK_PORCH + 250) 
					and (to_integer(Hcount) < HSYNC + HBACK_PORCH + 266) 
					and (to_integer(Vcount) >= VSYNC + VBACK_PORCH + 100) 
					and (to_integer(Vcount) <= VSYNC + VBACK_PORCH - 1 + 116) then
				 sprite_h_pos := to_integer(Hcount) - (HSYNC + HBACK_PORCH + 250);
				 sprite_v_pos := to_integer(Vcount) - (VSYNC + VBACK_PORCH + 100);
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
			elsif (to_integer(Hcount) >= HSYNC + HBACK_PORCH + 300) 
					and (to_integer(Hcount) < HSYNC + HBACK_PORCH + 316) 
					and (to_integer(Vcount) >= VSYNC + VBACK_PORCH + 100) 
					and (to_integer(Vcount) <= VSYNC + VBACK_PORCH - 1 + 116) then
				 sprite_h_pos := to_integer(Hcount) - (HSYNC + HBACK_PORCH + 300);
				 sprite_v_pos := to_integer(Vcount) - (VSYNC + VBACK_PORCH + 100);
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
			elsif (to_integer(Hcount) >= HSYNC + HBACK_PORCH + 300) 
					and (to_integer(Hcount) < HSYNC + HBACK_PORCH + 316) 
					and (to_integer(Vcount) >= VSYNC + VBACK_PORCH + 150) 
					and (to_integer(Vcount) <= VSYNC + VBACK_PORCH - 1 + 166) then
				 sprite_h_pos := to_integer(Hcount) - (HSYNC + HBACK_PORCH + 300);
				 sprite_v_pos := to_integer(Vcount) - (VSYNC + VBACK_PORCH + 150);
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
			elsif (to_integer(Hcount) >= HSYNC + HBACK_PORCH + 300) 
					and (to_integer(Hcount) < HSYNC + HBACK_PORCH + 316) 
					and (to_integer(Vcount) >= VSYNC + VBACK_PORCH + 200) 
					and (to_integer(Vcount) <= VSYNC + VBACK_PORCH - 1 + 216) then
				 sprite_h_pos := to_integer(Hcount) - (HSYNC + HBACK_PORCH + 300);
				 sprite_v_pos := to_integer(Vcount) - (VSYNC + VBACK_PORCH + 150);
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
  
   -- brick wall sprite generation
	BrickWallSpriteGen : process (clk)
	  variable sprite_h_pos, sprite_v_pos : integer;
	  begin
		if rising_edge(clk) then	
			if reset = '1' then
				wall <= '0';
			elsif (to_integer(Hcount) >= HSYNC + HBACK_PORCH + 350) 
					and (to_integer(Hcount) < HSYNC + HBACK_PORCH + 366) 
					and (to_integer(Vcount) >= VSYNC + VBACK_PORCH + 200) 
					and (to_integer(Vcount) <= VSYNC + VBACK_PORCH - 1 + 216) then
				 sprite_h_pos := to_integer(Hcount) - (HSYNC + HBACK_PORCH + 350);
				 sprite_v_pos := to_integer(Vcount) - (VSYNC + VBACK_PORCH + 150);
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
  
   -- brick wall sprite generation
	BrickWallSpriteGen : process (clk)
	  variable sprite_h_pos, sprite_v_pos : integer;
	  begin
		if rising_edge(clk) then	
			if reset = '1' then
				wall <= '0';
			elsif (to_integer(Hcount) >= HSYNC + HBACK_PORCH + 350) 
					and (to_integer(Hcount) < HSYNC + HBACK_PORCH + 366) 
					and (to_integer(Vcount) >= VSYNC + VBACK_PORCH + 200) 
					and (to_integer(Vcount) <= VSYNC + VBACK_PORCH - 1 + 216) then
				 sprite_h_pos := to_integer(Hcount) - (HSYNC + HBACK_PORCH + 350);
				 sprite_v_pos := to_integer(Vcount) - (VSYNC + VBACK_PORCH + 150);
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
	
	
  -- Registered video signals going to the video DAC
  VideoOut: process (clk, reset)
  begin
    if reset = '1' then
      VGA_R <= "0000000000";
      VGA_G <= "0000000000";
      VGA_B <= "0000000000";
    elsif clk'event and clk = '1' then
		if blue = '1' or rabbit_b = '1' then
		  VGA_R <= "0000000000";
		  VGA_G <= "0000000000";
		  VGA_B <= "1111111111";
		elsif green = '1' or snake_body = '1' or snake_head_g = '1' 
								or snake_tail = '1' then
		  VGA_R <= "0000000000";
		  VGA_G <= "1111111111";
		  VGA_B <= "0000000000";
		elsif red = '1' or snake_head_r = '1' or wall = '1' then
		  VGA_R <= "1111111111";
		  VGA_G <= "0000000000";
		  VGA_B <= "0000000000";
		elsif black = '1' or snake_head_b = '1' then
		  VGA_R <= "0000000000";
		  VGA_G <= "0000000000";
		  VGA_B <= "0000000000";
		elsif white = '1' or snake_head_w = '1' or rabbit_w = '1' 
								or one = '1' or P = '1' or two = '1' 
								or I = '1' or N = '1' or S = '1' 
								or exclam = '1' or pause = '1' 
								or play = '1'  or W = '1' then
		  VGA_R <= "1111111111";
		  VGA_G <= "1111111111";
		  VGA_B <= "1111111111";
		elsif pink = '1' or rabbit_p = '1' then
		  VGA_R <= "1111111111";
		  VGA_G <= "0110000000";
		  VGA_B <= "0110100000";
		elsif gray = '1'  or rabbit_y = '1' then
		  VGA_R <= "0110000000";
		  VGA_G <= "0110000000";
		  VGA_B <= "0110000000";
		elsif yellow = '1' then
		  VGA_R <= "1111111111";
		  VGA_G <= "1111111111";
		  VGA_B <= "0000000000";
		elsif brown = '1' then
		  VGA_R <= "0100001001";
		  VGA_G <= "0010000100";
		  VGA_B <= "0000010011";
		elsif tan = '1' then
		  VGA_R <= "0110100000";
		  VGA_G <= "0101110000";
		  VGA_B <= "0100001010";
      elsif vga_hblank = '0' and vga_vblank ='0' then -- black background
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

	
	SPRITES(0) <= (others => '0');
  
  end rtl;


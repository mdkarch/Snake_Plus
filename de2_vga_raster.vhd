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

begin
  
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


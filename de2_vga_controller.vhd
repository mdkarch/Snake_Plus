library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions.all;

-- PROTOCOL:
		-- FOR ADDRESS = 00
			--9-0: Y (LSB)
			--19-10: X
			--24-20: SPRITE SELECT
			--25: 1=ADD, 0=REMOVE
			--26-27: Which segment referring to
			--			00=head, 01=second to head
			--			10=second to tail 11=tail
			--26-31: UNUSED (MSB)
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

  type ram_type is array(2 downto 0) of
            std_logic_vector(31 downto 0);
  signal RAM : ram_type;
  signal ram_address: signed(2 downto 0);
  signal led_chooser : integer;
  

  signal tiles : tiles_ram;
  signal snake1 : snake_ram;
  signal snake2  : snake_ram;
  
  signal clk25 : std_logic := '0';

begin

	-- Initialization 

  ram_address <= signed(address(2 downto 0));
  
  
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
	 
      if reset_n = '0' then
			readdata <= (others => '0');
			tiles <= (others=>(others=>(others=>'0')));
			snake1 <= (others=>(others=>'0'));
			snake2 <= (others=>(others=>'0'));
			led_chooser <= 0;
      else
        if chipselect = '1' then -- This chip is right one
          if address = "0000" then
            if read = '1' then
              readdata <= RAM(to_integer(ram_address));
            elsif write = '1' then
              RAM(to_integer(ram_address)) <= writedata;
            end if;
          else
            if write = '1' then
						led_chooser <= to_integer(signed(writedata(15 downto 0)));
            end if;
          end if;
        else
		  -- EXTRA STUFF HERE FOR DEBUGGING ONLY
          leds <= RAM(led_chooser)(15 downto 0);
				if led_chooser > 1 then
					leds(12) <= '1';
				else
					leds(12) <= '0';
				end if;
        end if;
      end if;
    end if;
  end process;

--VGA stuff

V1: entity work.de2_vga_raster port map (
    reset => '0',
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

end rtl;

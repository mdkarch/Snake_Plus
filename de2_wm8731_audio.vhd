library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.sounds.all;

entity de2_wm8731_audio is
	port (
		clk			: in std_logic;								--		Audio CODEC Chip Clock AUD_XCK
		reset_n		: in std_logic;
		 
		start_sound	: in std_logic;								--		Start sound playback
		select_sound: in std_logic_vector(3 downto 0);		--		Select a sound

			-- 	Audio interface signals
		AUD_ADCLRCK	: out std_logic;								--    Audio CODEC ADC LR Clock
		AUD_ADCDAT	: in  std_logic;								--    Audio CODEC ADC Data
		AUD_DACLRCK	: out std_logic;								--    Audio CODEC DAC LR Clock
		AUD_DACDAT	: out std_logic;								--    Audio CODEC DAC Data
		AUD_BCLK		: inout std_logic; 							--    Audio CODEC Bit-Stream Clock

		leds			: out std_logic_vector(15 downto 0)
	);
end  de2_wm8731_audio;

architecture rtl of de2_wm8731_audio is     

signal lrck : std_logic;
signal bclk : std_logic;
signal xck  : std_logic;
 
signal lrck_divider : unsigned(11 downto 0); 
signal bclk_divider : unsigned(3 downto 0);
 
signal set_bclk 	: std_logic;
signal set_lrck 	: std_logic;
signal clr_bclk 	: std_logic;
signal lrck_lat 	: std_logic;


signal sound_on 	: std_logic := '0';
signal sound	 	: std_logic_vector(3 downto 0) := X"0";

signal sound1_out	: unsigned(15 downto 0);
signal sound2_out	: unsigned(15 downto 0);

signal counter 	: unsigned(15 downto 0);
 
signal shift_out	: unsigned(15 downto 0);

begin
	  
	-- LRCK divider 
	-- Audio chip main clock is 25MHz / Sample rate 12KHz
	-- Divider is 25 MHz / 47KHz = 532 (X"214")
	-- Left justify mode set by I2C controller

	--leds(15) <= sound_on;
	leds(13 downto 0) <= std_logic_vector(counter)(13 downto 0);
	 
	process (clk)
	begin
		if rising_edge(clk) then
			if reset_n = '0' then 
				lrck_divider <= (others => '0');
			elsif lrck_divider = X"213"  then        -- "214" minus 1
				lrck_divider <= X"000";
			else 
				lrck_divider <= lrck_divider + 1;
			end if;
		end if;   
	end process;

	process (clk)
	begin
		if rising_edge(clk) then      
			if reset_n = '0' then 
				bclk_divider <= (others => '0');
			elsif bclk_divider = X"B" or set_lrck = '1'  then  
				bclk_divider <= X"0";
			else 
				bclk_divider <= bclk_divider + 1;
			end if;
		end if;
	end process;

	set_lrck <= '1' when lrck_divider = X"213" else '0';
	 
	process (clk)
	begin
		if rising_edge(clk) then
			if reset_n = '0' then
				lrck <= '0';
			elsif set_lrck = '1' then 
				lrck <= not lrck;
			end if;
		end if;
	end process;
	 
	-- BCLK divider
	set_bclk <= '1' when bclk_divider(3 downto 0) = "0101" else '0';
	clr_bclk <= '1' when bclk_divider(3 downto 0) = "1011" else '0';
	  
	process (clk)
	begin
		if rising_edge(clk) then
			if reset_n = '0' then
				bclk <= '0';
			elsif set_lrck = '1' or clr_bclk = '1' then
				bclk <= '0';
			elsif set_bclk = '1' then 
				bclk <= '1';
			end if;
		end if;
	end process;
	  
	-- Audio data shift output
	process (clk)
	begin
		if rising_edge(clk) then
			if reset_n = '0' then
				shift_out <= (others => '0');
			elsif set_lrck = '1' then
				if sound_on = '1' then
					if sound = X"0" then 
						shift_out <= sound1_out;
					elsif sound = X"1" then 
						shift_out <= sound2_out;
					end if;
				end if;
			elsif clr_bclk = '1' then 
				shift_out <= shift_out (14 downto 0) & '0';
			end if;
		end if;   
	end process;

	sound1_out <= sound1(to_integer(counter));
	sound2_out <= sound2(to_integer(counter));
	  
	-- Audio outputs

	AUD_ADCLRCK  <= lrck;          
	AUD_DACLRCK  <= lrck;          
	AUD_DACDAT   <= shift_out(15); 
	AUD_BCLK     <= bclk;   

	process (clk)
	begin
		if rising_edge(clk) then
			if reset_n = '0' then 
				sound_on <= '0';
				leds(15) <= '0';
			elsif start_sound = '1' then
				sound_on <= '1';
				leds(15) <= '1';
			end if;
		end if;
	end process;

	 
	process(clk)      
	begin
		if rising_edge(clk) then
			if reset_n = '0' then 
				counter <= (others => '0');
				leds(14) <= '0';
			elsif lrck_lat = '1' and lrck = '0'  then 	
				if sound_on = '1' then
					leds(14) <= '1';
					if (counter < X"FFFF") then 
						counter <= counter + 1;
						--sound_on <= '1';
					else
						counter <= X"0000";
						--sound_on <= '0';
					end if;					
				end if;
			end if;
		end if;
	end process;

	process(clk)
	begin
		if rising_edge(clk) then
			lrck_lat <= lrck;
		end if;
	end process;

end architecture;
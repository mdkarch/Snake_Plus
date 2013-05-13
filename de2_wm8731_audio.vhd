library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--use work.sounds.all;

entity de2_wm8731_audio is
	port (
		clk			: in std_logic;								--		Audio CODEC Chip Clock AUD_XCK
		reset_n		: in std_logic;
		 
		start_sound	: in std_logic;								--		Start sound playback
		select_sound: in std_logic_vector(3 downto 0);		--		Select a sound
		
		change_divider_enable : in std_logic;					-- 	Enable divider change
		divider_in		: in std_logic_vector(31 downto 0);		--		Value to change divider to

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

COMPONENT move_sound_rom IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (8 DOWNTO 0);
		clock			: IN STD_LOGIC  := '1';
		q				: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
END COMPONENT;  

COMPONENT powerup_sound_rom IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (8 DOWNTO 0);
		clock			: IN STD_LOGIC  := '1';
		q				: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
END COMPONENT; 

COMPONENT gameover_sound_rom IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
		clock			: IN STD_LOGIC  := '1';
		q				: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
END COMPONENT; 

COMPONENT snakePlus_sound_rom IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
		clock			: IN STD_LOGIC  := '1';
		q				: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
END COMPONENT; 

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
signal sound_end0 : std_logic := '0';
signal sound_end1 : std_logic := '0';
signal sound_end2 : std_logic := '0';
signal sound_end3 : std_logic := '0';


signal sound0_out	: std_logic_vector(15 downto 0);
signal sound1_out	: std_logic_vector(15 downto 0);
signal sound2_out	: std_logic_vector(15 downto 0);
signal sound3_out	: std_logic_vector(15 downto 0);

signal counter0 	: unsigned(8 downto 0);
signal counter1	: unsigned(8 downto 0);
signal counter2	: unsigned(11 downto 0);
signal counter3	: unsigned(11 downto 0);
signal reset_counters : std_logic := '0';
signal unset		: std_logic := '0';
 
signal shift_out	: std_logic_vector(15 downto 0) := (others => '0');

--constant divider : integer := 561;
--signal divider : unsigned(31 downto 0) := X"00000823";
signal divider : unsigned(31 downto 0);


begin
	  
	-- LRCK divider 
	-- Audio chip main clock is 25MHz / Sample rate 12KHz
	-- Divider is 25 MHz / 8KHz = 3125s (X"C34")
	-- Left justify mode set by I2C controller

	
	process(clk)
	begin
		if rising_edge(clk) then
			if reset_n = '0' then
				divider <= X"00000C34";
				leds(5) <= '0';
			elsif change_divider_enable = '1' then
				divider <= unsigned(divider_in);
				leds(5) <= '1';
			else
				leds(5) <= '0';
			end if;
		end if;
	end process;
	 
	process (clk)
	begin
		if rising_edge(clk) then
			if reset_n = '0' then 
				lrck_divider <= (others => '0');
			elsif lrck_divider = divider  then
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

	set_lrck <= '1' when lrck_divider = divider else '0';
	 
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
						shift_out <= sound0_out;
					elsif sound = X"1" then 
						shift_out <= sound1_out;
					elsif sound = X"2" then 
						shift_out <= sound2_out;
					elsif sound = X"3" then 
						shift_out <= sound3_out;
					end if;
				end if;
			elsif clr_bclk = '1' then 
				shift_out <= shift_out (14 downto 0) & '0';
			end if;
		end if;   
	end process;
	  
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
				leds(14) <= '0';
				sound <= X"0";
				reset_counters <= '0';
				unset <= '0';
			elsif start_sound = '1' then
				sound_on <= '1';
				leds(15 downto 14) <= "10";
				sound <= select_sound;
				reset_counters <= '1';
				unset <= '1';
			elsif unset = '1' then
				reset_counters <= '0';
				unset <= '0';
			elsif (sound_end0 or sound_end1 or sound_end2 or sound_end3) = '1' then
				sound_on <= '0';
				leds(15 downto 14) <= "01";
			end if;
		end if;
	end process;
	
	leds(9) <= lrck_lat and not lrck;
	
	-- Counter for sound0
	process(clk)      
	begin
		if rising_edge(clk) then
			if reset_n = '0' then 
				counter0 <= (others => '0');
				sound_end0 <= '0';
				leds(12 downto 10) <= "000";
			elsif reset_counters = '1' then
				counter0 <= (others => '0');
			elsif lrck_lat = '1' and lrck = '0'  then 	
				if sound_on = '1' and sound = X"0" then				
					if (counter0 < X"1F9") then 
						leds(11 downto 10) <= "10";
						counter0 <= counter0 + 1;
					else
						leds(11 downto 10) <= "01";
						counter0 <= (others => '0');
						sound_end0 <= '1';
					end if;	
				end if;
			elsif sound_end0 = '1' then
				leds(12) <= '0';
				sound_end0 <= '0';
			end if;
		end if;
	end process;

	-- Counter for sound1
	process(clk)      
	begin
		if rising_edge(clk) then
			if reset_n = '0' then 
				counter1 <= (others => '0');
				sound_end1 <= '0';
			elsif reset_counters = '1' then
				counter1 <= (others => '0');
			elsif lrck_lat = '1' and lrck = '0'  then 	
				if sound_on = '1' and sound = X"1" then
					if (counter1 < X"199") then 
						counter1 <= counter1 + 1;
					else
						counter1 <= (others => '0');
						sound_end1 <= '1';
					end if;
				end if;
			elsif sound_end1 = '1' then
				sound_end1 <= '0';
			end if;
		end if;
	end process;
	
	-- Counter for sound2
	process(clk)      
	begin
		if rising_edge(clk) then
			if reset_n = '0' then 
				counter2 <= (others => '0');
				sound_end2 <= '0';
			elsif reset_counters = '1' then
				counter2 <= (others => '0');
			elsif lrck_lat = '1' and lrck = '0'  then 	
				if sound_on = '1' and sound = X"2" then				
					if (counter2 < X"82A") then 
						counter2 <= counter2 + 1;
					else
						counter2 <= (others => '0');
						sound_end2 <= '1';
					end if;	
				end if;
			elsif sound_end2 = '1' then
				sound_end2 <= '0';
			end if;
		end if;
	end process;	
	
	-- Counter for sound3
	process(clk)      
	begin
		if rising_edge(clk) then
			if reset_n = '0' then 
				counter3 <= (others => '0');
				sound_end3 <= '0';
			elsif reset_counters = '1' then
				counter3 <= (others => '0');
			elsif lrck_lat = '1' and lrck = '0'  then 	
				if sound_on = '1' and sound = X"3" then				
					if (counter3 < X"961") then 
						counter3 <= counter3 + 1;
					else
						counter3 <= (others => '0');
						sound_end3 <= '1';
					end if;	
				end if;
			elsif sound_end3 = '1' then
				sound_end3 <= '0';
			end if;
		end if;
	end process;	

	
	process(clk)
	begin
		if rising_edge(clk) then
			lrck_lat <= lrck;
		end if;
	end process;
	
	s0: move_sound_rom port map (
		address		=> std_logic_vector(counter0),
		clock			=> clk,
		q				=> sound0_out
	);
	
	s1: powerup_sound_rom port map (
		address		=> std_logic_vector(counter1),
		clock			=> clk,
		q				=> sound1_out
	);
	
	s2: gameover_sound_rom port map (
		address		=> std_logic_vector(counter2),
		clock			=> clk,
		q				=> sound2_out
	);
	
	s3: snakePlus_sound_rom port map (
		address		=> std_logic_vector(counter3),
		clock			=> clk,
		q				=> sound3_out
	);

end architecture;
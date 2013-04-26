library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity de2_audio_controller is

	port (

		clk			: in  std_logic;
		reset_n		: in  std_logic;
		read			: in  std_logic;
		write			: in  std_logic;
		chipselect	: in  std_logic;
		address		: in  std_logic_vector(3 downto 0);
		readdata		: out std_logic_vector(31 downto 0);
		writedata	: in  std_logic_vector(31 downto 0);	
		 
		 
			-- 	Audio interface signals
		AUD_ADCLRCK	: out std_logic;       --    Audio CODEC ADC LR Clock
		AUD_ADCDAT	: in  std_logic;       --    Audio CODEC ADC Data
		AUD_DACLRCK	: out std_logic;       --    Audio CODEC DAC LR Clock
		AUD_DACDAT	: out std_logic;       --    Audio CODEC DAC Data
		AUD_BCLK		: inout std_logic;     --    Audio CODEC Bit-Stream Clock
		AUD_XCK		: out std_logic;       --	  Chip Clock
		 
		iCLK			: in std_logic;
		iRST_N		: in std_logic;
		I2C_SCLK		: out std_logic;
		I2C_SDAT		: inout std_logic;
		
		leds			: out std_logic_vector(15 downto 0)
	);
  
end de2_audio_controller;


architecture datapath of de2_audio_controller is

component de2_wm8731_audio is
	port (
		clk 				: in std_logic;								--		Audio CODEC Chip Clock AUD_XCK
		reset_n 			: in std_logic;
		 
		start_sound 	: in std_logic;								--		Start sound playback
		select_sound	: in std_logic_vector(3 downto 0);		--		Select a sound
		 
		 -- Audio interface signals
		AUD_ADCLRCK  	: out std_logic;								--    Audio CODEC ADC LR Clock
		AUD_ADCDAT   	: in  std_logic;								--    Audio CODEC ADC Data
		AUD_DACLRCK  	: out std_logic;								--    Audio CODEC DAC LR Clock
		AUD_DACDAT   	: out std_logic;								--    Audio CODEC DAC Data
		AUD_BCLK     	: inout std_logic; 							--    Audio CODEC Bit-Stream Clock
		
		leds       		: out std_logic_vector(15 downto 0)
	);
end component;

component de2_i2c_av_config is
	port (
		iCLK 		: in std_logic;
		iRST_N 	: in std_logic;
		I2C_SCLK : out std_logic;
		I2C_SDAT : inout std_logic
	);
end component;


signal audio_clock : unsigned(1 downto 0) := "00";
signal start		 : std_logic := '0';


begin

	process (clk)
	begin
		if rising_edge(clk) then
			audio_clock <= audio_clock + "1";
		end if;
	end process;
	
	process (clk)
	begin
		if rising_edge(clk) then
			if reset_n = '0' then
				start <= '0';
			elsif chipselect = '1' then
				if read = '1' then
					start <= '1';
				else 
					start <= '0';
				end if;
			end if;
		end if;
	end process;

	AUD_XCK <= audio_clock(1);

	i2c: de2_i2c_av_config port map (
		iCLK     => clk,
		iRST_n   => '1',
		I2C_SCLK => I2C_SCLK,
		I2C_SDAT => I2C_SDAT
	);

	V1: de2_wm8731_audio port map (
		clk				=> audio_clock(1),
		reset_n			=> reset_n,
		start_sound		=> start,
--		select_sound	=> address,
		select_sound	=> X"0",
		  
		  -- 	Audio interface signals
		AUD_ADCLRCK		=> AUD_ADCLRCK,
		AUD_ADCDAT		=> AUD_ADCDAT,
		AUD_DACLRCK		=> AUD_DACLRCK,
		AUD_DACDAT		=> AUD_DACDAT,
		AUD_BCLK			=> AUD_BCLK,
		
		leds 				=> leds
	);

end datapath;
-- de2_audio_controller_0.vhd

-- This file was auto-generated as part of a generation operation.
-- If you edit it your changes will probably be lost.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity de2_audio_controller_0 is
	port (
		clk         : in    std_logic                     := '0';             --          clock.clk
		reset_n     : in    std_logic                     := '0';             --          reset.reset_n
		read        : in    std_logic                     := '0';             -- avalon_slave_0.read
		write       : in    std_logic                     := '0';             --               .write
		chipselect  : in    std_logic                     := '0';             --               .chipselect
		address     : in    std_logic_vector(3 downto 0)  := (others => '0'); --               .address
		readdata    : out   std_logic_vector(31 downto 0);                    --               .readdata
		writedata   : in    std_logic_vector(31 downto 0) := (others => '0'); --               .writedata
		AUD_ADCDAT  : in    std_logic                     := '0';             --    conduit_end.export
		AUD_DACLRCK : out   std_logic;                                        --               .export
		AUD_DACDAT  : out   std_logic;                                        --               .export
		AUD_BCLK    : inout std_logic                     := '0';             --               .export
		AUD_XCK     : out   std_logic;                                        --               .export
		iCLK        : in    std_logic                     := '0';             --               .export
		iRST_N      : in    std_logic                     := '0';             --               .export
		I2C_SCLK    : out   std_logic;                                        --               .export
		I2C_SDAT    : inout std_logic                     := '0';             --               .export
		leds        : out   std_logic_vector(15 downto 0);                    --               .export
		AUD_ADCLRCK : out   std_logic                                         --               .export
	);
end entity de2_audio_controller_0;

architecture rtl of de2_audio_controller_0 is
	component de2_audio_controller is
		port (
			clk         : in    std_logic                     := 'X';             -- clk
			reset_n     : in    std_logic                     := 'X';             -- reset_n
			read        : in    std_logic                     := 'X';             -- read
			write       : in    std_logic                     := 'X';             -- write
			chipselect  : in    std_logic                     := 'X';             -- chipselect
			address     : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- address
			readdata    : out   std_logic_vector(31 downto 0);                    -- readdata
			writedata   : in    std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			AUD_ADCDAT  : in    std_logic                     := 'X';             -- export
			AUD_DACLRCK : out   std_logic;                                        -- export
			AUD_DACDAT  : out   std_logic;                                        -- export
			AUD_BCLK    : inout std_logic                     := 'X';             -- export
			AUD_XCK     : out   std_logic;                                        -- export
			iCLK        : in    std_logic                     := 'X';             -- export
			iRST_N      : in    std_logic                     := 'X';             -- export
			I2C_SCLK    : out   std_logic;                                        -- export
			I2C_SDAT    : inout std_logic                     := 'X';             -- export
			leds        : out   std_logic_vector(15 downto 0);                    -- export
			AUD_ADCLRCK : out   std_logic                                         -- export
		);
	end component de2_audio_controller;

begin

	de2_audio_controller_0 : component de2_audio_controller
		port map (
			clk         => clk,         --          clock.clk
			reset_n     => reset_n,     --          reset.reset_n
			read        => read,        -- avalon_slave_0.read
			write       => write,       --               .write
			chipselect  => chipselect,  --               .chipselect
			address     => address,     --               .address
			readdata    => readdata,    --               .readdata
			writedata   => writedata,   --               .writedata
			AUD_ADCDAT  => AUD_ADCDAT,  --    conduit_end.export
			AUD_DACLRCK => AUD_DACLRCK, --               .export
			AUD_DACDAT  => AUD_DACDAT,  --               .export
			AUD_BCLK    => AUD_BCLK,    --               .export
			AUD_XCK     => AUD_XCK,     --               .export
			iCLK        => iCLK,        --               .export
			iRST_N      => iRST_N,      --               .export
			I2C_SCLK    => I2C_SCLK,    --               .export
			I2C_SDAT    => I2C_SDAT,    --               .export
			leds        => leds,        --               .export
			AUD_ADCLRCK => AUD_ADCLRCK  --               .export
		);

end architecture rtl; -- of de2_audio_controller_0

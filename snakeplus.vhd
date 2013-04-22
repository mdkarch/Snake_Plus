library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity snakeplus is
	port (
		signal CLOCK_50 : in std_logic;
		signal LEDR : out std_logic_vector(17 downto 0);
		SRAM_DQ : inout std_logic_vector(15 downto 0);
		SRAM_ADDR : out std_logic_vector(17 downto 0);
		SRAM_UB_N,
		SRAM_LB_N,
		SRAM_WE_N,
		SRAM_CE_N,
		SRAM_OE_N : out std_logic;

		-- PS/2 port

		 PS2_DAT,                    -- Data
		 PS2_CLK : in std_logic;     -- Clock
		 
		 SW	: in std_logic_vector(17 downto 0);

		 -- VGA output
		 
		 VGA_CLK,                                            -- Clock
		 VGA_HS,                                             -- H_SYNC
		 VGA_VS,                                             -- V_SYNC
		 VGA_BLANK,                                          -- BLANK
		 VGA_SYNC : out std_logic;                           -- SYNC
		 VGA_R,                                              -- Red[9:0]
		 VGA_G,                                              -- Green[9:0]
		 VGA_B : out std_logic_vector(9 downto 0);           -- Blue[9:0]
					  
		AUD_ADCAT : in std_logic;
		AUD_BCLK : inout std_logic;
		AUD_ADCLRCK,
		AUD_DACDAT,
		AUD_DACLRCK,
		AUD_XCK : out std_logic;
		
		I2C_SCLK : out std_logic;
		I2C_SDAT : inout std_logic;
		iCLK,
		iRST_N : in std_logic
);
end snakeplus;
architecture rtl of snakeplus is
signal counter : unsigned(15 downto 0);
signal reset_n : std_logic;
signal was_reset: std_logic := '0';
begin
		LEDR(17) <= '1';
		LEDR(16) <= '1';
		process (CLOCK_50)
		begin
			if rising_edge(CLOCK_50) then
			if was_reset = '0' then
				reset_n <= '0';
				was_reset <= '1';
			else
				reset_n <= '1';
			end if;
		end if;
		end process;
		nios : entity work.snake_system port map (
		clk_0 => CLOCK_50,
		reset_n => reset_n,
		leds_from_the_de2_vga_controller_0 => LEDR(15 downto 0),
		sw_to_the_de2_vga_controller_0 => SW(17 downto 0),
		SRAM_ADDR_from_the_sram => SRAM_ADDR,
		SRAM_CE_N_from_the_sram => SRAM_CE_N,
		SRAM_DQ_to_and_from_the_sram => SRAM_DQ,
		SRAM_LB_N_from_the_sram => SRAM_LB_N,
		SRAM_OE_N_from_the_sram => SRAM_OE_N,
		SRAM_UB_N_from_the_sram => SRAM_UB_N,
		SRAM_WE_N_from_the_sram => SRAM_WE_N,

		PS2_Clk_to_the_ps2 => PS2_CLK,
		PS2_Data_to_the_ps2 => PS2_DAT,
	  
		VGA_BLANK_from_the_de2_vga_controller_0 => VGA_BLANK,
	  
		VGA_B_from_the_de2_vga_controller_0 => VGA_B,
		VGA_CLK_from_the_de2_vga_controller_0 => VGA_CLK,
		VGA_G_from_the_de2_vga_controller_0 => VGA_G,
		VGA_HS_from_the_de2_vga_controller_0 => VGA_HS,
		VGA_R_from_the_de2_vga_controller_0 => VGA_R,
		
		VGA_SYNC_from_the_de2_vga_controller_0 => VGA_SYNC,
		VGA_VS_from_the_de2_vga_controller_0 => VGA_VS,
		
		AUD_ADCDAT_to_the_de2_audio_0 => AUD_ADCAT,
      AUD_ADCLRCK_from_the_de2_audio_0 => AUD_ADCLRCK,
      AUD_BCLK_to_and_from_the_de2_audio_0 => AUD_BCLK,
      AUD_DACDAT_from_the_de2_audio_0 => AUD_DACDAT,
      AUD_DACLRCK_from_the_de2_audio_0 => AUD_DACLRCK,
      AUD_XCK_from_the_de2_audio_0 => AUD_XCK,
      I2C_SCLK_from_the_de2_audio_0 => I2C_SCLK,
      I2C_SDAT_to_and_from_the_de2_audio_0 => I2C_SDAT,
      iCLK_to_the_de2_audio_0 => iCLK,
      iRST_N_to_the_de2_audio_0 => iRST_N
);
end rtl;
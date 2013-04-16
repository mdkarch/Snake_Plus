-- de2_vga_controller_0.vhd

-- This file was auto-generated as part of a generation operation.
-- If you edit it your changes will probably be lost.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity de2_vga_controller_0 is
	port (
		clk        : in  std_logic                     := '0';             --          clock.clk
		reset_n    : in  std_logic                     := '0';             --          reset.reset_n
		read       : in  std_logic                     := '0';             -- avalon_slave_0.read
		write      : in  std_logic                     := '0';             --               .write
		chipselect : in  std_logic                     := '0';             --               .chipselect
		address    : in  std_logic_vector(3 downto 0)  := (others => '0'); --               .address
		readdata   : out std_logic_vector(31 downto 0);                    --               .readdata
		writedata  : in  std_logic_vector(31 downto 0) := (others => '0'); --               .writedata
		VGA_CLK    : out std_logic;                                        --    conduit_end.export
		VGA_HS     : out std_logic;                                        --               .export
		VGA_VS     : out std_logic;                                        --               .export
		VGA_BLANK  : out std_logic;                                        --               .export
		VGA_SYNC   : out std_logic;                                        --               .export
		VGA_R      : out std_logic_vector(9 downto 0);                     --               .export
		VGA_G      : out std_logic_vector(9 downto 0);                     --               .export
		VGA_B      : out std_logic_vector(9 downto 0);                     --               .export
		leds       : out std_logic_vector(15 downto 0);                    --               .export
		sw         : in  std_logic_vector(17 downto 0) := (others => '0')  --               .export
	);
end entity de2_vga_controller_0;

architecture rtl of de2_vga_controller_0 is
	component snake_plus_vga is
		port (
			clk        : in  std_logic                     := 'X';             -- clk
			reset_n    : in  std_logic                     := 'X';             -- reset_n
			read       : in  std_logic                     := 'X';             -- read
			write      : in  std_logic                     := 'X';             -- write
			chipselect : in  std_logic                     := 'X';             -- chipselect
			address    : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- address
			readdata   : out std_logic_vector(31 downto 0);                    -- readdata
			writedata  : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			VGA_CLK    : out std_logic;                                        -- export
			VGA_HS     : out std_logic;                                        -- export
			VGA_VS     : out std_logic;                                        -- export
			VGA_BLANK  : out std_logic;                                        -- export
			VGA_SYNC   : out std_logic;                                        -- export
			VGA_R      : out std_logic_vector(9 downto 0);                     -- export
			VGA_G      : out std_logic_vector(9 downto 0);                     -- export
			VGA_B      : out std_logic_vector(9 downto 0);                     -- export
			leds       : out std_logic_vector(15 downto 0);                    -- export
			sw         : in  std_logic_vector(17 downto 0) := (others => 'X')  -- export
		);
	end component snake_plus_vga;

begin

	de2_vga_controller_0 : component snake_plus_vga
		port map (
			clk        => clk,        --          clock.clk
			reset_n    => reset_n,    --          reset.reset_n
			read       => read,       -- avalon_slave_0.read
			write      => write,      --               .write
			chipselect => chipselect, --               .chipselect
			address    => address,    --               .address
			readdata   => readdata,   --               .readdata
			writedata  => writedata,  --               .writedata
			VGA_CLK    => VGA_CLK,    --    conduit_end.export
			VGA_HS     => VGA_HS,     --               .export
			VGA_VS     => VGA_VS,     --               .export
			VGA_BLANK  => VGA_BLANK,  --               .export
			VGA_SYNC   => VGA_SYNC,   --               .export
			VGA_R      => VGA_R,      --               .export
			VGA_G      => VGA_G,      --               .export
			VGA_B      => VGA_B,      --               .export
			leds       => leds,       --               .export
			sw         => sw          --               .export
		);

end architecture rtl; -- of de2_vga_controller_0

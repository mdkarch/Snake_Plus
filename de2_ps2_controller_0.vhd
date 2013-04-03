-- de2_ps2_controller_0.vhd

-- This file was auto-generated as part of a generation operation.
-- If you edit it your changes will probably be lost.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity de2_ps2_controller_0 is
	port (
		avs_s1_reset      : in std_logic := '0'; -- avalon_slave_0.beginbursttransfer_n
		avs_s1_clk        : in std_logic := '0'; --               .beginbursttransfer_n
		avs_s1_read       : in std_logic := '0'; --             s1.read
		avs_s1_chipselect : in std_logic := '0'; --               .chipselect
		PS2_Clk           : in std_logic := '0'; --    conduit_end.export
		PS2_Data          : in std_logic := '0'  --               .export
	);
end entity de2_ps2_controller_0;

architecture rtl of de2_ps2_controller_0 is
	component de2_ps2 is
		port (
			avs_s1_reset      : in std_logic := 'X'; -- beginbursttransfer_n
			avs_s1_clk        : in std_logic := 'X'; -- beginbursttransfer_n
			avs_s1_read       : in std_logic := 'X'; -- read
			avs_s1_chipselect : in std_logic := 'X'; -- chipselect
			PS2_Clk           : in std_logic := 'X'; -- export
			PS2_Data          : in std_logic := 'X'  -- export
		);
	end component de2_ps2;

begin

	de2_ps2_controller_0 : component de2_ps2
		port map (
			avs_s1_reset      => open,              -- avalon_slave_0.beginbursttransfer_n
			avs_s1_clk        => open,              --               .beginbursttransfer_n
			avs_s1_read       => avs_s1_read,       --             s1.read
			avs_s1_chipselect => avs_s1_chipselect, --               .chipselect
			PS2_Clk           => PS2_Clk,           --    conduit_end.export
			PS2_Data          => PS2_Data           --               .export
		);

end architecture rtl; -- of de2_ps2_controller_0

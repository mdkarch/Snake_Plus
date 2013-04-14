package SPRITES is
	type ram_type is array(4 downto 0) of std_logic_vector(255 downto 0);
	signal SPRITES : ram_type;
	
end package SPRITES;

package body SPRITES is
	--SPRITES(0) <= "00000000000000000000000000000000";

end package body SPRITES;
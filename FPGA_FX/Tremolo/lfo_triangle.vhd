library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity lfo_triangle is
port(

	clk:		in std_logic;
	d_out:	out std_logic_vector(16 downto 0)

);
end lfo_triangle;


architecture solucion of lfo_triangle is

signal contador:				std_logic_vector(16 downto 0) := "00000000000000000";
signal ud:						std_logic;
signal clk2:					std_logic;

begin

process(clk)
begin

if rising_edge (clk) then

	clk2 <= not clk2;

end if;
end process;


process(clk2,ud)
begin
	
	if rising_edge(clk2) then
			
			if ud = '0' then
					
					if contador = 65535 then
							
							contador <= "01111111111111111";
							ud <= not ud;
							
					else
					
							contador <= contador + 1;
					
					end if;
						
			end if;
			
			if ud = '1' then
			
					if contador = 1 then
							
							contador <= "00000000000000000";
							ud <= not ud;
							
					else
					
							contador <= contador - 1;
					
					end if;
			end if;
	end if;
	
end process;
d_out <= contador;
--d_out <= "01111111111111111";
--d_out <= "00000000000000000";
end solucion;
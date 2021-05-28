library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity lfo_cuadrada is
port(

	clk:		in std_logic;
	d_out:	out std_logic_vector(16 downto 0)

);
end lfo_cuadrada;


architecture solucion of lfo_cuadrada is

signal contador:				std_logic_vector(17 downto 0) := (others =>'0');
signal index:					std_logic_vector(16 downto 0) := (others =>'0');
signal ud:						std_logic;

begin


process(clk,ud)
begin
	
	if rising_edge(clk) then
			
			if ud = '0' then
					
					if contador = "011111111111111111" then
							
							contador <= "011111111111111111";
							ud <= not ud;
							
					else
					
							contador <= contador + 1;
					
					end if;
						
			end if;
			
			if ud = '1' then
			
					if contador = 1 then
							
							contador <= (others=>'0');
							ud <= not ud;
							
					else
					
							contador <= contador - 1;
					
					end if;
			end if;
	end if;
	
end process;

process(contador)
begin
	if contador >= 65535  then
		
		index <= "01111111111111111";
		
	else
	
		index <= contador (16 downto 0);
	
	end if;

end process;


d_out <= index;
--d_out <= "01111111111111111";
--d_out <= "00000000000000000";
end solucion;
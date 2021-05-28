  
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity clock is
	port(
				
				CLK:			in std_logic;
				
				MCLK:			out std_logic;
				SCLK:			out std_logic;
				LRCK:			out std_logic
	
	);
end clock;


architecture solucion of clock is

signal contador :		std_logic_vector(10 downto 0);

begin

process (CLK)
begin
if (rising_edge(CLK)) then
		contador <= contador  + 1;
end if;

end process;


MCLK <= contador(0);
SCLK <= contador(2);
LRCK <= contador(8);

end solucion;
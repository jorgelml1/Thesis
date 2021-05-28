library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;


entity lfo_clock is
port(
		clk:				in std_logic;
		lfo_clk:			out std_logic
);
end lfo_clock;

architecture solucion of lfo_clock is

signal contador:			std_logic_vector(19 downto 0);
signal x:					std_logic;
begin

process (clk)
begin
	if rising_edge(clk) then

				if contador = 20 then
					x <= not x;
					contador <= (others =>'0');
				
				else
				
					contador <= contador + 1;
					
				end if;
		end if;
end process;
lfo_clk <= x;

end solucion;


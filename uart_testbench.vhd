library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity uart_testbench is
	port(
						clk: 				in std_logic;
						rx_in:			in std_logic;
						m1,m2:		out std_logic;
						leds:			out std_logic_vector(7 downto 0)	
	);
end uart_testbench;

architecture solucion of uart_testbench is
signal temp:		std_logic_vector(7 downto 0);
signal y:		std_logic;
component uart 
	port(
						clk: 				in std_logic;
						rx_in:			in std_logic;
						data_ok:	out std_logic;
						data:			out std_logic_vector(7 downto 0)	
	);
end component;


begin


U1:  uart port map(clk,rx_in,y, temp);

leds <= not temp;



m1  <= '0' when temp = "01110011" else '1';
m2 <= '0' when temp = "01100001" else '1';
end solucion;

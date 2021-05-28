library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity tremolo is
port (
	
	clk:			in std_logic;
	
	en:			in std_logic;
	wave:			in std_logic;
	
	valid_in:	in 	std_logic;
	valid_out:	out 	std_logic;
	
	data_in:		in 	signed(23 downto 0);
	data_out:	out	signed(23 downto 0)

);
end tremolo;

architecture solucion of tremolo is

signal w_square:				std_logic_vector(16 downto 0);
signal w_triangle:			std_logic_vector(16 downto 0);
signal w_type:					std_logic_vector(16 downto 0);
signal clklfo:					std_logic;
signal data_p:					signed(23 downto 0);

component lfo_clock is
port(
		clk:		in std_logic;
		lfo_clk:	out std_logic
);
end component;

component lfo_cuadrada is
port(

	clk:		in std_logic;
	d_out:	out std_logic_vector(16 downto 0)
);
end component;

component lfo_triangle is
port(

	clk:		in std_logic;
	d_out:	out std_logic_vector(16 downto 0)
);
end component;

component tremcpu is
port (
	
	clk:			in std_logic;
	
	valid_in:	in 	std_logic;
	valid_out:	out 	std_logic;
	
	data_in:		in 	signed(23 downto 0);
	data_out:	out	signed(23 downto 0);
	
	factor:		in 	std_logic_vector(16 downto 0)

);
end component;


begin

divisor:		lfo_clock
port map(
	
	clk 			=> clk,
	lfo_clk 		=> clklfo
);


lfo1:	lfo_triangle
port map(
	clk 			=> clklfo,
	d_out 		=> w_triangle
);

lfo2:	lfo_cuadrada
port map(
	clk 			=> clklfo,
	d_out 		=> w_square
);


cpu: tremcpu
port map(
	clk			=>		clk,
	
	valid_in 	=>		valid_in,
	valid_out 	=>		valid_out,
	
	data_in		=>		data_in,
	data_out		=>		data_p,
	
	factor		=>		w_type
);

--TRUEBYPASS

data_out <= data_p when en = '1' else data_in;

w_type <= w_triangle when wave = '1' else w_square;

end solucion;
library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity tremcpu is
port (
	
	clk:			in std_logic;
	
	valid_in:	in 	std_logic;
	valid_out:	out 	std_logic;
	
	data_in:		in 	signed(23 downto 0);
	data_out:	out	signed(23 downto 0);
	
	factor:		in 	std_logic_vector(16 downto 0)
);
end tremcpu;

architecture solucion of tremcpu is

signal state : 						integer := 0;
signal mult_in_a:				   	signed(23 downto 0)  := (others =>'0');
signal mult_in_b:   					signed(16 downto 0)  := (others =>'0');
signal mult_out:						signed(40 downto 0) := (others =>'0');
signal temp_out:						signed (23 downto 0);
begin


--TREMOLO PROCESAMIENTO
process (clk)
begin
if (rising_edge(clk)) then    

    if (valid_in = '1' and state = 0) then
		 
		  mult_in_a <= data_in;
		  mult_in_b<= signed(factor);

        state <= 1;

	elsif (state = 1) then

        temp_out <= resize(shift_right(mult_out,16),24);
        state <= 2;

     elsif (state = 2) then

		data_out <= temp_out; 
		  valid_out <= '1';
        state <= 3;

      elsif (state = 3) then

			valid_out <= '0';
			state <= 0;
			
      end if;      
    

end if;
end process;


--MULTIPLICADOR
process(mult_in_a, mult_in_b)
begin
mult_out <= mult_in_a * mult_in_b;
end process;

 
end solucion;
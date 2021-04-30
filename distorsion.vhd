library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity distorsion is

port(
	
	clk:			in std_logic;

	data_in:		in signed(23 downto 0);
	
	data_out:	out signed(23 downto 0);
	
	valid_in:	in std_logic;
	
	valid_out:	out std_logic;
	
	umbral_p:     integer;
	umbral_n:     integer;
	
	gain:				integer;
	
	volumen:			integer
	
);

end distorsion;

architecture solucion of distorsion is

signal umbralp_temp:		signed(23 downto 0);
signal umbraln_temp:		signed(23 downto 0);
signal data_out_temp:	signed (23 downto 0);
signal state : 			integer := 0;
signal data_in_temp:		signed(23 downto 0);
signal mult_in_a:			signed(23 downto 0)  := (others =>'0');
signal mult_in_b:   		signed(31 downto 0)  := (others =>'0');
signal mult_out :			signed(55 downto 0) := (others =>'0');

begin


umbralp_temp <= to_signed(umbral_p,24);
umbraln_temp <= to_signed(umbral_n,24);

---MULTIPLICADOR
process(mult_in_a,mult_in_b)
begin
	mult_out <= mult_in_a*mult_in_b;
end process;



process(clk)
begin
if rising_edge(clk) then
	
			if(valid_in = '1' and state = 0) then
						
						mult_in_a <= data_in;
						mult_in_b <= to_signed(gain,32);
						
						state <= 1;
			
			elsif (state = 1) then
			
						data_in_temp <= resize(shift_right(mult_out,27),24);
						state <= 2;
						
			elsif(state = 2) then
			
						if (data_in_temp >= umbralp_temp) then
		
								data_out_temp <= umbralp_temp;
								
						else 
						
							if (data_in_temp >= umbraln_temp) then
		
								data_out_temp <= data_in_temp;
								
							else 
						
								data_out_temp <= umbraln_temp;						
							
							end if;							
							
						end if;		
							
					state <= 3;	
					
			elsif( state = 3) then
			
						mult_in_a <= data_out_temp;
						mult_in_b <= to_signed(volumen,32);
						
						state <= 4;
			
			
			elsif(state = 4) then
						
						data_out <= resize(shift_right(mult_out,28),24);
						valid_out <= '1';
						state <= 5;
			
			elsif(state = 5) then
					
						valid_out <= '0';
						state <= 0;
			end if;
end if;
end process;	
	

end solucion;


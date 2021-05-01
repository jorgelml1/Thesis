library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity iir_2order is
port(
		clk:				in std_logic;
		
		data_in:			in signed (23 downto 0);
		data_out:		out signed (23 downto 0);
		
		valid_in:		in std_logic;
		valid_out:		out std_logic;
		
		a0 : integer;
		a1 : integer;
		a2 : integer;
		b1 : integer;
		b2 : integer

);
end iir_2order;

architecture solucion of iir_2order is


signal state : integer := 0;

signal mult_in_a:				   	signed(23 downto 0)  := (others =>'0');
signal mult_in_b:   					signed(31 downto 0)  := (others =>'0');
signal mult_out :						signed(55 downto 0) := (others =>'0');

signal temp :							signed (39 downto 0):= (others=>'0');
signal temp_in, in_z1, in_z2, out_z1, out_z2 : signed (23 downto 0):= (others=>'0');


begin

process(mult_in_a, mult_in_b)
begin
mult_out <= mult_in_a * mult_in_b;
end process;



process (clk)
begin
if (rising_edge(clk)) then    


    if (valid_in = '1' and state = 0) then
        mult_in_a <= data_in;
        temp_in <= data_in;
        mult_in_b <= to_signed(a0,32);
        state <= 1;

    elsif (state = 1) then

        temp <= resize(shift_right(mult_out,30),40);
        mult_in_a <= in_z1;
        mult_in_b <= to_signed(a1,32);
        state <= 2;

     elsif (state = 2) then

        temp <= temp + resize(shift_right(mult_out,30),40);
        mult_in_a <= in_z2;
        mult_in_b <= to_signed(a2,32);
        state <= 3;

         
      elsif (state = 3) then


        temp <= temp + resize(shift_right(mult_out,30),40);
        mult_in_a <= out_z1;
        mult_in_b <= to_signed(b1,32);
        state <= 4;

      elsif (state = 4) then

        temp <= temp - resize(shift_right(mult_out,30),40);
        mult_in_a <= out_z2;
        mult_in_b <= to_signed(b2,32);
        state <= 5;

      elsif (state = 5) then

        temp <= temp - resize(shift_right(mult_out,30),40);
        state <= 6;
        
      elsif (state = 6) then

        data_out <= resize(temp,24);
        out_z1 <= resize(temp,24);
        out_z2 <= out_z1;       
        in_z2 <= in_z1;
        in_z1 <= temp_in;
        valid_out <= '1';
        state <= 7;
        
      elsif (state = 7) then
		
        valid_out <= '0';
        state <= 0;
		  
      end if;      
    

end if;
end process;
end solucion;

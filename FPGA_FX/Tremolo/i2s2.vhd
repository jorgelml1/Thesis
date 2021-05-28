library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity i2s2 is
port(
			MCLK:							in std_logic;
			LRCK : 						in std_logic;
			SCLK:							in std_logic;
			AD_SDOUT:					in std_logic;
			DA_SDIN:						out std_logic := '0';
			
			out_l:						out signed (23 downto 0)  := (others => '0');
			out_r:						out signed (23 downto 0)  := (others => '0');
			
			in_l:							in signed (23 downto 0);
			in_r:							in signed (23 downto 0);
			
			SYNC:							out std_logic := '0'
);
end i2s2;


architecture solucion of i2s2 is

--------------------------------------------------------------------------
--REGISTROS DE ENTRADA Y SALIDA
--------------------------------------------------------------------------

signal in_shift :			std_logic_vector (63 downto 0) := (others=>'0');
signal out_shift:			std_logic_vector (63 downto 0) := (others=>'0');

---------------------------------------------------------------------------
--DETECTORES DE FLANCOS
---------------------------------------------------------------------------

signal SCLK_edge:		std_logic_vector(1 downto 0) := (others =>'0');
signal LRCK_edge:		std_logic_vector(1 downto 0) := (others =>'0');
signal framesync : 		std_logic := '0';


begin

---------------------------------------------------------------------------
--DETECTORES DE FLANCOS
---------------------------------------------------------------------------
process (MCLK)
begin
if (rising_edge(MCLK)) then
    
	SCLK_edge <= SCLK_edge(0) & SCLK;
	LRCK_edge <= LRCK_edge(0) & LRCK;     
    
end if;
end process;	

process (MCLK)
begin 
if (rising_edge(MCLK)) then

	if (LRCK_edge = "10") then
		framesync <= '1';
	elsif (SCLK_edge = "01") then
		framesync <= '0';
	end if;
    
end if;
end process;

---------------------------------------------------------------------------
--REGISTRO DE ENTRADA
---------------------------------------------------------------------------

process (MCLK)
begin
if (rising_edge(MCLK)) then
    
	if (SCLK_edge = "10") then
		in_shift <= in_shift(62 downto 0) & AD_SDOUT;
		
			if (LRCK_edge = "10") then                
	   
			out_l <= signed(in_shift(62 downto 39));
			out_r <= signed(in_shift(30 downto 7));
			SYNC <= '1';
			
			end if;      
	else
			SYNC  <= '0';
	end if;
	
 end if;
end process;

---------------------------------------------------------------------------
--REGISTRO DE SALIDA
---------------------------------------------------------------------------

process (MCLK)
begin
if (rising_edge(MCLK)) then
    
	if (SCLK_edge = "01") then
	   DA_SDIN <= out_shift(63);
		out_shift <= out_shift(62 downto 0) & '0';  
	elsif (SCLK_edge = "00" and framesync='1') then
		out_shift <= std_logic_vector(in_l) & "00000000" & std_logic_vector(in_r) & "00000000";
	end if;  
           
    
end if;
end process;

	

end solucion;
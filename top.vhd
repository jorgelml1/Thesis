library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity top is

port (
		
			MCLK1:						out std_logic;
			LRCK1: 						out std_logic;
			SCLK1:						out std_logic;
			MCLK2:						out std_logic;
			LRCK2: 						out std_logic;
			SCLK2:						out std_logic;			
			AD_SDOUT:					in std_logic;
			DA_SDIN:						out std_logic := '0';
			
			CLK:								in std_logic

);

end top;


architecture solucion of top is


---------------------------------------------

component i2s2 is
port(
			MCLK:							in std_logic;
			LRCK : 						in std_logic;
			SCLK:							in std_logic;
			AD_SDOUT:			in std_logic;
			DA_SDIN:				out std_logic := '0';
			
			out_l:							out signed (23 downto 0)  := (others => '0');
			out_r:							out signed (23 downto 0)  := (others => '0');
			
			in_l:								in signed (23 downto 0);
			in_r:								in signed (23 downto 0);
			
			SYNC:							out std_logic := '0'
);
end component;

component clock is
	port(
				
				CLK:				in std_logic;
				
				MCLK:			out std_logic;
				SCLK:			out std_logic;
				LRCK:			out std_logic
	
	);
end component;

component ganancia is

	port(
		
		clk:			in std_logic;
		
		data_in:		in signed (23 downto 0);
		valid_in:	in std_logic;
		valid_out:	out std_logic;		
		data_out:	out signed (23 downto 0) := (others =>'0');
		
		a0: integer
	
	);
end component;


component distorsion is

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
end component;


component iir_2order is
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
end component;




-------------------------------------------------

signal MCLK_TEMP:		std_logic;
signal LRCK_TEMP:		std_logic;
signal SCLK_TEMP:		std_logic;

signal DA_SDIN_TEMP:				std_logic;
signal left_s, left_p:			signed (23 downto 0);
signal right_s, right_p:		signed(23 downto 0); 
signal sync:						std_logic;  
signal valid_gain_l, valid_gain_r:			std_logic;
signal valid_filtro_r,valid_filtro2_r:		std_logic;
signal right_distor, left_distor:			signed (23 downto 0);
signal right_distor_p:							signed (23 downto 0);
signal right_distor_pp, right_distor_ppp:	signed (23 downto 0);


begin

rxtx : i2s2
    port map (

        MCLK 					=> MCLK_TEMP,
			LRCK 					=> LRCK_TEMP,
        SCLK 					=> SCLK_TEMP,
        AD_SDOUT 	=> AD_SDOUT,
        DA_SDIN 		=> DA_SDIN,
        
		  out_l 					=> left_s,
        out_r 					=> right_s,
        
        in_l					=> right_distor_ppp,
        in_r					=> right_s,
        
        SYNC					=> sync
		  
      );

clkgen: clock
	port map(
				
				CLK				=>		CLK,
				MCLK				=> 	MCLK_TEMP,
				SCLK				=> 	SCLK_TEMP,
				LRCK			   =>		LRCK_TEMP
	);
	


dist1:	distorsion 

port map(
	
	clk			=> CLK,

	data_in		=> left_s,
	
	data_out		=> right_distor,
	
	valid_in		=> sync,
	
	valid_out	=>	valid_gain_r,
	
	umbral_p		=>  524288,
	umbral_n		=>  -524288,
	
	gain			=> 671088640,
	
	volumen     => 402653184
	
	
);

dist2: distorsion 

port map(
	
	clk			=> CLK,

	data_in		=> right_distor,
	
	data_out		=> left_distor,
	
	valid_in		=> valid_gain_r,
	
	valid_out	=>	open,
	
	umbral_p		=>  131072,
	umbral_n		=>  -131072,
	
	gain =>       	805306368,
	
	volumen     => 402653184
	
	
);

filtro:	iir_2order 
port map(
		clk				=> CLK,
		
		data_in			=> right_distor,
		data_out			=> right_distor_p,
		
		valid_in			=> valid_gain_r,
		valid_out		=> valid_filtro_r,
		
		a0 				=> 16178689,
		a1 				=>	32357378,
		a2 				=>	16178689,
		b1 				=>	-1900237922,
		b2 				=> 881210855

);		

filtro2:	iir_2order 
port map(
		clk				=> CLK,
		
		data_in			=> right_distor_P,
		data_out			=> right_distor_pp,
		
		valid_in			=> valid_filtro_r,
		valid_out		=> valid_filtro2_r,
		
		a0 				=> 1053253797,
		a1 				=>	-2106507594,
		a2 				=>	1053253797,
		b1 				=>	-2105111758,
		b2 				=> 1034161607

);	


filtro3:	iir_2order 
port map(
		clk				=> CLK,
		
		data_in			=> right_distor_pp,
		data_out			=> right_distor_ppp,
		
		valid_in			=> valid_filtro2_r,
		valid_out		=> open,
		
		a0 				=> 1053253797,
		a1 				=>	-2106507594,
		a2 				=>	1053253797,
		b1 				=>	-2105111758,
		b2 				=> 1034161607

);			


MCLK1 <= MCLK_TEMP;
LRCK1 <= LRCK_TEMP;
SCLK1 <= SCLK_TEMP;

MCLK2 <= MCLK_TEMP;
LRCK2 <= LRCK_TEMP;
SCLK2 <= SCLK_TEMP;

--DA_SDIN <= not DA_SDIN_TEMP;
end solucion;

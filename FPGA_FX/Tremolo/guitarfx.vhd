library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity guitarfx is

port (
		
			MCLK1:						out std_logic;
			LRCK1: 						out std_logic;
			SCLK1:						out std_logic;
			MCLK2:						out std_logic;
			LRCK2: 						out std_logic;
			SCLK2:						out std_logic;			
			AD_SDOUT:					in std_logic;
			DA_SDIN:						out std_logic := '0';
			
			CLK:							in std_logic;
			
			en:							in std_logic;
			wave:							in std_logic
);

end guitarfx;


architecture solucion of guitarfx is


--RELOJES DEL PROCESO
component clock is
	port(
				
				CLK:			in std_logic;
				
				MCLK:			out std_logic;
				SCLK:			out std_logic;
				LRCK:			out std_logic
	
	);
end component;

--TX y RX AUDIO
component i2s2 is
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
end component;

--------------

component tremolo is
port (
	
	clk:			in std_logic;
	
	en:			in std_logic;
	wave:			in std_logic;
	
	valid_in:	in 	std_logic;
	valid_out:	out 	std_logic;
	
	data_in:		in 	signed(23 downto 0);
	data_out:	out	signed(23 downto 0)

);
end component;



--CONEXIONES

signal MCLK_TEMP:		std_logic;
signal LRCK_TEMP:		std_logic;
signal SCLK_TEMP:		std_logic;

signal DA_SDIN_TEMP:				std_logic;
signal left_s, left_p:			signed (23 downto 0);
signal right_s, left_trem:		signed(23 downto 0); 
signal sync:						std_logic;  
signal valid_phaser:				std_logic;


begin

rxtx : i2s2
    port map (

        MCLK 					=> MCLK_TEMP,
			LRCK 					=> LRCK_TEMP,
        SCLK 					=> SCLK_TEMP,
        AD_SDOUT 				=> AD_SDOUT,
        DA_SDIN 				=> DA_SDIN,
        
		  out_l 					=> left_s,
        out_r 					=> right_s,
        
        in_l					=> left_p,
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
	
MCLK1 <= MCLK_TEMP;
LRCK1 <= LRCK_TEMP;
SCLK1 <= SCLK_TEMP;

MCLK2 <= MCLK_TEMP;
LRCK2 <= LRCK_TEMP;
SCLK2 <= SCLK_TEMP;

tremolofx: tremolo

port map(
	
	clk		=> CLK,
	
	en			=> en,
	wave		=> wave,
	
	valid_in		=> sync,
	valid_out 	=> open,
	
	data_in 		=>  left_s,
	data_out 	=>  left_p

);


end solucion;
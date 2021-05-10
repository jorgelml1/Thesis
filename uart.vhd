library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity uart is
	port(
						clk: 				in std_logic;
						rx_in:			in std_logic;
						data_ok:	out std_logic;
						data:			out std_logic_vector(7 downto 0)	
	);
end uart;


architecture solucion of uart is
			signal counter:			std_logic_vector(9 downto 0);
			signal data_temp:	  std_logic_vector(7 downto 0);
			signal enable:			std_logic;
			type estados is     (S0,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10);
			signal ep: 					estados;
begin

-- Contador 434 pulsos de clock
	process(clk,enable)
	begin
				if rising_edge(clk) then
						if enable = '1' then
								counter <= counter + 1;
										if counter  = 434 then
												counter <= (others =>'0');
										end if;
						end if;				
				end if;	
	end process;
	
	
-- Maquina de estados del controlador UART
	process(clk)
    
  begin
			if rising_edge(clk) then
					case ep is
					
										-- Detecta el bit de start = '0'
										when S0 => enable <= '0';data_ok<='0';	
											if rx_in = '0' then
													ep <= S1;
											else
													
													ep  <= S0;
											end if;
										
										-- Hace la lectura del bit de start
										when S1 => enable <= '1';
											if counter = 434 then
													ep <= S2;
											else
													ep <= S1;
											end if;
											
										-- Hace la lectura del primer bit
										when S2 => enable <= '1';
											if counter = 217 then
													data_temp(0) <= rx_in;
											end if;
											
											if counter = 434 then
													ep <= S3;
											else
													ep <= S2;
											end if;

										-- Hace la lectura del segundo bit
										when S3 => enable <= '1';
											if counter = 217 then
													data_temp(1) <= rx_in;
											end if;
											
											if counter = 434 then
													ep <= S4;
											else
													ep <= S3;
											end if;											

										-- Hace la lectura del tercer bit
										when S4 => enable <= '1';
											if counter = 217 then
													data_temp(2) <= rx_in;
											end if;
											
											if counter = 434 then
													ep <= S5;
											else
													ep <= S4;
											end if;												
	
										-- Hace la lectura del cuarto bit
										when S5 => enable <= '1';
											if counter = 217 then
													data_temp(3) <= rx_in;
											end if;
											
											if counter = 434 then
													ep <= S6;
											else
													ep <= S5;
											end if;
	
											-- Hace la lectura del quinto bit
										when S6 => enable <= '1';
											if counter = 217 then
													data_temp(4) <= rx_in;
											end if;
											
											if counter = 434 then
													ep <= S7;
											else
													ep <= S6;
											end if;
	
												-- Hace la lectura del sexto bit
										when S7 => enable <= '1';
											if counter = 217 then
													data_temp(5) <= rx_in;
											end if;
											
											if counter = 434 then
													ep <= S8;
											else
													ep <= S7;
											end if;
	
												-- Hace la lectura del septimo bit
										when S8 => enable <= '1';
											if counter = 217 then
													data_temp(6) <= rx_in;
											end if;
											
											if counter = 434 then
													ep <= S9;
											else
													ep <= S8;
											end if;	

												-- Hace la lectura del octavo bit
										when S9 => enable <= '1';
											if counter = 300 then
													data_temp(7) <= rx_in;
											end if;
											
											if counter = 434 then
													ep <= S10;
											else
													ep <= S9;
											end if;											

												-- Hace la lectura del bit de parada
										when S10 => enable <= '1';data_ok<='1';
											if counter = 434 then
													ep <= S0;
											else
													ep <= S10;
											end if;																
						
				end case;
		end if;
	end process;	

	data <= data_temp;


end solucion;


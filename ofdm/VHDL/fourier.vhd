----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:48:50 05/15/2015 
-- Design Name: 
-- Module Name:    fourier - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------



--Informacion de la ifft 

--Maquina de estados
--	Reposo: Me mantengo en él hasta que recibo la confirmación de escritura del primer valor en la memoria
--	Voy a tener cargada la configuracion inicial
--		-->fwd_inv = 0 and fwd_inv_we = 1
-- 	-->CP_LEN=001100 	 
--		-->CP_LEN_WE=1 Mientras dure mas de tres ciclos desde que se ejecuta el start ya no se va a poder cambiar


--	la comprobacion del dato en la ram pone start=1 (se queda puesto hasta el final)

--LA IFFT CUANDO EMPIEZA A TRASMITIR TIENE QUE PONER LA REAL E IMAGINARIA Y CAMBIAR EN CADA CLK
library IEEE;


use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.STD_LOGIC_1164.ALL;


-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fourier is
	generic(
		ancho_bus_dir:integer:=7; --Declararlo asi me permite poder hacer ifft
										  --de distinto tamaño en complicaciones posteriores
		precision:integer:=8     
										  
					);					  
		Port ( 
			  clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           block_valid: in std_logic;
			  data_re : in  STD_LOGIC_VECTOR (precision-1 downto 0);
			  data_im : in  STD_LOGIC_VECTOR (precision-1 downto 0);
           direcc_re : out  STD_LOGIC_VECTOR (ancho_bus_dir-1 downto 0);
			  direcc_im : out  STD_LOGIC_VECTOR (ancho_bus_dir-1 downto 0);
			  direcc_out: out STD_LOGIC_VECTOR (9 downto 0);
				data_out: out  STD_LOGIC_VECTOR (31 downto 0);
				data_valid : OUT STD_LOGIC--Para que el transmisor pueda empezar a enviar desde la primera linea
				);
		
end fourier;
  

----------Inicio de arquitectura----------
architecture Behavioral of fourier is


COMPONENT ifft
  PORT (
    clk : IN STD_LOGIC;
    start : IN STD_LOGIC;  --Mantener on desde primer a ultimo simbolo ES NECESARIO EN EL PRIMER BLOQUE 
    unload : IN STD_LOGIC; --¿está bien la eleccion? junto a edone
    cp_len : IN STD_LOGIC_VECTOR(6 DOWNTO 0);  --Tamaño prefijo
    cp_len_we : IN STD_LOGIC;  					  --Estas diciendo el tamaño. Mientras duren mas de 3 ciclos es suficiente
    xn_re : IN STD_LOGIC_VECTOR(7 DOWNTO 0);  
    xn_im : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    fwd_inv : IN STD_LOGIC;                    --Configuracion del bloque
    fwd_inv_we : IN STD_LOGIC;					  --Configuracion del bloque
    rfd : OUT STD_LOGIC;  							  --Fin de estado Inicio
    xn_index : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);--Indice carga
    busy : OUT STD_LOGIC;
    edone : OUT STD_LOGIC;                     --Secuencia de descarga
    done : OUT STD_LOGIC;							  --Secuencia de descarga
    dv : OUT STD_LOGIC;     						  --Data_valid
    xk_index : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);--Indice descarga
    cpv : OUT STD_LOGIC; 							  --Descargando prefijo cilico
    xk_re : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    xk_im : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END COMPONENT;

component Descarga_IFFT is
    Port (clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           enable : in  STD_LOGIC;  --Del DV
           xk_re : in  STD_LOGIC_VECTOR (15 downto 0);
           xk_im : in  STD_LOGIC_VECTOR (15 downto 0);
			  datamemoria: OUT STD_LOGIC_VECTOR (31 downto 0); 
			  data_valid : out  STD_LOGIC;  --directamente de DV de la ifft
			  direcc: out STD_LOGIC_VECTOR (9 downto 0)  --De escritura en la memoria
																		--es de 9 bits pq incluye el PC y todos
																		--los simbolos posibles (hasta 7)  
			  ); 
end component;






--Definicion de señales
Type estado is (	Reposo, EsperaRFD, CargaDatos, EsperaEdone, DobleMensaje); --Para la maquina de estados
signal a_estado, p_estado: estado;

signal rfd: std_logic;
signal cp_len_we, fwd_inv, fwd_inv_we, a_start, a_unload, edone,dv: std_logic; 
signal cp_len, xn_index: STD_LOGIC_VECTOR (6 downto 0);
signal  xk_re,xk_im :   STD_LOGIC_VECTOR (15 downto 0);
signal Dmemoria_descarga:  STD_LOGIC_VECTOR (31 downto 0); 

-- xk_index,done
begin

  bloque_ifft_prefijo : ifft
  PORT MAP (
    clk => clk,
    start => a_start,
    unload => a_unload,
    cp_len => cp_len,
    cp_len_we => cp_len_we,
    xn_re => data_re,
    xn_im => data_im,
    fwd_inv => fwd_inv,
    fwd_inv_we => fwd_inv_we,
    rfd => rfd,
    xn_index => xn_index,
    busy => open,
    edone => edone,
    done => open,
    dv => dv,
    xk_index => open,
    cpv => open,
    xk_re => xk_re,
    xk_im => xk_im
  );
  
Descarga: Descarga_IFFT 
    Port map( clk=>clk,
           reset=>reset,
			  enable =>dv,  --Del DV de la ifft
           xk_re =>xk_re,
           xk_im =>xk_im,
			  datamemoria=>Dmemoria_descarga,
			  data_valid =>data_valid, --directamente de DV de la ifft
			  direcc=>direcc_out  --De escritura en la memoria de la que leerá el transmisor
			  ); 
  


direcc_re<=xn_index;

direcc_im<=xn_index;

data_out<=Dmemoria_descarga;

sinc:process (clk,reset) 
begin
	if (reset='1' ) then 
	--Estado de partida
		a_estado<=reposo;
		cp_len<="0001100";
      cp_len_we<='1';
		fwd_inv<='0';
		fwd_inv_we<='1';
	elsif(rising_edge(clk)) then  
		a_estado<=p_estado;  
		
	end if;

end process;


comb:process (a_estado,block_valid,rfd, edone,xn_index)
begin

---------------Condiciones por defecto--------------
	p_estado<=a_estado;
	a_start<='0'; 
	a_unload<='0'; 
	
	--Configuracion de IFFT, mientras dure mas de 3 ciclos de reloj desde start seria suficiente
	--pero si se deja puesto tampoco pasa nada
	cp_len<="0001100";
	cp_len_we<='1';
	fwd_inv<='0';
	fwd_inv_we<='1'; 
	case a_estado is
	 --Debemos incluir toda la casuistica de datos entrantes y situacion de la ifft para que no se pierdan datos por el camino
	 
		when reposo => 
				if(block_valid='1') then
					p_estado<=EsperaRFD;
				
				end if;
				
--		when esperaIFFT =>
--				if(busy='0') then
--				p_estado<=esperaRFD;
--				end if;
--			
		when EsperaRFD =>
			a_start<='1';
				if(rfd='1') then   --RFD solo se va a poner despues de a_start y yo me encargo de que
										 --esta solo se active antes de cada bloque de datos
				p_estado<=CargaDatos;
				end if;
			
		when CargaDatos =>			
			--La lectura se hace automaticamente gracias a la latencia de la memoria
			if (xn_index="1111111") then --He llegado al final de la memoria y
				p_estado<=EsperaEdone;	--despues de escribir los ultimos datos quiero
												--esperar a que se vuelva a rellenar la memoria
			
			end if;
			
			
			when EsperaEdone => 
			   if(edone='1') then   
			      a_unload<='1';	
					p_estado<=reposo;
				end if;
				if(block_valid='1') then --Me avisan de que ya está listo el siguiente bloque a transmitir mientras sigue trabajndo la ifft
			     p_estado<=DobleMensaje;
				end if;
				
		when  DobleMensaje =>
				 if(edone='1') then   
			      a_unload<='1';	
					p_estado<=esperaRFD;
				end if;
--			
		
			
      end case;
		
	end process;
end Behavioral;


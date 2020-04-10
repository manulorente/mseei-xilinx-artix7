library IEEE;


use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CompletaMensaje is
	generic(
		ancho_byte:integer:=8;
		ancho_bus_dir:integer:=6; --Hasta 64 caracteres, nuestros nombres ocupan unos 39
		val_sat_cont3:integer:=6   --Hay que poner 600 para qeu cumpla el estandar sin sobreescribir en
											--el interleaver
		);
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  palanca1: in  STD_LOGIC; --Dbpsk
			  palanca2: in  STD_LOGIC; --Dqpsk
			  palanca3: in  STD_LOGIC; --D8psk           
           data_out : out  STD_LOGIC;
			  data_valid: out  STD_LOGIC;
			  error : out  STD_LOGIC;  --Va a encender los leds de la fpga indicando que no se puede hacer esa combinacion 
           modulacion : out  STD_LOGIC_VECTOR (2 downto 0)); --va a darle al resto de los bloques la modulacion
																				 --que se utiliza desde lo que lea de las palancas
																				 --001 Dbpsk
																				 --010 Dqpsk
																				 --100 D8psk
end CompletaMensaje;

architecture Behavioral of CompletaMensaje is


COMPONENT DatosEntrada
  PORT (   
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END COMPONENT;


Type estado is (Reposo, compruebaMod, serializa_dbpsk, serializa_dqpsk, serializa_d8psk, cerosencoder_dbpsk, cerosencoder_dqpsk,cerosencoder_d8psk, completa_dbpsk,completa_dqpsk,completa_d8psk, final);
signal a_estado, p_estado: estado;
signal cont1, p_cont1: integer; --Usado para serializar cada byte y para los ceros del encoder
signal cont2, p_cont2: integer; --Usado para comrobar el tamaño del simbolo
signal dir, p_dir: STD_LOGIC_VECTOR (ancho_bus_dir-1 downto 0); --Acceso a memoria
signal datavalid,p_datavalid : std_logic;
signal dataout,p_dataout : std_logic;

signal cont3, p_cont3: integer;
--STD_LOGIC_VECTOR (val_sat_cont3-1 downto 0); --Usado para darle tiempo al encoder 


signal a_modu, p_modu: STD_LOGIC_VECTOR (2 downto 0);

signal data_in :  STD_LOGIC_VECTOR (ancho_byte-1 downto 0); 
signal a_err, p_err: std_logic; --Usado para encender los leds de la fpga en caso de error



begin

Fichero_nombres : DatosEntrada
  PORT MAP (
    clka => clk,
    addra => dir,
    douta => data_in
  );

sinc: process(clk,reset) 
begin  
		if(reset='1') then   
				cont1<=7;
				cont2<=0;
				cont3<=0;
				dir<=(others=>'0');
				datavalid<='0';
				a_estado<=reposo;
				dataout<='0';
				a_modu<=(others=>'0');
				a_err<='0';
--				
		elsif (rising_edge(clk)) then 
				cont1<=p_cont1;  --Para completar el mensaje
				cont2<=p_cont2;  --Para serializar el mensaje
				cont3<=p_cont3;  --Para darle un respiro al encoder y que solo salgan datos cada vez que sature
				dir<=p_dir;
				datavalid<=p_datavalid;
				dataout<=p_dataout;
				a_estado<=p_estado; 
				a_modu<=p_modu;
				a_err<=p_err;

			
	    end if; 
end process;

---------------interconexiones necesarias-------------------

data_valid<=datavalid;
data_out<=dataout;
modulacion<=a_modu;
error<=a_err;

comb:process (a_estado, palanca1, palanca2, palanca3, data_in, cont1, cont2,cont3, datavalid, dataout, dir,a_modu,a_err)--a_modu

variable fin : STD_LOGIC_VECTOR (ancho_byte downto 0); --Para comprobacion de final de mensaje
--variable sat_cont3 : STD_LOGIC_VECTOR (val_sat_cont3-1 downto 0); --Para comprobacion de final de mensaje

begin
fin:=(others=>'0'); 
--sat_cont3:=(others=>'1');

---------Condiciones por defecto para todos los estados-------------------
	p_estado<=a_estado; 
	p_dir<=dir;
	p_cont1<=cont1;
	p_cont2<=cont2;
	p_datavalid<='0';
	p_dataout<=dataout;
	p_cont3<=cont3;
--   error<='0';
--	modulacion<="000";
	p_err<=a_err;
	p_modu<=a_modu;
	p_cont3<=cont3+1; --  val_sat_cont3  p_cont3<=0;
	
	
	
----------------------Maquina de estados----------------------------------

	case a_estado is
		   
			when reposo =>
					p_cont3<=cont3;
					if (palanca1='1' or palanca2='1' or palanca3='1') then
						p_estado<=CompruebaMod;	
					end if;


	--Me voy a quedar aqui hasta que tenga una combinacion valida, en caso de empezar teniendo una incorrecta se encenderán
	--los leds hasta que se arregle. Si ha comenzado estando bien no afectará que se cambien las palancas			
			when CompruebaMod =>
			    p_cont3<=cont3;
				p_estado<=reposo;  --Esta condición me proporciona robustez ya que si se quitan todas las palancas quiero volver a empezar
				--Asignar el tipo de modulacion es irrelevante en caso de error
													--ya que me voy a quedar en el estado de reposo esperando a que se arregle
					p_modu<="000";
					
					
					if(palanca1='1' and (palanca2='0' and palanca3='0') ) then   
							p_modu<="001";
							p_estado<=serializa_dbpsk;
							p_err<='0';
							
						  	
					elsif(palanca1='0' and (palanca2='1' and palanca3='0')) then
							p_modu<="010";
							p_err<='0';
							p_estado<=serializa_dqpsk;
							
							
					elsif(palanca1='0' and (palanca2='0' and palanca3='1')) then   --En este caso ya se ha comprobado que las otras dos estan apagadas
							p_modu<="100";
							p_err<='0';
							p_estado<=serializa_d8psk;
					else
					      	p_err<='1';
								p_estado<=CompruebaMod ;
					end if;
					
					
					
				
					
	--Tener estados distintos en funcion de la modulacion me permite que cualquier cambio en las palancas ya no 
	--afecte mas pero me obliga a crear estados individualizados para no perder la modulacion	

---------------------------------DBPSK-------------------------
			when serializa_dbpsk=>

					if(data_in=fin) then
						p_estado<=cerosencoder_dbpsk;
						p_cont1<=0;
					else 
					
							if(cont3=val_sat_cont3) then   --Para darle un respiro al encoder
									p_cont3<=0;
									p_dataout<=data_in(cont1);  --Esto se puede? si, lo he probado en la practica 3 y te ahorras miles de estados
									p_datavalid<='1';
									p_cont2<=cont2+1;
										if(cont1=0) then --Se pone la ultima que se va a cumplir por poner el if aqui
															  --En matlab están ordenadas los bytes de mas a menos significativo
											p_cont1<=7;
											p_dir<=dir+1;
										else
											p_cont1<=cont1-1;
										end if;
							end if;
							
					end if;		
					if(cont2=48) then    --Esta condicion permite tener actualizado el tamaño ocupado de un simbolo
						p_cont2<=0;
					end if;
					

					
			when cerosencoder_dbpsk =>
			
			 if(cont3=val_sat_cont3) then
					p_cont3<=0;
					p_cont1<=cont1+1;
					p_cont2<=cont2; --Para que no aumente cont2 en caso de cont1=6 en el que ya no mete el cero
					if(cont1<=5  )then
						p_dataout<='0';
						p_datavalid<='1';
						p_cont2<=cont2+1;
					else
						p_estado<=completa_dbpsk;
					end if;
						  
					if(cont2=48) then
							p_cont2<=0;   
					end if;
				end if;
				
when completa_dbpsk =>
		-- De lo que se trata es de llegar a un multiplo del tamaño que va a tener cada simbolo
		--en funcion del tipo de modulacion. Esto lo hago con un segundo contador
		
			p_cont2<=cont2;
					if(cont2=48) then
						p_cont2<=0;
						p_estado<=final;
					else
						if(cont3=val_sat_cont3 ) then
						    p_cont3<=0;
							p_cont2<=cont2+1;
							p_dataout<='0';
							p_datavalid<='1';
						end if;
					end if;









	-----------------------DQPSK---------------------------------

	when serializa_dqpsk=>
				
				   if(data_in=fin) then
						p_estado<=cerosencoder_dqpsk;
						p_cont1<=0;
					else --  val_sat_cont3  p_cont3<=0;
							
							if(cont3=val_sat_cont3 ) then   --Para darle un respiro al encoder
								
								 p_cont3<=0;
								p_dataout<=data_in(cont1);  --Esto se puede? si, lo he probado en la practica 3 y te ahorras miles de estados
								p_datavalid<='1';
								
								p_cont2<=cont2+1;
								
								if(cont1=0) then 
    								p_cont1<=7;
									p_dir<=dir+1;
							   else
									p_cont1<=cont1-1;
								end if;
								
							end if;
							       
							
					end if;
					if(cont2=96) then
							p_cont2<=0;
					end if;
				
				
		when cerosencoder_dqpsk =>--  val_sat_cont3  p_cont3<=0;
		 if(cont3=val_sat_cont3) then
		      p_cont3<=0;
				p_cont1<=cont1+1;
				p_cont2<=cont2; --Para que no aumente cont2 en caso de cont1=6 en el que ya no mete el cero
				if(cont1<=5) then
					p_dataout<='0';
					p_datavalid<='1';
					p_cont2<=cont2+1;
						  
					if(cont2=96) then
						p_cont2<=0;
					end if;
				else
					p_estado<=completa_dqpsk;
				end if;
			end if;	
when completa_dqpsk =>
		-- De lo que se trata es de llegar a un multiplo del tamaño que va a tener cada simbolo
		--en funcion del tipo de modulacion. Esto lo hago con un segundo contador
		
			p_cont2<=cont2;
			if(cont2=96) then
				p_cont2<=0;
				p_estado<=final;
			else  --val_sat_cont3  p_cont3<=0;
				if(cont3=val_sat_cont3) then
				   p_cont3<=0;
					p_cont2<=cont2+1;
					p_dataout<='0';
					p_datavalid<='1';
				end if;
			end if;






	--------------------------D8PSK-------------------------


	when serializa_d8psk=>
				   if(data_in=fin) then
						p_estado<=cerosencoder_d8psk;
						p_cont1<=0;
					else 
						--val_sat_cont3  p_cont3<=0;
							if(cont3=val_sat_cont3  ) then   --Para darle un respiro al encoder
								
								 p_cont3<=0;
								p_dataout<=data_in(cont1);  --Esto se puede? si, lo he probado en la practica 3 y te ahorras miles de estados
								p_datavalid<='1';
								p_cont2<=cont2+1;
									if(cont1=0) then --Se pone la ultima que se va a cumplir por poner el if aqui 
										p_cont1<=7;
										p_dir<=dir+1;
									else
									p_cont1<=cont1-1;
									end if;
							end if;
					end if;
							
					if(cont2=144) then
							p_cont2<=0;
					end if;
					
					
--val_sat_cont3  p_cont3<=0;
				
		when cerosencoder_d8psk =>
			if(cont3=val_sat_cont3) then
				p_cont3<=0;			
				p_cont1<=cont1+1;
				p_cont2<=cont2; --Para que no aumente cont2 en caso de cont1=6 en el que ya no mete el cero
				if(cont1<=5) then
					p_dataout<='0';
					p_datavalid<='1';
					p_cont2<=cont2+1;
					if(cont2=144) then
						p_cont2<=0;
					end if;
				else
					p_estado<=completa_d8psk;
				end if;
		   end if;
	when completa_d8psk =>
		-- De lo que se trata es de llegar a un multiplo del tamaño que va a tener cada simbolo
		--en funcion del tipo de modulacion. Esto lo hago con un segundo contador
		
			p_cont2<=cont2;
			if(cont2=144) then
			p_cont2<=0;
			p_estado<=final;	
--val_sat_cont3  p_cont3<=0;
			else
				if(cont3=val_sat_cont3) then
				p_cont3<=0;
					p_cont2<=cont2+1;
					p_dataout<='0';
					p_datavalid<='1';
				end if;
			end if;			

	---------------


			when others =>
				--La idea era enviar por el siete segmentos un mensaje de "On"+ el numero de la modulacion pero no ha dado tiempo 
				--de incluirlo.
				--Me voy a quedar aqui quieto pq no hay nada mas que hacer hasta un reset

			 
				
				
	end case;
	
end process;

end Behavioral;



  







				
--				
--				if(palanca1='1' and palanca2='1' and palanca3='1') then --Se utiliza a modo de reset sincrono
--																					--para que, si en receptor se ve algun error poder 
--																					--reenviar directamente el mensaje
--					p_estado<=reposo;
--					p_dir<=(others=>'0');
--					p_cont1<=0;
--					p_cont2<=0;
--				end if;




--architecture Behavioral of Completa_mensaje is
--COMPONENT datos_entrada
--  PORT (
--    clka : IN STD_LOGIC;
--    addra : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
--    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
--  );
--END COMPONENT;
--component Envia_error is
--    Port ( clk : in  STD_LOGIC;
--           reset : in  STD_LOGIC;
--			  A : out  STD_LOGIC;
--           B : out  STD_LOGIC;
--           C : out  STD_LOGIC;
--           D : out  STD_LOGIC;
--           E : out  STD_LOGIC;
--           F : out  STD_LOGIC;
--           G : out  STD_LOGIC;
--           DP : out  STD_LOGIC;
--           AN : out  STD_LOGIC_VECTOR (3 downto 0);
--			  modulacion: in STD_LOGIC_VECTOR (2 downto 0);  --Tener la modulacion en ?????????????????????? detectar errores
--           error : in  STD_LOGIC_VECTOR (2 downto 0)); --Codigo del error
--																		--	0 No hay error aparece On en display
--																		--	1 Modulacion incorrecta, aparece Err1
--end component;


--			    A : out  STD_LOGIC;
--           B : out  STD_LOGIC;
--           C : out  STD_LOGIC;
--           D : out  STD_LOGIC;
--           E : out  STD_LOGIC;
--           F : out  STD_LOGIC;
--           G : out  STD_LOGIC;
--           DP : out  STD_LOGIC;
--           AN : out  STD_LOGIC_VECTOR (3 downto 0);






--
--fichero_nombres : datos_entrada
--  PORT MAP (
--    clka => clk,
--    addra => dir,
--    douta => data_in
--  );
--Incluir este bloque de esta manera me permite tener el tratamiento de errores mucho mas limpio

--Display_error: Envia_error  
--   Port map( clk=>clk,
--           reset=>reset,    ---Esta parte no le veo demasiada logica, necesito el cable o desde el ucf es suficiente?
--			  A=>A,   
--           B=>B,
--           C=>C,
--           D=>D,
--           E=>E,
--           F=>F,
--           G=>G,
--           DP=>DP,
--           AN=>AN,
--			  modulacion=>modu,
--           error=>err);
--			  --Codigo del error
--									--	0 No hay error aparece On en display
--									--	1 Modulacion incorrecta, aparece Err1












--			CREO QUE ESTA PARTE LA NECESITAREMOS PARA CONECTARLO A LA PRACTICA 3
--
--				if(cont1=8) then --Se pone la condicion siguiente a la ultima que quieres 
--					p_cont1<=0;
--					p_dir<=dir+1;
--					
--				else
--					p_dataout<=data_in(cont1);  --Esto se puede? si, lo he probado en la practica 3 y te ahorras miles de estados
--					p_datavalid<='1';
--					p_cont1<=cont1+1;
--					p_cont2<=cont2+1;
--				end if;
--				
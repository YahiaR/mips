library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity RegsMIPS is
    port (
        Clk : in std_logic; -- Reloj
        NRst : in std_logic; -- Reset asíncrono a nivel bajo
        Wd3 : in std_logic_vector(31 downto 0); --Valor que tomara el registro A3
        A3 : in std_logic_vector(4  downto 0); -- Dirección del registro destino
        A2 : in std_logic_vector(4  downto 0); -- Señal de entrada
        A1 : in std_logic_vector(4 downto 0); -- Señal de entrada
        Rd1 : out std_logic_vector(31 downto 0); -- Salida 
        Rd2 : out std_logic_vector(31 downto 0); -- Salida 
        We3 : in std_logic --Señal de habilitación
          
    ); 
end RegsMIPS;

architecture Practica of RegsMIPS is

    -- Tipo para almacenar los registros
    type regs_t is array (0 to 31) of std_logic_vector(31 downto 0);

    -- Esta es la señal que contiene los registros. El acceso es de la
    -- siguiente manera: regs(i) acceso al registro i, donde i es
    -- un entero. Para convertir del tipo std_logic_vector a entero se
    -- hace de la siguiente manera: conv_integer(slv), donde
    -- slv es un elemento de tipo std_logic_vector

    -- Registros inicializados a '0' 
    -- NOTA: no cambie el nombre de esta señal.
    signal regs : regs_t;  
    
begin  

    ------------------------------------------------------
    -- Escritura del registro RT
    ------------------------------------------------------
    process (Clk, NRst)
        begin
        -- Comprobamos si Nrst = 0 para inicializar todos los registros a 0.
            if NRst = '0' then
                for i in 0 to 31 loop
                 regs(i)<= (others=> '0');
              end loop;
          -- Si no lo es, se actualiza el valor de regs por cada ciclo de reloj
            elsif rising_edge (Clk) then
                if  We3='1' then
                    if A3 = "00000" then
                        regs(conv_integer(A3)) <= (others => '0');
                    else
                        regs(conv_integer(A3)) <= Wd3;
                    end if;
               end if;
            end if;

    end process;


    ------------------------------------------------------
    -- Lectura del registro RS
    ------------------------------------------------------

  process (A1,regs,A2)

    begin
    --Comprobamos si lo que se lee es 0 porque entonces Rd1 toma de valor todo cero.
     if A1 = "00000" then
         Rd1 <= (others=> '0');
     else
     -- Si no, se lee todo lo que haya en el registro y se guarda en dos salidas distintas para dos valores de entrada distintos.
       Rd1 <= regs(conv_integer(A1));
	  end if;
	  if A2= "00000" then
	     Rd2<= (others=> '0');
	  else 
		  Rd2 <= regs(conv_integer(A2));
      end if;
  end process;
  
end Practica;


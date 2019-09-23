library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity ALUMIPS is
    port (
        Op1 : in std_logic_vector(31 downto 0); -- Operando
        Op2 : in std_logic_vector(31 downto 0); -- Operando
        ALUControl : in std_logic_vector(2 downto 0); -- Selección de operación
        Res : out std_logic_vector(31 downto 0); -- Resultado
        Z : out std_logic -- Salida de estado
);

end ALUMIPS;

architecture Practica of ALUMIPS is 
--Señales auxiliares para el desplazamiento(sll)

	signal Desp1: std_logic_vector (31 downto 0); 
	signal Desp2: std_logic_vector (31 downto 0);
	signal Desp3: std_logic_vector (31 downto 0);
	signal Desp4: std_logic_vector (31 downto 0);
	signal Desp5: std_logic_vector (31 downto 0);
--Señal auxiliar para guardar la resta de los dos operandos
	signal Resta: std_logic_vector (31 downto 0);
--Señal auxiliar que se iguala a Res
	signal R: std_logic_vector (31 downto 0);
begin 
   Resta <= Op1 - Op2; 
   Res <= R;
process (ALUControl, Op1, Op2, Desp5, Resta)--Lista de sensibilidad
	begin 
		case  ALUControl is  
			when "010" => R <= Op1 + Op2;--Operación de suma
			when "110" => R <= Resta;--Operación de resta guardada en la variable aux
			when "000" => R <= Op1 and Op2;--Operación de multiplicación
			when "011" => R <= Op1 xor Op2;--Operación de suma exclusiva
			when "111" =>
			--Realizamos las operaciones necesarias para el slt(set less than).
			--Comparamos los bits más significativos de ambos operandos y despúes los restamos para ver cual es mayor y activar la R
				if Op1(31) = Op2(31) then
					if  Resta(31) = '1' then
						R <= x"00000001";
					else 
						R <= (others => '0');
					end if;
				elsif Op1(31)='1' then
					R <= x"00000001";
				elsif Op1(31)='0' then
					R <= (others => '0');				
				end if;
				
			when "101" => R <= Op1 nor Op2;--Realizamos la operación de la negación de la suma
		   	when "001" => R <= Desp5; --Igualamos el resultado, de realizar la sll, a R
			when others => R <= x"00000000";
		end case;
	end process;
	
	--Realizamos las operaciones necesarias para el sll(desplazamiento hacia la izquierda) en process diferentes para cada desplazamiento 
process (Op2,Op1)
	begin 
	--Desplazamiento de 16 bits 
		if Op2(4) = '1' then
			Desp1 <= Op1(15 downto 0) & x"0000" ;
		else 
			Desp1 <= Op1;
		end if;
end process;

	--Desplazamiento de 8 bits 
process (Op2, Desp1)
   begin
		if Op2(3) = '1' then
			Desp2 <= Desp1(23 downto 0) & x"00";
		else 
			Desp2 <= Desp1;
		end if;
end process;
	--Desplazamiento de 4 bits 
process (Op2, Desp2)
	begin
		if Op2(2) = '1' then
			Desp3 <= Desp2(27 downto 0) & x"0";
		else
			Desp3 <= Desp2;
		end if;
end process;

	--Desplazamiento de 2 bits 	
process (Op2, Desp3)
	begin
		if Op2(1)= '1' then
			Desp4 <= Desp3(29 downto 0) & "00";
		else 
			Desp4 <= Desp3;
		end if;
end process;

	--Desplazamiento de 1 bit
process(Op2, Desp4)
	begin
		if Op2(0)= '1' then
			Desp5 <= Desp4(30 downto 0) & '0';
		else 
			Desp5 <= Desp4;
		end if;
end process;

--La señal de estado que corresponde a la bandera de Z, la cual se activa cuando el resultado(R) es igual a 0
process(R)
	begin
		if R = x"00000000" then
			Z <= '1';
		else 
			Z <= '0';
		end if;
   end process;
end Practica;

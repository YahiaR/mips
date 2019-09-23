

library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_LOGIC_arith.ALL;
use IEEE.std_logic_unsigned.ALL;

entity MemProgVectores is
	port (
		MemProgAddr : in std_logic_vector(31 downto 0); -- Direcci�n para la memoria de programa
		MemProgData : out std_logic_vector(31 downto 0) -- C�digo de operaci�n
	);
end MemProgVectores;

architecture Simple of MemProgVectores is

begin

	LecturaMemProg: process(MemProgAddr)
	begin
		-- La memoria devuelve un valor para cada direcci�n.
		-- Estos valores son los c�digos de programa de cada instrucci�n,
		-- estando situado cada uno en su direcci�n.
		case MemProgAddr is
		-------------------------------------------------------------
		-- S�lo introducir cambios desde aqu�	

			-- Por cada instrucci�n en .text, agregar una l�nea del tipo:
			-- when DIRECCION => MemProgData <= INSTRUCCION;
			-- Por ejemplo, si la posici�n 0x00000000 debe guardarse la instrucci�n con c�digo m�quina 0x20010004, poner:
			-- when X"00000000" => MemProgData <= X"20010004";
		-- Hasta aqu�	
		---------------------------------------------------------------------	
			when X"00000000" => MemProgData <= X"20090000";
			when X"00000004" => MemProgData <= X"8c082000";
			when X"00000008" => MemProgData <= X"0128502a";
			when X"0000000C" => MemProgData <= X"100a0008";
			when X"00000010" => MemProgData <= X"00098080";
			when X"00000014" => MemProgData <= X"8e0b2004";
			when X"00000018" => MemProgData <= X"8e0c201c";
			when X"0000001c" => MemProgData <= X"000c68c0";
			when X"00000020" => MemProgData <= X"016d7022";
			when X"00000024" => MemProgData <= X"ae0e2034";
			when X"00000028" => MemProgData <= X"21290001";
			when X"0000002C" => MemProgData <= X"08000002";
			when X"00000030" => MemProgData <= X"0800000c";
			
			when others => MemProgData <= X"00000000"; -- Resto de memoria vac�a
		end case;
	end process LecturaMemProg;

end Simple;



library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity MemDataVectores is
	port (
		Clk : in std_logic;
		NRst : in std_logic;
		MemDataAddr : in std_logic_vector(31 downto 0);
		MemDataDataWrite : in std_logic_vector(31 downto 0);
		MemDataWE : in std_logic;
		MemDataDataRead : out std_logic_vector(31 downto 0)
	);
end MemDataVectores;

architecture Simple of MemDataVectores is

  -- 4 GB son 1 gigapalabras, pero el simulador no deja tanta memoria
  -- Dejamos 64 kB (16 kpalabras), usamos los 16 LSB
  type Memoria is array (0 to (2**14)-1) of std_logic_vector(31 downto 0);
  signal memData : Memoria;

begin

	EscrituraMemProg: process(Clk, NRst)
	begin
	if NRst = '0' then
		-- Se inicializa a ceros, salvo los valores de las direcciones que
		-- tengan un valor inicial distinto de cero (datos ya cargados en
		-- memoria de datos desde el principio)
		for i in 0 to (2**14)-1 loop
			memData(i) <= (others => '0');
		end loop;
		-- Cada palabra ocupa 4 bytes
	-------------------------------------------------------------
	-- Sólo introducir cambios desde aquí	

		-- Por cada dato en .data, agregar una línea del tipo:
		-- memData(conv_integer(DIRECCIÓN)/4) <= DATO;
		-- Por ejemplo, si la posición 0x00002000 debe inicializarse con el dato 0x12345678, poner:
		--memData(conv_integer(X"00002000")/4) <= X"12345678";
	-- Hasta aquí	
	
	---------------------------------------------------------------------	
		memData(conv_integer(X"00002000")/4) <= X"00000006";
		memData(conv_integer(X"00002004")/4) <= X"00000002";
		memData(conv_integer(X"00002008")/4) <= X"00000004";
		memData(conv_integer(X"0000200C")/4) <= X"00000006";
		memData(conv_integer(X"00002010")/4) <= X"00000008";
		memData(conv_integer(X"00002014")/4) <= X"0000000A";
		memData(conv_integer(X"00002018")/4) <= X"0000000C";
		memData(conv_integer(X"0000201C")/4) <= X"FFFFFFFF";
		memData(conv_integer(X"00002020")/4) <= X"FFFFFFFB";
		memData(conv_integer(X"00002024")/4) <= X"00000004";
		memData(conv_integer(X"00002028")/4) <= X"0000000A";
		memData(conv_integer(X"0000202C")/4) <= X"00000001";
		memData(conv_integer(X"00002030")/4) <= X"FFFFFFFB";
	
	elsif rising_edge(Clk) then
		-- En este caso se escribe por flanco de bajada para que sea
		-- a mitad de ciclo y todas las señales estén estables
		if MemDataWE = '1' then
			memData(conv_integer(MemDataAddr)/4) <= MemDataDataWrite;
		end if;
	end if;
	end process EscrituraMemProg;

	-- Lectura combinacional siempre activa
	-- Cada vez se devuelve una palabra completa, que ocupa 4 bytes
	LecturaMemProg: process(MemDataAddr, memData)
	begin
		-- Parte baja de la memoria sí está, se lee tal cual
		if MemDataAddr(31 downto 16)=X"0000" then
			MemDataDataRead <= MemData(conv_integer(MemDataAddr)/4);
		else -- Parte alta no existe, se leen ceros
			MemDataDataRead <= (others => '0');
		end if;
	end process LecturaMemProg;

end Simple;


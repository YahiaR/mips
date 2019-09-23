library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UnidadControl is
	port(
		OPCode: in std_logic_vector(31 downto 26); --Entrada de la Unidad de control
		Funct: in std_logic_vector(5 downto 0); --Entrada de la Unidad de control
		Jump:  out std_logic; --Señal de control (salida)
		Branch: out std_logic;--Señal de control (salida)
		MemToReg: out std_logic;--Señal de control (salida)
		MemWrite: out std_logic;--Señal de control (salida)
		ALUSrc: out std_logic;--Señal de control (salida)
		ALUControl: out std_logic_vector(2 downto 0);--Señal de control (salida)
		ExtCero: out std_logic;--Señal de control (salida)
		RegWrite: out std_logic;--Señal de control (salida)
		ShiftReg: out std_logic;--Señal de control (salida)
		RegDest: out std_logic--Señal de control (salida)
	);
end UnidadControl;

architecture Practica5 of UnidadControl is

begin
	
	MemToReg <= '1' when OPCode = "100011" else '0'; --Si MemToReg vale 1, se realiza la instrucción lw.
	
	MemWrite <= '1' when OPCode = "101011" else '0'; --Si MemWrite vale 1, se realiza la instrucción sw.
	
	Branch <= '1' when OPCode = "000100" else '0'; --Si Branch vale 1, se realiza la instrucción beq.
	
	--Si ALUControl tiene esos valores, realiza las siguientes intrucciones:
	

	ALUControl <= "110" when OPCode = "000100" --beq
		else "010" when OPCode = "100011" or OPCode = "101011" -- lw y sw
		else "010" when OPCode = "001000" --addi
		else "000" when OPCode = "001100" --andi
		else "011" when OPCode = "001110" --xori
		else "111" when OPCode = "001010" --slti
		else "010" when OPCode = "000000" and Funct = "100000" --add
		else "110" when OPCode = "000000" and Funct = "100010" --sub
		else "101" when OPCode = "000000" and Funct = "100111" --nor
		else "011" when OPCode = "000000" and Funct = "100110" --xor
		else "000" when OPCode = "000000" and Funct = "100100" --and
		else "111" when OPCode = "000000" and Funct = "101010" --slt
		else "001"; --sll
	
	
	ALUSrc <= '0' when OPCode = "000000" and Funct/= "000000" else '0' when OPCode = "000100" else '1'; --Si AluSrc vale 1, se realizan todas las instrucciones menos beq y R-type
	
	RegDest <= '1' when OPCode = "000000"  else '0';--Si RegDest vale 1, se realiza la instruccion r-type incluyendo sll
	
	RegWrite <='0' when OPCode ="101011" or OPCode ="000100" or OPCode ="000010" else '1';--Si RegWrite vale 0, se realizan las instrucciones sw, beq y j 
	
	ExtCero <='1' when OPCode ="001100" or OPCode ="001110" else '0';--Si ExtCero vale 1, se realizan las instrucciones logicas inm (andi y xori)
	
	Jump <= '1' when OPCode= "000010" else '0';-- Si Jump vale 1, se realiza la instrucción j
	
	ShiftReg <= '1' when OPCode= "000000" and Funct= "000000" else '0'; --Si ShiftReg vale 1, se realiza la instrucción sll

end Practica5;
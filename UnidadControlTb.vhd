library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity UnidadControlTb is
end UnidadControlTb;
 
architecture behavior of UnidadControlTb is
 
   type CasosPruebaT is record
		instruccion : std_logic_vector(31 downto 0);
		sigControl :  std_logic_vector(10 downto 0);
		aluControl : std_logic_vector(2 downto 0);
		operacion : string(5 downto 1);
	end record;

	component UnidadControl
	port(
		OPCode : in  std_logic_vector (5 downto 0); -- OPCode de la instrucción
		Funct : in std_logic_vector(5 downto 0); -- Funct de la instrucción
		-- Señales para el PC
		Jump : out  std_logic;
		Branch : out  std_logic;
		-- Señales para la memoria
		MemToReg : out  std_logic;
		MemWrite : out  std_logic;
		
		-- Señales para la ALU
		ALUSrc : out  std_logic;
		ALUControl : out  std_logic_vector (2 downto 0);
		ExtCero : out std_logic;
		ShiftReg : out std_logic;
		
		-- Señales para el GPR
		RegWrite : out  std_logic;
		RegDest : out  std_logic
        );
	end component;

	
   --Inputs
   signal OPCode : std_logic_vector(5 downto 0) := (others => '0');
   signal funct : std_logic_vector(5 downto 0) := (others => '0');
   

 	--Outputs
   signal regWrite, ALUSrc, branch, memWrite, memToReg, jump, extCero, RegDest, ShiftReg : std_logic;
	signal ALUControl : std_logic_vector(2 downto 0);
   
	
	signal controlFlags : std_logic_vector(10 downto 0);
	
	signal instruc : std_logic_vector(31 downto 0);
	
	-- numero de casos de prueba
	constant NUMCASOSPRUEBA : integer := 15;

	-- matriz de casos de prueba
	type CasosPruebaT2 is array (1 to NUMCASOSPRUEBA) of CasosPruebaT;

  
  constant casos_prueba : CasosPruebaT2 := (

	-- 1 INSTRUCCION: lw
	--	INSTRUCCION		SENIALES_CTRL	ALU_OP
	(	x"8c012000",	"01100100000",	"010", "lw   "),
	-- 2 INSTRUCCION: sw
	--	INSTRUCCION		SENIALES_CTRL	ALU_OP
	(	x"ac012024",	"00101-0-00-",	"010", "sw   "),
	-- 3 INSTRUCCION: add
	--	INSTRUCCION		SENIALES_CTRL	ALU_OP
	(	x"00430820",	"01000000-01",	"010", "add  "),
	-- 4 INSTRUCCION: sub
	--	INSTRUCCION		SENIALES_CTRL	ALU_OP
	(	x"00430822",	"01000000-01",	"110", "sub  "),
	-- 5 INSTRUCCION: xor
	--	INSTRUCCION		SENIALES_CTRL	ALU_OP
	(	x"00221826",	"01000000-01",	"011", "xor  "),
	-- 6 INSTRUCCION: and
	--	INSTRUCCION		SENIALES_CTRL	ALU_OP
	(	x"00000024",	"01000000-01",	"000", "and  "),
	-- 6 INSTRUCCION: or
	--	INSTRUCCION		SENIALES_CTRL	ALU_OP
	--(	x"00221825",	"01000000-01",	"001", "or   "),
	-- 7 INSTRUCCION: slt
	--	INSTRUCCION		SENIALES_CTRL	ALU_OP
	(	x"0000002a",	"01000000-01",	"111", "slt  "),
	-- 8 INSTRUCCION: nor
	--	INSTRUCCION		SENIALES_CTRL	ALU_OP
	(	x"00250827",	"01000000-01",	"101", "nor  "),
	-- 9 INSTRUCCION: beq
	--	INSTRUCCION		SENIALES_CTRL	ALU_OP
	(	x"10000020",	"00010-0--0-",	"110", "beq  "),
	-- 10 INSTRUCCION: j
	--	INSTRUCCION		SENIALES_CTRL	ALU_OP
	(	x"08000022",	"-0--0-1--0-",	"---", "j    "),
	-- INSTRUCCIONES ALU INMEDIATAS
	-- 11 INSTRUCCION: addi
	--	INSTRUCCION		SENIALES_CTRL	ALU_OP
	(	x"2041002a",	"01100000000",	"010", "addi "),
	-- 12 INSTRUCCION: andi
	--	INSTRUCCION		SENIALES_CTRL	ALU_OP
	(	x"30410025",	"01100000100",	"000", "andi "),
	-- 13 INSTRUCCION: ori
	--	INSTRUCCION		SENIALES_CTRL	ALU_OP
	--(	x"34230025",	"01100000100",	"001", "ori  "),
	-- 14 INSTRUCCION: xori
	--	INSTRUCCION		SENIALES_CTRL	ALU_OP
	(	x"38238026",	"01100000100",	"011", "xori "),
	-- 15 INSTRUCCION: slti
	--	INSTRUCCION		SENIALES_CTRL	ALU_OP
	(	x"28410027",	"01100000000",	"111", "slti "),
	-- 16 INSTRUCCION: sll
	--	INSTRUCCION		SENIALES_CTRL	ALU_OP
	(	x"00010940",	"11100000-01",	"001", "sll  ")
	);
	
	 -- Tiempo que vamos a esperar a que conteste la UC  
  constant tdelay : time := 10 ns;
  
  signal fallos : integer := 0;
  
BEGIN
 

   uut: UnidadControl PORT MAP (
      OPCode => OPCode,
		Funct => funct,
		jump => jump,
	--	RegToPC => regToPC,
		Branch => branch,
	--	PCToReg => pcToReg,
		MemToReg => memToReg,
		MemWrite => memWrite,
		ALUSrc => ALUSrc,
		ALUControl => ALUControl,
		ExtCero => extCero,
		ShiftReg => ShiftReg,
		RegWrite => regWrite,
		RegDest => RegDest
	);
 
   
	--controlFlags <= regWrite & ALUSrc & branch & memWrite & memToReg & jump & pcToReg & extCero & regToPC & RegDest;
	controlFlags <= shiftReg & regWrite & ALUSrc & branch & memWrite & memToReg & jump & '-' & extCero & '-' & RegDest;

   -- Stimulus process
	stim_proc: process
   begin		
	     
		for i in 1 to NUMCASOSPRUEBA loop
		
			OPCode <= casos_prueba(i).INSTRUCCION(31 downto 26);
			funct <= casos_prueba(i).INSTRUCCION(5 downto 0);
			
			instruc <= casos_prueba(i).INSTRUCCION;
			
			wait for tdelay;
			
			assert std_match(controlFlags,casos_prueba(i).sigControl)
			report "fallo en seniales caso " & casos_prueba(i).operacion & ". Los bits de control erroneos son:"
			severity warning;
			
			assert std_match(shiftReg,casos_prueba(i).sigControl(10))
			report "shiftReg: " & std_logic'image(shiftReg) & ". Deseado: " & std_logic'image(casos_prueba(i).sigControl(10))
			severity warning;
			
			assert std_match(regWrite,casos_prueba(i).sigControl(9))
			report "regWrite: " & std_logic'image(regWrite) & ". Deseado: " & std_logic'image(casos_prueba(i).sigControl(9))
			severity warning;
			
			assert std_match(ALUSrc,casos_prueba(i).sigControl(8))
			report "ALUSrc: " & std_logic'image(ALUSrc) & ". Deseado: " & std_logic'image(casos_prueba(i).sigControl(8))
			severity warning;
			
			assert std_match(branch,casos_prueba(i).sigControl(7))
			report "branch: " & std_logic'image(branch) & ". Deseado: " & std_logic'image(casos_prueba(i).sigControl(7))
			severity warning;
			
			assert std_match(memWrite,casos_prueba(i).sigControl(6))
			report "memWrite: " & std_logic'image(memWrite) & ". Deseado: " & std_logic'image(casos_prueba(i).sigControl(6))
			severity warning; 
			
			assert std_match(memToReg,casos_prueba(i).sigControl(5))
			report "memToReg: " & std_logic'image(memToReg) & ". Deseado: " & std_logic'image(casos_prueba(i).sigControl(5))
			severity warning;
			
			assert std_match(jump,casos_prueba(i).sigControl(4))
			report "jump: " & std_logic'image(jump) & ". Deseado: " & std_logic'image(casos_prueba(i).sigControl(4))
			severity warning;
			
--			assert std_match(pcToReg,casos_prueba(i).sigControl(3))
--			report "pcToReg: " & std_logic'image(pcToReg) & ". Deseado: " & std_logic'image(casos_prueba(i).sigControl(3))
--			severity warning;
			
			assert std_match(extCero,casos_prueba(i).sigControl(2))
			report "extCero: " & std_logic'image(extCero) & ". Deseado: " & std_logic'image(casos_prueba(i).sigControl(2))
			severity warning;
			
--			assert std_match(regToPC,casos_prueba(i).sigControl(1))
--			report "regToPC: " & std_logic'image(regToPC) & ". Deseado: " & std_logic'image(casos_prueba(i).sigControl(1))
--			severity warning;
			
			assert std_match(RegDest,casos_prueba(i).sigControl(0))
			report "RegDest: " & std_logic'image(RegDest) & ". Deseado: " & std_logic'image(casos_prueba(i).sigControl(0))
			severity warning;
			
			if not std_match(controlFlags,casos_prueba(i).sigControl) then
				fallos <= fallos + 1;
			end if;
			
			assert std_match(aluControl,casos_prueba(i).aluControl)
			report "fallo en ALUControl caso " & casos_prueba(i).operacion & ". Los bits de ALUControl son:"
			severity warning;
			
			assert std_match(aluControl,casos_prueba(i).aluControl)
			report "ALUControl: " & std_logic'image(aluControl(2)) & std_logic'image(aluControl(1)) & std_logic'image(aluControl(0)) & ". Deseado: " & std_logic'image(casos_prueba(i).aluControl(2)) & std_logic'image(casos_prueba(i).aluControl(1)) & std_logic'image(casos_prueba(i).aluControl(0))
			severity warning;
			
			if not std_match(ALUControl,casos_prueba(i).aluControl) then
				fallos <= fallos + 1;
			end if;
			
			-- if i = 12 then -- Instrucción jr.
				-- if regWrite = '1' and PCToReg = '1' then
					-- report "Fallo en jr (i=12), porque regWrite='1' y PCToReg='1'"; -- Se puede poner RegWrite='1' mientras que PCToReg no sea 1. Porque si no, se escribiria el PC en $31
					-- fallos <= fallos + 1;
				-- end if;
			-- end if;
			
		end loop;
		
		wait for tdelay;
		
		report "Simulación finalizada. Si no hay errores previos, la simulación es correcta";
		wait;
	end process;

END;

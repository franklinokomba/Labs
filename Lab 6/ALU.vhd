--------------------------------------------------------------------------------
--
-- LAB #4
--
--------------------------------------------------------------------------------

Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity ALU is
	Port(	DataIn1: in std_logic_vector(31 downto 0);
		DataIn2: in std_logic_vector(31 downto 0);
		ALUCtrl: in std_logic_vector(4 downto 0);
		Zero: out std_logic;
		ALUResult: out std_logic_vector(31 downto 0) );
end entity ALU;

architecture ALU_Arch of ALU is
	-- ALU components	
	component adder_subtracter
		port(	datain_a: in std_logic_vector(31 downto 0);
			datain_b: in std_logic_vector(31 downto 0);
			add_sub: in std_logic;
			dataout: out std_logic_vector(31 downto 0);
			co: out std_logic);
	end component adder_subtracter;

	component shift_register
		port(	datain: in std_logic_vector(31 downto 0);
		   	dir: in std_logic;
			shamt:	in std_logic_vector(4 downto 0);
			dataout: out std_logic_vector(31 downto 0));
	end component shift_register;
	signal dummie :std_logic;
	signal M1 : std_logic_vector(31 downto 0);
	signal M2 : std_logic_vector(31 downto 0);
	signal direction : std_logic;
	signal adds_subs : std_logic;
	signal copy : std_logic_vector(31 downto 0); 
begin
	-- Add ALU VHDL implementation here
	direction <= ALUCtrl(1) xor ALUCtrl(0);
	
	with ALUCtrl select
	adds_subs <=   '1' when "00001",
		       '0' when others;

	with ALUCtrl select
	copy <=		DataIn1 and DataIn2 when "00011" |"00100",
		     	DataIn1 or DataIn2 when "00101" | "00110", 
		 	M1(31 downto 0) when "00000" | "00001" | "00010",
			M2(31 downto 0) when "00111" | "01000" | "01001" | "01010",
			DataIn2(31 downto 0) when others;


	alu1 : adder_subtracter port map(DataIn1(31 downto 0), DataIn2(31 downto 0),adds_subs, M1(31 downto 0),dummie);
	alu2 : shift_register port map(DataIn1(31 downto 0), direction, DataIn2(4 downto 0), M2(31 downto 0));

	ALUResult <= copy(31 downto 0);

	with copy select
	Zero <=	 '1' when "00000000"&"00000000"&"00000000"&"00000000", 
		 '0' when others;
	 

end architecture ALU_Arch;

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


	-- Add ALU VHDL implementation here
	signal outputSign, temp,adder,subtractor,OR_out, AND_out,andi, addi,ori,shift: std_logic_vector(31 downto 0);
	signal passThrough: std_logic_vector(31 downto 0);
	signal carry: std_logic;
	signal ori_temp3,ori_temp2,andi_temp3,andi_temp2: std_logic_vector(19 downto 0);
begin
	
	add1: adder_subtracter port map (DataIn1,DataIn2,'0',adder,carry); --Port map for adding the 32 bit numbers
	add2: adder_subtracter port map (DataIn1,DataIn2,'1',subtractor,carry); --Port map subtracting the 32 bit numbers
	
	OR_out<=DataIn1 or DataIn2;	    --or the 32 bit numbers
	AND_out<=DataIn1 and DataIn2;	--and the 32 bit numbers
	passThrough <= DataIn2;         -- DataIn2 pass through signal

	     ---OR immediate
	ori_temp2<= DataIn2(19 downto 0);
	ori_temp3<= DataIn1(19 downto 0) or ori_temp2;
	ori<=DataIn1(31 downto 20) & ori_temp3 ;

	     -----AND immediate
	andi_temp2<= DataIn2(19 downto 0);
	andi_temp3<= DataIn1(19 downto 0) and andi_temp2;
	andi<=DataIn1(31 downto 20) & andi_temp3 ;
	
	add3: adder_subtracter port map (DataIn1,temp, '0' ,addi,carry);

	shift1: shift_register port map(DataIn1,ALUCtrl(0),DataIn2(10 downto 6),shift);


	with ALUCtrl select
		outputSign<= adder when "00000",
			subtractor when "00001",
			AND_out when "00010",
			OR_out when "00101",
			addi when "00110",
			andi when "01010",
			ori when "01101",
			passThrough when "01111",
			shift when others;

	with outputSign select
		Zero<= '1' when X"00000000",
			'0' when others;

	ALUResult<=outputSign;
end architecture ALU_Arch;



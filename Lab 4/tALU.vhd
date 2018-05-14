--------------------------------------------------------------------------------
--
-- Test Bench for LAB #4
--
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY testALU_vhd IS
END testALU_vhd;

ARCHITECTURE behavior OF testALU_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT ALU
		Port(	DataIn1: in std_logic_vector(31 downto 0);
			DataIn2: in std_logic_vector(31 downto 0);
			ALUCtrl: in std_logic_vector(4 downto 0);
			Zero: out std_logic;
			ALUResult: out std_logic_vector(31 downto 0) );
	end COMPONENT ALU;

	--Inputs
	SIGNAL datain_a : std_logic_vector(31 downto 0) := (others=>'0');
	SIGNAL datain_b : std_logic_vector(31 downto 0) := (others=>'0');
	SIGNAL control	: std_logic_vector(4 downto 0)	:= (others=>'0');

	--Outputs
	SIGNAL result   :  std_logic_vector(31 downto 0);
	SIGNAL zeroOut  :  std_logic;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: ALU PORT MAP(
		DataIn1 => datain_a,
		DataIn2 => datain_b,
		ALUCtrl => control,
		Zero => zeroOut,
		ALUResult => result
	);
	

	tb : PROCESS
	BEGIN

		-- Wait 100 ns for global reset to finish
		wait for 100 ns;

		-- Start testing the ALU
		-- test the adder_subtracter first
		datain_a <= X"4F302C85";
		datain_b <= X"7A222578";
		control  <= "00000";		-- Control in binary (ADD and ADDI test)
		wait for 20 ns; 		    -- dataout should be 0xC95251FD and zeroOut = 0

		datain_a <= X"4F302C85";
		datain_b <= X"7A222578";	   -- subtraction at 120nS
		control  <= "00001";          -- dataout should be 0xD50E070D		
		wait for 20 ns;               
		
		datain_a <= X"FFFFFFFF";	--and all 1's and 0's
		datain_b <= X"00000000";	--after 140
		control  <= "00010";		
		wait for 20 ns; 

		datain_a <= X"FFFFFFFF";	--or all 1's and 0's
		datain_b <= X"00000000";	--after 160
		control  <= "00101";		
		wait for 20 ns;

	
		datain_a <= X"00000000";	--adding immediate to zero
		datain_b <= X"00FFFFFF";	--after 180
		control  <= "00110";		
		wait for 20 ns;
	
		
		datain_a <= X"00000000";	-- oring numbers immidates
		datain_b <= X"FFFFFFFF";	--after 200
		control  <= "01101";		
		wait for 20 ns; 

		--datain_a <= X"00000000";	-- Data in 2 pass through line
		datain_b <= X"11111111";	--after 220
		control  <= "01111";		
		wait for 20 ns; 	
		
		datain_a <= X"FFFFFFFF";	-- shift left by 2
		datain_b <= X"00000080";	--after 240
		control  <= "11110";		
		wait for 20 ns; 	
			
		datain_a <= X"0FFFFFFF";	-- shift right by 2
		datain_b <= X"00000080";	--after 260
		control  <= "11111";		
		wait for 20 ns;

        datain_a <= X"00000000";	-- shift right by 2
		datain_b <= X"FFFFFFFF";	--after 280
		control  <= "01010";		
		wait for 20 ns; 		
	
			
		wait; -- will wait forever
	END PROCESS;

END;
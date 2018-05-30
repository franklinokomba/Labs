--------------------------------------------------------------------------------
--
-- LAB #5 - Memory and Register Bank
--
--------------------------------------------------------------------------------
LIBRARY ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity RAM is
    Port(Reset:	  in std_logic;
	 Clock:	  in std_logic;	 
	 OE:      in std_logic;
	 WE:      in std_logic;
	 Address: in std_logic_vector(29 downto 0);
	 DataIn:  in std_logic_vector(31 downto 0);
	 DataOut: out std_logic_vector(31 downto 0));
end entity RAM;
architecture staticRAM of RAM is

   type ram_type is array (0 to 127) of std_logic_vector(31 downto 0);
   signal my_ram : ram_type;

  
   signal integer_Address: integer;
  
begin

  RamProc: process(Clock, Reset, OE, WE, Address) is

  begin
	
    if Reset = '1' then
	-- Add code to reset the RAM
	my_ram <= (others => (others => '0'));
    end if;

    integer_Address<=to_integer(unsigned(Address)); 

    if falling_edge(Clock) then
	-- Add code to write data to RAM
	if WE='1' then
	
		if integer_Address < 128  then
			my_ram(integer_Address)<=DataIn;
    		end if;
	end if;
    end if;

	-- Rest of the RAM implementation
    if rising_edge(Clock) then
	-- Add code to write data to RAM
	if (OE = '0') then
		if(integer_Address < 128) then
			DataOut<=my_ram(integer_Address);
		else
			DataOut<= (others => 'Z');
		end if;
	end if;
    end if;
  end process RamProc;
	
end staticRAM;	

--------------------------------------------------------------------------------
LIBRARY ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity Registers is
    Port(ReadReg1: in std_logic_vector(4 downto 0); 
         ReadReg2: in std_logic_vector(4 downto 0); 
         WriteReg: in std_logic_vector(4 downto 0);
	 WriteData: in std_logic_vector(31 downto 0);
	 WriteCmd: in std_logic;
	 ReadData1: out std_logic_vector(31 downto 0);
	 ReadData2: out std_logic_vector(31 downto 0));
end entity Registers;

architecture remember of Registers is
	component register32
  	    port(datain: in std_logic_vector(31 downto 0);
		 enout32,enout16,enout8: in std_logic;
		 writein32, writein16, writein8: in std_logic;
		 dataout: out std_logic_vector(31 downto 0));
	end component;

signal zero,first,second,third,forth,fifth,sixth,seventh: std_logic_vector(31 downto 0);
signal select_writein: std_logic_vector(7 downto 0);
begin
    -- Add your code here for the Register Bank implementation

with WriteCmd & WriteReg select
	select_writein <= 	
				"00000001" when "110000",
				"00000010" when "110001",
				"00000100" when "110010",
				"00001000" when "110011",
				"00010000" when "110100",
				"00100000" when "110101",
				"01000000" when "110110",
				"10000000" when "110111",
				"00000000" when others;

			

a0: register32 port map(WriteData, '0', '1', '1', select_writein(0), '0','0', zero);
a1: register32 port map(WriteData, '0', '1', '1', select_writein(1), '0','0', first);
a2: register32 port map(WriteData, '0', '1', '1', select_writein(2), '0','0', second);
a3: register32 port map(WriteData, '0', '1', '1', select_writein(3), '0','0', third);
a4: register32 port map(WriteData, '0', '1', '1', select_writein(4), '0','0', forth);
a5: register32 port map(WriteData, '0', '1', '1', select_writein(5), '0','0', fifth);
a6: register32 port map(WriteData, '0', '1', '1', select_writein(6), '0','0', sixth);
a7: register32 port map(WriteData, '0', '1', '1', select_writein(7), '0','0', seventh);


with ReadReg1 select 
	ReadData1<= 	X"00000000" when "00000",
			zero when "10000",
			first when "10001",
			second when "10010",
			third when "10011",
			forth when "10100",
			fifth when "10101",
			sixth when "10110",
			seventh when "10111",
			X"00000000" when others;

with ReadReg2 select 
	ReadData2<= 	X"00000000" when "00000",
			zero when "10000",
			first when "10001",
			second when "10010",
			third when "10011",
			forth when "10100",
			fifth when "10101",
			sixth when "10110",
			seventh when "10111",
			X"00000000" when others;

end remember;



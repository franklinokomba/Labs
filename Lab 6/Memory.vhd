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
   signal i_ram : ram_type;
   signal dummie: integer range 0 to 127;
   
begin

  RamProc: process(Clock, Reset, OE, WE, Address) is

  begin
	
    if Reset = '1' then
      for i in 0 to 127 loop   
          i_ram(i) <= X"00000000";
      end loop;
    end if;

    if falling_edge(Clock) then
	-- Add code to write data to RAM
	-- Use to_integer(unsigned(Address)) to index the i_ram array
	if WE = '1'  and to_integer(unsigned(Address)) < 128  then
		i_ram (to_integer(unsigned(Address))) <= DataIn(31 downto 0);
 		
	end if;
	
    end if;
	-- Rest of the RAM implementation
    
    if OE = '0' and to_integer(unsigned(Address)) < 128 then
	DataOut <= i_ram(to_integer(unsigned(Address)));
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
		 enout32,enout16,enout8: in std_logic; --active low
		 writein32, writein16, writein8: in std_logic; --active high
		 dataout: out std_logic_vector(31 downto 0));
	end component;
	
	signal a0, a1, a2, a3, a4, a5, a6, a7: std_logic_vector (31 downto 0);
	signal escribe : std_logic_vector (7 downto 0);
	signal zero : std_logic := '0';
	signal one : std_logic := '1';
	

begin
    -- Add your code here for the Register Bank implementation
	with ReadReg1 select
	ReadData1<= a0 when "01010",
		a1	when "01011",
		a2	when "01100",
		a3 	when "01101",
		a4	when "01110",
		a5	when "01111",
		a6	when "10000",
		a7	when "10001",
		X"00000000" when others;

	with ReadReg2 select
	ReadData2 <=a0	when "01010",
		a1	when "01011",
		a2	when "01100",
		a3 	when "01101",
		a4	when "01110",
		a5	when "01111",
		a6	when "10000",
		a7	when "10001",
		X"00000000" when others;

	with WriteCmd & WriteReg select
	escribe<="00000001" when "101010",
		"00000010" when "101011",
		"00000100" when "101100",
		"00001000" when "101101",
		"00010000" when "101110",
		"00100000" when "101111",
		"01000000" when "110000",
		"10000000" when "110001",
		"00000000" when others;
							 -- escribe
	x10: register32 port map(WriteData, zero, one, one, escribe(0), zero, zero, a0);
	x11: register32 port map(WriteData, zero, one, one, escribe(1), zero, zero, a1);
	x12: register32 port map(WriteData, zero, one, one, escribe(2), zero, zero, a2);
	x13: register32 port map(WriteData, zero, one, one, escribe(3), zero, zero, a3);
	x14: register32 port map(WriteData, zero, one, one, escribe(4), zero, zero, a4);
	x15: register32 port map(WriteData, zero, one, one, escribe(5), zero, zero, a5);
	x16: register32 port map(WriteData, zero, one, one, escribe(6), zero, zero, a6);
	x17: register32 port map(WriteData, zero, one, one, escribe(7), zero, zero, a7);


end remember;

-----------------------------------------------------------------------------------------------------
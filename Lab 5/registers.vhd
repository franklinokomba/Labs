--------------------------------------------------------------------------------
--
-- LAB #3
--
--------------------------------------------------------------------------------

Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity bitstorage is
	port(bitin: in std_logic;
		 enout: in std_logic;
		 writein: in std_logic;
		 bitout: out std_logic);
end entity bitstorage;

architecture memlike of bitstorage is
	signal q: std_logic := '0';
begin
	process(writein) is
	begin
		if (rising_edge(writein)) then
			q <= bitin;
		end if;
	end process;
	
	-- Note that data is output only when enout = 0	
	bitout <= q when enout = '0' else 'Z';
end architecture memlike;

--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity fulladder is
    port (a : in std_logic;
          b : in std_logic;
          cin : in std_logic;
          sum : out std_logic;
          carry : out std_logic
         );
end fulladder;

architecture addlike of fulladder is
begin
  sum   <= a xor b xor cin; 
  carry <= (a and b) or (a and cin) or (b and cin); 
end architecture addlike;


--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity register8 is
	port(datain: in std_logic_vector(7 downto 0);
	     enout:  in std_logic;
	     writein: in std_logic;
	     dataout: out std_logic_vector(7 downto 0));
end entity register8;

architecture memmy of register8 is
	component bitstorage
		port(bitin: in std_logic;
		 	 enout: in std_logic;
		 	 writein: in std_logic;
		 	 bitout: out std_logic);
	end component;
begin
	--insert code here.
	bit_0: bitstorage port map (datain(0), enout, writein, dataout(0));
	bit_1: bitstorage port map (datain(1), enout, writein, dataout(1));
	bit_2: bitstorage port map (datain(2), enout, writein, dataout(2));
	bit_3: bitstorage port map (datain(3), enout, writein, dataout(3));
	bit_4: bitstorage port map (datain(4), enout, writein, dataout(4));
	bit_5: bitstorage port map (datain(5), enout, writein, dataout(5));
	bit_6: bitstorage port map (datain(6), enout, writein, dataout(6));
	bit_7: bitstorage port map (datain(7), enout, writein, dataout(7));
end architecture memmy;

--------------------------------------------------------------------------------

Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity register32 is
	port(datain: in std_logic_vector(31 downto 0);
		 enout32,enout16,enout8: in std_logic;
		 writein32, writein16, writein8: in std_logic;
		 dataout: out std_logic_vector(31 downto 0));
end entity register32;

architecture biggermem of register32 is
		--register8 as a component
	component register8
		port(datain: in std_logic_vector(7 downto 0);
	    	     enout:  in std_logic;
	 	     writein: in std_logic;
	     	     dataout: out std_logic_vector(7 downto 0));
	end component;


signal newEnout: std_logic_vector(2 downto 0);
signal newWritein: std_logic_vector(2 downto 0);

begin
    --insert code here
process(enout32, enout16, enout8, writein32, writein16, writein8)
begin
	if (enout32 = '0') then
		newEnout <= "000";
	elsif (enout16 = '0') then
		newEnout <= "100";
	elsif (enout8 = '0') then
		newEnout <= "110";
	else
		newEnout <= "111";
	end if;

	if (writein32 = '1') then
		newWritein <= "111";
	elsif (writein16 = '1') then
		newWritein <= "011";
	elsif (writein8 = '1') then
		newWritein <= "001";
	else
		newWritein <= "000";
	end if;
end process;

	first8: register8 port map (datain(7 downto 0), newEnout(0), newWritein(0), dataout(7 downto 0));
	second8: register8 port map (datain(15 downto 8), newEnout(1), newWritein(1), dataout(15 downto 8));
	third8: register8 port map (datain(23 downto 16), newEnout(2), newWritein(2), dataout(23 downto 16));
	fourth8: register8 port map (datain(31 downto 24), newEnout(2), newWritein(2), dataout(31 downto 24));

end architecture biggermem;

------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity adder_subtracter is
	port(	datain_a: in std_logic_vector(31 downto 0);
		datain_b: in std_logic_vector(31 downto 0);
		add_sub: in std_logic;
		dataout: out std_logic_vector(31 downto 0);
		co: out std_logic);
end entity adder_subtracter;

architecture calc of adder_subtracter is
	component fulladder
	    port (a : in std_logic;
          	  b : in std_logic;
          	  cin : in std_logic;
          	  sum : out std_logic;
          	  carry : out std_logic);
	end component;

signal newDatain_b: std_logic_vector(31 downto 0);
signal carryin: std_logic_vector(32 downto 0);

begin
	carryin(0) <= add_sub;
	with add_sub select
		newDatain_b <= not datain_b WHEN '1',
			           datain_b WHEN others;

	FullAdd: FOR i IN 0 TO 31 GENERATE
	FullAdder_i: fulladder port map (datain_a(i), newDatain_b(i), carryin(i), dataout(i), carryin(i+1));
	END GENERATE;
	co <= carryin(32);
	
end architecture calc;

--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity shift_register is
	port(	datain: in std_logic_vector(31 downto 0);
	   	dir: in std_logic;
		shamt:	in std_logic_vector(4 downto 0);
		dataout: out std_logic_vector(31 downto 0));
end entity shift_register;

architecture shifter of shift_register is
	
begin
	--insert code here
	dataout <= datain(30 downto 0) & '0' WHEN (dir = '0' and shamt = "00001") ELSE
		   '0' & datain(31 downto 1) WHEN (dir = '1' and shamt = "00001") ELSE
		   datain(29 downto 0) & "00" WHEN (dir = '0' and shamt = "00010") ELSE
		   "00" & datain(31 downto 2) WHEN (dir = '1' and shamt = "00010") ELSE
		   datain(28 downto 0) & "000" WHEN (dir = '0' and shamt = "00011") ELSE
		   "000" & datain(31 downto 3) WHEN (dir = '1' and shamt = "00011") ELSE
		   datain;
	
end architecture shifter;



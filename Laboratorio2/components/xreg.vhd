-- Quartus II VHDL Template
-- Basic Shift Register

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.riscv_pkg.all;

entity xreg is
	port (
		iCLK, iRST, iWREN:   	in  std_logic;
		iRS1, iRS2, iRD, iDISP:	in  std_logic_vector(4 downto 0);
		iDATA:  						in  std_logic_vector(31 downto 0);
		oREGA, oREGB, oREGD:		out std_logic_vector(31 downto 0);
	);
end entity xreg;

architecture rtl of xreg is
	type banco is array (31 downto 0) of std_logic_vector(31 downto 0);
   signal xreg32:  banco;
begin
	oREGA <= xreg32(to_integer(unsigned(iRS1)));
	oREGB <= xreg32(to_integer(unsigned(iRS2)));
	oREGD <= xreg32(to_integer(unsigned(iDISP)));

	process(iCLK)
	begin
		if rising_edge(iCLK) then
			if iRST = '1' then 
				xreg32  <=  (others => (others => '0'));
				xreg32(SP_POS) <=  STACK_ADDRESS;
				xreg32(GP_POS) <=  DATA_ADDRESS;
			elsif iWREN = '1' and iRD /= "00000" then
				xreg32(to_integer(unsigned(iRD))) <= iDATA;
			end if;
		end if;
	end process;
end architecture rtl;

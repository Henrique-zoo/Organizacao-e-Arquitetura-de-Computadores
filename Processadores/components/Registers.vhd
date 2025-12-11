-- Quartus II VHDL Template
-- Basic Shift Register

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.riscv_pkg.all;

entity Registers is
	port (
		clock:          in  std_logic;
		reset:          in  std_logic;
		write_en:       in  std_logic;
		RS1:            in  std_logic_vector(4 downto 0);
		RS2:            in  std_logic_vector(4 downto 0);
		RD:             in  std_logic_vector(4 downto 0);
		disp_select:    in  std_logic_vector(4 downto 0);
		data:           in  std_logic_vector(31 downto 0);
		read_data_A:    out std_logic_vector(31 downto 0);
		read_data_B:    out std_logic_vector(31 downto 0);
		read_disp:      out std_logic_vector(31 downto 0)
	);
end entity Registers;

architecture rtl of Registers is
	type	 bank is array (31 downto 0) of std_logic_vector(31 downto 0);
	signal Registers32:  bank;
begin
	read_data_A <= Registers32(to_integer(unsigned(RS1)));
	read_data_B <= Registers32(to_integer(unsigned(RS2)));
	read_disp	<= Registers32(to_integer(unsigned(disp_select)));

	process(clock, reset)
	begin
		if reset = '1' then
			Registers32  <=  (others => (others => '0'));
			Registers32(SP_POS) <=  STACK_ADDRESS;
			Registers32(GP_POS) <=  DATA_ADDRESS;
		elsif rising_edge(clock) then
			if write_en = '1' and RD /= "00000" then
				Registers32(to_integer(unsigned(RD))) <= data;
			end if;
		end if;
	end process;
end architecture rtl;

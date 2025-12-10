library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity IF_ID is
    port (
		  clk:			in std_logic;
		  rst:			in std_logic;
        PC_in:			in std_logic_vector(31 downto 0);
        instr_in:		in std_logic_vector(31 downto 0);
        PC_out:		out std_logic_vector(31 downto 0);
        instr_out:	out std_logic_vector(31 downto 0)
    );
end entity IF_ID;

architecture rtl of IF_ID is
begin
    make_register: process(clk, rst)
    begin
        if rst = '1' then
            PC_out    <= x"0000_0000";
            instr_out <= x"0000_0000";
        elsif rising_edge(clk) then
            PC_out    <= PC_in;
            instr_out <= instr_in;
        end if;
    end process make_register;
end architecture rtl;
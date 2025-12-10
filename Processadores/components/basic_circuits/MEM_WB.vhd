library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MEM_WB is
    port (
		  clk:		  in	std_logic;
		  rst:		  in	std_logic;
        WB:         in	std_logic_vector(1 downto 0);
        RD_in:      in	std_logic_vector(4 downto 0); 
        ALUOut_in:  in	std_logic_vector(31 downto 0);
        memOut_in:  in	std_logic_vector(31 downto 0);
        regWrite:   out std_logic;
        mem2Reg:    out std_logic;
        RD_out:     out std_logic_vector(4 downto 0);
        ALUOut_out: out std_logic_vector(31 downto 0);
        memOut_out: out std_logic_vector(31 downto 0)
    );
end entity MEM_WB;

architecture rtl of MEM_WB is
begin
    make_register: process(clk, rst)
    begin
        if rst = '1' then
            regWrite    <= '0';
            mem2Reg     <= '0';
            ALUOut_out  <= (others => '0');
            memOut_out  <= (others => '0');
            RD_out      <= (others => '0');
        elsif rising_edge(clk) then
            regWrite    <= WB(1);
            mem2Reg     <= WB(0);
            ALUOut_out  <= ALUOut_in;
            memOut_out  <= memOut_in;
            RD_out      <= RD_in;
        end if;
    end process make_register;
end architecture rtl;
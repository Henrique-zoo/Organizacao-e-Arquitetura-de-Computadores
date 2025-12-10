library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ID_EX is
    port (
		  clk:		  in 	std_logic;
		  rst:		  in 	std_logic;
        regWrite:   in 	std_logic;
        mem2Reg:    in 	std_logic;
        memRead:    in 	std_logic;
        memWrite:   in 	std_logic;
        ALUsrc_in:  in 	std_logic;
        ALUop_in:   in 	std_logic_vector(1 downto 0);
        regA_in:    in 	std_logic_vector(31 downto 0);
        regB_in:    in 	std_logic_vector(31 downto 0);
        imm_in:     in 	std_logic_vector(31 downto 0);
        funct_in:   in 	std_logic_vector(9 downto 0);
        RD_in:      in 	std_logic_vector(4 downto 0);
        WB:         out std_logic_vector(1 downto 0);
        M:          out std_logic_vector(1 downto 0);
        ALUsrc_out: out std_logic;
        ALUop_out:  out std_logic_vector(1 downto 0);
        regA_out:   out std_logic_vector(31 downto 0);
        regB_out:   out std_logic_vector(31 downto 0);
        imm_out:    out std_logic_vector(31 downto 0);
        funct_out:  out std_logic_vector(9 downto 0);
        RD_out:     out std_logic_vector(4 downto 0)
    );
end entity ID_EX;

architecture rtl of ID_EX is
begin
    make_register: process(clk, rst)
    begin
        if rst = '1' then
            WB <= "00";
            M  <= "00";
            ALUsrc_out  <= '1';
            ALUop_out   <= "00";
            regA_out    <= (others => '0');
            regB_out    <= (others => '0');
            imm_out     <= (others => '0');
            funct_out   <= (others => '0');
            RD_out      <= (others => '0');
        elsif rising_edge(clk) then
            WB <= regWrite & mem2Reg;
            M  <= memRead & memWrite;
            ALUsrc_out  <= ALUsrc_in;
            ALUop_out   <= ALUop_in;
            regA_out    <= regA_in;
            regB_out    <= regB_in;
            imm_out     <= imm_in;
            funct_out   <= funct_in;
            RD_out      <= RD_in;
        end if;
    end process make_register;
end architecture rtl;
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.riscv_pkg.all;

entity gen_imm is
    port (
        instr : in  std_logic_vector(31 downto 0);
        imm32 : out std_logic_vector(31 downto 0)
    );
end entity gen_imm;

architecture behavioral of gen_imm is
    alias opcode: std_logic_vector(6 downto 0) is instr(6 downto 0);
begin
    with opcode select
        imm32   <=  x"00000" & instr(31 downto 20) when OPC_LOAD | OPC_OPIMM | OPC_JALR,
                    x"00000" & instr(31 downto 25) & instr(11 downto 7) when OPC_STORE,
                    (18 downto 0 => '0') & instr(31) & instr(7) & instr(30 downto 25) & instr(11 downto 8) & '0' when OPC_BRANCH,
                    (10 downto 0 => '0') & instr(31) & instr(19 downto 12) & instr(20) & instr(30 downto 21) & '0' when OPC_JAL,
                    instr(31 downto 12) & x"000" when OPC_LUI,
                    ZERO32 when others;
end architecture behavioral;

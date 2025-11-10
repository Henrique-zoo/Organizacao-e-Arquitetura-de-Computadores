library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.riscv_pkg.all;

entity general_control is
    port (
        opcode:     in  std_logic_vector(6 downto 0);
        mem2Reg:    out std_logic;
        memRead:    out std_logic;
        branch:     out std_logic;
        jump:       out std_logic;
        ALUOp:      out std_logic_vector(1 downto 0);
        memWrite:   out std_logic;
        ALUSrc:     out std_logic;
        regWrite:   out std_logic
    );
end entity general_control;

architecture behavioral of general_control is
    signal state: std_logic_vector(8 downto 0);
begin
    with opcode select
        state <=  '0' & '0' & '0' & '0' & "10" & '0' & '0' & '1'  when  OPC_RTYPE,
                  '0' & '0' & '0' & '0' & "10" & '0' & '1' & '1'  when  OPC_OPIMM,
                  '-' & '0' & '0' & '0' & "00" & '1' & '1' & '0'  when  OPC_STORE,
                  '1' & '1' & '0' & '0' & "00" & '0' & '1' & '1'  when  OPC_LOAD,
                  '-' & '0' & '1' & '0' & "01" & '0' & '0' & '0'  when  OPC_BRANCH,
                  '0' & '0' & '0' & '1' & "01" & '0' & '-' & '1'  when  OPC_JAL,
                  '0' & '0' & '0' & '1' & "10" & '0' & '1' & '1'  when  OPC_JALR,
                  '0' & '0' & '1' & '0' & "00" & '0' & '1' & '1'  when  OPC_LUI,
                  (others => '-')                                 when  others;

    mem2Reg  <=  state(8);
    memRead  <=  state(7);
    branch   <=  state(6);
    jump     <=  state(5);
    ALUOp    <=  state(4 downto 3);
    memWrite <=  state(2);
    ALUSrc   <=  state(1);
    regWrite <=  state(0);
end architecture behavioral;
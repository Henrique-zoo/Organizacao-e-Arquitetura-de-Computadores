library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity unifiedMemory is
    port (
        clock:       in  std_logic;
        memRead:     in  std_logic;
        memWrite:    in  std_logic;
        address:     in  std_logic_vector(31 downto 0);
        data:        in  std_logic_vector(31 downto 0);
        instrOrData: out std_logic_vector(31 downto 0)
    );
end entity unifiedMemory;

architecture rtl of unifiedMemory is
    signal  memIWrite, memDwrite: std_logic;
    signal  instr, readData: std_logic_vector(31 downto 0);
begin
    memIWrite <= memWrite and not address(28);
    memDwrite <= memWrite and address(28);
    instrOrData <= instr when address(28) = '0' else readData;
    
    MemI_inst: entity work.ramI
        port map (
            address => address(11 downto 2),
            clock   => clock,
            data    => data,
            wren    => memIWrite,
            q       => instr
        );
    
    MemD_inst: entity work.ramD
        port map (
            address => address(11 downto 2),
            clock   => clock,
            data    => data,
            wren    => memDWrite,
            q       => readData
        );
end architecture rtl;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.riscv_pkg.all;

entity Pipeline is
    port (
        clockCPU : in  std_logic;
        clockMem : in  std_logic;
        reset    : in  std_logic;
        PC       : out std_logic_vector(31 downto 0);
        instr    : out std_logic_vector(31 downto 0);
        regin    : in  std_logic_vector(4 downto 0);
        regout   : out std_logic_vector(31 downto 0)
    );
end Pipeline;

architecture Behavioral of Pipeline is
    -- Sinais internos
    signal PC_i      : std_logic_vector(31 downto 0) := x"00400000";
    signal instr_i   : std_logic_vector(31 downto 0) := (others => '0');
    signal regout_i  : std_logic_vector(31 downto 0) := (others => '0');
    signal SaidaULA         : std_logic_vector(31 downto 0);
    signal Leitura2         : std_logic_vector(31 downto 0);
    signal MemData, wIouD   : std_logic_vector(31 downto 0);
    signal EscreveMem       : std_logic;
    signal IF_ID, ID_EX, EX_MEM, MEM_WB: std_logic_vector(31 downto 0);


begin
    -- Atribuição das saídas
    PC     <= PC_i;
    instr  <= instr_i;
    regout <= regout_i;
    
    -- Processo para atualização do PC
    process(clockCPU, reset)
    begin
        if reset = '1' then
            PC_i <= x"0040_0000";
        elsif rising_edge(clockCPU) then
            PC_i <= std_logic_vector(unsigned(PC_i) + 4);
        end if;
    end process;
    
    -- Atribuições contínuas
    EscreveMem <= '0';
    SaidaULA   <= (others => '0');
    
    -- Instanciação da memória de instruções
    MemC : ramI
        port map (
            address => PC_i(11 downto 2),
            clock   => clockMem,
            data    => (others => '0'),
            wren    => '0',
            q       => instr_i
        );
    
    -- Instanciação da memória de dados
    MemD : ramD
        port map (
            address => SaidaULA(11 downto 2),
            clock   => clockMem,
            data    => Leitura2,
            wren    => EscreveMem,
            q       => MemData
        );
    
    -- Seu código do processador viria aqui
    
end Behavioral;
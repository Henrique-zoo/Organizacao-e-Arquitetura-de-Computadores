library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.riscv_pkg.all;

entity multiciclo is
    port (
        clockCPU : in  std_logic;
        clockMem : in  std_logic;
        reset    : in  std_logic;
        PC       : out std_logic_vector(31 downto 0);
        instr    : out std_logic_vector(31 downto 0);
        regin    : in  std_logic_vector(4 downto 0);
        regout   : out std_logic_vector(31 downto 0);
		estado	  : out std_logic_vector(3 downto 0)
    );
end multiciclo;

architecture Behavioral of multiciclo is
    -- Sinais internos
	 signal wIouD          : std_logic_vector(31 downto 0);

    signal PC_i      : std_logic_vector(31 downto 0) := x"0040_0000";
	 signal PCBack	   : std_logic_vector(31 downto 0) := x"0040_0000";
    signal instr_i   : std_logic_vector(31 downto 0) := (others => '0');
    signal regout_i  : std_logic_vector(31 downto 0) := (others => '0');
    signal estado_i, proximo  : std_logic_vector(3 downto 0);
    signal Leitura2         	: std_logic_vector(31 downto 0);
    signal MemData, rmem  		: std_logic_vector(31 downto 0);
    signal EscreveMem       	: std_logic;
    
begin
    -- Atribuição das saídas
    PC     	<= PC_i;
    instr  	<= instr_i;
    regout 	<= regout_i;
	 estado 	<= estado_i;
	 rmem 	<= MemData when wIouD(28) = '1' else instr_i;
    
    -- Processo para atualização do PC
    process(clockCPU, reset)
    begin
        if reset = '1' then
            PC_i <= x"00400_000";
				PCBack <= x"00400_000";
				estado_i <= "0000";
        elsif rising_edge(clockCPU) then
            estado_i <= proximo;
        end if;
    end process;
    
    -- Atribuições contínuas
    EscreveMem <= '0';
    
    -- Instanciação da memória de instruções
    MemC : ramI
        port map (
            address => wIouD(11 downto 2),
            clock   => clockMem,
            data    => (others => '0'),
            wren    => '0',
            q       => instr_i
        );
    
    -- Instanciação da memória de dados
    MemD : ramD
        port map (
            address => wIouD(11 downto 2),
            clock   => clockMem,
            data    => Leitura2,
            wren    => (EscreveMem and not wIouD(28)),
            q       => MemData
        );
    
    -- Seu código do processador viria aqui
    
end Behavioral;
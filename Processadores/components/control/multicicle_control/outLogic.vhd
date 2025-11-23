library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity outLogic is
    port (
        currentState : in  std_logic_vector( 3 downto 0 );
        ALUOp        : out std_logic_vector( 1 downto 0 );
        ALUsrcA      : out std_logic_vector( 1 downto 0 );
        ALUsrcB      : out std_logic_vector( 1 downto 0 );
        IRWrite      : out std_logic;
        IorD         : out std_logic;
        mem2Reg      : out std_logic_vector( 1 downto 0 );
        memRead      : out std_logic;
        memWrite     : out std_logic;
        PCWrite      : out std_logic;
        PCWriteCond  : out std_logic;
        PCbackWrite  : out std_logic;
        PCsrc        : out std_logic;
        regWrite     : out std_logic
    );
end entity outLogic;

architecture rtl of outLogic is
    signal Q: std_logic_vector(3 downto 0);
begin
    Q <= currentState;
    
    PCsrc <= (not Q(3) and Q(2)) or (Q(3) and not Q(2) and not Q(1));
    ALUOp(1) <= (not Q(3) and Q(1) and not Q(0));
    ALUOp(0) <= (Q(3) and not Q(2) and not Q(1));
    ALUsrcA(1) <= (Q(2) and not Q(1) and Q(0)) or (not Q(3) and not Q(2) and not Q(1) and not Q(0));
    ALUsrcA(0) <= (not Q(3) and Q(1)) or (Q(3) and not Q(2) and not Q(1));
    ALUsrcB(1) <= (not Q(3) and Q(0));
    ALUsrcB(0) <= (Q(2) and not Q(1) and Q(0)) or (not Q(3) and not Q(2) and not Q(1) and not Q(0));
    PCbackWrite <= (not Q(3) and not Q(2) and not Q(1) and not Q(0));
    regWrite <= (Q(3) and not Q(2) and Q(0)) or (Q(2) and not Q(1) and Q(0));
    mem2Reg(1) <= (not Q(2) and Q(1) and Q(0)) or (Q(3) and Q(2) and not Q(1) and Q(0));
    mem2Reg(0) <= (Q(2) and not Q(1) and Q(0));
    PCWriteCond <= (Q(3) and not Q(2) and not Q(1) and not Q(0));
    PCWrite <= (not Q(3) and not Q(2) and not Q(1) and not Q(0))
               or (not Q(3) and Q(2) and not Q(1) and Q(0));
    IorD <= (not Q(3) and Q(1));
    memWrite <= (not Q(3) and Q(2) and Q(1) and Q(0));
    memRead <= (not Q(3) and not Q(2) and not Q(1) and not Q(0))
               or (not Q(3) and Q(2) and Q(1) and not Q(0));
    IRWrite <= (not Q(3) and not Q(2) and not Q(1) and not Q(0));
end architecture rtl;

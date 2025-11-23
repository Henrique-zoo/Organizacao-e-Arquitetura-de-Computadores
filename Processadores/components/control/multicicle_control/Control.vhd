library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.riscv_pkg.all;

entity Control is
    port (
        clock:       in  std_logic;
        reset:       in  std_logic;
        opcode:      in  std_logic_vector(6 downto 0);
        ALUOp:       out std_logic_vector(1 downto 0);
        ALUsrcA:     out std_logic_vector(1 downto 0);
        ALUsrcB:     out std_logic_vector(1 downto 0);
        IRWrite:     out std_logic;
        IorD:        out std_logic;
        mem2Reg:     out std_logic_vector(1 downto 0);
        memRead:     out std_logic;
        memWrite:    out std_logic;
        PCWrite:     out std_logic;
        PCWriteCond: out std_logic;
        PCbackWrite: out std_logic;
        PCsrc:       out std_logic;
        regWrite:    out std_logic;
        state:       out std_logic_vector(3 downto 0)
    );
end entity Control;

architecture rtl of Control is 
    signal current_state:   std_logic_vector(3 downto 0);
    signal sel:             std_logic_vector(2 downto 0);
    signal registerIn_in:   std_logic_vector(7 downto 0);
begin
    state <= current_state;

    sel_mapping: process(opcode)
    begin
        case opcode is
            when OPC_LOAD   =>  sel <= "000";
            when OPC_STORE  =>  sel <= "001";
            when OPC_OPIMM  =>  sel <= "010";
            when OPC_JALR   =>  sel <= "011";
            when OPC_RTYPE  =>  sel <= "100";
            when OPC_BRANCH =>  sel <= "101";
            when OPC_JAL    =>  sel <= "110";
            when OPC_LUI    =>  sel <= "111";
            when others     =>  sel <= (others => '-');
        end case;
    end process sel_mapping;

    out_logic: entity work.outLogic
        port map (
            ALUOp        => ALUOp,
            ALUsrcA      => ALUsrcA,
            ALUsrcB      => ALUsrcB,
            currentState => current_state,
            IRWrite      => IRWrite,
            IorD         => IorD,
            mem2Reg      => mem2Reg,
            memRead      => memRead,
            memWrite     => memWrite,
            PCWrite      => PCWrite,
            PCWriteCond  => PCWriteCond,
            PCbackWrite  => PCbackWrite,
            PCsrc        => PCsrc,
            regWrite     => regWrite
        );

    next_state_logic: entity work.nextStateLogic
        port map (
            currentState => current_state,
            selection    => sel,
            registerIn   => registerIn_in
        );

    shift_register : entity work.ShiftRegister
        port map (
            CLK => clock,
            RST => reset,
            D   => registerIn_in(3 downto 0),
            L   => registerIn_in(4),
            R   => registerIn_in(5),
            S   => registerIn_in(7 downto 6),
            Q   => current_state
        );
end architecture rtl;

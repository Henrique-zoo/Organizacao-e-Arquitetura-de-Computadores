library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity nextStateLogic is
    port (
        currentState : in  std_logic_vector(3 downto 0);
        selection    : in  std_logic_vector(2 downto 0);
        registerIn   : out std_logic_vector(7 downto 0)
    );
end entity nextStateLogic;

architecture rtl of nextStateLogic is 

    signal muxIn_0_in   : std_logic_vector(7 downto 0);
    signal muxIn_1_in   : std_logic_vector(7 downto 0);
    signal muxIn_2_in   : std_logic_vector(7 downto 0);
    signal muxIn_3_in   : std_logic_vector(7 downto 0);
    signal muxIn_4_in   : std_logic_vector(7 downto 0);
    signal muxIn_5_in   : std_logic_vector(7 downto 0);
    signal muxIn_6_in   : std_logic_vector(7 downto 0);
    signal muxIn_7_in   : std_logic_vector(7 downto 0);
    signal ground  : std_logic;
    signal source  : std_logic;

begin
    ground  <=  '0'; -- Terra
    source  <=  '1'; -- Fonte
    --------------------------------------------------------------------------------
    -- lw                                                                         --
    --------------------------------------------------------------------------------
    muxIn_0_in(0) <= ground;
    muxIn_0_in(1) <= ground;
    muxIn_0_in(2) <= ground;
    muxIn_0_in(3) <= ground;
    muxIn_0_in(4) <= source;
    muxIn_0_in(5) <= not currentState(1);
    muxIn_0_in(6) <= currentState(3);
    muxIn_0_in(7) <= not currentState(3);
    --------------------------------------------------------------------------------
    -- sw                                                                         --
    --------------------------------------------------------------------------------
    muxIn_1_in(0) <= ground;
    muxIn_1_in(1) <= ground;
    muxIn_1_in(2) <= ground;
    muxIn_1_in(3) <= ground;
    muxIn_1_in(4) <= ground;
    muxIn_1_in(5) <= source;
    muxIn_1_in(6) <= currentState(2) xor currentState(3);
    muxIn_1_in(7) <= source;
    --------------------------------------------------------------------------------
    -- addi                                                                       --
    --------------------------------------------------------------------------------
    muxIn_2_in(0) <= ground;
    muxIn_2_in(1) <= ground;
    muxIn_2_in(2) <= ground;
    muxIn_2_in(3) <= ground;
    muxIn_2_in(4) <= source;
    muxIn_2_in(5) <= source;
    muxIn_2_in(6) <= currentState(1) or currentState(3);
    muxIn_2_in(7) <= not (currentState(1) and currentState(3));
    --------------------------------------------------------------------------------
    -- jalr                                                                       --
    --------------------------------------------------------------------------------
    muxIn_3_in(0) <= currentState(1);
    muxIn_3_in(1) <= ground;
    muxIn_3_in(2) <= currentState(1);
    muxIn_3_in(3) <= ground;
    muxIn_3_in(4) <= ground;
    muxIn_3_in(5) <= source;
    muxIn_3_in(6) <= currentState(2) xor currentState(1);
    muxIn_3_in(7) <= source;
    --------------------------------------------------------------------------------
    -- R-Type                                                                     --
    --------------------------------------------------------------------------------
    muxIn_4_in(0) <= ground;
    muxIn_4_in(1) <= ground;
    muxIn_4_in(2) <= ground;
    muxIn_4_in(3) <= ground;
    muxIn_4_in(4) <= source;
    muxIn_4_in(5) <= not currentState(0);
    muxIn_4_in(6) <= currentState(2) or currentState(1);
    muxIn_4_in(7) <= not currentState(1);
    --------------------------------------------------------------------------------
    -- beq                                                                        --
    --------------------------------------------------------------------------------
    muxIn_5_in(0) <= ground;
    muxIn_5_in(1) <= ground;
    muxIn_5_in(2) <= ground;
    muxIn_5_in(3) <= ground;
    muxIn_5_in(4) <= source;
    muxIn_5_in(5) <= not currentState(3);
    muxIn_5_in(6) <= currentState(0);
    muxIn_5_in(7) <= not currentState(0);
    --------------------------------------------------------------------------------
    -- jal                                                                        --
    --------------------------------------------------------------------------------
    muxIn_6_in(0) <= not currentState(2);
    muxIn_6_in(1) <= ground;
    muxIn_6_in(2) <= not currentState(2);
    muxIn_6_in(3) <= ground;
    muxIn_6_in(4) <= ground;
    muxIn_6_in(5) <= source;
    muxIn_6_in(6) <= currentState(0);
    muxIn_6_in(7) <= source;
    --------------------------------------------------------------------------------
    -- lui                                                                        --
    --------------------------------------------------------------------------------
    muxIn_7_in(0) <= not currentState(2);
    muxIn_7_in(1) <= ground;
    muxIn_7_in(2) <= not currentState(2);
    muxIn_7_in(3) <= not currentState(2);
    muxIn_7_in(4) <= ground;
    muxIn_7_in(5) <= source;
    muxIn_7_in(6) <= currentState(0);
    muxIn_7_in(7) <= source;

    Mux8x1: entity work.Multiplexer_bus_8
        generic map ( nrOfBits => 8 )
        port map (
            enable  => '1',
            muxIn_0 => muxIn_0_in,
            muxIn_1 => muxIn_1_in,
            muxIn_2 => muxIn_2_in,
            muxIn_3 => muxIn_3_in,
            muxIn_4 => muxIn_4_in,
            muxIn_5 => muxIn_5_in,
            muxIn_6 => muxIn_6_in,
            muxIn_7 => muxIn_7_in,
            muxOut  => registerIn,
            sel     => selection
        );
end architecture rtl;

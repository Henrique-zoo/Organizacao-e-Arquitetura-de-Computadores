library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity D_FLIPFLOP is
    generic ( invertClockEnable : INTEGER := 0 );
    port (
        clock  : in  std_logic;
        d      : in  std_logic;
        preset : in  std_logic;
        reset  : in  std_logic;
        tick   : in  std_logic;
        q      : out std_logic;
        qBar   : out std_logic
    );
end entity D_FLIPFLOP;

architecture behavioral of D_FLIPFLOP is
    signal s_clock        : std_logic;
    signal s_currentState : std_logic;
    signal s_nextState    : std_logic;
begin
    q    <= s_currentState;
    qBar <= not s_currentState;
    s_clock <= clock when invertClockEnable = 0 else not(clock);

    s_nextState <= d;

    makeMemory: process(all) is
    begin
        if (reset = '1') then
            s_currentState <= '0';
        elsif (preset = '1') then
            s_currentState <= '1';
        elsif (rising_edge(s_clock)) then
            if (tick = '1') then
                s_currentState <= s_nextState;
            end if;
        end if;
    end process makeMemory;
end behavioral;

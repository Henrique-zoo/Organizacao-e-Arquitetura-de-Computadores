library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ShiftRegister is
    PORT (
        CLK : in  std_logic;
        D   : in  std_logic_vector(3 downto 0);
        L   : in  std_logic;
        R   : in  std_logic;
        RST : in  std_logic;
        S   : in  std_logic_vector(1 downto 0);
        Q   : out std_logic_vector(3 downto 0)
    );
end entity ShiftRegister;

architecture rtl of ShiftRegister is
    signal D_in  : std_logic_vector(3 downto 0);
    signal Q_in  : std_logic_vector(3 downto 0);
    signal S_in  : std_logic_vector(1 downto 0);

    signal mux_out3 : std_logic;
    signal mux_out2 : std_logic;
    signal mux_out1 : std_logic;
    signal mux_out0 : std_logic;

    signal L_in    : std_logic;
    signal CLK_net : std_logic;
    signal RST_net : std_logic;
    signal R_in    : std_logic;

    signal const_zero : std_logic;
begin
    D_in <= D;
    S_in <= S;
    L_in    <= L;
    CLK_net <= CLK;
    RST_net <= RST;
    R_in    <= R;
    Q <= Q_in;
    const_zero  <=  '0';

    Mux_bit3: entity work.Multiplexer_4
        port map (
            enable  => '1',
            muxIn_0 => Q_in(3),
            muxIn_1 => R_in,
            muxIn_2 => Q_in(2),
            muxIn_3 => D_in(3),
            muxOut  => mux_out3,
            sel     => S_in(1 downto 0)
        );

    Mux_bit2: entity work.Multiplexer_4
        port map (
            enable  => '1',
            muxIn_0 => Q_in(2),
            muxIn_1 => Q_in(3),
            muxIn_2 => Q_in(1),
            muxIn_3 => D_in(2),
            muxOut  => mux_out2,
            sel     => S_in(1 downto 0)
        );

    Mux_bit1: entity work.Multiplexer_4
        port map (
            enable  => '1',
            muxIn_0 => Q_in(1),
            muxIn_1 => Q_in(2),
            muxIn_2 => Q_in(0),
            muxIn_3 => D_in(1),
            muxOut  => mux_out1,
            sel     => S_in(1 downto 0)
        );

    Mux_bit0: entity work.Multiplexer_4
        port map (
            enable  => '1',
            muxIn_0 => Q_in(0),
            muxIn_1 => Q_in(1),
            muxIn_2 => L_in,
            muxIn_3 => D_in(0),
            muxOut  => mux_out0,
            sel     => S_in(1 downto 0)
        );

    FlipFlop3: entity work.D_FLIPFLOP
        port map (
            clock  => CLK_net,
            d      => mux_out3,
            preset => const_zero,
            reset  => RST_net,
            tick   => '1',
            q      => Q_in(3),
            qBar   => open
        );

    FlipFlop2: entity work.D_FLIPFLOP
        port map (
            clock  => CLK_net,
            d      => mux_out2,
            preset => const_zero,
            reset  => RST_net,
            tick   => '1',
            q      => Q_in(2),
            qBar   => open
        );

    FlipFlop1: entity work.D_FLIPFLOP
        port map (
            clock  => CLK_net,
            d      => mux_out1,
            preset => const_zero,
            reset  => RST_net,
            tick   => '1',
            q      => Q_in(1),
            qBar   => open
        );

    FlipFlop0: entity work.D_FLIPFLOP
        port map (
            clock  => CLK_net,
            d      => mux_out0,
            preset => const_zero,
            reset  => RST_net,
            tick   => '1',
            q      => Q_in(0),
            qBar   => open
        );
end architecture rtl;

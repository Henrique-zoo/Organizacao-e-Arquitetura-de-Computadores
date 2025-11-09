library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.riscv_pkg.all;

entity ALU is
    port (
        iControl:   in  std_logic_vector(3 downto 0);
        iA:         in  std_logic_vector(31 downto 0);
        iB:         in  std_logic_vector(31 downto 0);
        oResult:    out std_logic_vector(31 downto 0);
        zero:       out std_logic
    );
end entity ALU;

architecture rtl of ALU is
    -- intermediate signals
    signal adder_sum:   std_logic_vector(31 downto 0);
    signal subt_i:      std_logic;
begin
    adder: entity work.adder(behavioral)
        port map (
            subt =>  subt_i,
            A    =>  iA,
            B    =>  iB,
            S    =>  adder_sum
        );

    subt_i  <=  '1' when (iControl = OPSUB) or (iControl = OPSLT) or (iControl = OPC_BRANCH) else '0';
    zero    <=  '1' when adder_sum = ZERO32 else '0';

    out_logic: process(all)
    begin
        case iControl is
            when OPAND  =>
                oResult <= iA and iB;
            when OPOR   =>
                oResult <= iA or iB;
            when OPADD | OPSUB =>
                oResult <= adder_sum;
            when OPSLT  =>
                if signed(iA) < signed(iB) then
                    oResult <= std_logic_vector(to_signed(1,32));
                else
                    oResult <= ZERO32;
                end if;
            when others =>
                oResult <= ZERO32;
        end case;
    end process out_logic;
end rtl;
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity adder is
    port (
        subt:   in  std_logic;
        A:      in  std_logic_vector(31 downto 0);
        B:      in  std_logic_vector(31 downto 0);
        S:      out std_logic_vector(31 downto 0)
    );
end entity adder;

architecture behavioral of adder is
begin
    process(all)
        variable res: signed(31 downto 0);
    begin
        if subt = '1' then
            res := signed(A) - signed(B);
        else
            res := signed(A) + signed(B);
        end if;
        S <= std_logic_vector(res);
    end process;
end architecture behavioral;
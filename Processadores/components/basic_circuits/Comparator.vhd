library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Comparator is
    port (
        A:  	in std_logic_vector(31 downto 0);
        B:  	in std_logic_vector(31 downto 0);
        equal:	out std_logic
    );
end entity Comparator;

architecture behavioral of Comparator is
begin
    equal <= '1' when A = B else '0';
end architecture behavioral;
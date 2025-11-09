library IEEE;
use IEEE.std_logic_1164.all;

entity Mux2x1 is
    port (
        A:  in  std_logic_vector(31 downto 0);
        B:  in  std_logic_vector(31 downto 0);
        S:  in  std_logic;
        C:  out std_logic_vector(31 downto 0)
    );
end entity Mux2x1;

architecture behavioral of Mux2x1 is
begin
    C <= A when (S = '0') else
         B when (S = '1') else
         (others => '0');
end architecture behavioral;
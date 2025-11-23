library IEEE;
use IEEE.std_logic_1164.all;

entity Mux4x1 is
    port (
        A:  in  std_logic_vector(31 downto 0);
        B:  in  std_logic_vector(31 downto 0);
        C:  in  std_logic_vector(31 downto 0);
        D:  in  std_logic_vector(31 downto 0);
        S:  in  std_logic_vector(1 downto 0);
        Y:  out std_logic_vector(31 downto 0)
    );
end entity Mux4x1;

architecture behavioral of Mux4x1 is
begin
    Y <= A when (S = "00") else
         B when (S = "01") else
         C when (S = "10") else
         D when (S = "11") else
         (others => '0');
end architecture behavioral;
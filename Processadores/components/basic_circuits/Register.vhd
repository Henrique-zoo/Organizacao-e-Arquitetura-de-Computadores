library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Register32 is
    generic ( reset_val: std_logic_vector(31 downto 0) );
    port (
        clock:       in  std_logic;
        reset:       in  std_logic;
        writeEnable: in  std_logic;
        data:        in  std_logic_vector(31 downto 0);
        regOut:      out std_logic_vector(31 downto 0)
    );
end entity Register32;

architecture behavioral of Register32 is
begin
    make_register: process(clock, reset)
    begin
        if reset = '1' then
            regOut <= reset_val;
        elsif rising_edge(clock) then
            if writeEnable = '1' then
                regOut <= data;
            end if;
        end if;
    end process make_register;
end architecture behavioral;
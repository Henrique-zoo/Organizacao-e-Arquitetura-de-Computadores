library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Multiplexer_bus_8 is
    generic ( nrOfBits : INTEGER );
    port ( 
        enable:  in  std_logic;
        muxIn_0: in  std_logic_vector((nrOfBits - 1) downto 0);
        muxIn_1: in  std_logic_vector((nrOfBits - 1) downto 0);
        muxIn_2: in  std_logic_vector((nrOfBits - 1) downto 0);
        muxIn_3: in  std_logic_vector((nrOfBits - 1) downto 0);
        muxIn_4: in  std_logic_vector((nrOfBits - 1) downto 0);
        muxIn_5: in  std_logic_vector((nrOfBits - 1) downto 0);
        muxIn_6: in  std_logic_vector((nrOfBits - 1) downto 0);
        muxIn_7: in  std_logic_vector((nrOfBits - 1) downto 0);
        sel:     in  std_logic_vector(2 downto 0);
        muxOut:  out std_logic_vector((nrOfBits - 1) downto 0)
    );
end entity Multiplexer_bus_8;

architecture behavioral of Multiplexer_bus_8 is 
begin
    makeMux: process(all) is
    begin
        if (enable = '0') then
            muxOut <= (others => '0');
        else
            case (sel) is
                when "000" => muxOut <= muxIn_0;
                when "001" => muxOut <= muxIn_1;
                when "010" => muxOut <= muxIn_2;
                when "011" => muxOut <= muxIn_3;
                when "100" => muxOut <= muxIn_4;
                when "101" => muxOut <= muxIn_5;
                when "110" => muxOut <= muxIn_6;
                when others  => muxOut <= muxIn_7;
            end case;
        end if;
    end process makeMux;
end behavioral;

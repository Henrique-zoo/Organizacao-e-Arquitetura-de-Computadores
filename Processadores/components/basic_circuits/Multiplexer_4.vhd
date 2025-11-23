library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Multiplexer_4 is
    port (
        enable  : in  std_logic;
        muxIn_0 : in  std_logic;
        muxIn_1 : in  std_logic;
        muxIn_2 : in  std_logic;
        muxIn_3 : in  std_logic;
        sel     : in  std_logic_vector(1 downto 0);
        muxOut  : out std_logic
    );
end entity Multiplexer_4;

architecture behavioral of Multiplexer_4 is 
begin
    makeMux: process(all) is
    begin
        if (enable = '0') then
            muxOut <= '0';
        else
            case (sel) is
                when "00" => muxOut <= muxIn_0;
                when "01" => muxOut <= muxIn_1;
                when "10" => muxOut <= muxIn_2;
                when others  => muxOut <= muxIn_3;
            end case;
        end if;
    end process makeMux;
end behavioral;

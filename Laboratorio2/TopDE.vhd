library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;
use work.riscv_pkg.all;

entity TopDE is
    port (
        CLOCK, reset:	in  std_logic;
        regin:				in  std_logic_vector(4 downto 0);
		  ClockDIV:		out std_logic;
        PC, instr, regout:			out std_logic_vector(31 downto 0);
        state:    		out std_logic_vector(3 downto 0)
    );
end entity TopDE;

architecture behavioral of TopDE is
    signal ClockDIV_i:  std_logic := '1';
begin
    -- Clock divider process
    process(CLOCK)
    begin
        if rising_edge(CLOCK) then
            ClockDIV_i <= not ClockDIV_i;
        end if;
    end process;
    
    ClockDIV <= ClockDIV_i;
    
    -- Instantiation of Uniciclo
    UNI1 : Uniciclo
        port map (
            clockCPU => ClockDIV_i,
            clockMem => CLOCK,
            reset    => reset,
            PC       => PC,
            instr    => instr,
            regin    => regin,
            regout   => regout
        );
    
	     -- Instantiation of Multiciclo
--    MULT1 : Multiciclo
--        port map (
--            clockCPU => ClockDIV_i,
--            clockMem => CLOCK,
--            reset    => reset,
--            PC       => PC,
--            instr    => instr,
--            regin    => regin,
--            regout   => regout,
--				state	=> state
--        );
		  
		 
--		PIP1 : Pipeline
--		   port map (
--            clockCPU => ClockDIV_i,
--            clockMem => CLOCK,
--            reset    => reset,
--            PC       => PC,
--            instr    => instr,
--            regin    => regin,
--            regout   => regout
--        );
	 
end behavioral;
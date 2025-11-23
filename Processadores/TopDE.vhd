library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;
use work.riscv_pkg.all;

entity TopDE is
    port (
        CLOCK, reset: in  std_logic;
        regin:		  in  std_logic_vector(4 downto 0);
		ClockDIV:	  out std_logic;
        PC:			  out std_logic_vector(31 downto 0);
        instr:		  out std_logic_vector(31 downto 0);
        regout:		  out std_logic_vector(31 downto 0);
        state:    	  out std_logic_vector(3 downto 0)
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
    
    -- Instantiation of Uniciclo (explicit entity instantiation)
    --UNI1: entity work.uniciclo
    --    port map (
    --        clockCPU => ClockDIV_i,
    --        clockMem => CLOCK,
    --        reset    => reset,
    --        regin    => regin,
    --        PC       => PC,
    --        instr    => instr,
    --        regout   => regout
    --    );
    
    -- Instantiation of Multiciclo (explicit entity instantiation)
    MULT1: entity work.multiciclo
        port map (
            clockCPU => ClockDIV_i,
            clockMem => CLOCK,
            reset    => reset,
            regin    => regin,
            PC       => PC,
            instr    => instr,
            regout   => regout,
			state	 => state
        );
		  
		 
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
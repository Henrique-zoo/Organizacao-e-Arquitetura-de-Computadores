library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.riscv_pkg.all;

entity alu_control is
    port (
        ALUOp:      in  std_logic_vector(1 downto 0);
        funct10:    in  std_logic_vector(9 downto 0);
        ALUCtrl:    out std_logic_vector(3 downto 0)
    );
end entity alu_control;

architecture behavioral of alu_control is
begin
    out_logic: process(all)
    begin
        case ALUOp is
            when "00"   =>
                ALUCtrl   <=  OPADD;
            when "01"   =>
                ALUCtrl   <=  OPSUB;
            when others =>
                case funct10 is
                    when FUNCT10_ADD    =>
                        ALUCtrl   <=  OPADD;
                    when FUNCT10_SUB    =>
                        ALUCtrl   <=  OPSUB;
                    when FUNCT10_AND    =>
                        ALUCtrl   <=  OPAND;
                    when FUNCT10_OR     =>
                        ALUCtrl   <=  OPOR;
                    when FUNCT10_SLT    =>
                        ALUCtrl   <=  OPSLT;
                    when others =>
                        ALUCtrl   <=  OPNULL;
                end case;
        end case;
    end process out_logic;
end architecture behavioral;
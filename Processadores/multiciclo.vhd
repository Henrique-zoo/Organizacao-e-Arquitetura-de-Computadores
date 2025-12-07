library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.riscv_pkg.all;

entity Multiciclo is
    port (
        clockCPU:   in  std_logic;
        clockMem:   in  std_logic;
        reset:      in  std_logic;
        regin:      in  std_logic_vector(4 downto 0);
        PC:         out std_logic_vector(31 downto 0);
        instr:      out std_logic_vector(31 downto 0);
        regout:     out std_logic_vector(31 downto 0);
        state:      out std_logic_vector(3 downto 0)
    );
end Multiciclo;

architecture structural of Multiciclo is
    -- Sinais internos
    signal wIorD:             std_logic_vector(31 downto 0);
    signal PCout:             std_logic_vector(31 downto 0);
    signal PCback_out:        std_logic_vector(31 downto 0);
    signal instr_i:           std_logic_vector(31 downto 0) := (others => '0');
    signal regout_i:          std_logic_vector(31 downto 0) := (others => '0');
    signal state_i:           std_logic_vector(3 downto 0);
    signal next_state:        std_logic_vector(3 downto 0);
    signal data_register_out: std_logic_vector(31 downto 0);
    signal Register_A_out:    std_logic_vector(31 downto 0);
    signal Register_B_out:    std_logic_vector(31 downto 0);
    signal Reg_ALUout:        std_logic_vector(31 downto 0);
    signal ALUout:            std_logic_vector(31 downto 0);
    signal memory_out:        std_logic_vector(31 downto 0);
    signal mux2x1_1_out:      std_logic_vector(31 downto 0);
    signal mux2x1_2_out:      std_logic_vector(31 downto 0);
    signal mux4x1_1_out:      std_logic_vector(31 downto 0);
    signal mux4x1_2_out:      std_logic_vector(31 downto 0);
    signal mux4x1_3_out:      std_logic_vector(31 downto 0);
    signal immediate:         std_logic_vector(31 downto 0);
    signal RegA, RegB:        std_logic_vector(31 downto 0);
    -- sinais de controle
    signal ALUop:             std_logic_vector(1 downto 0);
    signal ALUsrcA:           std_logic_vector(1 downto 0);
    signal ALUsrcB:           std_logic_vector(1 downto 0);
    signal mem2reg:           std_logic_vector(1 downto 0);
    signal IRWrite:           std_logic;
    signal IorD:              std_logic;
    signal memRead:           std_logic;
    signal memWrite:          std_logic;
    signal PCWrite:           std_logic;
    signal PCWriteCond:       std_logic;
    signal PCbackWrite:       std_logic;
    signal PCsrc:             std_logic;
    signal regWrite:          std_logic;

    -- ALU control / status
    signal alu_ctrl:          std_logic_vector(3 downto 0);
    signal zeroALU:           std_logic;
    signal PCwriteFinal:      std_logic;

    alias opcode:             std_logic_vector(6 downto 0) is instr_i(6 downto 0);
    alias funct7:             std_logic_vector(6 downto 0) is instr_i(31 downto 25);
    alias funct3:             std_logic_vector(2 downto 0) is instr_i(14 downto 12);
begin
    -- Atribuição das saídas
    PC      <= PCout;
    instr   <= instr_i;
    regout  <= regout_i;
    state  <= state_i;

    PC_Register: entity work.Register32
        generic map ( reset_val => x"0040_0000" )
        port map (
            clock       => clockCPU,
            reset       => reset,
            writeEnable => PCwriteFinal,
            data        => mux2x1_2_out,
            regOut      => PCout
        );
    
    Mux2x1_1: entity work.Mux2x1
        port map (
            A => PCout,
            B => Reg_ALUout,
            S => IorD,
            C => mux2x1_1_out
        );
    
    Memory: entity work.unifiedMemory
        port map (
            clock       => clockMem,
            memWrite    => memWrite,
            memRead     => memRead,
            address     => mux2x1_1_out,
            data        => Register_B_out,
            instrOrData => memory_out
        );
    
    Instruction_Register: entity work.Register32
        generic map ( reset_val => x"0000_0000" )
        port map (
            clock       => clockCPU,
            reset       => reset,
            writeEnable => IRWrite,
            data        => memory_out,
            regOut      => instr_i
        );

    Data_Register: entity work.Register32
        generic map ( reset_val => x"0000_0000" )
        port map (
            clock       => clockCPU,
            reset       => reset,
            writeEnable => '1',
            data        => memory_out,
            regOut      => data_register_out
        );

    Register_Bank: entity work.Registers
        port map (
            clock    	=> clockCPU,
            reset    	=> reset,
            write_en		=> regWrite,
            RS1			=> instr_i(19 downto 15),
            RS2			=> instr_i(24 downto 20),
            RD				=> instr_i(11 downto 7),
				disp_select => regin,
            data			=> mux4x1_1_out,
            read_data_A => RegA,
            read_data_B => RegB,
            read_disp	=> regout_i
        );
    
    Mux4x1_1: entity work.Mux4x1
        port map (
            A => Reg_ALUout,
            B => PCout,
            C => data_register_out,
            D => immediate,
            S => mem2reg,
            Y => mux4x1_1_out
        );

    Immediate_Generator: entity work.ImmGen
        port map (
            instr => instr_i,
            imm32 => immediate
        );

    PCback: entity work.Register32
        generic map ( reset_val => x"0040_0000" )
        port map (
            clock       => clockCPU,
            reset       => reset,
            writeEnable => PCbackWrite,
            data        => PCout,
            regOut      => PCback_out
        );

    Register_A: entity work.Register32
        generic map ( reset_val => x"0000_0000" )
        port map (
            clock       => clockCPU,
            reset       => reset,
            writeEnable => '1',
            data        => RegA,
            regOut      => Register_A_out
        );
    
    Register_B: entity work.Register32
        generic map ( reset_val => x"0000_0000" )
        port map (
            clock       => clockCPU,
            reset       => reset,
            writeEnable => '1',
            data        => RegB,
            regOut      => Register_B_out
        );

    Mux4x1_2: entity work.Mux4x1
        port map (
            A => PCback_out,
            B => Register_A_out,
            C => PCout,
            D => (others => '0'),
            S => ALUsrcA,
            Y => mux4x1_2_out
        );

    Mux4x1_3: entity work.Mux4x1
        port map (
            A => Register_B_out,
            B => x"0000_0004",
            C => immediate,
            D => (others => '0'),
            S => ALUsrcB,
            Y => mux4x1_3_out
        );

    ALU: entity work.ALU
        port map (
            iControl => alu_ctrl,
            iA       => mux4x1_2_out,
            iB       => mux4x1_3_out,
            oResult  => ALUout,
            zero     => zeroALU
        );

    ALUout_Register: entity work.Register32
        generic map ( reset_val => x"0000_0000" )
        port map (
            clock       => clockCPU,
            reset       => reset,
            writeEnable => '1',
            data        => ALUout,
            regOut      => Reg_ALUout
        );

    Mux2x1_2: entity work.Mux2x1
        port map (
            A => ALUout,
            B => Reg_ALUout,
            S => PCsrc,
            C => mux2x1_2_out
        );

    Control: entity work.Control
        port map (
            clock       => clockCPU,
            reset       => reset,
            opcode      => opcode,
            ALUOp       => ALUop,
            ALUsrcA     => ALUsrcA,
            ALUsrcB     => ALUsrcB,
            IRWrite     => IRWrite,
            IorD        => IorD,
            mem2Reg     => mem2Reg,
            memRead     => memRead,
            memWrite    => memWrite,
            PCWrite     => PCWrite,
            PCWriteCond => PCWriteCond,
            PCbackWrite => PCbackWrite,
            PCsrc       => PCsrc,
            regWrite    => regWrite,
            state       => state_i
        );

    alu_ctrl_inst: entity work.alu_control
        port map (
            ALUOp   => ALUop,
            funct10 => funct7 & funct3,
            ALUCtrl => alu_ctrl
        );

    PCwriteFinal <= PCWrite or (PCWriteCond and zeroALU);

end architecture structural;
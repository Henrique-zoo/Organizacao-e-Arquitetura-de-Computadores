library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.riscv_pkg.all;

entity Pipeline is
    port (
        clockCPU:   in  std_logic;
        clockMem:   in  std_logic;
        reset:      in  std_logic;
        PC:         out std_logic_vector(31 downto 0);
        instr:      out std_logic_vector(31 downto 0);
        regin:      in  std_logic_vector(4 downto 0);
        regout:     out std_logic_vector(31 downto 0)
    );
end Pipeline;

architecture Behavioral of Pipeline is
    -- Sinais do estágio IF
    signal PC_IF:           std_logic_vector(31 downto 0);
    signal instr_IF:        std_logic_vector(31 downto 0);
    signal PC_4:            std_logic_vector(31 downto 0);
    signal mux2x1_1_out:    std_logic_vector(31 downto 0);
    
    -- Sinais do estágio ID
    signal PC_ID:           std_logic_vector(31 downto 0);
    signal instr_ID:        std_logic_vector(31 downto 0);
    signal imm_ID:          std_logic_vector(31 downto 0);
    signal regA_ID:         std_logic_vector(31 downto 0);
    signal regB_ID:         std_logic_vector(31 downto 0);
    signal PC_jump:         std_logic_vector(31 downto 0);
    signal mem2Reg_ID:      std_logic;
    signal memRead_ID:      std_logic;
    signal branch_ID:       std_logic;
    signal jump_ID:         std_logic;
    signal ALUop_ID:        std_logic_vector(1 downto 0);
    signal memWrite_ID:     std_logic;
    signal ALUSrc_ID:       std_logic;
    signal regWrite_ID:     std_logic;
    signal equal:           std_logic;
    signal PC_select:       std_logic;
    
    -- Sinais do estágio EX
    signal WB_EX:           std_logic_vector(1 downto 0);
    signal M_EX:            std_logic_vector(1 downto 0);
    signal ALUsrc_EX:       std_logic;
    signal ALUop_EX:        std_logic_vector(1 downto 0);
    signal regA_EX:         std_logic_vector(31 downto 0);
    signal regB_EX:         std_logic_vector(31 downto 0);
    signal imm_EX:          std_logic_vector(31 downto 0);
    signal funct_EX:        std_logic_vector(9 downto 0);
    signal RD_EX:           std_logic_vector(4 downto 0);
    signal ALU_in_2:        std_logic_vector(31 downto 0);
    signal alu_ctrl:        std_logic_vector(3 downto 0);
    signal ALUout_EX:       std_logic_vector(31 downto 0);
    
    -- Sinais do estágio MEM
    signal WB_MEM:          std_logic_vector(1 downto 0);
    signal memRead_MEM:     std_logic;
    signal memWrite_MEM:    std_logic;
    signal ALUOut_MEM:      std_logic_vector(31 downto 0);
    signal RegB_MEM:        std_logic_vector(31 downto 0);
    signal RD_MEM:          std_logic_vector(4 downto 0);
    signal memOut_MEM:      std_logic_vector(31 downto 0);
    
    -- Sinais do estágio WB
    signal regWrite_WB:     std_logic;
    signal mem2Reg_WB:      std_logic;
    signal RD_WB:           std_logic_vector(4 downto 0);
    signal ALUOut_WB:       std_logic_vector(31 downto 0);
    signal memOUt_WB:       std_logic_vector(31 downto 0);
    signal WriteBackData:   std_logic_vector(31 downto 0);
begin
	
	 PC <= PC_ID;
	 instr <= instr_ID;
    PC_select <= (equal and branch_ID) or jump_ID;

    Mux2x1_1: entity work.Mux2x1
        port map (
            A => PC_4,
            B => PC_jump,
            S => PC_select,
            C => mux2x1_1_out
        );

    PC_Register: entity work.Register32
        generic map ( reset_val => x"0040_0000" )
        port map (
            clock       => clockCPU,
            reset       => reset,
            writeEnable => '1',
            data        => mux2x1_1_out,
            regOut      => PC_IF
        );
    
    MemI_inst: entity work.ramI
        port map (
            address => PC_IF(11 downto 2),
            clock   => clockMem,
            data    => (others => '0'),
            wren    => '0',
            q       => instr_IF
        );

    adder_pc4_inst: entity work.adder
        port map (
            subt => '0',
            A    => PC_IF,
            B    => x"00000004",
            S    => PC_4
        );

    IF_ID_inst: entity work.IF_ID
        port map (
            clk         => clockCPU,
            rst         => reset,
            PC_in       => PC_IF,
            instr_in    => instr_IF,
            PC_out      => PC_ID,
            instr_out   => instr_ID
        );

    gen_imm: entity work.ImmGen
        port map (
            instr => instr_ID,
            imm32 => imm_ID
        );

    ctrl_unit: entity work.general_control
        port map (
            opcode   =>  instr_ID(6 downto 0),
            mem2Reg  =>  mem2Reg_ID,
            memRead  =>  memRead_ID,
            branch   =>  branch_ID,
            jump     =>  jump_ID,
            ALUOp    =>  ALUop_ID,
            memWrite =>  memWrite_ID,
            ALUSrc   =>  ALUSrc_ID,
            regWrite =>  regWrite_ID
        );

    adder_jump_inst: entity work.adder
        port map (
            subt => '0',
            A    => PC_ID,
            B    => imm_ID,
            S    => PC_jump
        );

    reg_bank: entity work.Registers
        port map (
			clock    	=> clockCPU,
            reset    	=> reset,
            write_en	=> regWrite_WB,
            RS1			=> instr_ID(19 downto 15),
            RS2			=> instr_ID(24 downto 20),
            RD			=> RD_WB,
			disp_select => regin,
            data		=> WriteBackData,
            read_data_A => regA_ID,
            read_data_B => regB_ID,
            read_disp	=> regout
        );

    comp_inst: entity work.Comparator
        port map (
            A   		=> regA_ID,
            B   		=> regB_ID,
            equal   	=> equal
        );

    ID_EX_inst: entity work.ID_EX
        port map (
            clk         => clockCPU,
            rst         => reset,
            regWrite    => regWrite_ID,
            mem2Reg     => mem2Reg_ID,
            memRead     => memRead_ID,
            memWrite    => memWrite_ID,
            ALUsrc_in   => ALUSrc_ID,
            ALUop_in    => ALUop_ID,
            regA_in     => regA_ID,
            regB_in     => regB_ID,
            imm_in      => imm_ID,
            funct_in    => instr_ID(31 downto 25) & instr_ID(14 downto 12),
            RD_in       => instr_ID(11 downto 7),
            WB          => WB_EX,
            M           => M_EX,
            ALUsrc_out  => ALUsrc_EX,
            ALUop_out   => ALUop_EX,
            regA_out    => regA_EX,
            regB_out    => regB_EX,
            imm_out     => imm_EX,
            funct_out   => funct_EX,
            RD_out      => RD_EX
        );

    Mux2x1_2: entity work.Mux2x1
        port map (
            A => regB_EX,
            B => imm_EX,
            S => ALUsrc_EX,
            C => ALU_in_2
        );

    alu_ctrl_inst: entity work.alu_control
        port map (
            ALUOp   => ALUop_EX,
            funct10 => funct_EX,
            ALUCtrl => alu_ctrl
        );
    
    -- Instanciação da ULA
    alu_inst: entity work.ALU
        port map (
            iControl => alu_ctrl,
            iA       => regA_EX,
            iB       => ALU_in_2,
            oResult  => ALUout_EX,
            zero     => open
        );

    EX_MEM_inst: entity work.EX_MEM
        port map (
            clk         => clockCPU,
            rst         => reset,
            WB_in       => WB_EX,
            M           => M_EX,
            ALUOut_in   => ALUout_EX,
            regB_in     => regB_EX,
            RD_in       => RD_EX,
            WB_out      => WB_MEM,
            memRead     => memRead_MEM,
            memWrite    => memWrite_MEM,
            ALUOut_out  => ALUOut_MEM,
            regB_out    => RegB_MEM,
            RD_out      => RD_MEM
        );

    -- Instanciação da memória de dados
    MemD_inst: entity work.ramD
        port map (
            address => ALUOut_MEM(11 downto 2),
            clock   => clockMem,
            data    => RegB_MEM,
            wren    => memWrite_MEM,
            -- Não tem memRead
            q       => memOut_MEM
        );

    MEM_WB_inst: entity work.MEM_WB
        port map (
            clk         => clockCPU,
            rst         => reset,
            WB          => WB_MEM,
            RD_in       => RD_MEM, 
            ALUOut_in   => ALUOut_MEM,
            memOut_in   => memOut_MEM,
            regWrite    => regWrite_WB,
            mem2Reg     => mem2Reg_WB,
            RD_out      => RD_WB,
            ALUOut_out  => ALUOut_WB,
            memOut_out  => memOUt_WB
        );

    Mux2x1_3: entity work.Mux2x1
        port map (
            A => ALUOut_WB,
            B => memOUt_WB,
            S => mem2Reg_WB,
            C => WriteBackData
        );
    
end Behavioral;
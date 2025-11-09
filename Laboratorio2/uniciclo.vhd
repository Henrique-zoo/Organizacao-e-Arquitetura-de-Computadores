library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.riscv_pkg.all;

entity uniciclo is
    port (
        clockCPU, clockMem, reset:  in  std_logic;
        regin:                      in  std_logic_vector(4 downto 0);
        PC, instr, regout:          out std_logic_vector(31 downto 0)
    );
end uniciclo;

architecture structural of uniciclo is
	-- Sinais internos
	signal  	PC_i:       	std_logic_vector(31 downto 0) := x"00400000";
	signal  	instr_i:    	std_logic_vector(31 downto 0) := (others => '0');
	signal  	regout_i:   	std_logic_vector(31 downto 0) := (others => '0');
	signal  	ALUOut, MemData, RegA, RegB, imm_i, RegB_ALU, WriteBackData, PC_plus4, PC_plusImm, PC_next:	std_logic_vector(31 downto 0);
	signal  	mem2Reg, memRead, branch, jump, memWrite, ALUSrc, regWrite, zeroALU:        std_logic;
	signal  	ALUOp:      	std_logic_vector(1 downto 0);
	signal 	    alu_ctrl:  		std_logic_vector(3 downto 0);
	signal      iRS1:			std_logic_vector(4 downto 0);
	alias   	opcode:     	std_logic_vector(6 downto 0) is instr_i(6 downto 0);
begin
    PC      <= PC_i;
    instr   <= instr_i;
    regout  <= regout_i;

    iRS1    <=  "00000" when opcode = OPC_LUI else instr_i(19 downto 15);
    
    -- Instanciação da memória de instruções
    MemI_inst: ramI
        port map (
            address => PC_i(11 downto 2),
            clock   => clockMem,
            data    => (others => '0'),
            wren    => '0',
            q       => instr_i
        );
    
    -- Instanciação da memória de dados
    MemD_inst: ramD
        port map (
            address => ALUOut(11 downto 2),
            clock   => clockMem,
            data    => RegB,
            wren    => memWrite,
            q       => MemData
        );
    
    -- Geração do imediato
    gen_imm: entity work.gen_imm(behavioral)
        port map (
            instr => instr_i,
            imm32 => imm_i
        );

    -- Banco de registradores
    reg_bank: entity work.xreg(rtl)
        port map (
            iCLK    => clockCPU,
            iRST    => reset,
            iWREN   => regWrite,
            iRS1    => iRS1,
            iRS2    => instr_i(24 downto 20),
            iRD     => instr_i(11 downto 7),
            iDATA   => WriteBackData,
            oREGA   => RegA,
            oREGB   => RegB,
            iDISP   => regin,
            oREGD   => regout_i
        );

    -- Unidade de controle principal (decodificação de opcode)
    ctrl_unit: entity work.general_control(behavioral)
        port map (
            opcode   =>  opcode,
            mem2Reg  =>  mem2Reg,
            memRead  =>  memRead,
            branch   =>  branch,
            jump     =>  jump,
            ALUOp    =>  ALUOp,
            memWrite =>  memWrite,
            ALUSrc   =>  ALUSrc,
            regWrite =>  regWrite
        );

    -- Unidade de controle da ULA (gera código de operação para a ALU)
    alu_ctrl_inst: entity work.alu_control(behavioral)
        port map (
            ALUOp   => ALUOp,
            funct10 => instr_i(31 downto 25) & instr_i(14 downto 12),
            ALUCtrl => alu_ctrl
        );

    -- Seleção da segunda entrada da ULA (RegB ou imediato)
    mux_alusrc: entity work.Mux2x1(behavioral)
        port map (
            A => RegB,
            B => imm_i,
            S => ALUSrc,
            C => RegB_ALU
        );

    -- Instanciação da ULA
    alu_inst: entity work.ALU(rtl)
        port map (
            iControl => alu_ctrl,
            iA       => RegA,
            iB       => RegB_ALU,
            oResult  => ALUOut,
            zero     => zeroALU
        );

    -- Mux de escrita no banco (resultado da ALU ou dado da memória)
    mux_mem2reg_inst: entity work.Mux2x1(behavioral)
        port map (
            A   =>  ALUOut,
            B   =>  MemData,
            S   =>  mem2Reg,
            C   =>  WriteBackData
        );

    -- Adder para PC+4
    adder_pc4_inst: entity work.adder(behavioral)
        port map (
            subt => '0',
            A    => PC_i,
            B    => x"00000004",
            S    => PC_plus4
        );

    -- Adder para PC + immediate (branch target)
    adder_pcimm_inst: entity work.adder(behavioral)
        port map (
            subt => '0',
            A    => PC_i,
            B    => imm_i,
            S    => PC_plusImm
        );

    -- Seleção do próximo PC (PC+4 ou PC+imm)
    mux_pc_inst: entity work.Mux2x1(behavioral)
        port map (
            A => PC_plus4,
            B => PC_plusImm,
            S => (branch and zeroALU) or jump,
            C => PC_next
        );

    process(clockCPU, reset)
    begin
        if reset = '1' then
            PC_i <= x"00400000";
        elsif rising_edge(clockCPU) then
            PC_i <= PC_next;
        end if;
    end process;
end architecture structural;
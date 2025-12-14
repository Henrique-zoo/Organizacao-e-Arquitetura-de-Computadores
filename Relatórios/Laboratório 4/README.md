# Laboratório 4 - CPU RISC-V PIPELINE

## Objetivos

- Treinar o aluno com a Linguagem de Descrição de Hardware (HDL) Verilog;
- Familiarizar o aluno com o software de síntese **QUARTUS Prime**;
- Desenvolver a capacidade de análise e síntese de sistemas digitais usando uma HDL;
- Implementar uma CPU **Pipeline** compatível com a ISA **RV32I reduzida**.

---

## <small>(10.0)</small> **1.** Implementação do Processador Pipeline

Implemente o processador **Pipeline** com ISA reduzida com as instruções: **add**, **sub**, **and**, **or**, **slt**, **lw**, **sw**, **beq**, **jal**, e ainda as instruções **jalr**, **addi** e **lui**.

<img src="assets/Pipeline.png" alt="Processador Pipeline">

Os blocos de **Memória**, **Bloco de Controle**, **Banco de Registradores**, **Gerador de Imediatos**, **ULA** e **Controlador da ULA** são os mesmos do processador **Uniciclo**.

> **Dica:** Use `ClockCPU = ClockMem / 2`

---

### <small>(1.0)</small> **1.1.** Registradores de Pipeline

Ao caminho de dados do seu processador **Uniciclo**, acrescente os **registradores de pipeline**.

---

### <small>(5.0)</small> **1.2.** Implementação do Processador Pipeline Completo

Implemente o **Processador Pipeline completo** com os registradores de pipeline.

#### <small>(1.0)</small> **(a)** Visualize o netlist RTL view.

#### <small>(1.0)</small> **(b)** Levante os requisitos físicos e temporais do seu processador.

#### <small>(1.5)</small> **(c)** Faça a simulação por forma de onda funcional e temporal com o programa `de1.s`, corrigindo todos os *hazards* no programa apenas com a inserção de bolhas (`nop`), mostrando o funcionamento correto da CPU.

#### <small>(1.5)</small> **(d)** Qual a máxima frequência de clock utilizável na sua CPU? Verifique experimentalmente mudando a frequência **CLOCK** e apresentando a simulação temporal por forma de onda.

---

### <small>(2.0)</small> **1.3.** Comparação entre Arquiteturas

Compare os **requerimentos físicos e temporais** dos seus **três processadores**:

- Uniciclo  
- Multiciclo  
- Pipeline  

**Comente os resultados.**

---

### <small>(2.0)</small> **1.4.** Tempo de Execução do Programa

Qual o **melhor tempo** que cada processador executa o programa `de1.s`? Qual a **explicação** para os resultados obtidos?
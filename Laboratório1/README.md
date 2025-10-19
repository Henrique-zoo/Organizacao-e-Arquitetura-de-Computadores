# Laboratório 1 – Organização e Arquitetura de Computadores (CIC0099)

## Informações Gerais

**Disciplina:** CIC0099 – Organização e Arquitetura de Computadores – Unificado 2025/2  
**Equipes:** até 5 pessoas  

---

## Laboratório 1 – Assembly RISC-V

### Objetivos

- Familiarizar-se com o simulador/montador **RARS**.  
- Desenvolver a capacidade de **codificação de algoritmos** em Assembly.  
- Desenvolver a capacidade de **análise de desempenho** de algoritmos.  
- Compreender a **compilação de código C para Assembly RISC-V RV32IMF**.

---

### 1. Simulador/Montador RARS (2,5 pontos)

Baixe e extraia o arquivo **Lab1.zip** disponível no Moodle.

#### 1.1 Execução do programa `sort.s` (0 pt)

No diretório `Arquivos`, abra **Rars16_Custom1** e carregue o programa `sort.s`.

Dado o vetor:  
$V[30]=\{9,2,5,1,8,2,4,3,6,7,10,2,32,54,2,12,6,3,1,78,54,23,1,54,2,65,3,6,55,31\}$

a) Ordene o vetor em **ordem crescente**, conte o número de **instruções por tipo** e o **total** executado.  
Determine também o **tamanho do código executável** e o **uso de memória de dados**.

b) Modifique o programa para **ordem decrescente** e repita as medições.  

c) Usando os **contadores CSR** (vide final do documento), meça o **número de instruções** e o **tempo de execução**.

#### 1.2 Análise de desempenho teórica (2,5 pts)

Considere um processador RISC-V de **50 MHz** com **CPI = 1**.

Para os vetores:
- $V_0[n] = \{1,2,3,4,...,n\}$ (ordenado)
- $V_1[n] = \{n,n-1,n-2,...,1\}$ (inversamente ordenado)

a) Escreva as equações do tempo de execução $t_0[n]$ e $t_1[n]$ em função de $n$.  
b) Para $n=\{10,20,...,100\}$, plote $t_0[n]$ e $t_1[n]$ em um gráfico e **comente os resultados**.

---

### 2. Compilador Cruzado GCC (2,5 pontos)

Um **compilador cruzado** permite compilar para uma arquitetura diferente da máquina usada.

Exemplos:
```bash
riscv64-unknown-elf-gcc -S -march=rv32imf -mabi=ilp32f  # RISC-V RV32IMF
arm-eabi-gcc -S -march=armv7                            # ARMv7
gcc -S -m32                                              # x86
```

> 💡 O site [Compiler Explorer](https://godbolt.org/) disponibiliza compiladores C online para diversas arquiteturas.

#### 2.1 Teste inicial (0 pts)

Compile programas triviais em C usando as diretivas `-O0` e `-O3` para observar o uso de registradores e memória.

#### 2.2 Compilação do `sortc.c` (0,5 pts)

Compile com `-O0` e obtenha `sortc.s`.  
Indique as modificações necessárias para execução no RARS.  
>Dica: utilize a função `show` de `sort.s` para evitar implementar `printf`.

#### 2.3 Comparativo de desempenho (1,0 pt)

Monte uma tabela comparando:
- Número total de instruções executadas  
- Tamanho do código em bytes  
para `-O0`, `-O3`, `-Os` e para o programa `sort.s` original.  
Analise os resultados.

#### 2.4 Pesquisa (1,0 pt)

Explique as diferenças entre as otimizações `-O0`, `-O1`, `-O2`, `-O3` e `-Os`.

---

### 3. Transformada Discreta de Fourier (DFT) (5,0 pontos)

A DFT converte sinais do domínio do tempo para o domínio da frequência:

$$
X[k] = \sum_{n=0}^{N-1} x[n]  e^{-i\frac{2π·k·n}{N}}
$$

onde $i = \sqrt{-1}$ e $N$ é o número de amostras.

#### 3.1 Função trigonométrica (0,5 pt)

Implemente um procedimento que receba um ângulo `θ` (em `fa0`) e retorne `cos(θ)` (`fa0`) e `sin(θ)` (`fa1`).  
Use **séries de Taylor** para aproximação.

#### 3.2 Função DFT (1,0 pt)
Escreva um procedimento em Assembly RISC-V com a seguinte definição 
```c
void DFT(float *x, float *X_real, float *X_imag, int N);
```
que dado o endereço do vetor $x[n]$ de floats (em `a0`) de tamanho $N$ na memória, os endereços dos espaços 
reservados para o vetor complexo $X[k]$ (parte real e parte imaginária) (em `a1` e `a2`) e o número de pontos $N$ (em `a3`), calcule a DFT de $N$ pontos de $x[n]$ e coloque o resultado no espaço alocado para $X_{real}[k]$ e $X_{imag}[k]$.

#### 3.3 Programa Principal (0,5 pt)

Escreva um programa `main` que defina no `.data` o vetor $x[n]$, o espaço para o vetor $X[K]$, o valor de $N$, e chame o procedimento DFT.   
```assembly
.data 
N: .word 8  
x: .float 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0 
X_real: .float 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 
X_imag: .float 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 
.text 
...
jal DFT 
... 
```
Em seguida, apresente no console a saída dos $N$ pontos no formato:
```
x[n]	X[k] 
1.0		8.0+0.0i      
1.0		0.0+0.0i 
1.0		0.0+0.0i 
1.0		0.0+0.0i 
1.0		0.0+0.0i 
1.0		0.0+0.0i 
1.0		0.0+0.0i 
1.0		0.0+0.0i 
```

#### 3.4 Calcule a DFT dos seguintes vetores $x[n]$, com $N=8$ (1.0 pt)
```assembly
x1: .float 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 
x2: .float 1.0, 0.7071, 0.0, -0.7071, -1.0, -0.7071, 0.0, 0.7071 
x3: .float 0.0, 0.7071. 1.0,  0.7071, 0.0, -0.7071, -1.0, -0.7071 
x4: .float 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0
```

#### 3.5 Para os sinais $x[n]$ abaixo  
a) $N=8$, $x[n]=\{1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0\}$

b) $N=12$, $x[n]=\{1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0 , ..., 0.0\}$

c) $N=16$, $x[n]=\{1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0 , ..., 0.0\}$

d) $N=20$, $x[n]=\{1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0 , ..., 0.0\}$ 

e) $N=24$, $x[n]=\{1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0 , ..., 0.0\}$ 

f) $N=28$, $x[n]=\{1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0 , ..., 0.0\}$ 

g) $N=32$, $x[n]=\{1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0 , ..., 0.0\}$ 

h) $N=36$, $x[n]=\{1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0 , ..., 0.0\}$ 

i) $N=40$, $x[n]=\{1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0 , ..., 0.0\}$ 

j) $N=44$, $x[n]=\{1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0 , ..., 0.0\}$


- (1,0) 3.5.1) Para cada item: Meça o tempo de execução do procedimento DFT e calcule a frequência do 
processador RISC-V Uniciclo simulado pelo Rars.

- (1,0) 3.5.2) Faça um gráfico em escala de N  texec 
Que conclusões podemos tirar desta análise?

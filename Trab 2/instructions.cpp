/**
* UNIVERSIDADE DE BRASÍLIA
* ORGANIZAÇÃO E ARQUITETURA DE COMPUTADORES 
* TURMA C - 2021/2
*
* Trabalho 2: Simulador RISCV 
*
* INSTRUÇÕES
*
* Aluno: João Pedro de Oliveira Silva
* Matrícula: 19/0057807
**/
#include "memoria.c"

#include "globals.h"

/**
x[rd] = x[rs1] + x[rs2]

 Add. R-type, RV32I and RV64I.
Adiciona o registrador x[rs2] ao registrador x[rs1] e grava o resultado em x[rd]. O overflow
aritmético é ignorado.
Formas comprimidas: c.add rd, rs2; c.mv rd, rs2
* @return A soma feita.
 */
int32_t rADD(int rd, int rs1, int rs2) {
  int32_t resultado = breg[rs1] + breg[rs2];
  breg[rd] = resultado;
  return resultado;
}

/**
 rd, rs1, immediate x[rd] = x[rs1] + sext(immediate)
Add Immediate. I-type, RV32I and RV64I.
Adiciona o valor imediato de sinal estendido ao registrador x[rs1] e escreve o resultado em
x[rd]. O overflow aritmético é ignorado.
 @return A soma feita.
*/
int32_t iADDI(int rd, int rs1, int32_t immediate) {
  int32_t resultado = breg[rs1] + immediate;
  breg[rd] = resultado;
  return resultado;
}

/**
Função AND do tipo R. Faz um and bit a bit.
 rd, rs1, rs2 x[rd] = x[rs1] & x[rs2]
AND. R-type, RV32I and RV64I.
Calcula o AND bitwise dos registradores x[rs1] e x[rs2] e escreve o resultado em x[rd].
 * @return A comparação feita.
 */
int32_t rAND(int rd, int rs1, int rs2) {
  int32_t resultado = breg[rs1] & breg[rs2];
  breg[rd] = resultado;
  return resultado;
}

/**
 Função AND do tipo I. Faz um and bit a bit.
 AND Immediate. I-type, RV32I and RV64I.
Calcula o AND bitwise do valor imediato com sinal estendido e do registrador x[rs1] e 
escreve o resultado em x[rd].

 * @return A comparação feita.
 */
int32_t iANDI(int rd, int rs1, int32_t immediate) {
  int32_t resultado = breg[rs1] & immediate;
  breg[rd] = resultado;
  return resultado;
}

/**
 Função AUIPC do tipo U. Soma PC com o imediato.
 rd, immediate x[rd] = pc + sext(immediate[31:12] << 12)
Add Upper Immediate to PC. U-type, RV32I and RV64I.
Adiciona o valor imediato com sinal estendido de 20 bits, deslocada para a esquerda por 12
 */
uint32_t uAUIPC(int rd, uint32_t immediate) {
  uint32_t resultado = pc + (immediate << 12);
  breg[rd] = resultado;
  return resultado;
}

/**
 rs1, rs2, offset if (rs1 == rs2) pc += sext(offset)
Branch if Equal. B-type, RV32I and RV64I.
Se o registrador x[rs1] for igual ao registrador x[rs2],
 "seta" o pc para o pc atual mais o offset
com sinal estendido.
 * @param label Comando para o qual o endereço será redirecionado.
 */
void sbBEQ(int rs1, int rs2, int label) {
  if (breg[rs1] == breg[rs2]) {
    pc += label;
    has_jumped = true;
  }
}

/**
 * Função BNE do tipo SB. Pula para endereço se os registradores a serem
 rs1, rs2, offset if (rs1 6= rs2) pc += sext(offset)
Branch if Not Equal. B-type, RV32I and RV64I.
Se o registrador x[rs1] não é igual ao registrador x[rs2], 
"seta" o pc para o pc atual mais o
offset com sinal estendido.
 * @param label Comando para o qual o endereço será redirecionado.
 */
void sbBNE(int rs1, int rs2, int label) {
  if (breg[rs1] != breg[rs2]) {
    pc += label;
    has_jumped = true;
  }
}

/**
 * Função BGE do tipo SB. Pula para endereço se o primeiro registrador é maior
 * ou igual ao segundo.
rs1, rs2, offset if (rs1 ≥s rs2) pc += sext(offset)
Branch if Greater Than or Equal. B-type, RV32I and RV64I.
Se o registrador x[rs1] é pelo menos igual a x[rs2], tratando os valores como números em
complemento de dois, "seta" o pc para o pc atual mais o offset com sinal estendido.

 * @param label Comando para o qual o endereço será redirecionado.
 */
void sbBGE(int rs1, int rs2, int label) {
  if (breg[rs1] >= breg[rs2]) {
    pc += label;
    has_jumped = true;
  }
}

/**
 * Função BGEU do tipo SB. Pula para endereço se os registradores a serem
 * comparados são diferentes. Os valores são unsigned.
 rs1, rs2, offset if (rs1 ≥u rs2) pc += sext(offset)
Branch if Greater Than or Equal, Unsigned. B-type, RV32I and RV64I.
If register x[rs1] is at least x[rs2], treating the values as unsigned numbers,
 set the pc to the
current pc plus the sign-extended offset
 * @param label Comando para o qual o endereço será redirecionado.
 */
void sbBGEU(int rs1, int rs2, int label) {
  if ((unsigned)breg[rs1] >= (unsigned)breg[rs2]) {
    pc += label;
    has_jumped = true;
  }
}

/**
 Função BLT do tipo SB. Pula para endereço se o primeiro registrador é menor
 que o segundo.
rs1, rs2, offset if (rs1 <s rs2) pc += sext(offset)
Branch if Less Than. B-type, RV32I and RV64I.
Se o registrador x[rs1] é menor que o registrador x[rs2], tratando os valores como números
em complemento de dois, "seta" o pc para o pc atual mais offset com sinal estendido.
 * @param label Comando para o qual o endereço será redirecionado.
 */
void sbBLT(int rs1, int rs2, int label) {
  if (breg[rs1] < breg[rs2]) {
    pc += label;
    has_jumped = true;
  }
}

/**
 * Função BLTU do tipo SB. Pula para endereço se o primeiro registrador é menor
 * que o segundo. Os valores são unsigned.
 rs1, rs2, offset if (rs1 <u rs2) pc += sext(offset)
Branch if Less Than, Unsigned. B-type, RV32I and RV64I.
Se o registrador x[rs1] é menor que o registrador x[rs2], tratando os valores como números
sem sinal, "seta" o pc para o pc atual mais o offset de sinal estendido.

 * @param label Comando para o qual o endereço será redirecionado.
 */
void sbBLTU(int rs1, int rs2, int label) {
  if ((unsigned)breg[rs1] < (unsigned)breg[rs2]) {
    pc += label;
    has_jumped = true;
  }
}

/**
 * Função JAL do tipo UJ. Pula para o endereço especificado e guarda o PC de
 agora.
 rd, offset x[rd] = pc+4; pc += sext(offset)
Jump and Link. J-type, RV32I and RV64I.
Escreve o endereço da próxima instrução (PC + 4) para x[rd] e, em seguida, atribui ao PC
o atual valor de PC atual mais o valor de deslocamento com extensão de sinal. Se rd for
omitido, x1 é adotado.
 * @param target Endereço de instrução novo para o qual se quer pular.
 */
void ujJAL(int rd, int offset) {
  breg[rd] = pc + 4;
  pc += offset;
  has_jumped = true;
}

/**
 * Função JALR do tipo UJ. Pula para o endereço especificado no registrador mais
o imediato e guarda o PC de agora.
 rd, offset(rs1) t =pc+4; pc=(x[rs1]+sext(offset))&∼1; x[rd]=t
Jump and Link Register. I-type, RV32I and RV64I.
Copia o PC para x[rs1] + sign-extend(deslocamento), mascarando o bit menos significativo
do endereço calculado, então grava o valor anterior do PC + 4 em x[rd]. Se rd for omitido,
x1 é assumido.
 * @param target Registrador com o endereço de instrução novo para o qual se
 * quer pular.
 * @param immediate Offset do endereço para o qual se quer pular.
 */
void ujJALR(int rs1, int offset, int immediate) {
  breg[rs1] = pc + 4;
  pc = breg[offset] + immediate;
  has_jumped = true;
}

/**
 * Função LB do tipo I. Carrega um byte de um endereço. Já foi feita em
 * memoriaRV.c, então só vou chamar de lá.
 rd, offset(rs1) x[rd] = sext(M[x[rs1] + sext(offset)][7:0])
Load Byte. I-type, RV32I and RV64I.
Carrega um byte da memória no endereço x[rs1] + sign-extend(deslocamento) e grava-o
x[rd], realizando extensão de sinal.
 * @return O byte encontrado.
 */
int32_t iLB(int rd, uint32_t address, int32_t kte) {
  int32_t byte = lb(breg[address], kte);
  breg[rd] = byte;
  return byte;
}

/**
 * Função OR do tipo R. Faz um or bit a bit.
 rd, rs1, rs2 x[rd] = x[rs1] | x[rs2]
OR. R-type, RV32I and RV64I.
Calcula o OR-inclusivo bit a bit dos registradores x[rs1] e x[rs2] 
e grava o resultado em x[rd].

 * @return A comparação feita.
 */
int32_t rOR(int rd, int rs1, int rs2) {
  int32_t resultado = breg[rs1] | breg[rs2];
  breg[rd] = resultado;
  return resultado;
}

/**
 * Função LBU do tipo I. Carrega um byte unsigned de um endereço. Já foi feita
 * em memoria.c, então só vou chamar de lá.
rd, offset(rs1) x[rd] = M[x[rs1] + sext(offset)][7:0]
Load Byte, Unsigned. I-type, RV32I and RV64I.
Carrega um byte da memória no endereço x[rs1] + sign-extend(deslocamento) e grava-o
x[rd], realizando extensão de zero.

 * @return O byte encontrado.
 */
int32_t iLBU(int rd, uint32_t address, int32_t kte) {
  int32_t byte = lbu(breg[address], kte);
  breg[rd] = byte;
  return byte;
}

/**
 * Função LW do tipo I. Carrega uma palavra de um endereço. Já foi feita em
 memoria.c, então só vou chamar de lá.
 rd, offset(rs1) x[rd] = sext(M[x[rs1] + sext(offset)][31:0])
Load Word. I-type, RV32I and RV64I.
Carrega quatro bytes da memória no endereço x[rs1] + sign-extend(deslocamento) e grava-os
em x[rd]. Para RV64I, o resultado é um sinal estendido.
 * @return A palavra encontrada.
 */
int32_t iLW(int rd, uint32_t address, int32_t kte) {
  int32_t word = lw(breg[address], kte);
  breg[rd] = word;
  return word;
}

/**
 * Função LUI do tipo U. Carrega um número imediato seguido de 12 0's.
 rd, immediate x[rd] = sext(immediate[31:12] << 12)
Load Upper Immediate. U-type, RV32I and RV64I.
Escreve o valor imediato de 20 bits com sinal estendido e deslocado em 12 bits à esquerda
para x[rd], zerando os 12 bits inferiores.

 * @result Número shiftado.
 */
int32_t uLUI(int rd, int immediate) {
  int32_t resultado = immediate << 12;
  breg[rd] = resultado;
  return resultado;
}

/**
 * Pseudo função NOP. Não faz operação alguma.
 */
void pseudoNOP() { 
  iADDI(0, 0, 0); 
}

/**
 * Função SLTU do tipo R. Se o primeiro argumento é menor que o segundo, seta
 * para 1, senão para 0. Todos unsigned.
rd, rs1, rs2 x[rd] = x[rs1] <u x[rs2]
Set if Less Than, Unsigned. R-type, RV32I and RV64I.
Compara x[rs1] e x[rs2] como números sem sinal e escreve 1 em x[rd] se x[rs1] for menor, e
0 caso contrário
 * @result 1 se o primeiro registrador é menor que o segundo, senão 0.
 */
int32_t rSLTU(int rd, int rs1, int rs2) {
  uint reg1 = breg[rs1];
  uint reg2 = breg[rs2];
  int32_t resultado = reg1 < reg2 ? 1 : 0;
  breg[rd] = resultado;
  return resultado;
}

/**
 * Função ORI do tipo I. Faz um or bit a bit com o imediato.
 rd, rs1, immediate x[rd] = x[rs1] | sext(immediate)
OR Immediate. I-type, RV32I and RV64I.
Calcula o OR-inclusivo bit a bit do imediato de sinal estendido com o registrador x[rs1] e
grava o resultado em x[rd]
 * @result Resultado da comparação.
 */
int32_t iORI(int rd, int rs1, int immediate) {
  int32_t resultado = breg[rs1] | immediate;
  breg[rd] = resultado;
  return resultado;
}

/**
 * Função SB do tipo S. Salva um byte em um endereço. Já foi feita em
 memoria.c, então só vou chamar de lá.
 * @param address Endereço em bit do byte procurado.
 * @param kte Offset do endereço.
 * @param dado Byte a ser salvo na memória.
 */
void sSB(uint32_t address, int32_t dado, int32_t kte) {
  int8_t byte = breg[dado] & 0x000000FF;
  sb(breg[address], kte, byte);
}

/**
 * Função SLLI do tipo I. Shifta o número no registrador pra esquerda conforme
 * o imediato
 rd, rs1, shamt x[rd] = x[rs1] << shamt
Shift Left Logical Immediate. I-type, RV32I and RV64I.
Desloca o conteúdo do registrador x[rs1] em shamt posições para à esquerda. Os bits vazios
são preenchidos com zeros e o resultado é gravado em x[rd]. Para RV32I, a instrução só é
permitida quando shamt[5] = 0.
 * @result O número shiftado.
 */
int32_t iSLLI(int rd, int rs1, int immediate) {
  int32_t resultado = breg[rs1] << immediate;
  breg[rd] = resultado;
  return resultado;
}

/**
 * Função SLT do tipo R. Se o primeiro argumento é menor que o segundo, seta
 * para 1, senão para 0.
rd, rs1, rs2 x[rd] = x[rs1] <s x[rs2]
Set if Less Than. R-type, RV32I and RV64I.
Compara x[rs1] e x[rs2] como números de complemento de dois e escreve 1 em x[rd] se
x[rs1] for menor, e 0 caso contrário
 */
int32_t rSLT(int rd, int rs1, int rs2) {
  int32_t resultado = breg[rs1] < breg[rs2] ? 1 : 0;
  breg[rd] = resultado;
  return resultado;
}

/**
 * Função SRAI do tipo I. Faz um shift aritmético para a direita na quantidade
 * de bits especificado.
 rd, rs1, shamt x[rd] = x[rs1] >>s shamt
Shift Right Arithmetic Immediate. I-type, RV32I and RV64I.
Desloca o conteúdo do registrador x[rs1] em shamt posições para à direita. Os bits vazios são
preenchidos com cópias do bit mais significativo de x[rs1], e o resultado é gravado em x[rd].
Para RV32I, a instrução só é permitida quando shamt[5] = 0.
 * @result Número shiftado.
 */
int32_t iSRAI(int rd, int rs1, int immediate) {
  int32_t resultado = breg[rs1] >> immediate;
  breg[rd] = resultado;
  return resultado;
}

/**
 * Função SRLI do tipo I. Faz um shift lógico para a direita na quantidade de
 * bits especificado.
rd, rs1, shamt x[rd] = x[rs1] >>u shamt
Shift Right Logical Immediate. I-type, RV32I and RV64I.
Desloca o conteúdo do registrador x[rs1] em shamt posições para à direita. Os bits vazios
são preenchidos com zeros e o resultado é gravado em x[rd]. Para RV32I, a instrução só é
permitida quando shamt[5] = 0.
 * @result Número shiftado.
 */
int32_t iSRLI(int rd, int rs1, int immediate) {
  uint32_t reg1 = breg[rs1];
  int32_t resultado = reg1 >> immediate;
  breg[rd] = resultado;
  return resultado;
}

/**
 * Função SUB do tipo R. Subtrai os dois valores de registradores e guarda em um
 * terceiro.
 rd, rs1, rs2 x[rd] = x[rs1] - x[rs2]
Subtract. R-type, RV32I and RV64I.
Subtrai o registrador x[rs2] do registrador x[rs1] e grava o resultado em x[rd]. O overflow
aritmético é ignorado.
 * @return A subtração feita.
 */
int32_t rSUB(int rd, int rs1, int rs2) {
  int32_t resultado = breg[rs1] - breg[rs2];
  breg[rd] = resultado;
  return resultado;
}

/**
 * Função SW do tipo S. Salva uma palavra em um endereço. Já foi feita em
  memoria.c, então só vou chamar de lá.
 rs2, offset(rs1) M[x[rs1] + sext(offset)] = x[rs2][31:0]
Store Word. S-type, RV32I and RV64I.
Armazena os quatro bytes menos significativos do registrador x[rs2] na memória no endereço
x[rs1] + sign-extend(deslocamento).
 * @param dado Palavra a ser salva na memória.
 */
void sSW(uint32_t address, int32_t dado, int32_t kte) {
  sw(address, kte, dado);
}

/**
 * Função XOR do tipo R. Faz um xor bit a bit.
rd, rs1, rs2 x[rd] = x[rs1] ˆ x[rs2]
Exclusive-OR. R-type, RV32I and RV64I.
Calcula o OR-exclusivo bit a bit dos registradores x[rs1] e x[rs2] e grava o resultado em
x[rd]
 * @return A comparação feita.
 */
int32_t rXOR(int rd, int rs1, int rs2) {
  int32_t resultado = breg[rs1] ^ breg[rs2];
  breg[rd] = resultado;
  return resultado;
}

/**
 * Função ecall. Vê o comando em A7 e executa conforme.
 * @return Se a função chamar exit retorna true.
 */
bool sysECALL() {
    uint32_t code = breg[A7];
    uint32_t a0 = breg[A0];
    switch (code) {
        case 1:
            printf("%d", a0);
            break;
        case 4:
            printf("%s", ((char*)mem)+a0);
            break;
        case 10:
            return true;
            break;
        default:
            break;
    }
  return false; 
}
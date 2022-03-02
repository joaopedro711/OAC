/**
* UNIVERSIDADE DE BRASÍLIA
* ORGANIZAÇÃO E ARQUITETURA DE COMPUTADORES 
* TURMA C - 2021/2
*
* Trabalho 2: Simulador RISCV 
*
* Funções
*
* Aluno: João Pedro de Oliveira Silva
* Matrícula: 19/0057807
**/






//
/// A Maioria da parte do codigo, foi fornecida pelo professor em sala de aula
//


#include "instructions.cpp"

//*********************************************** REGISTRADORES *************************************************************

//Inicia os registradores
void init(){
    pc = 0; 
    ri = 0;
    has_jumped = false;
    stop_prg = false;       //pra continuar executando o programa
    sp = 0x3ffc;
    gp = 0x1800;
    build_dic();
}

//*********************************************** DUMP_MEM *************************************************************

//Imprime o conteúdo da memória a partir do endereço start até o endereço end. O 
//formato pode ser em hexa (‘h’) ou decimal (‘d’)

void dump_mem(int start_byte, int end_byte, char format){
    switch(format){
        case 'h':
        case 'H':
            for(uint32_t i = start_byte; i <= end_byte; i+=4){
                printf("%08x \t%08x\n", i, lw(i, 0));
            }
        case 'd':
        case 'D':
            for(int i = start_byte; i <= end_byte; i+=4){
                printf("%x \t%d\n", i, lw(i, 0));
            } 
        default:
            break;       
    }
}



//*********************************************** DUMP_REG *************************************************************

//Imprime o conteúdo dos registradores do RV32I, incluindo o banco de registradores e 
//os registradores pc, hi e lo. O formato pode ser em hexa (‘h’) ou decimal (‘d’).

void dump_reg() {
  for (int i = 0; i < 32; i++) {
    if (i % 4 == 0) {
      printf("---------------------------------\n");
    }
    printf("|%s =\t%8d\t%8x|\n", reg_str[i].c_str(), breg[i], breg[i]);
  }
  printf("---------------------------------\n");
}

//*********************************************** LOAD_MEM  *************************************************************

//carrega os arquivos binários para a memória
int load_mem(const char *fn, int start) {
  FILE *fptr;
  int *m_ptr = mem + (start >> 2);
  int size = 0;

  fptr = fopen(fn, "rb");
  if (!fptr) {
    printf("Arquivo nao encontrado!\n");
    return -1;
  } else {
    while (!feof(fptr)) {
      fread(m_ptr, 4, 1, fptr);
      m_ptr++;
      size++;
    }
    fclose(fptr);
  }
  return size;
}









// Determina o formato da intrucao
//
FORMATS get_i_format(uint32_t opcode, uint32_t func3, uint32_t func7) {
    switch (opcode) {
        case 0x33:
            return RType;
        case 0x03:
        case 0x13:
        case 0x67:
        case 0x73:
            return IType;
        case 0x23:
            return SType;
        case 0x63:
            return SBType;
        case 0x37:
        case 0x17:
            return UType;
        case 0x6F:
            return UJType;
        case 0x00:
            if (func3 == 0 && func7 == 0) {
                return NOPType;
            } else {
                return NullFormat;
            }
        default:
            cout << "Undefined Format";
            return NullFormat;
    }
}

// Determina a instrucao a ser executada

INSTRUCTIONS get_instr_code(uint32_t opcode, uint32_t func3, uint32_t func7) {
  switch (opcode) {
    case LUI:
      return I_lui;
    case AUIPC:
      return I_auipc;
    case BType:
      switch (func3) {
        case BEQ3:
          return I_beq;
        case BNE3:
          return I_bne;
        case BGE3:
          return I_bge;
        case BGEU3:
          return I_bgeu;
        case BLT3:
          return I_blt;
        case BLTU3:
          return I_bltu;
      }
      break;
    case ILType:
      switch (func3) {
        case LB3:
          return I_lb;
        case LW3:
          return I_lw;
        case LBU3:
          return I_lbu;
        default:
          break;
      }
      break;
    case JAL:
      return I_jal;
    case JALR:
      return I_jalr;
    case StoreType:
      switch (func3) {
        case SB3:
          return I_sb;
        case SW3:
          return I_sw;
        default:
          break;
      }
      break;
    case ILAType:
      switch (func3) {
        case ADDI3:
          return I_addi;
        case SLLI3:
          return I_slli;
        case SRAI3:
          if (func7 == SRLI7) {
            return I_srli;
          } else {
            return I_srai;
          }
        case ORI3:
          return I_ori;
        case ANDI3:
          return I_andi;
        default:
          break;
      }
      break;
    case RegType:
      switch (funct3) {
        case ADDSUB3:
          if (func7 == SUB7) {
            return I_sub;
          } else {
            return I_add;
          }
        case SLL3:
          return I_sll;
        case SLT3:
          return I_slt;
        case SLTU3:
          return I_sltu;
        case XOR3:
          return I_xor;
        case OR3:
          return I_or;
        case AND3:
          return I_and;
        case SR3:
          if (func7 == SRA7) {
            return I_sra;
          } else {
            return I_srl;
          }
        default:
          break;
      }
      break;
    case ECALL:
      return I_ecall;
    default:
      printf("Instrucao Invalida (PC = %08x RI = %08x)\n", pc, ri);
      break;
  }
  return I_nop;
}

// Instrucao decodificada
//
INSTRUCTIONS instruction;


//*********************************************** FETCH *************************************************************

//busca a instrução a ser executada da memória e atualiza o pc. 
//ri = lw(pc, 0); # carrega instrução endereçada pelo pc
//pc = pc + 4; # aponta para a próxima instrução

void fetch () {
    ri = lw(pc, 0);
    //pc = pc + 4;
}

//*********************************************** DECODE *************************************************************
/*
Extrai todos os campos da instrução: 
- opcode: código da operação 
- rs1: índice do primeiro registrador fonte 
- rs2: índice do segundo registrador fonte 
- rd: índice do registrador destino, que recebe o resultado da operação 
- shamt: quantidade de deslocamento em instruções shift e rotate
- funct3: código auxiliar de 3 bits para determinar a instrução a ser executada 
- funct7: código auxiliar de 7 bits para determinar a instrução a ser executada 
- imm12_i: constante de 12 bits, valor imediato em instruções tipo I 
- imm12_s: constante de 12 bits, valor imediato em instruções tipo S 
- imm13: constante de 13 bits, valor imediato em instruções tipo SB, bit 0 é sempre 0 
- imm20_u: constante de 20 bits mais significativos, 31 a 12 
- imm21: constante de 21 bits para saltos relativos, bit 0 é sempre 0 
Todos os valores imediatos tem o sinal estendido. É sugerido criar uma função, 
int32_t	geraImm(ri), que produz o valor imediato em 32 bits a partir do código da 
instrução */

void decode() {
    int32_t tmp;

    opcode = ri & 0x7F;             // codigo da operação
    rs1 = (ri >> 15) & 0x1F;        // primeiro operando
    rs2 = (ri >> 20) & 0x1F;        // segundo operando
    rd = (ri >> 7) & 0x1F;          // registrador destino
    shamt = (ri >> 20) & 0x1F;      // deslocamento
    funct3 = (ri >> 12) & 0x7;      // auxiliar codigo instrucao
    funct7 = (ri >> 25);            // auxiliar codigo de instrucao
    imm12_i = ((int32_t)ri) >> 20;  // imediato 12 bits

    tmp = get_field(ri, 7, 0x1f);
    imm12_s = set_field(imm12_i, 0, 0x1f, tmp);
    
    imm13 = imm12_s;
    imm13 = set_bit(imm13, 11, imm12_s & 1);
   
    imm13 = imm13 & ~1;
    imm20_u = (unsigned)(ri & (~0xFFF)) >> 12;
    // mais aborrecido: imediato 21 bits
    imm21 = (int32_t)ri >> 11;                // estende sinal
    tmp = get_field(ri, 12, 0xFF);            // lê campo 19:12
    imm21 = set_field(imm21, 12, 0xFF, tmp);  // escreve campo em imm21
    tmp = get_bit(ri, 20);                    // le o bit 11 em ri(20)
    imm21 = set_bit(imm21, 11, tmp);          // posiciona bit 11
    tmp = get_field(ri, 21, 0x3FF);
    imm21 = set_field(imm21, 1, 0x3FF, tmp);
    imm21 = imm21 & ~1;  // zera bit 0

    instruction = get_instr_code(opcode, funct3, funct7);
    imm32_t = *imediatos[get_i_format(opcode, funct3, funct7)];
}
//*********************************************** EXECUTE *************************************************************

//A função void	 execute() executa a instrução que foi lida pela função fetch() e 
//decodificada por decode().

void execute() {
    
    breg[0]=0;                  //garante que sempre terá o valor 0;

    switch (instruction) {
        case I_add:
            rADD(rd, rs1, rs2);
            break;
        case I_addi:
            iADDI(rd, rs1, imm12_i);
            break;
        case I_and:
            rAND(rd, rs1, rs2);
            break;
        case I_andi:
            iANDI(rd, rs1, imm12_i);
            break;
        case I_auipc:
            uAUIPC(rd, imm20_u);
            break;
        case I_beq:
            sbBEQ(rs1, rs2, imm13);
            break;
        case I_bne:
            sbBNE(rs1, rs2, imm13);
            break;
        case I_bge:
            sbBGE(rs1, rs2, imm13);
            break;
        case I_bgeu:
            sbBGEU(rs1, rs2, imm13);
            break;
        case I_blt:
            sbBLT(rs1, rs2, imm13);
            break;
        case I_bltu:
            sbBLTU(rs1, rs2, imm13);
            break;
        case I_jal:
            ujJAL(rd, imm21);
            break;
        case I_jalr:
            ujJALR(rd, rs1, imm12_i);
            break;
        case I_lb:
            iLB(rd, rs1, imm12_i);
            break;
        case I_or:
            rOR(rd, rs1, rs2);
            break;
        case I_lbu:
            iLBU(rd, rs1, imm12_i);
            break;
        case I_lw:
            iLW(rd, rs1, imm12_i);
            break;
        case I_lui:
            uLUI(rd, imm20_u);
            break;
        case I_nop:
            pseudoNOP();
            break;
        case I_sltu:
            rSLTU(rd, rs1, rs2);
            break;
        case I_ori:
            iORI(rd, rs1, imm12_i);
            break;
        case I_sb:
            sSB(rs1, rs2, imm12_s);
            break;
        case I_slli:
            iSLLI(rd, rs1, shamt);
            break;
        case I_slt:
            rSLT(rd, rs1, rs2);
            break;
        case I_srai:
            iSRAI(rd, rs1, shamt);
            break;
        case I_srli:
            iSRLI(rd, rs1, shamt);
            break;
        case I_sub:
            rSUB(rd, rs1, rs2);
            break;
        case I_sw:
            sSW(breg[rs1], breg[rs2], imm12_s);
            break;
        case I_xor:
            rXOR(rd, rs1, rs2);
            break;
        case I_ecall:
            stop_prg = sysECALL();
            break;
        default:
            printf("Comando não reconhecido...\n");
            break;
    }
}

//*********************************************** STEP *************************************************************

//A função step() executa uma instrução do RV32I: 
//step() => fecth(), decode(), execute() 
void step() {
	fetch();
	decode();
    execute();
    
    breg[ZERO] = 0;             //garantindo ficar com o valor 0
    if (has_jumped) {
        has_jumped = false;
    } else {
        pc = pc + 4;
    }
    
}

//*********************************************** RUN *************************************************************

//A função run() executa o programa até encontrar uma chamada de sistema para 
//encerramento, ou até o pc ultrapassar o limite do segmento de código (2k words). 
void run() {
	init();                                             //inicia o programa
	while ((pc < DATA_SEGMENT_START) && !stop_prg)
        step();
    if (stop_prg) {
        printf("\n-- program is finished running (0) --\n");
    } else {
        printf("\n-- program is finished running (dropped off bottom) --\n");
  }
}


//*********************************************** Função Print *************************************************************
/*
void print_instr(instruction_context_st& ic){
    switch(ic.ins_format){
        case RType:
            cout << setw(n:10) << left << instr_str(ic.ins_code)
                 << setw(n:4)  << reg_str(ic.rd)
                 << ","
                 << setw(n:4)  << reg_str(ic.rs1)
                 << ","
                 << setw(n:4)  << reg_str(ic.rs2)
                 << endl;
            break;  
        case IType:
            cout << setw(n:10) << left << instr_str(ic.ins_code)
                 << setw(n:4)  << reg_str(ic.rd)
                 << ","
                 << setw(n:4)  << reg_str(ic.rs1)
                 << ","
                 << setw(n:4)  << imm12_i
                 << endl;
            break; 
        case SType:
            cout << setw(n:10) << left << instr_str(ic.ins_code)
                 << setw(n:4)  << reg_str(ic.rd)
                 << ","
                 << setw(n:4)  << reg_str(ic.rs1)
                 << ","
                 << setw(n:4)  << imm12s_i
                 << endl;
            break; 
        case SBType:
            cout << setw(n:10) << left << instr_str(ic.ins_code)
                 << setw(n:4)  << reg_str(ic.rs1)
                 << ","
                 << setw(n:4)  << reg_str(ic.rs2)
                 << ","
                 << setw(n:4)  << imm13
                 << endl;
            break;     
        case UType:
            cout << setw(n:10) << left << instr_str(ic.ins_code)
                 << setw(n:4)  << reg_str(ic.rd)
                 << ","
                 << setw(n:4)  << imm20_u
                 << endl;
            break; 
        case UJType:
            cout << setw(n:10) << left << instr_str(ic.ins_code)
                 << setw(n:4)  << reg_str(ic.rd)
                 << ","
                 << setw(n:4)  << imm21
                 << endl;
            break;  
        default:
            cout << "Unknown format" << endl;       

    }
} 
*/
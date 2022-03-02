/**
* UNIVERSIDADE DE BRASÍLIA
* ORGANIZAÇÃO E ARQUITETURA DE COMPUTADORES 
* TURMA C - 2021/2
*
* Retirado do Trabalho 1: Acesso a Memória do RISCV, compõem o trabalho 2
*
* Aluno: João Pedro de Oliveira Silva
* Matrícula: 19/0057807
**/



#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>

#define MEM_SIZE 4096
int32_t mem[MEM_SIZE];


int erro = 0, certo = 0;          

//************************** Funções *****************************************************************

//Testa se o endereço é válido
int testeAddres(uint32_t address){
    if((address % 4 != 0)){                                  //se é inválido
        printf("Erro de Endereço 0x%08X. Não é multiplo de 4\n", address);
        erro = 1;                                            
                                           
        return erro;                                         //retorna 1 se deu errado
    }
    return 0;                                                //se o endereço for válido
}

/**
 * Lê um inteiro alinhado - endereços múltiplos de 4.
 * A função calcula o endereço de memória somando os parâmetros:
 * Endereço palavra = address + kte
 * A função deve checar se o endereço é um múltiplo de 4 (%4 == 0).
 * Se não for, deve escrever uma mensagem de erro e retornar zero.
 * Se o endereço estiver correto, a função deve:
 * - Dividi-lo por 4 para obter o índice do vetor memória
 * - Retornar o o valor lido da memória
 */
int32_t lw(uint32_t address, int32_t kte){
    certo = testeAddres(address + kte);

    if(certo == 0){                         //caso o endereço esteja certo, retorna 0
        return mem[(address + kte)/4];      //obtem o indice vetor memoria
    }
    return 0;
}

/**
 * Lê um byte do vetor memória e retorna-o, estendendo o sinal para 32 bits.
 * Lembrando que as palavras da memória tem 4 bytes cada, para acessar um byte
 * dentro da palavra pode-se:
 * • Ler a palavra que contém o byte e, por operações de mascaramento, extrair
 * byte endereçado, ou
 * • Criar um ponteiro para byte e fazer um type cast (coerção de tipo) do
 * endereço do vetor memória (int *) para byte (char *).
 */

int32_t lb(uint32_t address, int32_t kte){
   
    int8_t *bytePointer = (int8_t *) mem;                   //Inicializo um ponteiro que aponta para o início da MEM e anda de 8b em 8b
    int32_t word = bytePointer[address + kte];              //transformando o byte em uma palavra de 32 bits

    return word;
    
}

/**
 * Lê um byte do vetor memória e retorna-o como um número positivo, ou seja,
 * todos os bits superiores devem ser zerados.
*/ 
//Mesca coisa da função LB, só muda que agora o byteponter é um inteiro de 8 bits sem sinal
int32_t lbu(uint32_t address, int32_t kte){
    uint8_t *bytePointer = (uint8_t *) mem;                   //Inicializo um ponteiro que aponta para o início da MEM e anda de 8b em 8b
    uint32_t word = bytePointer[address + kte];              //transformando o byte em uma palavra de 32 bits

    return word;
    
}
/**
 * Escreve um inteiro alinhado na memória - endereços múltiplos de 4. O cálculo
 * do endereço é realizado da mesma forma que na operação lw().
*/
void sw(uint32_t address, int32_t kte, int32_t dado){
    certo = testeAddres(address+kte);
    if(certo == 0){                         //caso o endereço esteja certo, retorna 0
        mem[(address + kte)/4] = dado;      //coloca o dado no indice vetor memoria
    }
    //retun 0;  
}

/**
 * Escreve um byte na memória. Caso utilize operações de mascaramento, a palavra
 * que contém o byte deve ser lida da memória, o byte deve ser posicionado
 * corretamente através de deslocamentos e a escrita ocorre utilizando máscaras.
 * Alternativamente pode-se utilizar a coerção para (char *) e escrever
 * diretamente na posição usando o endereço calculado como índice.
 */
void sb(uint32_t address, int32_t kte, int8_t dado) {
    int8_t *bytePointer = (int8_t *) mem;                   //Inicializo um ponteiro que aponta para o início da MEM e anda de 8b em 8b
    bytePointer[address + kte] = dado;                      //coloca o dado no indice vetor memoria
}



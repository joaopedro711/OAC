/**
* UNIVERSIDADE DE BRASÍLIA
* ORGANIZAÇÃO E ARQUITETURA DE COMPUTADORES 
* TURMA C - 2021/2
*
* Trabalho 1: Acesso a Memória do RISCV 
*
* Aluno: João Pedro de Oliveira Silva
* Matrícula: 19/0057807
**/

#include <stdio.h>
#include <stdint.h>  
#include <stdbool.h>

#define MEM_SIZE 4096 
int32_t mem[MEM_SIZE];  // Memória.

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


//***************************************** MAIN *************************************************************
int main(){

    //*************************Testes propostos ************************************************

    //1. Iniciar a memória:	executar a seguinte	sequência de operações de escrita.
    //A.
    sb(0, 0, 0x04); sb(0, 1, 0x03); sb(0, 2, 0x02); sb(0, 3, 0x01);
    //b.
    sb(4, 0, 0xFF); sb(4, 1, 0xFE); sb(4, 2, 0xFD); sb(4, 3, 0xFC); 
    //c.
    sw(12, 0, 0xFF); 
    //d.
    sw(16, 0, 0xFFFF); 
    //e.
    sw(20, 0, 0xFFFFFFFF); 
    //f.
    sw(24, 0, 0x80000000); 

    //Teste de Escrita
    // Imprimir	o conteúdo da memória	em formato	hexa. O resultado deve ser:
    for (int i = 0; i < 7; i++) {
        printf("%c: mem[%d] = 0x%08X\n", 'a' + i, i, mem[i]);
    }
    printf("\n");

    //3. Ler os dados e imprimir em hexadecimal:	
    printf("lb(4,0) = 0x%08X\n", lb(4,0));
    printf("lb(4,1) = 0x%08X\n", lb(4,1));
    printf("lb(4,2) = 0x%08X\n", lb(4,2));
    printf("lb(4,3) = 0x%08X\n\n", lb(4,3));
    
    printf("lbu(4,0) = 0x%08X\n", lbu(4,0));
    printf("lbu(4,1) = 0x%08X\n", lbu(4,1));
    printf("lbu(4,2) = 0x%08X\n", lbu(4,2));
    printf("lbu(4,3) = 0x%08X\n\n", lbu(4,3));
    
    printf("lw(12,0) = 0x%08X\n", lw(12,0));
    printf("lw(16,0) = 0x%08X\n", lw(16,0));
    printf("lw(20,0) = 0x%08X\n\n\n", lw(20,0));
    

//***********************************************************************************
    
    printf("Testes extras\n\n");


    // escrever uma palavra em endereço não divisível por 4. Espera-se ter um erro na saída.  
    printf("Extra 1: ");
    sw(29, 0, 0x80000000);
    


    //ler byte negativo da memória,  o ultimo bit tem que ser extendido.
    printf("Extra 2: ");
    int32_t aux = lb(4,0);
    if (aux == -1) {
        printf("Leitura de byte negativo corretamente.  0x%08X = -1\n", aux);
    } else {
        printf("Error, ao ler byte negativo da memória.\n");
    }

    // ler byte negativo da memória, como unsigned, se o ultimo bit não foi extendido.
    printf("Extra 3: ");
    int32_t aux1 = lbu(4,0);
    if (aux1 == 255) {
        printf("Leitura de byte sem sinal corretamente.  0x%08X = 255\n", aux1);
    } else {
        printf("Error, ao ler byte sem sinal da memória.\n");
    }

    // ler palavra em endereço fora da memória, tem que dá error
    printf("Extra 4: ");
    int32_t aux2 = lw(MEM_SIZE,0);

    if(aux2 == 0){                  //significa que está fora da memória
        printf("Error, Endereço fora da memória.\n");
    }
    
    

    // ler palavra em endereço negativo, tem que dá erro
    printf("Extra 5: ");
    lw(-1,0);
    
    return 0;
}
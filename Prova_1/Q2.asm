#Uma forma de se medir a similaridade entre o conteúdo de dois vetores de inteiros positivos é
#através da soma das diferenças absolutas (SAD). Traduza o código C desse
#algoritmo para assembly do RISCV. Definir a função int sad(int *pv1, int *pv2, int size), 
#passando os parâmetros através dos registradores ai, retornando o resultado no registrador a0 e
#empilhando o contexto na chamada. 

#int sad(int *pv1, int *pv2, int size) {      
#    int i, acc=0;
#    for (i = 0; i < size; i++) {
#        acc = acc + abs(*pv1 - *pv2);
#        pv1++;
#        pv2++;
#     }
#     return acc;
#}

#Definir no segmento de dados dois vetores de inteiros:
#int a[] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 };
#int b[] = { 9, 8, 7, 6, 5, 4, 3, 2, 1 };

#O programa deve ler do teclado um inteiro indicando quantos elementos dos vetores devem ser
#utilizados pelo SAD. Se n = 2, por exemplo, fazer a SAD entre { 1, 2 } e { 9, 8 }. Se n = 4,
#a SAD seria entre { 1, 2, 3, 4 } e { 9, 8, 7, 6 }.

#Imprimir o resultado da SAD e encerrar o programa com uma chamada do sistema.

##############################################################################################################

.data
  a: .word 1 2 3 4 5 6 7 8 9
  b: .word 9 8 7 6 5 4 3 2 1
  
.text

	#quantos elementos usar dos vetores
	li a7, 5
	ecall
	mv a4, a0

	# carrega o endereço
	la a1, a 
	la a2, b

	call sad

	li a7, 1		#printa na tela o valor que esta em a0
	ecall

	li a7, 10 # encerra o programa
	ecall



sad:
	addi sp,sp, -24 # guarda espaço na pilha
	sw ra 0(sp)	#guarda endereço de retorno
	
	sw s0, 4(sp)
	sw s1, 8(sp)
	sw s2, 12(sp)
	sw s3, 16(sp)
	sw s4, 20(sp)
	
	#coloca os endereços dos vetores nos registradores S
	mv s0,a1 # s0 = a
	mv s1, a2 # s1 = b
	mv s2, a4 # s2 = size

	li s3, 0  # c = 0

	li s4, 0 # for (i = 0; i < size; i++)
for:
	bge s4, s2, for_fim

	slli t0, s4, 2 # t0  = a[i]
	add t0, t0, s0
	lw t0, 0(t0)

	slli t1, s4, 2 # t1 = b[i]
	add t1, t1, s1
	lw t1, 0(t1)

	sub t0, t0, t1 # t0 = a[i] - b[i]

	bgez t0, abs  # t0 = abs(a[i] - b[i])
	li t1, -1
	mul t0, t0, t1
	
abs:

	add s3, s3, t0 # c = c + abs(a[i] - b[i])

	addi s4, s4, 1
	b for
for_fim:
  
	mv a0, s3 # coloco o valor em a0
	#Lê os valores na pilha
	lw ra, 0(sp)
	lw s0, 4(sp)
	lw s1, 8(sp)
	lw s2, 12(sp)
	lw s3, 16(sp)
	lw s4, 20(sp)
	#devolve espaço pra pilha
	addi sp, sp, 24
	
	ret
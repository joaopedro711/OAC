#Transformar os caracteres minúsculos de uma frase em maiúsculos.
#Procedimento:
#1. Ler uma frase do teclado (chamada do sistema). Não usar caracteres especiais ou acentuados e restringir-se a um máximo de 30 caracteres.
#2. Percorrer a frase e transformar as letras minúsculas em maiúsculas.
#Não altera letras maiúsculas, dígitos ou caracteres especiais.
#3. Imprimir a frase resultante na tela. 
#Termine o programa com a chamada do sistema.

############################# Cabeçalho da Resposta ############################
.data

rsp:  .space 30
size: .word 30

.text

# Seu código abaixo:

	
	li a7, 8
	la a0, rsp
	la a1, size
	lw a1, 0(a1)
	ecall
	
	la s0, rsp	
Loop:	
	lbu s1, 0(s0)
	beq s1, zero, fim
	mv a0, s1
	jal eh_min
	addi s0, s0, 1
	beq a0, zero, Loop
	addi s1, s1, -32
	sb s1, -1(s0)
	j Loop
	
fim:	
	li a7, 4
	la a0, rsp
	ecall
	li a7, 10
	ecall
	
eh_min:
	slti t0, a0, 123
	li   t1, 96
	slt  t1, t1, a0
	and  a0, t0, t1
	ret
################# Cabeçalho da Resposta - Não altere ###########################
.data
# segmento de dados
ehpar: 	 .string "Eh par"
ehimpar: .string "Eh impar"

#segmento de codigo
.text
# seu codigo aqui...

	#ler um inteiro
	li	a7, 5
	ecall
	
	mv	t0, a0		#t0 recebe esse valor
	
	addi	t1, t1, 2	#t1 rece o valor 2
	
	rem	t2, t0, t1		# t0 = t1 % 2
	
	mv	a0, t2
	
	#faço t0=0, t1=1 e t2=-1
	add	t0, zero, zero
	addi	t1, zero, 1
	addi	t2, zero, -1
	
	#chamando cada função, vai pra correspondente
	beq	a0, t0, par		# compara se é igual	
	beq	a0, t1, impar
	beq	a0, t2, impar

par:
	li	a7, 4		#print string "eh par"
	la	a0, ehpar	#carrega o endereço da string "eh par" em a0
	ecall
	
	li	a7, 10		#encerra programa
	ecall
	
impar:
	li	a7, 4		#print string "eh impar"
	la	a0, ehimpar	#carrega o endereço da string "eh impar" em a0	
	ecall
	
	li	a7, 10		#encerra programa
	ecall
	
	li	a7, 10
	ecall
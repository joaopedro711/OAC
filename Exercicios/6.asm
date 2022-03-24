#Ler um inteiro do teclado e imprimir o número de bits em 1 em sua representação binária. 
#Encerrar o programa com a chamada do sistema.

.text

	li a7, 5
	ecall
	
	li  t0, 1
	add t1, zero, zero
	li  t2, 32 
loop:
	blez t2, fim
	addi t2, t2, -1
	and  a1, a0, t0
	srli a0, a0, 1
	add  t1, t1, a1
	j loop
fim:
	li a7, 1
	mv a0, t1
	ecall
	
	li a7, 10
	ecall
	
#Leia 3 inteiros do teclado, por ordem, a, b e c. Calcule e imprima o resultado da 
#express„o: a + b*c
#Termine o programa com a chamada do sistema.

.text
	#l  o primeiro numero e coloca em t0
	li	a7, 5
	ecall
	
	mv	t0, a0
	
	#l  o segundo numero e coloca em t1
	li	a7, 5
	ecall
	
	mv	t1, a0
	
	#l  o terceiro numero e coloca em t2
	li	a7, 5
	ecall
	
	mv	t2, a0
	
	# a0 vai receber o caluclo de toda operaÁ„o
	
	mul	a0, t1, t2		# a0 = t1* t2
	add	a0, a0, t0		# a0 += t0
	
	li	a7, 1
	ecall
	
	li	a7, 10
	ecall
	
	
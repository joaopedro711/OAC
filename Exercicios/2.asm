#Leia dois inteiros do teclado e escreva o resultado da sua soma na console. 
#Termine o programa com a chamada do sistema.

.text
	#pegando primeiro valor 
	li	a7, 5
	ecall
	#colocando em t0, mv == mover o valor de a0 para t0
	mv	t0, a0
	
	#pegando segundo valor 
	li	a7, 5
	ecall
	#colocando em t1
	mv	t1, a0
	
	add	t0, t0, t1
	
	
	#carrego o valor da soma que esta em t0 pra a0
	mv	a0, t0
	#printa a soma no terminal
	li	a7, 1
	ecall
	
	#fim do programa, "Program terminated by calling exit"
	li	a7, 10
	ecall
	

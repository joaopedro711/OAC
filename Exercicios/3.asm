#Ler uma sequência de inteiros do teclado, somá-los e imprimir o resultado. 
#O primeiro número lido indica o número de inteiros que devem ser lidos e somados.
#Termine o programa com a chamada do sistema.

.text 

main:
	#ler o valor que representa o tanto de vezes que devo ler
	li	a7, 5
	ecall
	
	#guardo o valor em t0
	mv	t0, a0
	
	
	#chamo label leitura
	call	leitura
	
	mv	a0, t2			# a0 recebe o valor da soma pra printar
	
	#print 
	li	a7, 1
	ecall
	
	#encerramento
	li	a7, 10
	ecall

#label que faz o tanto de leituras que foi pedido	
leitura:
	beq	t0, t3, fim		#se for igual a t3, vai pra outro label pra retornar pra main, t3 tem valor 0, podia ser qualquer um com valor 0
	
	#caso não seja igual a 0, vou ler mais valores e somar, coloco a soma em t2
	li	a7, 5			#leio mais valores
	ecall
	
	mv	t1, a0			# coloco o novo valor em t1
	add	t2, t2, t1		# t2 +=t1
	
	addi	t0, t0, -1		# decremento o valor de t0
	
	j	leitura			#fica em loop até ler tudo	
	

#retorno pra main		
fim:
	ret		
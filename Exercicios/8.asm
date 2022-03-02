#Ao ler um string do teclado com a chamada de sistema a7 = 8, a fun��o retorna o string com o caracter 
#nova linha ('\n') ao final. 
#Fa�a uma fun��o que recebe o endere�o em mem�ria de um string em a0 e substitui o caracter '\n' por 
#zero, indicando o fim do string.
#Escreva apenas a fun��o. A entrada e sa�da � feita no cabe�alho da resposta.
#Par�metros da fun��o:
#a0 : endere�o do primeiro caracter do string
#a1 : c�digo do caracter nova linha ('\n')

######################## Cabe�alho da resposta - n�o alterar ###################
.data 
str:	.space 32
nl:	    .word 10

.text
	li a7, 8
	la a0, str
	li a1, 30
	ecall
	
	lw  a1, nl
	jal limpa
	
	li a7, 4
	la a0, str
	ecall
	
	li a7, 10
	ecall
	
######################## Escreva a fun��o limpa a seguir #######################	
limpa:
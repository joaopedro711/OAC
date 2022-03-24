#Ao ler um string do teclado com a chamada de sistema a7 = 8, a função retorna o string com o caracter 
#nova linha ('\n') ao final. 
#Faça uma função que recebe o endereço em memória de um string em a0 e substitui o caracter '\n' por 
#zero, indicando o fim do string.
#Escreva apenas a função. A entrada e saída é feita no cabeçalho da resposta.
#Parâmetros da função:
#a0 : endereço do primeiro caracter do string
#a1 : código do caracter nova linha ('\n')

######################## Cabeçalho da resposta - não alterar ###################
.data 
str:	.space 32
nl:	    .word 10

.text
	li a7, 8
	la a0, str
	li a1, 32
	ecall
	
	lw  a1, nl
	jal limpa
	
	li a7, 4
	la a0, str
	ecall
	
	li a7, 10
	ecall
	
limpa:
	lbu t1, 0(a0)
	beqz t1, fim
	bne t1, a1 segue
	sb zero, 0(a0)
segue:
	addi a0, a0, 1
	j limpa
fim:
	ret
#Escreva uma função que lê três números a, b e c. Os dois primeiros são reais em representação 
#IEEE 754 e o último (c) é um inteiro. Calcule a diferença x entre os expoentes dos números a e b 
#e multiplique o inteiro c por 2**x. Imprima o resultado na tela. 
#Por exemplo, se a = 4.0, b = 16.0, c = 100, o programa deve imprimir 25 na tela.
#Para a = 40.0, b = 7.0, c = 13, o valor impresso deve ser 104.
#Encerre o programa com a chamada do sistema.

.text

li a7, 6
ecall
fmv.x.s a1, fa0
ecall
fmv.x.s a2, fa0

#pegando inteiro, a3 = C
li	a7, 5
ecall
add	a3, a3, a0
		
srli	a1, a1, 23
srli	a2, a2, 23
andi	a1, a1, 0xFF # Pegando so os ultimos 8 bits, referente ao expoente
andi	a2, a2, 0xFF
addi	a1, a1, -127
addi	a2, a2, -127
sub	a4, a1, a2   # diferença dos expoentes

#li 	a7, 1
#ecall

# C = C * 2**X		x == a0
mv	a1, a4	
addi 	a2, zero, 2
addi 	a0, zero, 2	
blt	a4, zero, pot1 #se A0 for negativo:
jal 	pot2		#se A0 for positivo:

pot1:
	addi 	a1, a1, 1
	beq	a1, zero, fim1
	mul	a0, a0, a2
	
	j	pot1
	
			
pot2:	
	addi 	a1, a1, -1
	beq	a1, zero, fim2
	mul 	a0, a0, a2
	
	j	pot2


fim1:
div  a0, a3, a0

li 	a7, 1
ecall
li 	a7, 10
ecall

fim2:
mul  a0, a0, a3

li 	a7, 1
ecall
li 	a7, 10
ecall
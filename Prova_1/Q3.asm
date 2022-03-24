#Uma aproximação do valor da hipotenusa de um triângulo retângulo pode ser obtida pela expressão:
#        h(a, b) = max((0,875x + 0,5y), x),
#               onde x = max(a, b) e y = min(a, b) e a e b são inteiros positivos.
#Implemente as funções max e min, que recebem como parâmetro dois inteiros em a0 e a1 e retornam
#o respectivo resultado em a0.
#Implemente um código que lê dois catetos do teclado e calcula a expressão h(a, b) no assembly do RV.
#Imprima o resultado na tela e encerre o programa com a chamada do sistema.


######################## Cabeçalho da resposta ###################
.data
x:	.float 0.875
y:	.float 0.5

.text
	li a7, 5	#lê inteiro (a)
	ecall
	
	mv t1, a0	
	
	li a7, 5 	#lê inteiro (b)
	ecall
	
	mv a1, a0
	mv a0, t1	#coloca o valor de a em a0
	
    # preparar argumentos aqui e fazer chamada recursiva
    
	jal rec
    # imprime resultado
resultado:
    	li a7, 1
    	ecall
    # encerra
	li a7, 10
	ecall
	
# coloque abaixo o código da função recursiva. 
# x = a2, y = a3
rec:	
	jal maior_menor
	
	jal func
	jal max
	jal resultado
	ret 


maior_menor:
	blt a0, a1, a0_menor
	bge a0, a1, a0_maior
	ret
a0_menor:
	mv a2, a1	#a2 = valor de maximo, o x
	mv a3, a0 	#a3 = valor de minimo, o y
	ret
a0_maior:
	mv a2, a0	#a2 = valor de maximo, o x
	mv a3, a1 	#a3 = valor de minimo, o y
	ret	

	
func:
	la t1, x
	flw ft0, (t1)
	la t1, y
	flw ft1, (t1)
	fcvt.s.w ft2, a2
	fcvt.s.w ft3, a3
	fmul.s ft2, ft0, ft2
	fmul.s ft3, ft1, ft3
	fadd.s ft2, ft3, ft2
	ret
	
	
max:
	fcvt.w.s a5, ft2
	blt a2, a5, a5_maior
	jal a2_maior
	
a5_maior:
	mv a0, a5
	ret
a2_maior:
	mv a0, a2
	ret
	

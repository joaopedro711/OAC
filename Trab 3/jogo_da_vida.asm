#################################################
#* UNIVERSIDADE DE BRASÍLIA                     #               
#* DEPARTAMENTO DE CIÊNCIA DA COMPUTAÇÃO        #                            
#* ORGANIZAÇÃO E ARQUITETURA DE COMPUTADORES    #
#*                                              #
#* Trabalho III: Jogo da Vida em Assembly RISCV #
#*                                              # 
#* Aluno: João Pedro de Oliveira Silva          #
#* Matrícula: 190057807                         #
#*                                              #
#################################################

.data
mat1: .byte 		0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
 			0 1 1 0 0 0 1 0 0 0 0 0 0 0 0 0 
 			0 1 1 0 0 0 0 1 0 0 0 0 0 0 0 0 
 			0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 
 			0 0 0 0 0 0 0 0 0 0 0 1 1 1 0 0 
 			0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
 			0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
 			0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
			0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
 			0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
 			0 0 0 1 1 0 0 0 0 0 1 1 1 0 0 0 
 			0 0 1 1 0 0 0 0 0 0 0 1 0 0 0 0 
 			0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 
 			0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
 			0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
 			0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0

mat2: .byte 0:255 


#variaveis para as cores e o heap do bitmap
cor: .word 0x00FFFF		# cor = aqua
not_cor: .word 0x0
heap: .word 0x3000

.text

main:
	# Registradores recebendo os endereços e dados das variaveis
	la	s4, mat1			#s4 recebe o endereço da matriz 1
	la	s5, mat2			#s5 = endereço da segunda matriz de bytes
	lw	s6, heap			#a3 = endereço do heap do display
	lw	s2, cor				#s2 = cor 
	lw	s1, not_cor			
	
	
	mv	a0, s4				#a0 é passado como argumento pra start_mat1
	call 	plotm				#inicia pra escrever a matriz 1 no display
	
loop:	
	call	geracion			#Geração da mat1 em diante
	
	mv	a0, s4				# a0 = mat1
	mv	a1, s5				# a1 = mat2
	call	atualiza
	
	mv	a0, s4
	call 	plotm				#desenha a matriz no display
	
	call	sleep				#especie de delay_cicles
	
	
	j	loop
	
	#encerra código
	li	a7,10
	ecall
###########################################    PROCESS    ########################################

#-------------   sleep ------------------#
sleep:
	li	a0, 50				# 50 milisegundos
	li	a7, 32				
	ecall
	
	ret


#--------------- Plotm -----------------#	
# plotm(mat) - onde a0 = endereço inicial da matriz: desenha a matriz 
#na tela gráfica 

plotm:
	addi	a5, zero, 1			#a5 = contador de linhas				
	addi	a6, zero, 1			#a6 = contador de colunas
	addi	s9, zero, 17			#posição referente ao fim de linha ou coluna
	mv	a4, s6				#a4 = cópia do heap
	
plotm1:
	beq	a6, s9, plotm2			#checa se já percorreu as 16 colunas
	addi	a4, a4, 4			#avaça na posição da mat1
	lb	t0, 0(a0)			# t0= valor do indice da mat1
	addi	a0, a0, 1			#anda a matriz de bytes
#	beqz	t0, write_mat1			#se for valor 0, volta pra descolorir
	
	sw	s1, -4(a4)			#Descolorindo o pixel
	addi	a6, a6, 1 			#incrementa +1 no contador 
	beqz	t0, plotm1			#se for valor 0, volta pra descolorir
	sw	s2,-4(a4)			#Colorindo o pixel 
	
	j	plotm1	
#descolore:
#	sw	s1, 0(a4)			#Descolorindo o pixel
#	addi	a6, a6, 1 			#incrementa +1 no contador 
#	j	write_mat1
			
plotm2:
	beq	a5, s9, plotm_fim		#se já foram as 16 linhas
	addi	a6, zero, 1			#inicializa o contador de coluna
	addi	a5, a5, 1			#incrementa o contador de linha
	
	j	plotm1

plotm_fim:
	ret

#--------------- GERACION-----------------#	

geracion:
	addi	a5, zero, 1			#a5 = contador de linhas				
	addi	a6, zero, 1			#a6 = contador de colunas
	mv	a4,s4				#a4 = copia de mat1
	mv	s8,s5				#s8 = copia de mat2

#subrotina que percorre cada coluna	
geracion2:					
	beq	a6, s9, geracion3		# Se chegar ao fim da coluna, percorrerá a outra linha

	#guardar o valor do endereço da posição de LOOP na pilha
	addi	sp, sp, -4
	sw	ra, 0(sp)
			
	call 	morto_vivo			#Determina se a célula vai viver ou não
	#Pega novamente o endereço da posição de LOOP da pilha
	lw 	ra, 0(sp)
	addi	sp, sp, 4
	
	sb	a7, 0(s8)			#a7 possui valor se morreu ou não
	
	addi	a4, a4, 1			#Avança posição de mat1
	addi	s8, s8, 1			#Avança posição de mat2
	addi	a6, a6, 1			# incrementa o contador de colunas
	
	j 	geracion2

#Pecorre linha
geracion3:			
	beq	a5, s9, geracion_fim		#a5==17
	addi	a5, a5, 1
	addi	a6, zero, 1
	j	geracion2

#Se percorreu toda a matriz	
geracion_fim:
	ret


#--------------- READM ---------------#
# readm(i, j, mat) - onde a0 = i, a1 = j e a2 = endereço inicial da 
# matriz: retorna o valor da célula da matriz em a0.
# estará retornando em a3 pra não bagunçar o código 
readm:
	addi	t1, zero, 0
	addi	t2, zero, 17
	blt	t2, a0, readm_fail		# Se t2 < a0
	blt	t2, a1, readm_fail		# Se t2 < a1
	ble	a0, t1, readm_fail		# Se a0 <= t2
	ble	a1, t1, readm_fail		# Se a0 <= t2
	j	readm_1

#esteja fora dos limites de tamanho
readm_fail:
	addi	a3, zero, 0
	ret

#Percorre coluna
readm_1:				
	addi	a1,a1,-1	
	beq	a1, zero, readm_2 		# Se a1 == 0
	addi	a2,a2,1				#Avança ponteiro da matriz
	j 	readm_1

#Pecorre linha
readm_2:				
	addi	a0, a0, -1
	beq	a0, zero, readm_fim
	addi	a1, zero, 17
	j	readm_1
	
readm_fim:
	lb	a3,0(a2)			#Guarda o valor do pixel
	ret
	


	

#---------------  MORTO_VIVO-----------------#	
#INPUT:		a5 = contador de linhas				
#		a6 = contador de colunas
#		a4 = cópia de mat1
#OUTPUT:	a7 = determina quem vive ou morre (1 = vive, 0 = morre)
morto_vivo:
	mv	a2, s4
	addi	a7, zero, 0			#a7 = contador de vizinhos vivos, zero registrador
	
	addi	sp, sp, -4			#guradando endereço de retorno na pilha
	sw	ra, 0(sp)		

#vizinho 1, canto superior esquerdo	
viz1:
	mv	a2, s4				#recebe valor de endereço de mat1
	addi	a0, a5, -1			#linha de cima
	addi	a1, a6, -1			#coluna anterior
	call 	readm
	beq	a3, zero, viz2			
	addi	a7, a7, 1			#vive

#vizinho2, de cima
viz2:
	mv	a2, s4				#recebe valor de endereço de mat1
	addi	a0, a5, -1			#linha de cima
	addi	a1, a6, 0			#mesma coluna
	call 	readm
	beq	a3, zero, viz3
	addi	a7, a7, 1			

#vizinho3, canto superior direito
viz3:
	mv	a2, s4				#recebe valor de endereço de mat1
	addi	a0, a5, -1			#linha de cima
	addi	a1, a6, 1			#proxima coluna
	call 	readm
	beq	a3, zero, viz4
	addi	a7, a7, 1

#vizinho4, lado esquerdo
viz4:
	mv	a2, s4				#recebe valor de endereço de mat1
	addi	a0, a5, 0			# mesma linha
	addi	a1, a6, -1			# coluna anterior
	call 	readm
	beq	a3, zero, viz5
	addi	a7, a7, 1

#vizinho5, lado direito
viz5:
	mv	a2, s4				#recebe valor de endereço de mat1
	addi	a0, a5, 0			# mesma linha
	addi	a1, a6, 1			# coluna anterior
	call 	readm
	beq	a3, zero, viz6
	addi	a7, a7, 1

#vizinho 6, canto inferior esquerdo
viz6:
	mv	a2, s4				#recebe valor de endereço de mat1
	addi	a0, a5, 1			#linha abaixo
	addi	a1, a6, -1			#coluna anterior
	call 	readm
	beq	a3, zero, viz7			#se pular pra viz7, significa que morreu
	addi	a7, a7, 1			#vive

#vizinho7, debaixo
viz7:
	mv	a2, s4				#recebe valor de endereço de mat1
	addi	a0, a5, 1			#linha abaixo
	addi	a1, a6, 0			# mesma coluna
	call 	readm
	beq	a3, zero, viz8			#se pular, significa que morreu
	addi	a7, a7, 1			#vive

#vizinho8, canto inferior direito
viz8:
	mv	a2, s4				#recebe valor de endereço de mat1
	addi	a0, a5, 1			#linha abaixo
	addi	a1, a6, 1			#proxima coluna
	call 	readm
	beq	a3, zero, viz_fim		#se pular, significa que morreu
	addi	a7, a7,1			#vice
	
viz_fim:

	addi	t0, zero, 2			#2 vizinhos
	addi	t1, zero, 3			#3 vizinhos
	addi	t2, zero, 4			# 4 vizinhos
	
	lw 	ra,0(sp)			#Recuperando ra da pilha	
	addi	sp,sp,4
	
	beq	t1, a7, vive			#Checa se a7 tem 3 vizinhos em sua volta
	
	add	a0, zero, a5			# a0= contador de linhas
	add	a1, zero, a6			# a1= contador de colunas
	add	a2, zero, s4			# a2= valor do endereço de mat1
	
	addi	sp,sp,-4			#colocando endereço de retorno na pilha
	sw	ra, 0(sp)	
		
	call 	readm
	
	lw 	ra,0(sp)			#Recuperando ra da pilha	
	addi	sp,sp,4
	
	beq	a3, zero, morre			#verifica se a3 não é célula
#	blt	a3, t0, morre			#Se tiver menos de 2 vizinhos
#	bge	a3, t2, morre			#Se tiver >= 4 morre
	
	beq	t0, a7, vive			# Se tiver 2 vizinhos a célula vive
	
#Se tiver < de 2 e > de 3, a célula morre
morre:	
	addi	a7, zero, 0			#a7 torna 0 se a célula morrer na prox. geração
	ret	
	
vive:
	addi	a7, zero, 1			#a7 torna 1 se a célula viver na prox. geração
	ret
	


		



#---------------  ATUALIZA  -----------------#	
#	a0 = cópia do endereço da mat1
#	a1 = cópia do endereço da mat2

#inicialização de valores
atualiza:
	addi	a5, zero, 1			#a5 = contador de linhas				
	addi	a6, zero, 1			#a6 = contador de colunas
	addi	s9, zero, 17			#max de linhas e coluna

atualiza_1:
	beq	a6, s9, atualiza_2		#se colunas for igual a 17, pula pra pular linha
	lb	t0, 0(a1)
	sb	t0, 0(a0)	
	addi	a0, a0, 1			#anda a mat1
	addi	a1, a1, 1			#anda a mat2
	addi	a6, a6, 1 			#contador de colunas += 1	
	j	atualiza_1	

#contador de linhas
atualiza_2:
	beq	a5,s9, atualiza_fim		#se tiver dado as 16 linhas percorridas
	addi	a6, zero, 1			#inicializa o contador de colunas
	addi	a5, a5, 1			#contador de linhas += 1
	j	atualiza_1

atualiza_fim:
	ret

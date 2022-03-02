#Leia um inteiro do teclado e escreva-o na console. Termine o programa com a chamada do sistema.

#Obs: consultar o "Help" do RARS, aba Syscalls, para ver como realizar as chamadas do sistema para implementar as funções solicitadas.

.text
		#pegando o valor, tipo Scanf() em C
		li	a7, 5
		ecall	

		#printando
		li	a7, 1
		ecall

		#encerrando programa, "Program terminated by calling exit"
   		li a7, 10
   		ecall 
   		      

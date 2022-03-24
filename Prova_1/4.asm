# O mesmo da 1 porem com o menor valor ao invés da diferença.

.text

li a7, 6
ecall
fmv.x.s a1, fa0
ecall
fmv.x.s a2, fa0


li	a7, 5
ecall
add	a3, a3, a0
		
srli	a1, a1, 23
srli	a2, a2, 23
andi	a1, a1, 0xFF 
andi	a2, a2, 0xFF
addi	a1, a1, -127
addi	a2, a2, -127

blt a1, a2, menor_a1
j	menor_a2

menor_a1:
	mv a4, a1
	j main
menor_a2:
	mv a4, a2
	j main


main:
	mv	a1, a4	
	addi 	a2, t5, 2
	addi 	a0, t5, 2	
	blt	a4, zero, p1 #se A0 for negativo:
	jal 	p2		#se A0 for positivo:

p1:
	addi 	a1, a1, 1
	beq	a1, t5, end1
	mul	a0, a0, a2
	
	j	p1
	
			
p2:	
	addi 	a1, a1, -1
	beq	a1, zero, end2
	mul 	a0, a0, a2
	
	j	p2

end2:
mul  a0, a0, a3

li 	a7, 1
ecall
li 	a7, 10
ecall

end1:
div  a0, a3, a0

li 	a7, 1
ecall
li 	a7, 10
ecall


main:
		.data
str:	.asciiz "Hello World.\n"
		.text
		li $v0, 4
		la $a0, str
		
		or $t0, $0, $0
while:	slti $t1, $t0, 5
		beq $t1, $0, done
		
		syscall
		
		addi $t0, $t0, 1
		j while

done:
		
		li $v0, 10
		syscall
main:
		.data
str:	.asciiz "Hello World.\n"
		.text
		li $v0, 4
		la $a0, str
		
		or $t0, $0, $0
loop:		
		syscall
		
		addi $t0, $t0, 1
		slti $t1, $t0, 5
		bne $t1, $0, loop
		
		li $v0, 10
		syscall
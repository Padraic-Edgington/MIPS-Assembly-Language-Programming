main:
		.data
str:	.asciiz "Hello World.\n"
		.text
		li $v0, 4
		la $a0, str
		
		or $t0, $0, $0
loop:	slti $t1, $t0, 5
		beq $t1, $0, endloop
		
		syscall		# Print "Hello World.\n"
		
		addi $t0, $t0, 1
		j loop
		
endloop:
		
		li $v0, 10
		syscall
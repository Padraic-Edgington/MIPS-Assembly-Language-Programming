main:
		.data
str:	.asciiz "Hello World.\n"
		.text
		li $v0, 4					#  Put 4 into $v0 as the main parameter for syscall
		la $a0, str					#  Put the address of the hello world string into $a0
		syscall						#  Syscall #4 prints the string in $a0
		
		li $v0, 10					#  Put 10 into $v0 as the main paramter for syscall
		syscall						#  Syscall #10 quits the program
main:

		#  Initialize variables
		li		$t0, 0						#  Element counter
		li		$t1, 0						#  Mean counter
		li		$t2, 0						#  Covariance counter

		#  Do-While Loop
		.data
query:	.asciiz	"Enter an integer:  "
		.text
loop:	li		$v0, 4
		la		$a0, query
		syscall								#  Print "Enter an integer:  "
		
		li		$v0, 5
		syscall								#  Read the next integer
		
		blt		$v0, $zero, done
		
		addi	$t0, $t0, 1					#  Increment the element counter
		add		$t1, $t1, $v0				#  Add the read number to the mean counter

		j		loop



done:	div		$t1, $t1, $t0				#  Calculate the mean
		div		$t2, $t2, $t0				#  Calculate the covariance




		
		.data
mean:	.asciiz	"The mean is "
sd:		.asciiz	"The covariance is "
nl:		.asciiz	".\n"
		.text
		li		$v0, 4
		la		$a0, mean
		syscall								#  Print "The mean is "
		
		li		$v0, 1
		move	$a0, $t1
		syscall								#  Print the mean
		
		li		$v0, 4
		la		$a0, nl
		syscall								#  Print ".\n"
		
		la		$a0, sd
		syscall								#  Print "The covariance is "
		
		li		$v0, 1
		move	$a0, $t2
		syscall								#  Print the standard deviation
		
		li		$v0, 4
		la		$a0, sd
		syscall								#  Print ".\n"
#############################################################################################
#                                     I/O and Arithmetic									#
#																							#
#  Padraic Edgington                                                          27 Feb, 2014	#
#																							#
#  Calculates the sum of squared errors for four observations								#
#																							#
#  v. 1		Initial release																	#
#############################################################################################

		.data
S1:		.asciiz	"Enter the expected value:  "
S2:		.asciiz	"Enter the first observed value:  "
S3:		.asciiz	"Enter the second observed value:  "
S4:		.asciiz	"Enter the third observed value:  "
S5:		.asciiz	"Enter the fourth observed value:  "
S6:		.asciiz	"The SSE is "
S7:		.asciiz ".\n"
		.text

main:
#####  Begin by reading in the relevant data from the console. #####
	#  Print "Enter the expected value:  ".
	li		$v0, 4			#  System call #4 prints the string referenced in $a0.
	la		$a0, S1			#  The label (address) of the string to print.
	syscall					#  Perform a system call.
	
	#  Read the expected value as an integer.
	li		$v0, 5			#  System call #5 reads an integer from the console into $v0.
	syscall					#  Perform a system call.
	move	$t0, $v0		#  Store the read integer into $t0.
	
	
	
	#  Print "Enter the first observed value:  ".
	li		$v0, 4			#  System call #4 prints the string referenced in $a0.
	la		$a0, S2			#  The label (address) of the string to print.
	syscall					#  Perform a system call.
	
	#  Read the first observation as an integer.
	li		$v0, 5			#  System call #5 reads an integer from the console into $v0.
	syscall					#  Perform a system call.
	move	$t1, $v0		#  Store the read integer into $t1
	
	
	
	#  Print "Enter the second observed value:  ".
	li		$v0, 4			#  System call #4 prints the string referenced in $a0.
	la		$a0, S3			#  The label (address) of the string to print.
	syscall					#  Perform a system call.
	
	#  Read the second observation as an integer.
	li		$v0, 5			#  System call #5 reads an integer from the console into $v0.
	syscall					#  Perform a system call.
	move	$t2, $v0		#  Store the read integer into $t2
	
	
	
	#  Print "Enter the third observed value:  ".
	li		$v0, 4			#  System call #4 prints the string referenced in $a0.
	la		$a0, S4			#  The label (address) of the string to print.
	syscall					#  Perform a system call.
	
	#  Read the third observation as an integer.
	li		$v0, 5			#  System call #5 reads an integer from the console into $v0.
	syscall					#  Perform a system call.
	move	$t3, $v0		#  Store the read integer into $t3
	
	
	
	#  Print "Enter the fourth observed value:  ".
	li		$v0, 4			#  System call #4 prints the string referenced in $a0.
	la		$a0, S5			#  The label (address) of the string to print.
	syscall					#  Perform a system call.
	
	#  Read the fourth observation as an integer.
	li		$v0, 5			#  System call #5 reads an integer from the console into $v0.
	syscall					#  Perform a system call.
	move	$t4, $v0		#  Store the read integer into $t4.
	
	
	
#####  Compute the sum of squared errors for the provided data.  #####
	#  x_0
	sub		$t9, $t0, $t1	#  \mu - x_0				$t9 = $t0 - $t1
	mul		$t8, $t9, $t9	#  (\mu - x_0)^2			$t8 = $t9 * $t9
	#  x_1
	sub		$t9, $t0, $t2	#  \mu - x_1				$t9 = $t0 - $t2
	mul		$t9, $t9, $t9	#  (\mu - x_1)^2			$t9 = $t9 * $t9
	add		$t8, $t8, $t9	#  (\mu - x_0)^2 + (\mu -x_1)^2		$t8 = $t8 + $t9
	#  x_2
	sub		$t9, $t0, $t3	#  \mu - x_2				$t9 = $t0 - $t3
	mul		$t9, $t9, $t9	#  (\mu - x_2)^2			$t9 = $t9 * $t9
	add		$t8, $t8, $t9	#  SSE(x_0, x_1, x_2)		$t8 = $t8 + $t9
	#  x_3
	sub		$t9, $t0, $t4	#  \mu - x_3				$t9 = $t0 - $t4
	mul		$t9, $t9, $t9	#  (\mu - x_3)^2			$t9 = $t9 * $t9
	add		$t8, $t8, $t9	#  SSE(x_0, x_1, x_2, x_3)	$t8 = $t8 * $t8
	
	
	
#####  Display the results.  #####
	#  Print "The SSE is ".
	li		$v0, 4			#  System call #4 prints the string referenced in $a0.
	la		$a0, S6			#  The label (address) of the string to print.
	syscall					#  Perform a system call.
	
	#  Print the SSE.
	li		$v0, 1			#  System call #1 prints the integer in $a0.
	move	$a0, $t8		#  Use $t8 as the parameter for the syscall.
	syscall
	
	#  Print ".\n".
	li		$v0, 4			#  System call #4 prints the string referenced in $a0.
	la		$a0, S7			#  The label (address) of the string to print.
	syscall					#  Perform a system call.
	
	
#####  Exit the program.  #####
	li		$v0, 10			#  System call #10 exits the program.
	syscall					#  Perform a system call.

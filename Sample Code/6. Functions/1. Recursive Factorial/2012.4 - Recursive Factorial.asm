#  Recursive factorial program
#########################
#  Factorial procedure  #
#########################
fact:	li		$t0, 2
		bge		$a0, $t0, recurs	# if n >= 2 go to L1
		
		#  If n <= 1, return 1
		li		$v0, 1				# set value register to 1
		jr		$ra
		
		#  If n >= 2, then recursion is needed
recurs:	
		#  Save parameters on the stack
		addi	$sp, $sp, -8		# adjust stack for 2 items
		sw		$ra, 4($sp)			# save the return address
		sw		$a0, 0($sp)			# save my argument n
		
		#  call factorial again with n=n-1
		addi	$a0, $a0, -1		# decrement n by 1
		jal		fact				# call factorial with n=n-1
		
		#  Once finished...
		lw		$a0, 0($sp)			# restore my argument n
		lw		$ra, 4($sp)			# restore the return address
		addi	$sp, $sp, 8			# pop two items off the stack
		
		mul		$v0, $v0, $a0		# result = fact(n-1) * n
		
		jr		$ra					# return to caller
	


######################
#  Driver Procedure  #
######################	
		
main:
		#  Step #1:  Query the user for an integer.
		.data
query:	.asciiz "Enter an integer:  "
		.text
		li		$v0, 4
		la		$a0, query
		syscall						# Print string
		
		li		$v0, 5
		syscall
		move	$s0, $v0			# Save input in $s0
		
		# Step #2:  Use a recursive algorithm to calculate the factorial of the integer.
		move	$a0, $s0			# store the number to be calculated in $a0.
		jal		fact				# call factorial with n=$s0
		move	$s1, $v0			# store the result in $s1

		# Step #3:  Display the result
		.data
res1:	.asciiz "! = "
res2:	.asciiz "\n"
		.text
		li		$v0, 1
		move	$a0, $s0
		syscall						# Print the given integer
		
		li		$v0, 4
		la		$a0, res1
		syscall						# Print the result string
		
		li		$v0, 1
		move	$a0, $s1
		syscall						# Print the factorial result
		
		li		$v0, 4
		la		$a0, res2
		syscall						# Print a new line character
		
		
		# Step #4:  Exit
		li		$v0, 10
		syscall						# Exit
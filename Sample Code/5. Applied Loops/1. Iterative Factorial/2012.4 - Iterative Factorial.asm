#  Iterative factorial program

main:

		#  Step #1:  Query the user for an integer.
		.data
query:	.asciiz "Enter an integer:  "
		.text
		li	$v0, 4
		la $a0, query
		syscall					# Print string
		
		li $v0, 5
		syscall
		move $s0, $v0			# Save input in $s0
		
		# Step #2:  Use an iterative algorithm to calculate the factorial of the integer.
		li $s1, 1				# Result is in $s1
		li $t0, 1				# Iterator count is in $t0
loop:	beq $t0, $s0, end
		addi $t0, $t0, 1		# counter++
		mul $s1, $s1, $t0		# result *= counter
		j loop
end:	

		# Step #3:  Display the result
		.data
res1:	.asciiz "! = "
res2:	.asciiz "\n"
		.text
		li $v0, 1
		move $a0, $s0
		syscall					# Print the given integer
		
		li $v0, 4
		la $a0, res1
		syscall					# Print the result string
		
		li $v0, 1
		or $a0, $s1
		syscall					# Print the factorial result
		
		li $v0, 4
		la $a0, res2
		syscall					# Print a new line character
		
		
		# Step #4:  Exit
		li $v0, 10
		syscall					# Exit
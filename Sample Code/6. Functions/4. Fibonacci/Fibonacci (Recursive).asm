#############################################################################################
#                                        Function Calls										#
#																							#
#  Padraic Edgington                                                          15 Oct, 2013	#
#																							#
#  Recursively calculates the value of a given Fibonacci number.							#
#																							#
#  Functions:																				#
#  fibonacci:	Calculates the Fibonacci number for the given index.						#
#																							#
#  v. 1		Initial release																	#
#############################################################################################


		#  fibonacci
		#
		#		Takes an index and returns the corresponding Fibonacci number from the series.
		#
		#  Parameters:
		#		$a0:  an unsigned integer index
		#
		#  Results:
		#		$v0:  an unsigned integer Fibonacci number
		#####################################################################################
fibonacci:
		#  Check termination conditions
		#  F(0) = 0
		#  F(1) = 1
		li		$t0, 1
		bgt		$a0, $t0, recurse			#  If the index is greater than 1, then calculate
											#  the solution recursively.
		bne		$a0, $zero, one				#  If the index is zero...
		li		$v0, 0						#    return zero.
		jr		$ra
		
one:	li		$v0, 1						#  If the index is one, return 1.
		jr		$ra

		#  F(x) = F(x-1) + F(x-2)
recurse:
		addi	$sp, $sp, -12				#  Allocate space on the stack for 3 integers.
		sw		$ra, 8 ($sp)				#  $sp+8 <= $ra
		sw		$a0, 4 ($sp)				#  $sp+4 <= Fibonacci index
		
		addiu	$a0, $a0, -1				#  x-1
		jal		fibonacci					#  F(x-1)
		sw		$v0, 0 ($sp)				#  $sp+0 <= F(x-1)
		
		lw		$a0, 4 ($sp)				#  Restore our original parameter.
		addi	$a0, $a0, -2				#  x-2
		jal		fibonacci					#  F(x-2)
		
		lw		$t0, 0 ($sp)				#  $t0 <= F(x-1)
		addu	$v0, $t0, $v0				#  $v0 <= F(x-1) + F(x-2)
		
		lw		$ra, 8 ($sp)				#  Restore the return address.
		addi	$sp, $sp, 12				#  Deallocate our space on the stack.
		jr		$ra
		
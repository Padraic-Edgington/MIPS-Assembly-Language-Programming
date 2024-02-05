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
		bgtz	$a0, loop					#  If the index is greater than 0, then calculate
											#  the solution iteratively.
		li		$v0, 0						#  If the index is zero...
		jr		$ra							#    return zero.
		
		#  F(x) = F(x-1) + F(x-2)
loop:
		li		$t0, 0						#  F(0) = 0
		li		$t1, 1						#  F(1) = 1
		li		$t2, 1						#  index = 1
test:	bge		$t2, $a0, return			#  Once the series has been calculated through the $a0'th
											#  Fibonacci number, then we are done.
											
		xor		$t1, $t0, $t1
		xor		$t0, $t0, $t1
		xor		$t1, $t0, $t1				#  Swap $t0 and $t1
		addu	$t1, $t0, $t1				#  F(x) = F(x-2) + F(x-1)
		
		addi	$t2, $t2, 1					#  index += 1
		j		test

return:	move	$v0, $t1					#  Copy the result to $v0.
		jr		$ra							#  return to calling function.
		
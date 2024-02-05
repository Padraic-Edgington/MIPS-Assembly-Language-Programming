power:	bne		$a1, $zero, recursion			#  If the power is greater than 1, then do some recursion.
		li		$v0, 1							#  Otherwise, return 1.
		jr		$ra
recursion:
		addi	$sp, $sp, -4					#  Allocate space for one integer on the stack.
		sw		$ra, 0 ($sp)					#  Store the return address on the stack.
		addi	$a1, $a1, -1					#  Decrement the power by 1.
		jal		power							#  Call the power function with the new parameters.
		mul		$v0, $a0, $v0					#  Multiply the result by the base and save it as the new result.
		lw		$ra, 0 ($sp)					#  Restore the return address from the stack.
		addi	$sp, $sp, 4						#  Deallocate the memory on the stack.
		jr		$ra								#  Return to the calling function.
		
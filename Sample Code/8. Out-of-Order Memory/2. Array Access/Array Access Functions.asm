


#############################################################################################
#                                Array Access Functions										#
#																							#
#  Padraic Edgington                                                          3 Apr 2015	#
#																							#
#  Functions:																				#
#  get:		Returns the value in the specified array cell.									#
#  set:		Changes the value in the specified array cell.									#
#																							#
#  v. 1		Initial release  (It appears to work.)											#
#############################################################################################



#############################################################################################
#  get																						#
#    Returns the value in the specified array cell.											#
#																							#
#  Parameters:																				#
#    $a0:  A pointer to an array/vector.													#
#    $a1:  The element to read from. 														#
#  Return values:																			#
#    $v0:  The data contained in the specified array cell.									#
#############################################################################################
get:	#  Check for a valid array and cell.
		addi	$sp, $sp, -4
		sw		$ra, 0 ($sp)
		jal		array_check
		lw		$ra, 0 ($sp)
		addi	$sp, $sp, 4
		#  If the test fails, return the failure code.
		beqz	$v0, get_data
		jr		$ra
		
get_data:
		addi	$t0, $a1, 1
		sll		$t0, $t0, 2
		add		$t0, $a0, $t0
		lw		$v0, 0 ($t0)
		jr		$ra
		
		
#############################################################################################
#  set																						#
#    Changes the value in the specified array cell.											#
#																							#
#  Parameters:																				#
#    $a0:  A pointer to an array/vector.													#
#    $a1:  The element to store to. 														#
#    $a2:  The value to set the cell to.													#
#############################################################################################
set:	#  Check for a valid array and cell.
		addi	$sp, $sp, -4
		sw		$ra, 0 ($sp)
		jal		array_check
		lw		$ra, 0 ($sp)
		addi	$sp, $sp, 4
		#  If the test fails, return the failure code.
		beqz	$v0, set_data
		jr		$ra
		
set_data:
		addi	$t0, $a1, 1
		sll		$t0, $t0, 2
		add		$t0, $a0, $t0
		sw		$a2, 0 ($t0)
		jr		$ra
		
		
		
		
#############################################################################################
#  array_check																				#
#    Checks to make sure that the array is valid and access is within bounds.				#
#																							#
#  Parameters:																				#
#    $a0:  A pointer to an array/vector.													#
#    $a1:  The element to access.	 														#
#############################################################################################
array_check:
		#  1.  Check for a valid array object.
		#      It should be a pointer to the data region of memory.
		lui		$t0, 0x1000								#  All data should be above 0x1000 0000 and not negative.
		blt		$a0, $t0, AC_fail
		#      It should also be word aligned, since the first value is an integer.
		li		$t0, 0xFFFFFFFC
		and		$t0, $a0, $t0						#  Set the last two bits to zero, to force it to be word aligned.
		bne		$a0, $t0, AC_fail						#  The results should be equal.
		#  2.  Check for a valid array size.
		#      It should be a natural (n>0) number.
		lw		$t0, 0 ($a0)
		blez	$t0, AC_fail
		#      There should be enough room in memory for the entire array.
		addi	$t0, $t0, 1								#  Add 1 to account for the length.
		sll		$t0, $t0, 2								#  Convert max index size to bytes.
		addu	$t0, $t0, $a0							#  Add that to the base address, making overflow produce a negative number.
		blt		$t0, $a0, AC_fail						#  The result should be greater than the base address.
		#  3.  Check for a valid array index.
		#      It should be a positive (n>=0) number.
		bltz	$a1, AC_fail
		#      It should be strictly less than the size of the array.
		lw		$t0, 0 ($a0)
		bge		$a1, $t0, AC_fail
		#  4.  The array should not cross memory boundaries.
		#      The array should not cross from the heap to the stack.
		bge		$a0, $sp, AC1							#  If the array is on the stack, then we don't have this problem.
		lw		$t0, 0 ($a0)
		addi	$t0, $t0, 1								#  Add 1 to include the length variable.
		sll		$t0, $t0, 2								#  Convert max index to bytes.
		addu	$t0, $t0, $a0							#  Add that to the base address, making overflow produce a negative number.
		bgt		$t0, $sp, AC_fail						#  The result should not enter the stack.
		#      The array should not cross from static memory to dynamic memory.
AC1:

		#  I've run out of insane conditions to consider...
		li		$v0, 0
		jr		$ra
		
		
AC_fail:#  The object is somehow damaged and should not be used.
		li		$v0, 0x80000001
		jr		$ra
		
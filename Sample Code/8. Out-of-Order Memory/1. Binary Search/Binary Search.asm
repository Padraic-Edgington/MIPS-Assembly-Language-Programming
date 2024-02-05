#######################
#  Binary Search      #
#  Padraic Edgington  #
#  March 6, 2013      #
#######################

		#
		#  Binary search function
		#
		#  Parameters:
		#  $a0:  The address of the tree
		#  $a1:  The integer to search for
		#  Results:
		#  $v0:  The index of the integer if found (starting from 1) or zero
		#		 if not found
		#
		#  This function searches a tree for an integer.  If the integer is
		#  found, it returns the index of the integer, otherwise it returns
		#  zero.  The index is runs from 1 to length.  If provided with bad
		#  input, the function return -1.
		#######################################################################
Binary_Search:
		#  Check parameters for usability
		ble		$a0, $zero, BSFail	#  If the address is zero or negative, then fail
		li		$t0, 4
		div		$a0, $t0
		mfhi	$t0
		bne		$t0, $zero, BSFail	#  If the address is not a multiple of four, then fail
		lw		$t0, 0 ($a0)
		ble		$t0, $zero, BSFail	#  If the size of the tree is less than 1, then fail

		li		$t1, 0x7FFFFFFF		#  Top of memory
		sll		$t0, $t0, 2
		addu	$t0, $a0, $t0		#  The size of the tree
		bgtu	$t0, $t1, BSFail	#  If the address of the last cell is outside of memory, then fail
		
		#  Search the tree for the integer
		addi	$sp, $sp, -12
		sw		$s0, 0 ($sp)
		sw		$s1, 4 ($sp)
		sw		$s2, 8 ($sp)
		addi	$s0, $a0, 4			#  The first element of the tree
		lw		$s1, 0 ($a0)		#  Get the size of the tree
		li		$s2, 1				#  Base address for current search
		
		#  Search loop to divide the array into halves and search each half
BSLoop:	beq		$s1, $zero, BSNo	#  If the size of the tree is zero, then the query couldn't be found
		li		$t0, 2
		div		$s1, $t0
		mflo	$t0					#  Find the midpoint of the tree
		sll		$t1, $t0, 2
		add		$t1, $t1, $s0		#  The address of the root of the tree
		lw		$t2, 0 ($t1)		#  The integer at the root of the tree
		blt		$t2, $a1, BSHi		#  If the root is less than the query, then search the right half of the tree
		bgt		$t2, $a1, BSLo		#  If the root is greater than the query, then search the left half of the tree
		
		#  Successfully found the queried integer
		add		$v0, $s2, $t0		#  The element is at the base index + the index of the root
		j		BSCleanup
		
		#  Search the left side of the tree
BSLo:								#  The left side starts at the same place
		move	$s1, $t0			#  The size of the left side is floor(size/2)
									#  The base index is still the same
		j		BSLoop				#  Search the left side
		
		#  Search the right side of the tree
BSHi:	addi	$s0, $t1, 4			#  The right side starts at root+1
		addi	$t0, $t0, 1			#  Size of the left side + the root node
		sub		$s1, $s1, $t0		#  Calculate the size of the right side as
									#    size - left - root node
		add		$s2, $s2, $t0		#  Calculate the base index of the right side as
									#    base + left + root node
		j		BSLoop				#  Search the right side
		
		
		#  If the query couldn't be found, return 0
BSNo:	li		$v0, 0
		j		BSCleanup
		
		
		#  If provided with a bad tree, return -1
BSFail:	li		$v0, -1
		jr		$ra
		
		
		#  When finished, restore the original saved registers
BSCleanup:
		lw		$s0, 0 ($sp)
		lw		$s1, 4 ($sp)
		lw		$s2, 8 ($sp)
		addi	$sp, $sp, 12
		jr		$ra
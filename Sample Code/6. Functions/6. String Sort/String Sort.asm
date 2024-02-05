#############################################################################################
#                                 	Recursion & Objects										#
#																							#
#  Padraic Edgington                                                          8 Apr, 2014	#
#																							#
#  sort:																					#
#  This function takes a list of strings and sorts them according to the alphabetical		#
#  order rules of English.																	#
#  This function returns -1 if the parameter was invalid.									#
#																							#
#  Parameters:																				#
#  $a0		A pointer to a list of strings.													#
#																							#
#  Return Values:																			#
#  $v0		A pointer to the first string in the sorted list.								#
#																							#
#  v. 1		Initial release																	#
#############################################################################################


		.text
sort:	#  Check for a valid parameter.
		blt		$a0, 0x10000000, BadParameter		#  A pointer to data should be in the data segment of memory.
		srl		$a1, $a0, 2
		sll		$a1, $a1, 2
		bne		$a0, $a1, BadParameter				#  A pointer should be divisible by 4.  (The last two bits are 0.)
		
		#  If ( next == null ) then the list is already sorted.
		lw		$t0, 4 ($a0)
		bne		$t0, $zero, SortRecursion
		
		move	$v0, $a0
		jr		$ra
		
SortRecursion:
		#  Store the parameter and return address on the stack.
		addi	$sp, $sp, -8
		sw		$a0, 0 ($sp)
		sw		$ra, 4 ($sp)
		
		#  Recursive sort call.
		lw		$a0, 4 ($a0)
		jal		sort
		
		#  Insertion call.
		lw		$a0, 0 ($sp)
		sw		$0,  4 ($a0)
		move	$a1, $v0
		jal		insert
		
		#  Restore the return address and pop the stack.
		lw		$ra, 4 ($sp)
		addi	$sp, $sp, 8
		
		jr		$ra
		
BadParameter:
		#  If the parameter is invalid, then return -1
		li		$v0, -1
		jr		$ra
		
		
		
		
insert:	#  If the second list is empty, then the first list is already sorted.
		bne		$a1, $zero, Insertion
		
		move	$v0, $a0
		jr		$ra
		
Insertion:
		#  Store the parameters and return address on the stack.
		addi	$sp, $sp, -12
		sw		$a0, 0 ($sp)		#  inserting element
		sw		$a1, 4 ($sp)		#  list
		sw		$ra, 8 ($sp)		#  return address
		
		
		#  Compare the two strings.
		lw		$a0, 0 ($a0)		#  l.data
		lw		$a1, 0 ($a1)		#  m.data
		jal		StringCompare
		
		bge		$v0, $zero, InsertRecursion
		
		#  The new string should be placed at the front of the list.
		lw		$v0, 0 ($sp)		#  inserting element
		lw		$a1, 4 ($sp)		#  list
		sw		$a1, 4 ($v0)
		
		lw		$ra, 8 ($sp)
		addi	$sp, $sp, 12
		jr		$ra
		
InsertRecursion:
		#  The first element in the list precedes the new element in alphabetical order.
		lw		$a0, 0 ($sp)		#  inserting element
		lw		$a1, 4 ($sp)		#  list
		lw		$a1, 4 ($a1)		#  next element in the list
		
		jal		insert
		
		lw		$a1, 4 ($sp)		#  next element in the list
		sw		$v0, 4 ($a1)		#  attach sorted list to new head
		move	$v0, $a1			#  Return the head of the given list.
		
		lw		$ra, 8 ($sp)
		addi	$sp, $sp, 12
		jr		$ra
		
		
		
		
		
StringCompare:
		#  Use the prebuilt character comparison function to determine which of the two strings precedes the other in alphabetical order.
		#  Return -1 if $a0 < $a1, 0 if $a0 == $a1 and +1 if $a0 > $a1.
		#  Return 0x8000 0000 if one or more of the strings is malformed.
		
		addi	$sp, $sp, -12
		sw		$s0, 0 ($sp)
		sw		$s1, 4 ($sp)
		sw		$ra, 8 ($sp)
		
		move	$s0, $a0
		move	$s1, $a1
		
SCloop:	lbu		$a0, 0 ($s0)
		lbu		$a1, 0 ($s1)
		
		beqz	$a0, temp
		beqz	$a1, SC2
		
		jal		compare
		
		beq		$v0, 0, SC0		#  $a0 < $a1
		beq		$v0, 1, SC1		#  $a0 = $a1; increment both strings
		beq		$v0, 2, SC2		#  $a0 > $a1
		beq		$v0, 3, SC3		#  Increment $a0 alone
		beq		$v0, 4, SC4		#  Increment $a1 alone
		beq		$v0, 5, SC1		#  Increment both strings
		
temp:	beqz	$a1, SC1b
		j		SC0
		
		#  $a0 < $a1; return -1
SC0:	li		$v0, -1
		
		lw		$s0, 0 ($sp)
		lw		$s1, 4 ($sp)
		lw		$ra, 8 ($sp)
		addi	$sp, $sp, 12
		jr		$ra
		
		#  $a0 = $a1; increment both strings
SC1:	addi	$s0, $s0, 1
		addi	$s1, $s1, 1
		
		j		SCloop
	
		#  $a0 = $a1; return 0
SC1b:	li		$v0, 0
		
		lw		$s0, 0 ($sp)
		lw		$s1, 4 ($sp)
		lw		$ra, 8 ($sp)
		addi	$sp, $sp, 12
		jr		$ra
		
		#  $a0 > $a1; return +1
SC2:	li		$v0, 1
		
		lw		$s0, 0 ($sp)
		lw		$s1, 4 ($sp)
		lw		$ra, 8 ($sp)
		addi	$sp, $sp, 12
		jr		$ra
		
		#  Invalid character in $a0; increment
SC3:	addi	$s0, $s0, 1

		j		SCloop
		
		#  Invalid character in $a1; increment
SC4:	addi	$s1, $s1, 1

		j		SCloop
		
		

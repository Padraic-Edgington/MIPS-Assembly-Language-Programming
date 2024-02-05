


#############################################################################################
#                                 Sudoku Solving Function									#
#																							#
#  Padraic Edgington                                                          27 Oct, 2014	#
#																							#
#  Functions:																				#
#  Sudoku_solver:		Takes a 9x9 array of integers and attempts to solve it using a		#
#						depth first search algorithm.										#
#																							#
#  v. 1		Initial release  (It appears to work.)											#
#############################################################################################


		#  Sudoku_solver
		#
		#      Takes a 9x9 array of integers and attempts to solve it using a
		#  depth first search algorithm.  The algorithm returns a completed
		#  array if it is possible to solve the given problem.  If the current
		#  problem is not solvable, then it returns a null pointer.
		#
		#  Parameters:
		#    $a0:  A pointer to a 9x9 array of integers.
		#
		#  Results:
		#    $v0:  The solved array if successful; a null pointer if unsuccessful.
		#######################################################################
Sudoku_solver:
		#  Test for a valid parameter in $a0.
		#  The array should either be on the stack on the heap.
		blt		$a0, 0x10008000, SS_BadParameter
		bgtu	$a0, 0x7FFFFFDC, SS_BadParameter
		#  The array should be composed of integers and thus word aligned.
		sll		$t0, $a0, 30					#  Shift off everything except the last two bits.
		bne		$t0, $0, SS_BadParameter		#  Now, all the bits should be zero.
		#  The array should consist of values between 0 and 9.
		li		$t0, 0
		li		$t1, 0
		li		$t9, 9
SS_Param_Loop:
		sll		$t2, $t0, 2
		add		$t2, $a0, $t2
		lw		$t2, 0 ($t2)					#  Fetch the address of a sub-array.
		blt		$t2, 0x10008000, SS_BadParameter	#  Memory range check for the sub-array.
		bgtu	$t2, 0x7FFFFFDC, SS_BadParameter
		sll		$t3, $t2, 30
		bnez	$t3, SS_BadParameter
		sll		$t3, $t1, 2
		add		$t2, $t2, $t3
		lw		$t2, 0 ($t2)					#  Fetch the cell value.
		bgtu	$t2, $t9, SS_BadParameter		#  Range check for the cell value.
		addi	$t1, $t1, 1
		blt		$t1, $t9, SS_Param_Loop
		li		$t1, 0
		addi	$t0, $t0, 1
		blt		$t0, $t9, SS_Param_Loop
		
		
		
########  Find an unknown cell by iterating over all the cells.
		li		$t0, 0							#  Row counter
		li		$t1, 0							#  Column counter
		li		$t2, 9							#  The number 9
SS_Search_loop:
		#  Fetch g[i]
		sll		$t3, $t0, 2						#  $t3 =  ix4
		add		$t3, $t3, $a0					#  $t3 = &g[i]
		lw		$t3, 0 ($t3)					#  $t3 =  g[i]
		#  Fetch g[i][j]
		sll		$t4, $t1, 2						#  $t4 =  jx4
		add		$t3, $t3, $t4					#  $t3 = &g[i][j]
		lw		$t3, 0 ($t3)					#  $t3 =  g[i][j]
		#  Check for empty cell
		beq		$t3, $zero, SS_empty_cell		#  If this is an empty cell, then process it.
		
		addi	$t1, $t1, 1
		bne		$t1, $t2, SS_Search_loop		#  Iterate over the columns.
		li		$t1, 0
		addi	$t0, $t0, 1
		bne		$t0, $t2, SS_Search_loop		#  Iterate over the rows.
		
		
		#  No empty cells means this is a solved Sudoku problem.
		move	$v0, $a0						#  Return the current parameter.
		jr		$ra
		
SS_empty_cell:
		#  Initialize the stack.
		#    Need space for the return address, list of available values
		addi	$sp, $sp, -20					#  Allocate space for two addresses.
		sw		$t1, 16 ($sp)					#  Store j
		sw		$t0, 12 ($sp)					#  Store i
		sw		$ra,  8 ($sp)					#  Store the return address.
		sw		$s1,  4 ($sp)					#  Store the old value of $s1.
		sw		$s0,  0 ($sp)					#  Store the old value of $s0.
		
		move	$s0, $a0						#  Saving the grid in $s0
												#  Saving the linked list of available values in $s1
												
#########  Pick a possible number for the cell.
		
		#  Create a linked list of available values for the current cell.
		li		$a0, 1							#  Possible value iterator.
		jal		SS_LLN_Constructor				#  Create the head node.
		move	$s1, $v0						#  Save the pointer to the head of the list.
		move	$t3, $v0						#  Storing the most recent node in $t3
SS_LL_loop:
		addi	$a0, $a0, 1						#  Increment the counter
		jal		SS_LLN_Constructor				#  Create the next node.
		sw		$v0, 4($t3)						#  Link the previous node to the new node.
		move	$t3, $v0						#  Storing the most recent node in $t3
		blt		$a0, $t2, SS_LL_loop			#  Quit once all 9 nodes have been constructed.
		
		
		
		#  Searching for used numbers. 
		li		$t3, 0
SS_used_loop:
#########  Check for used numbers in the same row.
		sll		$t4, $t0, 2						#  $t4 =  ix4
		add		$t4, $t4, $s0					#  $t4 = &g[i]
		lw		$t4, 0 ($t4)					#  $t4 =  g[i]
		sll		$t5, $t3, 2						#  $t5 =  kx4
		add		$t4, $t4, $t5					#  $t4 = &g[i][k]
		lw		$a1, 0 ($t4)					#  $a1 =  g[i][k]
		beq		$a1, $zero, SS_Check_Column		#  If the cell is empty, don't bother trying to remove it.
		move	$a0, $s1						#  Head of the linked list
		jal		SS_LLN_Remove					#  Remove the element from the linked list
		move	$s1, $v0						#  Save the updated linked list.
		
#########  Check for used numbers in the same column.
SS_Check_Column:
		sll		$t4, $t3, 2						#  $t4 =  kx4
		add		$t4, $t4, $s0					#  $t4 = &g[k]
		lw		$t4, 0 ($t4)					#  $t4 =  g[k]
		sll		$t5, $t1, 2						#  $t5 =  jx4
		add		$t4, $t4, $t5					#  $t4 = &g[k][j]
		lw		$a1, 0 ($t4)					#  $a1 =  g[k][j]
		beq		$a1, $zero, SS_Check_Next		#  If the cell is empty, don't bother trying to remove it.
		move	$a0, $s1						#  Head of the linked list
		jal		SS_LLN_Remove					#  Remove the element from the linked list
		move	$s1, $v0						#  Save the updated linked list.
		
SS_Check_Next:
		addi	$t3, $t3, 1						#  k++
		blt		$t3, $t2, SS_used_loop			#  If (k < 9) go through the loop again
		
#########  Check for used numbers in the same subgrid.
		li		$t3, 3
		div		$t8, $t0, $t3					#  i_grid =    i/3
		mul		$t8, $t8, $t3					#  i_grid = 3x(i/3)
		div		$t9, $t1, $t3					#  j_grid =    j/3
		mul		$t9, $t9, $t3					#  j_grid = 3x(j/3)
		
		li		$t4, 0							#  k
		li		$t5, 0							#  l
SS_Grid_Search:
		add		$t6, $t4, $t8					#     k+i_grid
		sll		$t6, $t6, 2						#  4x(k+i_grid)
		add		$t6, $t6, $s0					#  &g[k+i_grid]
		lw		$t6, 0 ($t6)					#   g[k+i_grid]
		add		$t7, $t5, $t9					#     l+j_grid
		sll		$t7, $t7, 2						#  4x(l+j_grid)
		add		$t6, $t6, $t7					#  &g[k+i_grid][l+j_grid]
		lw		$a1, 0 ($t6)					#   g[k+i_grid][l+j_grid]
		beq		$a1, $zero, SS_GS_Next			#  If the cell is empty, don't bother trying to remove it.
		move	$a0, $s1						#  Head of the linked list
		jal		SS_LLN_Remove					#  Remove the element from the linked list
		move	$s1, $v0						#  Save the updated linked list.
		
SS_GS_Next:
		addi	$t5, $t5, 1						#  l++
		blt		$t5, $t3, SS_Grid_Search		#  for (l=0; l < 3; l++)
		li		$t5, 0							#  l=0
		addi	$t4, $t4, 1						#  k++
		blt		$t4, $t3, SS_Grid_Search		#  for (k=0; k < 3; k++)
		
		
#########  Assign the first available number to the current cell.
SS_Assign_Loop:
		beq		$s1, $zero, SS_Unsolvable		#  If there are no available values for the current cell,
												#      then the grid is unsolvable.
		lw		$t3, 0 ($s1)					#  Get first available value
		lw		$s1, 4 ($s1)					#  Pass or fail, we're done with this element, move up the
												#      next one.
		sll		$t4, $t0, 2						#  $t4 =  ix4
		add		$t4, $t4, $s0					#  $t4 = &g[i]
		lw		$t4, 0 ($t4)					#  $t4 =  g[i]
		sll		$t5, $t1, 2						#  $t5 =  jx4
		add		$t4, $t4, $t5					#  $t4 = &g[i][j]
		sw		$t3, 0 ($t4)					#  g[i][j] = first available value
		move	$a0, $s0						#  Copy the grid pointer to the parameter
		jal		Sudoku_solver					#  Recursion!
		lw		$t0, 12 ($sp)					#  Restore i
		lw		$t1, 16 ($sp)					#  Restore j
		beq		$v0, $zero, SS_Assign_Loop		#  If we generated an unsolvable problem, then try the
												#  next available value.
#########  We've found a solution!
		
		#  Clean up and return to the calling function.
SS_Completed:
		lw		$ra,  8 ($sp)					#  Restore the return address
		lw		$s1,  4 ($sp)					#  Restore the old value of $s1.
		lw		$s0,  0 ($sp)					#  SResore the old value of $s0.
		addi	$sp, $sp, 20					#  Pop the stack
		addi	$gp, $gp, -72					#  Clearing the available list from the heap.
												#  This only works because it has been allocated like a
												#  stack.  In a better system, we'd have a deconstructor
												#  function.
		jr		$ra								#  Return to the calling function
		
SS_Unsolvable:									#  The provided grid was unsolvable
		sll		$t4, $t0, 2						#  $t4 =  ix4
		add		$t4, $t4, $s0					#  $t4 = &g[i]
		lw		$t4, 0 ($t4)					#  $t4 =  g[i]
		sll		$t5, $t1, 2						#  $t5 =  jx4
		add		$t4, $t4, $t5					#  $t4 = &g[i][j]
		sw		$zero, 0 ($t4)					#  Mark the failed cell as available again
		li		$v0, 0							#  Return the value 0 indicating that this attempt failed
		j		SS_Completed					#  Clean up and return to the calling function
		
SS_BadParameter:
		li		$v0, 0
		jr		$ra

		
		
		#  
		#  Linked List Node Constructor
		#
		#  Parameters
		#  $a0:  Data
		#
		#  Return Value
		#  $v0:  Address of the node
		######################################################################
SS_LLN_Constructor:
		sw		$a0, 0 ($gp)						#  Store the data.
		move	$v0, $gp							#  Copy the pointer to the return value register.
		addi	$gp, $gp, 8							#  Mark the memory as allocated on the heap.
		jr		$ra									#  Return to calling function.
		
		#
		#  Linked List Node Removal
		#    A tail recursive algorithm to iteratively search the linked list
		#  for nodes matching the provided value and remove them.
		#
		#  Parameters
		#  $a0:  Head of the array
		#  $a1:  Data to remove
		#
		#  Return Value
		#  $v0:  Address of the head of the list; returns null if the list is empty
		#######################################################################
SS_LLN_Remove:
		beq		$a0, $zero, SS_LLNR_Empty
		lw		$a2, 0 ($a0)						#  Get the value of the current head.
		beq		$a1, $a2, SS_LLNR_Head				#  Keep the head?
		
													#  If the head is kept...
		move	$v0, $a0							#  Save the address as the output.
		j		SS_LLNR_Tail
		
SS_LLNR_Head:										#  If the head is removed...
		lw		$a0, 4 ($a0)						#  Use the next element as the head of the list.
		j		SS_LLN_Remove						#  Start again with the new head.
		
SS_LLNR_Tail:										#  Tail recursion to remove the remaining nodes.
		lw		$a2, 4($a0)							#  Get the tail of the list.
		beq		$a2, $zero, SS_LLNRT_Empty
		lw		$a3, 0($a2)							#  Get the value of the head of the tail.
		beq		$a1, $a3, SS_LLNRT_Remove			#  Keep the head of the tail?
		
													#  If the head of the tail will not be removed...
		move	$a0, $a2							#  The head of the tail becomes the new head
		j		SS_LLNR_Tail						#  to search.
		
SS_LLNRT_Remove:									#  If the head of the tail will be removed...
		lw		$a2, 4($a2)							#  Get the address of the next element in the tail.
		sw		$a2, 4($a0)							#  Store it as the head of the tail.
		j		SS_LLNR_Tail						#  Check the tail again.
		
		
SS_LLNR_Empty:										#  If there are no more elements in the list...
		li		$v0, 0								#  Return a null pointer.
		jr		$ra
		
SS_LLNRT_Empty:										#  If there are no more elements in the tail...
		jr		$ra									#  return the head of the new list.
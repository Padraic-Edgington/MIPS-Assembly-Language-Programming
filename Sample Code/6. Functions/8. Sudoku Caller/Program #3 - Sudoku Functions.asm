


#############################################################################################
#                                 Sudoku Solving Function									#
#																							#
#  Padraic Edgington                                                          18 Jan, 2015	#
#																							#
#  Functions:																				#
#  Sudoku_solver:		Takes a 9x9 array of integers and attempts to solve it using a		#
#						depth first search algorithm.										#
#																							#
#  v. 1		Initial release  (It appears to work.)											#
#  v. 1.1	Added duplication code, which will create a new object to return.				#
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
		.text
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
		
		#  Duplicate the input grid, to produce a new object to operate on.
		move	$t0, $a0						#  Copy the input grid to $t0.
		li		$v0, 9							#  Syscall code to allocate memory.
		li		$a0, 360						#  Need 360 bytes to represent 10 nine-integer arrays.
		syscall
		move	$a0, $v0						#  Copy the return grid to $a0.
		
		#  Link up the sub-arrays to the main array.
		addi	$t1, $a0, 36					#  Row #1
		sw		$t1,  0 ($a0)
		addi	$t1, $t1, 36					#  Row #2
		sw		$t1,  4 ($a0)
		addi	$t1, $t1, 36					#  Row #3
		sw		$t1,  8 ($a0)
		addi	$t1, $t1, 36					#  Row #4
		sw		$t1, 12 ($a0)
		addi	$t1, $t1, 36					#  Row #5
		sw		$t1, 16 ($a0)
		addi	$t1, $t1, 36					#  Row #6
		sw		$t1, 20 ($a0)
		addi	$t1, $t1, 36					#  Row #7
		sw		$t1, 24 ($a0)
		addi	$t1, $t1, 36					#  Row #8
		sw		$t1, 28 ($a0)
		addi	$t1, $t1, 36					#  Row #9
		sw		$t1, 32 ($a0)
		
		#  Copy the elements of the input grid to the new grid.
		li		$t1, 0							#  i
		li		$t2, 0							#  j
		li		$t9, 9							#  9
Copy_Loop:
		sll		$t3, $t1, 2
		add		$t3, $t0, $t3
		lw		$t3, 0 ($t3)					#  in[i]
		
		sll		$t5, $t1, 2
		add		$t5, $a0, $t5
		lw		$t5, 0 ($t5)					#  out[i]
		
Copy_Loop_2:
		sll		$t4, $t2, 2
		add		$t4, $t3, $t4
		lw		$t4, 0 ($t4)					#  in[i][j]
		
		sll		$t6, $t2, 2
		add		$t6, $t5, $t6
		sw		$t4, 0 ($t6)					#  out[i][j] = in[i][j]
		
		addi	$t2, $t2, 1						#  j++
		bne		$t2, $t9, Copy_Loop_2			#  while (j < 9) repeat Copy_Loop_2
		
		li		$t2, 0							#  j = 0
		addi	$t1, $t1, 1						#  i++
		bne		$t1, $t9, Copy_Loop				#  while (i < 9) repeat Copy_Loop
		

Sudoku_Solver_Processing:
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
		jal		Sudoku_Solver_Processing		#  Recursion!
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
		
		
		#  Print two Sudoku grids side by side
		#
		#  Parameters
		#  $a0:  Expected Sudoku grid
		#  $a1:  Observed Sudoku grid
		#######################################################################
Print_Sudoku:
		.data
Header:	.asciiz	"\n      Puzzle                           Solution\n"
Divider:.asciiz	"        "
nl:		.asciiz "\n"
		.text
		addi	$sp, $sp, -16
		sw		$ra, 12 ($sp)				#  Store the return address.
		sw		$a1,  4 ($sp)				#  Store the observed Sudoku grid.
		sw		$a0,  0 ($sp)				#  Store the expected Sudoku grid.
		
		#  Print the header line
		li		$v0, 4
		la		$a0, Header
		syscall
		
		#  Print the top line of each grid
		jal		Print_Sudoku_Line
		la		$a0, Divider
		syscall
		jal		Print_Sudoku_Line
		la		$a0, nl
		syscall
		
		li		$t0, 0
		sw		$t0, 8 ($sp)				#  Store the row counter.
PS_Loop:
		#  Print the grid data
		lw		$a0, 0 ($sp)
		lw		$a1, 8 ($sp)
		jal		Print_Sudoku_Data			#  Print the expected row.
		
		li		$v0, 4
		la		$a0, Divider
		syscall
		
		lw		$a0, 4 ($sp)
		lw		$a1, 8 ($sp)
		jal		Print_Sudoku_Data			#  Print the observed row.
		
		li		$v0, 4
		la		$a0, nl
		syscall
		
		lw		$t0, 8 ($sp)
		addi	$t0, $t0, 1
		sw		$t0, 8 ($sp)				#  Increment the row counter.
		
		rem		$t2, $t0, 3
		bne		$t2, $zero, PS_Loop
		
		#  Print a horizontal grid line after every 3 rows.
		jal		Print_Sudoku_Line
		la		$a0, Divider
		syscall
		jal		Print_Sudoku_Line
		la		$a0, nl
		syscall
		
		li		$t1, 9
		bne		$t0, $t1, PS_Loop			#  Print 9 rows.
		
		li		$v0, 4
		la		$a0, nl
		syscall
		
		lw		$ra, 12 ($sp)				#  Restore the return address
		addi	$sp, $sp, 16
		jr		$ra

		
		#  Print top/bottom line
		#######################################################################
Print_Sudoku_Line:
				.data
Sudoku_Line:	.asciiz	"-------------------------"
				.text
		li		$v0, 4
		la		$a0, Sudoku_Line
		syscall
		jr		$ra
	
	
		#  Print a single row of a Sudoku grid
		#
		#  Parameters
		#  $a0:  Sudoku grid
		#  $a1:  row to print
		########################################################################
Print_Sudoku_Data:
		.data
Open:	.asciiz	"| "
Space:	.asciiz	" "
Middle:	.asciiz "| "
Close:	.asciiz	"|"
		.text
		sll		$t2, $a1, 2
		add		$t2, $a0, $t2
		lw		$t2, 0 ($t2)				#  Address of the row to print.

		#  Print the left edge of the grid.
		li		$v0, 4
		la		$a0, Open
		syscall
		
		#  Print the data in the grid.
		lw		$a0, 0 ($sp)
		lw		$a1, 4 ($sp)
		li		$t0, 0						#  Counter
		li		$t1, 9
PSD_Loop:
		sll		$t3, $t0, 2
		add		$t3, $t2, $t3
		lw		$a0, 0 ($t3)
		beqz	$a0, PSDL_Print_Space
		li		$v0, 1
		syscall								#  Print the value of the current cell.
		j		PSDL_Endif
PSDL_Print_Space:
		li		$v0, 4
		la		$a0, Space
		syscall

PSDL_Endif:		
		li		$v0, 4
		la		$a0, Space
		syscall
		
		addi	$t0, $t0, 1
		beq		$t0, $t1, PSD_Complete
		
		rem		$t3, $t0, 3
		bne		$t3, $zero, PSD_Loop
		
		li		$v0, 4
		la		$a0, Middle
		syscall								#  Print a subgrid bar.
		
		j		PSD_Loop
		
PSD_Complete:
		li		$v0, 4
		la		$a0, Close
		syscall
		
		jr		$ra

		.data
Easy:	.word	Ea, Eb, Ec, Ed, Ee, Ef, Eg, Eh, Ei
Ea:		.word	7, 0, 0, 6, 0, 4, 5, 0, 0
Eb:		.word	0, 0, 0, 0, 5, 0, 0, 0, 2
Ec:		.word	0, 0, 0, 2, 0, 3, 0, 9, 0
Ed:		.word	1, 3, 0, 9, 2, 0, 6, 0, 0
Ee:		.word	9, 2, 0, 4, 3, 6, 0, 7, 5
Ef:		.word	0, 0, 6, 0, 8, 1, 0, 2, 3
Eg:		.word	0, 1, 0, 3, 0, 9, 0, 0, 0
Eh:		.word	6, 0, 0, 0, 1, 0, 0, 0, 0
Ei:		.word	0, 0, 4, 7, 0, 2, 0, 0, 9
Medium:	.word	Ma, Mb, Mc, Md, Me, Mf, Mg, Mh, Mi
Ma:		.word	9, 0, 7, 0, 8, 0, 0, 0, 0
Mb:		.word	0, 0, 5, 0, 0, 9, 0, 0, 0
Mc:		.word	6, 1, 0, 4, 0, 0, 0, 0, 0
Md:		.word	2, 6, 0, 3, 1, 0, 0, 0, 8
Me:		.word	0, 0, 8, 0, 6, 0, 3, 0, 0
Mf:		.word	3, 0, 0, 0, 9, 5, 0, 4, 2
Mg:		.word	0, 0, 0, 0, 0, 1, 0, 8, 9
Mh:		.word	0, 0, 0, 6, 0, 0, 7, 0, 0
Mi:		.word	0, 0, 0, 0, 7, 0, 5, 0, 3
Hard:	.word	Ha, Hb, Hc, Hd, He, Hf, Hg, Hh, Hi
Ha:		.word	0, 6, 0, 0, 7, 0, 0, 0, 9
Hb:		.word	0, 0, 0, 0, 0, 0, 0, 4, 2
Hc:		.word	0, 0, 4, 5, 3, 0, 0, 0, 0
Hd:		.word	0, 0, 0, 7, 0, 0, 6, 0, 0
He:		.word	6, 4, 9, 0, 0, 0, 1, 7, 8
Hf:		.word	0, 0, 7, 0, 0, 8, 0, 0, 0
Hg:		.word	0, 0, 0, 0, 5, 6, 7, 0, 0
Hh:		.word	9, 7, 0, 0, 0, 0, 0, 0, 0
Hi:		.word	2, 0, 0, 0, 4, 0, 0, 5, 0
Evil:	.word	Va, Vb, Vc, Vd, Ve, Vf, Vg, Vh, Vi
Va:		.word	4, 2, 0, 8, 0, 0, 0, 0, 0
Vb:		.word	0, 1, 0, 6, 0, 0, 0, 0, 0
Vc:		.word	0, 0, 5, 9, 4, 0, 7, 0, 6
Vd:		.word	0, 0, 0, 0, 0, 0, 1, 0, 0
Ve:		.word	8, 5, 0, 0, 0, 0, 0, 9, 2
Vf:		.word	0, 0, 4, 0, 0, 0, 0, 0, 0
Vg:		.word	6, 0, 1, 0, 7, 8, 5, 0, 0
Vh:		.word	0, 0, 0, 0, 0, 6, 0, 4, 0
Vi:		.word	0, 0, 0, 0, 0, 9, 0, 8, 1
Unsolvable:		.word	Ua, Ub, Uc, Ud, Ue, Uf, Ug, Uh, Ui
Ua:	.word	0, 6, 0, 7, 0, 0, 0, 0, 9
Ub:	.word	0, 0, 0, 0, 0, 0, 0, 4, 2
Uc:	.word	0, 0, 4, 5, 3, 0, 0, 0, 0
Ud:	.word	0, 0, 0, 7, 0, 0, 6, 0, 0
Ue:	.word	6, 4, 9, 0, 0, 0, 1, 7, 8
Uf:	.word	0, 0, 7, 0, 0, 8, 0, 0, 0
Ug:	.word	0, 0, 0, 0, 5, 6, 7, 0, 0
Uh:	.word	9, 7, 0, 0, 0, 0, 0, 0, 0
Ui:	.word	2, 0, 0, 0, 4, 0, 0, 5, 0

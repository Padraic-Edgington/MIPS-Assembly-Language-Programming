


#############################################################################################
#                                 	Maze Solving Function									#
#																							#
#  Padraic Edgington                                                          18 Jan, 2015	#
#																							#
#  Functions:																				#
#  Maze_Solver:		Takes a maze of arbitrary size and attempts to solve it using a			#
#						depth first search algorithm.										#
#																							#
#  v. 1		Initial release  (It appears to work.)											#
#############################################################################################


		#  Maze_Solver
		#
		#      Takes a maze of arbitrary size and attempts to solve it using a
		#  depth first search algorithm.  The algorithm returns a linked list
		#  of directions to traverse the maze if it is possible to solve the
		#  given problem.  If the current problem is not solvable, then it 
		#  returns a null pointer.
		#
		#  Parameters:
		#    $a0:  A pointer to a maze.
		#    $a1:  The current column.
		#    $a2:  The current row.
		#    $a3:  The direction we just came from.
		#
		#  Results:
		#    $v0:  The solved array if successful; a null pointer if unsuccessful.
		#######################################################################
Maze_Solver:
		blt		$a0, 0x10000000, MS_Error	#  If the maze pointer is outside the memory range, then return an error
		srl		$t0, $a0, 2
		sll		$t0, $t0, 2
		bne		$a0, $t0, MS_Error			#  If the maze pointer is not word aligned, then return an error.
		addi	$sp, $sp -24				#  Allocate space for 6 integers.
		sw		$a0,  0 ($sp)				#  Store the maze pointer.
		sw		$a1,  4 ($sp)				#  Store the current column.
		sw		$a2,  8 ($sp)				#  Store the current row.
		sw		$a3, 12 ($sp)				#  Store the direction we came from.
											#  Store the available directions.
		sw		$ra, 20 ($sp)				#  Store the return address.
		
		
		#  int directions = m.get (x, y);
		jal		maze_get					#  Get the available directions for the current cell.
		sw		$v0, 16 ($sp)				#  Store the available directions.
		
		#  If the exit is visible from this position...
		andi	$t0, $v0, 16				#  directions & EXIT
		beq		$t0, $zero, MS_Up
		
		#		then we've found a solution.
		li		$a0, 0						#  Null pointer.
		li		$a1, 88						#  Exit character.
		jal		add_head					#  Generate the new linked list.
		
		lw		$ra, 20 ($sp)				#  Load the return address.
		addi	$sp, $sp, 24				#  Deallocate the space on the stack.
		jr		$ra

		#		Else, search the unvisited branches for the exit.
MS_Up:
		#  Check up for the exit.
		lw		$a3, 12 ($sp)				#  Restore the previous direction.

		andi	$t0, $v0, 8					#  directions & UP
		beq		$t0, $zero, MS_Down
		andi	$t0, $a3, 8					#  previous & UP
		bne		$t0, $zero, MS_Down
		
		lw		$a0,  0 ($sp)				#  The maze pointer:            m
		lw		$a1,  4 ($sp)				#  The new column index:        x
		lw		$a2,  8 ($sp)
		addi	$a2, $a2, 1					#  The new row index:           y+1
		li		$a3, 4						#  The new previous direction:  DOWN
		jal		Maze_Solver
		
		beqz	$v0, MS_Down				#  If l is null, then the exit is not up.
		
		#  Found the exit by going up!
		move	$a0, $v0					#  List of directions from here to the exit.
		li		$a1, 86						#  Go up from this point.
		jal		add_head					#  Generate the updated linked list.
		
		lw		$ra, 20 ($sp)				#  Load the return address.
		addi	$sp, $sp, 24				#  Deallocate the space on the stack.
		jr		$ra


MS_Down:
		#  Check down for the exit.
		lw		$a3, 12 ($sp)				#  Restore the previous direction.
		lw		$v0, 16 ($sp)				#  Load the available directions.

		andi	$t0, $v0, 4					#  directions & DOWN
		beq		$t0, $zero, MS_Left
		andi	$t0, $a3, 4					#  previous & DOWN
		bne		$t0, $zero, MS_Left
		
		lw		$a0,  0 ($sp)				#  The maze pointer:            m
		lw		$a1,  4 ($sp)				#  The new column index:        x
		lw		$a2,  8 ($sp)
		addi	$a2, $a2, -1				#  The new row index:           y-1
		li		$a3, 8						#  The new previous direction:  UP
		jal		Maze_Solver
		
		beqz	$v0, MS_Left				#  If l is null, then the exit is not down.
		
		#  Found the exit by going down!
		move	$a0, $v0					#  List of directions from here to the exit.
		li		$a1, 68						#  Go down from this point.
		jal		add_head					#  Generate the updated linked list.
		
		lw		$ra, 20 ($sp)				#  Load the return address.
		addi	$sp, $sp, 24				#  Deallocate the space on the stack.
		jr		$ra


MS_Left:
		#  Check left for the exit.
		lw		$a3, 12 ($sp)				#  Restore the previous direction.
		lw		$v0, 16 ($sp)				#  Load the available directions.

		andi	$t0, $v0, 2					#  directions & LEFT
		beq		$t0, $zero, MS_Right
		andi	$t0, $a3, 2					#  previous & LEFT
		bne		$t0, $zero, MS_Right
		
		lw		$a0,  0 ($sp)				#  The maze pointer:            m
		lw		$a1,  4 ($sp)
		addi	$a1, $a1, -1				#  The new column index:        x-1
		lw		$a2,  8 ($sp)				#  The new row index:           y
		li		$a3, 1						#  The new previous direction:  RIGHT
		jal		Maze_Solver
		
		beqz	$v0, MS_Right				#  If l is null, then the exit is not left.
		
		#  Found the exit by going left!
		move	$a0, $v0					#  List of directions from here to the exit.
		li		$a1, 76						#  Go left from this point.
		jal		add_head					#  Generate the updated linked list.
		
		lw		$ra, 20 ($sp)				#  Load the return address.
		addi	$sp, $sp, 24				#  Deallocate the space on the stack.
		jr		$ra


MS_Right:
		#  Check right for the exit.
		lw		$a3, 12 ($sp)				#  Restore the previous direction.
		lw		$v0, 16 ($sp)				#  Load the available directions.

		andi	$t0, $v0, 1					#  directions & RIGHT
		beq		$t0, $zero, MS_Fail
		andi	$t0, $a3, 1					#  previous & RIGHT
		bne		$t0, $zero, MS_Fail
		
		lw		$a0,  0 ($sp)				#  The maze pointer:            m
		lw		$a1,  4 ($sp)
		addi	$a1, $a1, 1					#  The new column index:        x+1
		lw		$a2,  8 ($sp)				#  The new row index:           y
		li		$a3, 2						#  The new previous direction:  LEFT
		jal		Maze_Solver
		
		beqz	$v0, MS_Fail				#  If l is null, then the exit is not right.
		
		#  Found the exit by going right!
		move	$a0, $v0					#  List of directions from here to the exit.
		li		$a1, 82						#  Go right from this point.
		jal		add_head					#  Generate the updated linked list.
		
		lw		$ra, 20 ($sp)				#  Load the return address.
		addi	$sp, $sp, 24				#  Deallocate the space on the stack.
		jr		$ra


MS_Fail:
		#  Couldn't find the exit down this branch.
		li		$v0, 0
		lw		$ra, 20 ($sp)				#  Load the return address.
		addi	$sp, $sp, 24				#  Deallocate the space on the stack.
		jr		$ra

		
MS_Error:
		#  Received bad parameters.
		li		$v0, -1						#  Error code.
		jr		$ra
		
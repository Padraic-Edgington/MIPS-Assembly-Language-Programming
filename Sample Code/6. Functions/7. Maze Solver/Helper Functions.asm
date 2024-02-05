


#############################################################################################
#                                 	Maze Helper Functions									#
#																							#
#  Padraic Edgington                                                          18 Jan, 2015	#
#																							#
#  Functions:																				#
#  maze_get:		Reads the value of an individual maze cell.								#
#  add_head:		Adds a direction to the head of a linked list representing the solution	#
#						to the maze.														#
#																							#
#  v. 1		Initial release  (It appears to work.)											#
#############################################################################################


		#  Parameters:
		#    $a0:  A pointer to a maze.
		#    $a1:  The column (x) to read from. 
		#    $a2:  The row (y) to read from.
maze_get:
		sll		$t0, $a2, 2					#  Convert index to bytes.
		add		$t0, $a0, $t0				#  Add offset to base address.
		lw		$t0, 0 ($t0)				#  Load row vector.
		
		add		$t0, $t0, $a1				#  Add offset to base address.
		lb		$v0, 0 ($t0)				#  Load data.
		jr		$ra							#  Return data to calling function.

		#  Parameters:
		#    $a0:  A pointer to an existing solution linked list.
		#    $a1:  The new data to add to the solution linked list.
add_head:
		move	$t0, $a0					#  Copy the existing linked list pointer to a safe place.
		move	$t1, $a1					#  Copy the character to a safe place.
		
		li		$v0, 9						#  Request memory allocation.
		li		$a0, 8						#  Allocate 8 bytes.
		syscall
		
		sw		$t1, 0 ($v0)				#  Store the character in the data field.
		sw		$t0, 4 ($v0)				#  Store the pointer in the next field.
		
		jr		$ra							#  Return the new linked list to the calling function.
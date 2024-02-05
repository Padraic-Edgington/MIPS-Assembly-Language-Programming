#############################################################################################
#                                   Conway's Game of Life									#
#																							#
#  Padraic Edgington                                                          24 Mar, 2013	#
#																							#
#  Functions:																				#
#  Life:		Takes a life object and updates it to the next time step.  (external		#
#					function)																#
#  Life_Get:	Retrieves the state of the requested cell in the world.						#
#  Life_Set:	Sets the state of the requested cell in the world.							#
#																							#
#  v. 1		Initial release																	#
#############################################################################################


		#  Life
		#
		#      Takes a life object and updates it to reflect the new state of
		#  the world.  This is the only function that should be exposed to
		#  external functions.
		#
		#  Parameters:
		#    $a0:  A life object
		#
		#  Results:
		#    $v0:  A new life object
		#######################################################################
Life:	#  Checking for an invalid object
		ble		$a0, $0, Life_Fail		#  object address too low
		li		$t0, 0x7FFFFFF8
		bgeu	$a0, $t0, Life_Fail		#  object address too high
		li		$t0, 0x00000003
		and		$t0, $t0, $a0
		bne		$t0, $0, Life_Fail		#  object not word aligned
		lw		$t0, 0 ($a0)			#  number of rows
		lw		$t1, 4 ($a0)			#  number of cols
		ble		$t0, $0, Life_Fail		#  number of rows too low
		ble		$t1, $0, Life_Fail		#  number of cols too low
		mul		$t2, $t0, $t1
		li		$t3, 8
		div		$t2, $t3
		mfhi	$t3
		beq		$t3, $0, Life_IO1
		li		$t3, 1
		j		Life_IO1
Life_IO1:
		mflo	$t2
		add		$t2, $t2, $t3
		add		$t3, $t2, $a0
		li		$t4, 0x7FFFFFF8
		bgeu	$t3, $t4, Life_Fail





		#  Store things on the stack
		addi	$sp, $sp, -36
		sw		$ra,  0 ($sp)
		sw		$s0,  4 ($sp)
		sw		$s1,  8 ($sp)
		sw		$s2, 12 ($sp)
		sw		$s3, 16 ($sp)
		sw		$s4, 20 ($sp)
		sw		$s5, 24 ($sp)
		sw		$s6, 28 ($sp)
		sw		$s7, 32 ($sp)





		#  Create a new object
		#  $s0:  number of rows
		#  $s1:  number of columns
		#  $t2:  number of bytes required for the boolean array
		#  $s6:  input life object
		#  $s7:  output life object
		move	$s6, $a0				#  Save the input life object address
		move	$s0, $t0				#  Save the number of rows
		move	$s1, $t1				#  Save the number of columns
		addi	$a0, $t2, 8				#  Calculate the size of the new object
		li		$v0, 9
		syscall							#  Request a block of memory
		move	$s7, $v0				#  Save the output life object address





		#  Initialize the new object
		sw		$t0, 0 ($s7)			#  Store the number of rows
		sw		$t1, 4 ($s7)			#  Store the number of cols
		li		$t3, 0
Life_Init:								#  Initialize each byte in the boolean array to zero
		add		$t4, $t3, $s7
		sb		$0, 8 ($t4)
		addi	$t3, $t3, 1
		blt		$t3, $t2, Life_Init		#  Iterate over the number of bytes in the array






		#  Implement the rules of the game
		#  1:  Any live cell with fewer than two live neighbors dies.
		#  2:  Any live cell with two or three live neighbors lives.
		#  3:  Any live cell with more than three live neighbors dies.
		#  4:  Any dead cell with three live neighbors becomes a live cell.

		#  $s0:  number of rows
		#  $s1:  number of columns
		#  $s2:  row counter
		#  $s3:  column counter
		#  $s4:  current cell state
		#  $s5:  neighboring cell state count
		#  $s6:  input life object
		#  $s7:  output life object
		li		$s2, 0					#  output row counter
		li		$s3, 0					#  output column counter
Life_Game:								#  main loop for the game
		#  Get the state of the current cell
		move	$a0, $s6
		move	$a1, $s3
		move	$a2, $s2
		jal		Life_Get
		move	$s4, $v0

		#  Get the state of the above left cell
		move	$a0, $s6
		addi	$a1, $s3, -1
		addi	$a2, $s2, -1
		jal		Life_Get
		move	$s5, $v0

		#  Get the state of the above center cell
		move	$a0, $s6
		move	$a1, $s3
		addi	$a2, $s2, -1
		jal		Life_Get
		add		$s5, $s5, $v0

		#  Get the state of the above right cell
		move	$a0, $s6
		addi	$a1, $s3, 1
		addi	$a2, $s2, -1
		jal		Life_Get
		add		$s5, $s5, $v0

		#  Get the state of the center left cell
		move	$a0, $s6
		addi	$a1, $s3, -1
		move	$a2, $s2
		jal		Life_Get
		add		$s5, $s5, $v0

		#  Get the state of the center right cell
		move	$a0, $s6
		addi	$a1, $s3, 1
		move	$a2, $s2
		jal		Life_Get
		add		$s5, $s5, $v0

		#  Get the state of the below left cell
		move	$a0, $s6
		addi	$a1, $s3, -1
		addi	$a2, $s2, 1
		jal		Life_Get
		add		$s5, $s5, $v0

		#  Get the state of the below center cell
		move	$a0, $s6
		move	$a1, $s3
		addi	$a2, $s2, 1
		jal		Life_Get
		add		$s5, $s5, $v0

		#  Get the state of the below right cell
		move	$a0, $s6
		addi	$a1, $s3, 1
		addi	$a2, $s2, 1
		jal		Life_Get
		add		$s5, $s5, $v0

		#  Set the state of the cell
		move	$a0, $s7
		move	$a1, $s3
		move	$a2, $s2
		
		bne		$s4, $0, Life_Alive		#  If the current cell is alive, run the related tests
		#  Tests for a dead cell:
		#  4:  Any dead cell with three live neighbors becomes a live cell.
		li		$t0, 3
		beq		$s5, $t0, Life_Dead_to_Alive
		li		$a3, 0					#  If cell does not have three neighbors, then the cell remains dead
		j		Life_Game_Set
Life_Dead_to_Alive:
		li		$a3, 1					#  If the cell has three neighbors, then it comes to life
		j		Life_Game_Set

Life_Alive:
		#  Tests for a live cell:
		#  1:  Any live cell with fewer than two live neighbors dies.
		#  2:  Any live cell with two or three live neighbors lives.
		#  3:  Any live cell with more than three live neighbors dies.
		li		$t0, 2					#  If a live cell has less than two live neighbors, then it dies
		blt		$s5, $t0, Life_Alive_to_Dead
		li		$t0, 3					#  If a live cell has more than three live neighbors, then it dies
		bgt		$s5, $t0, Life_Alive_to_Dead
		li		$a3, 1
		j		Life_Game_Set
Life_Alive_to_Dead:
		li		$a3, 0
		
Life_Game_Set:
		jal		Life_Set				#  Set the state of the cell




		#  Increment counters
		#  $s0:  number of rows
		#  $s1:  number of columns
		#  $s2:  row counter
		#  $s3:  column counter
		addi	$s3, $s3, 1				#  Increment the column counter
		blt		$s3, $s1, Life_Game		#  If there are more cells in the row,
										#  run the next one
		
		#  At the end of a row...
		li		$s3, 0					#  Reset the column counter
		addi	$s2, $s2, 1				#  Increment the row counter
		blt		$s2, $s0, Life_Game		#  If there are more rows, run the next one


	


		#  Once finished computing the new state
		move	$v0, $s7				#  Copy the output object to $v0
		#  Retrieve data from the stack
		lw		$ra,  0 ($sp)
		lw		$s0,  4 ($sp)
		lw		$s1,  8 ($sp)
		lw		$s2, 12 ($sp)
		lw		$s3, 16 ($sp)
		lw		$s4, 20 ($sp)
		lw		$s5, 24 ($sp)
		lw		$s6, 28 ($sp)
		lw		$s7, 32 ($sp)
		addi	$sp, $sp, 36
		#  Return to calling function
		jr		$ra
		





Life_Fail:								#  If provided with an invalid object,
		li		$v0, 0					#  then return a null pointer
		jr		$ra
		#######################################################################


		
		
		#  Life_Get
		#
		#      Given a life object, it returns the state of the requested cell.
		#
		#  Parameters:
		#    $a0:  A life object
		#    $a1:  x coordinate
		#    $a2:  y coordinate
		#
		#  Results:
		#    $v0:  The state (0 or 1) of the cell
		#######################################################################
Life_Get:
		#  Calculate the location of the cell in memory.
		lw		$t0, 0 ($a0)			#  number of rows
		lw		$t1, 4 ($a0)			#  number of columns
		blt		$a1, $0, LG_x_Less_Than	#  (x<0) ? x=cols+x : x
		bge		$a1, $t1, LG_x_Greater_Than	#  (x>=cols) ? x=x-cols : x
LG1:	blt		$a2, $0, LG_y_Less_Than	#  (y<0) ? y=rows+y : y
		bge		$a2, $t0, LG_y_Greater_Than	#  (y>=rows) ? y=y-rows : y
LG2:	mul		$t2, $a2, $t1
		add		$t2, $t2, $a1			#  cell = y*cols + x
		li		$t3, 8
		div		$t2, $t3				
		mflo	$t3						#  Get byte number for selected cell
		mfhi	$t2						#  Get within byte offset for selected cell
		add		$t4, $t3, $a0
		lbu		$t4, 8 ($t4)			#  Read the byte containing the requested data
		
		#  Select desired bit from the obtained byte
		li		$t5, 0x80
		srlv	$t5, $t5, $t2			#  Create bit mask for the desired bit
		and		$t5, $t5, $t4			#  Apply mask
		sne		$v0, $t5, $zero			#  Store result in $v0
		
		jr		$ra
		
		
LG_x_Less_Than:
		add		$a1, $t1, $a1
		j		LG1
LG_x_Greater_Than:
		sub		$a1, $a1, $t1
		j		LG1
LG_y_Less_Than:
		add		$a2, $t0, $a2
		j		LG2
LG_y_Greater_Than:
		sub		$a2, $a2, $t0
		j		LG2
		#######################################################################


		
		
		#  Life_Set
		#
		#      Given a life object, it sets the state of the requested cell.
		#
		#  Parameters:
		#    $a0:  A life object
		#    $a1:  x coordinate
		#    $a2:  y coordinate
		#    $a3:  New state
		#######################################################################
Life_Set:
		#  Calculate the location of the cell in memory.
		lw		$t0, 0 ($a0)			#  number of rows
		lw		$t1, 4 ($a0)			#  number of columns
		blt		$a1, $0, LS_x_Less_Than	#  (x<0) ? x=cols+x : x
		bge		$a1, $t1, LS_x_Greater_Than	#  (x>=cols) ? x=x-cols : x
LS1:	blt		$a2, $0, LS_y_Less_Than	#  (y<0) ? y=rows+y : y
		bge		$a2, $t0, LS_y_Greater_Than	#  (y>=rows) ? y=y-rows : y
LS2:	mul		$t2, $a2, $t1
		add		$t2, $t2, $a1			#  cell = y*cols + x
		li		$t3, 8
		div		$t2, $t3				
		mflo	$t3						#  Get byte number for selected cell
		mfhi	$t2						#  Get within byte offset for selected cell
		add		$t4, $t3, $a0
		lbu		$t5, 8 ($t4)			#  Read the byte containing the requested data
		
		#  Set the desired bit
		li		$t6, 0x80
		srlv	$t6, $t6, $t2			#  Create bit mask for desired bit
		bne		$a3, $0, LS_Set_1
		#  If the bit should be set to zero, use an "and" with the inverse of the mask
		nor		$t6, $t6, $0
		and		$t5, $t5, $t6
		j		LS3
		#  If the bit should be set to one, use an "or" with the mask
LS_Set_1:
		or		$t5, $t5, $t6
		
		#  Store the result back into memory
LS3:	sb		$t5, 8 ($t4)

		jr		$ra
		
		
LS_x_Less_Than:
		add		$a1, $t1, $a1
		j		LS1
LS_x_Greater_Than:
		sub		$a1, $a1, $t1
		j		LS1
LS_y_Less_Than:
		add		$a2, $t0, $a2
		j		LS2
LS_y_Greater_Than:
		sub		$a2, $a2, $t0
		j		LS2
		#######################################################################
		
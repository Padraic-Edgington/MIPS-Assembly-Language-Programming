#################################
#  Matrix Arithmetic Functions  #
#  Padraic Edgington            #
#  November 19, 2012            #
#################################


#  Matrix Addition
###############################################################################
mAdd:	beq		$a0, $zero, mFail	#  If the matrix does not exist, then quit
		beq		$a1, $zero, mFail	#  If the matrix does not exist, then quit
		lw		$s0, 0 ($a0)		#  Left matrix # of rows
		lw		$s1, 4 ($a0)		#  Left matrix # of columns
		lw		$t0, 0 ($a1)		#  Right matrix # of rows
		lw		$t1, 4 ($a1)		#  Right matrix # of columns
		move	$s2, $a0			#  Save the location of the left matrix
		move	$s3, $a1			#  Save the location of the right matrix
		
		#  Ensure the matrices have the same size
		bne		$s0, $t0, mFail		#  Number of rows are not equal
		bne		$s1, $t1, mFail		#  Number of columns are not equal
		ble		$s0, 0, mFail		#  Matrices must have at least one row
		ble		$s1, 0, mFail		#  Matrices must have at least one column
		
		#  Create an output matrix
		mul		$a0, $s0, $s1		#  Calculate number of cells in the output matrix
		sll		$a0, $a0, 2			#  Multiply by 4 to get the number of bytes needed
		addi	$a0, $a0, 8			#  Include space for the # of rows and # of cols
		li		$v0, 9				#  Request memory
		syscall						#  The location of the output matrix is in $v0
		sw		$s0, 0 ($v0)		#  Set the # of rows in the output matrix
		sw		$s1, 4 ($v0)		#  Set the # of columns in the output matrix

		#  Perform addition
		li		$t0, 8				#  Start at the first element in the matrices
mAddL:	add		$t1, $s2, $t0
		lw		$t2, 0 ($t1)		#  Fetch element from the left matrix
		add		$t1, $s3, $t0
		lw		$t3, 0 ($t1)		#  Fetch element from the right matrix
		add		$t2, $t2, $t3		#  Add the two elements
		add		$t1, $v0, $t0
		sw		$t2, 0 ($t1)		#  Save the element in the output matrix
		addi	$t0, $t0, 4			#  Increment the displacement
		bne		$t0, $a0, mAddL
		
		#  Return finished matrix
		jr		$ra


#  Matrix Subtraction
###############################################################################
mSub:	beq		$a0, $zero, mFail	#  If the matrix does not exist, then quit
		beq		$a1, $zero, mFail	#  If the matrix does not exist, then quit
		lw		$s0, 0 ($a0)		#  Left matrix # of rows
		lw		$s1, 4 ($a0)		#  Left matrix # of columns
		lw		$t0, 0 ($a1)		#  Right matrix # of rows
		lw		$t1, 4 ($a1)		#  Right matrix # of columns
		move	$s2, $a0			#  Save the location of the left matrix
		move	$s3, $a1			#  Save the location of the right matrix
		
		#  Ensure the matrices have the same size
		bne		$s0, $t0, mFail		#  Number of rows are not equal
		bne		$s1, $t1, mFail		#  Number of columns are not equal
		ble		$s0, 0, mFail		#  Matrices must have at least one row
		ble		$s1, 0, mFail		#  Matrices must have at least one column
		
		#  Create an output matrix
		mul		$a0, $s0, $s1		#  Calculate number of cells in the output matrix
		sll		$a0, $a0, 2			#  Multiply by 4 to get the number of bytes needed
		addi	$a0, $a0, 8			#  Include space for the # of rows and # of cols
		li		$v0, 9				#  Request memory
		syscall						#  The location of the output matrix is in $v0
		sw		$s0, 0 ($v0)		#  Set the # of rows in the output matrix
		sw		$s1, 4 ($v0)		#  Set the # of columns in the output matrix

		#  Perform subtraction
		li		$t0, 8				#  Start at the first element in the matrices
mSubL:	add		$t1, $s2, $t0
		lw		$t2, 0 ($t1)		#  Fetch element from the left matrix
		add		$t1, $s3, $t0
		lw		$t3, 0 ($t1)		#  Fetch element from the right matrix
		sub		$t2, $t2, $t3		#  Subtract the two elements
		add		$t1, $v0, $t0
		sw		$t2, 0 ($t1)		#  Save the element in the output matrix
		addi	$t0, $t0, 4			#  Increment the displacement
		bne		$t0, $a0, mSubL
		
		#  Return finished matrix
		jr		$ra


#  Constant Multiplication
###############################################################################
cMult:	beq		$a1, $zero, mFail	#  If the matrix does not exist, then quit
		lw		$s0, 0 ($a1)		#  # of rows
		lw		$s1, 4 ($a1)		#  # of columns
		move	$s2, $a0			#  Save the constant
		move	$s3, $a1			#  Save the location of the matrix
		
		#  Check for malformed matrices
		ble		$s0, 0, mFail		#  Matrices must have at least one row
		ble		$s1, 0, mFail		#  Matrices must have at least one column
		
		#  Create an output matrix
		mul		$a0, $s0, $s1		#  Calculate number of cells in the output matrix
		sll		$a0, $a0, 2			#  Multiply by 4 to get the number of bytes needed
		addi	$a0, $a0, 8			#  Include space for the # of rows and # of cols
		li		$v0, 9				#  Request memory
		syscall						#  The location of the output matrix is in $v0
		sw		$s0, 0 ($v0)		#  Set the # of rows in the output matrix
		sw		$s1, 4 ($v0)		#  Set the # of columns in the output matrix

		#  Perform multiplication
		li		$t0, 8				#  Start at the first element in the matrices
cMultL:	add		$t1, $s3, $t0
		lw		$t2, 0 ($t1)		#  Fetch element from the matrix
		mul		$t2, $t2, $s2		#  Multiply the two elements
		add		$t1, $v0, $t0
		sw		$t2, 0 ($t1)		#  Save the element in the output matrix
		addi	$t0, $t0, 4			#  Increment the displacement
		bne		$t0, $a0, cMultL
		
		#  Return finished matrix
		jr		$ra


#  Matrix Multiplication
###############################################################################
mMult:	beq		$a0, $zero, mFail	#  If the matrix does not exist, then quit
		beq		$a1, $zero, mFail	#  If the matrix does not exist, then quit
		move	$s0, $a0			#  Save the left matrix address
		move	$s1, $a1			#  Save the right matrix address
		lw		$s2, 0 ($a0)		#  Left matrix # of rows
		lw		$s3, 4 ($a0)		#  Left matrix # of cols
		lw		$t0, 0 ($a1)		#  Right matrix # of rows
		lw		$s4, 4 ($a1)		#  Right matrix # of cols
		
		#  Check for malformed matrices
		ble		$s2, 0, mFail		#  Matrices must have at least one row
		ble		$s3, 0, mFail		#  Matrices must have at least one column
		ble		$s4, 0, mFail		#  Matrices must have at least one column
		bne		$s3, $t0, mFail		#  If left.cols != right.rows, then quit
		
		#  Create an output matrix
		mul		$a0, $s2, $s4		#  Calculate number of cells in the output matrix
		addi	$a0, $a0, 2			#  Add space for the # of rows and # of cols
		sll		$a0, $a0, 2			#  Convert to byte addressing
		li		$v0, 9				#  Request memory
		syscall						#  The location of the output matrix is in $v0
		sw		$s2, 0 ($v0)		#  Set the # of rows in the output matrix
		sw		$s4, 4 ($v0)		#  Set the # of cols in the output matrix
		
		#  Perform multiplication
		li		$t0, 0				#  Row counter = 0
		li		$t1, 0				#  Column counter = 0
		li		$t2, 0				#  Summation counter = 0
output:	mul		$t9, $t0, $s4		#  Calculate offset from row
		add		$t9, $t9, $t1		#  Add offset for the column
		addi	$t9, $t9, 2			#  Add offset for the # of rows/cols
		sll		$t9, $t9, 2			#  Convert to byte addressing
		add		$t9, $t9, $v0		#  Address of output cell
		
		li		$t3, 0				#  Summation = 0
		
sum:	#  Left matrix address calculations
		mul		$t4, $t0, $s3		#  Calculate offset from row
		add		$t4, $t4, $t2		#  Use offset for summation iterator in columns
		addi	$t4, $t4, 2			#  Add offset for the # of rows/cols
		sll		$t4, $t4, 2			#  Convert to byte addressing
		add		$t4, $t4, $s0		#  Address of left input cell
		lw		$t4, 0 ($t4)		#  Read left cell
		
		#  Right matrix address calculations
		mul		$t5, $t2, $s4		#  Use offset for summation iterator in rows
		add		$t5, $t5, $t1		#  Add offset for the column
		addi	$t5, $t5, 2			#  Add offset for the # of rows/cols
		sll		$t5, $t5, 2			#  Convert to byte addressing
		add		$t5, $t5, $s1		#  Address of right input cell
		lw		$t5, 0 ($t5)		#  Read right cell
		
		mul		$t4, $t4, $t5		#  Multiply left cell by right cell
		add		$t3, $t3, $t4		#  Add new term to previously calculated ones
		
		addi	$t2, $t2, 1			#  Increment summation counter
		
		bne		$t2, $s3, sum		#  Repeat until we reach the end of the row/column
		
		#  After calculating each output cell...
		sw		$t3, 0 ($t9)		#  Save the result
		li		$t2, 0				#  Reset the summation counter
		li		$t3, 0				#  Reset the summation
		addi	$t1, $t1, 1			#  Increment the column counter
		
		bne		$t1, $s4, output	#  Repeat until we reach the end of the output column
		
		#  After calculated each output row...
		li		$t1, 0				#  Reset the column counter
		addi	$t0, $t0, 1			#  Increment the row counter
		
		bne		$t0, $s2, output	#  Repeat until we reach the end of the output rows

		jr		$ra					#  Return the result in $v0



#  Incorrect Parameters
###############################################################################		
mFail:									#  Matrix size mismatch or invalid definition
		move	$v0, $0					#  Return null pointer
		jr		$ra

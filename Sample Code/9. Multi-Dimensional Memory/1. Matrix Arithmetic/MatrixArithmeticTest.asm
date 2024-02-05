###########################################################################################
#                        Unit Tests for Matrix Arithmetic Homework                        #
#                                                                                         #
#  Padraic Edgington                                                         19 Nov, 2012 #
#                                                                                         #
#                                            v1.2                                         #
#  If there are bugs in this code, you may check back later for an updated version.       #
#                                                                                         #
#  You should write your code in a seperate file and prepend it to this file by running   #
#  either:                                                                                #
#  Windows:  copy /Y <Matrix Function Name>.asm + MatrixArithmeticTest.asm <output>.asm   #
#  Unix:     cat <Matrix Function Name>.asm MatrixArithmeticTest.asm > <output>.asm       #
#                                                                                         #
#  v.1    Initial release                                                                 #
#  v.1.1  Added the rest of the expected results, fixed bugs in the assertion functions   #
#  v.1.2  Fixed an error in the size of an identity matrix, added missing syscall         #
###########################################################################################
		.data
		#  Matrices are specified by # of rows and # of cols followed by elements listed in row major format.
A:		.word	5, 3, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
B:		.word	3, 5, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1
C:		.word	3, 3, 1, 2, 3, 4, 5, 6, 7, 8, 9
D:		.word	3, 3, 9, 8, 7, 6, 5, 4, 3, 2, 1
I3:		.word	3, 3, 1, 0, 0, 0, 1, 0, 0, 0, 1
I5:		.word	5, 5, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1

E1:		.word	3, 3, 10, 10, 10, 10, 10, 10, 10, 10, 10
E2:		.word	3, 3, -8, -6, -4, -2, 0, 2, 4, 6, 8
E3:		.word	5, 5, 50, 44, 38, 32, 26, 140, 125, 110, 95, 80, 230, 206, 182, 158, 134, 320, 287, 254, 221, 188, 410, 368, 326, 284, 242
E4:		.word	3, 3, 425, 490, 555, 250, 290, 330, 75, 90, 105
E5:		.word	3, 3, 10, 0, 0, 0, 10, 0, 0, 0, 10
		.text
		
main:	addi	$sp, $sp, 4			#  Make space for $ra on stack
		sw		$ra, 0 ($sp)		#  Store the return address on the stack


		#  Test #1
		#  Run C+D
		#######################################################################
		la		$a0, C				#  Left matrix
		la		$a1, D				#  Right matrix
		jal		mAdd				#  Call add function
		
		li		$a3, 1				#  Test #1
		move	$a0, $v0			#  Result
		la		$a1, E1				#  Expected result
		jal		assertEqual			#  Check for equality
		
		
		#  Test #2
		#  Run 10*I3
		#######################################################################
		li		$a0, 10				#  Constant
		la		$a1, I3				#  Matrix
		jal		cMult				#  Call constant multiply function
		
		li		$a3, 2				#  Test #2
		move	$a0, $v0			#  Result
		la		$a1, E5				#  Expected result
		jal		assertEqual		#  Check for equality
		
		
		#  Test #3
		#  Run C-D
		#######################################################################
		la		$a0, C				#  Left matrix
		la		$a1, D				#  Right matrix
		jal		mSub				#  Call subtract function
		
		li		$a3, 3				#  Test #3
		move	$a0, $v0			#  Result
		la		$a1, E2				#  Expected result
		jal		assertEqual			#  Check for equality
		
		
		#  Test #4
		#  Run A*B
		#######################################################################
		la		$a0, A				#  Left matrix
		la		$a1, B				#  Right matrix
		jal		mMult				#  Call matrix multiplication function
		
		li		$a3, 4				#  Test #4
		move	$a0, $v0			#  Result
		la		$a1, E3				#  Expected result
		jal		assertEqual			#  Check for equality
		
		
		#  Test #5
		#  Run B*A
		#######################################################################
		la		$a0, B				#  Left matrix
		la		$a1, A				#  Right matrix
		jal		mMult				#  Call matrix multiplication function
		
		li		$a3, 5				#  Test #5
		move	$a0, $v0			#  Result
		la		$a1, E4				#  Expected result
		jal		assertEqual			#  Check for equality
		
		
		#  Test #6
		#  Run I*A
		#######################################################################
		la		$a0, I5				#  Left matrix
		la		$a1, A				#  Right matrix
		jal		mMult				#  Call matrix multiplication function
		
		li		$a3, 6				#  Test #6
		move	$a0, $v0			#  Result
		la		$a1, A				#  Expected result
		jal		assertEqual			#  Check for equality
		
		
		#  Test #7
		#  Run B*I
		#######################################################################
		la		$a0, B				#  Left matrix
		la		$a1, I5				#  Right matrix
		jal		mMult				#  Call matrix multiplication function
		
		li		$a3, 7				#  Test #7
		move	$a0, $v0			#  Result
		la		$a1, B				#  Expected result
		jal		assertEqual			#  Check for equality
		
		
		#  Test #8
		#  Run A*A
		#######################################################################
		la		$a0, A				#  Left matrix
		la		$a1, A				#  Right matrix
		jal		mMult				#  Call matrix multiplication function
		
		li		$a3, 8				#  Test #8
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #9
		#  Run B*B
		#######################################################################
		la		$a0, B				#  Left matrix
		la		$a1, B				#  Right matrix
		jal		mMult				#  Call matrix multiplication function
		
		li		$a3, 9				#  Test #9
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #10
		#  Run A+B
		#######################################################################
		la		$a0, A				#  Left matrix
		la		$a1, B				#  Right matrix
		jal		mAdd				#  Call matrix addition function
		
		li		$a3, 10				#  Test #10
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #11
		#  Run B+A
		#######################################################################
		la		$a0, B				#  Left matrix
		la		$a1, A				#  Right matrix
		jal		mAdd				#  Call matrix addition function
		
		li		$a3, 11				#  Test #11
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #12
		#  Run A-B
		#######################################################################
		la		$a0, A				#  Left matrix
		la		$a1, B				#  Right matrix
		jal		mSub				#  Call matrix subtraction function
		
		li		$a3, 12				#  Test #12
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #13
		#  Run B-A
		#######################################################################
		la		$a0, B				#  Left matrix
		la		$a1, A				#  Right matrix
		jal		mSub				#  Call matrix subtraction function
		
		li		$a3, 13				#  Test #13
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Quit unit testing
		#######################################################################
		lw		$ra, 0 ($sp)		#  Restore return address
		addi	$sp, $sp, -4		#  Remove the return address from the stack
		jr		$ra					#  Return to caller
		
		
		#  Assert Equality
		#######################################################################
assertEqual:
		.data
eq1:	.asciiz	"Test #"
eq2:	.asciiz " failed:  Expected value:  "
eq3:	.asciiz	" \tObserved value:  "
eq4:	.asciiz "\n"
eq5:	.asciiz " failed:  The result matrix was not the correct size.\n"
		.text
		
		move	$s7, $a3			#  Save test #
		beq		$a0, $0, default	#  If the result pointer is null, then just fail.
		
		lw		$t0, 0 ($a0)		#  Result # of rows
		lw		$t1, 4 ($a0)		#  Result # of columns
		lw		$s0, 0 ($a1)		#  Expected # of rows
		lw		$s1, 4 ($a1)		#  Expected # of columns
		
		bne		$t0, $s0, failSize	#  If the number of rows does not match, then fail
		bne		$t1, $s1, failSize	#  If the number of columns does not match, then fail
		li		$t3, 8				#  Initialize array counter
		mult	$t0, $t1			#  Calculate number of elements in the matrix
		mflo	$t4
		addi	$t4, $t4, 2	
		sll		$t4, $t4, 2			#  Termination condition
		
aeLoop:	beq		$t3, $t4, Pass		#  If all elements are correct, then the result is correct
		add		$t5, $t3, $a0
		lw		$t5, 0 ($t5)		#  Fetch current element in the result matrix
		add		$t6, $t3, $a1
		lw		$t6, 0 ($t6)		#  Fetch current element in the expected matrix
		
		bne		$t5, $t6, aeFail	#  If the elements are not the same, then fail
		addi	$t3, $t3, 4			#  Increment array counter
		j		aeLoop				#  Check next element
		
aeFail:	li		$v0, 4				#  Print string
		la		$a0, eq1			#  "Test #"
		syscall
		
		li		$v0, 1				#  Print test number
		move	$a0, $s7
		syscall
		
		li		$v0, 4				#  Print string
		la		$a0, eq2			#  " failed:  Expected value:  "
		syscall
		
		li		$v0, 1				#  Print expected value
		move	$a0, $t6
		syscall
		
		li		$v0, 4				#  Print string
		la		$a0, eq3			#  " Observed value:  "
		syscall
		
		li		$v0, 1				#  Print observed value
		move	$a0, $t5
		syscall
		
		li		$v0, 4				#  Print string
		la		$a0, eq4			#  "\n"
		syscall

#  Switch commenting on the next three lines to continue checking after finding inequal numbers.
#  This may help in debugging at the cost of many more lines of error text.
#		addi	$t3, $t3, 4			#  Incerement the array counter
#		j		aeLoop				#  Check next element
		jr		$ra					#  Quit processing this matrix
		
failSize:
		li		$v0, 4				#  Print string
		la		$a0, eq1			#  "Test #"
		syscall
		
		li		$v0, 1				#  Print test number
		move	$a0, $s7
		syscall
		
		li		$v0, 4				#  Print string
		la		$a0, eq5			#  " failed:  The result matrix was not the correct size.\n"
		syscall
		
#  If the matrices are the wrong size, then we should not continue to attempt to read the matrices.
		jr		$ra					#  Incorrect matrix size
		
		
		#  Assert Failure
		#######################################################################
assertFail:
		.data
fail1:	.asciiz	"Test #"
fail2:	.asciiz " failed.  The function returned a pointer.\n"
		.text
		
		move	$s7, $a3			#  Store test number
		bne		$a0, $zero, fFail	#  If the pointer is not null, then fail
		j		Pass

fFail:	li		$v0, 4				#  Print string
		la		$a0, fail1			#  "Test #"
		syscall
		
		li		$v0, 1				#  Print test number
		move	$a0, $s7
		syscall
		
		li		$v0, 4				#  Print string
		la		$a0, fail2			#  " failed.  The function returned a pointer.\n"
		syscall
		
		jr		$ra					#  Failed null pointer check
		
		
		#  Default Failure
		#######################################################################
		.data
d1:		.asciiz	" has not yet been implemented (or for some other reason received a null pointer.)\n"
		.text
default:
		li		$v0, 4				#  Print string
		la		$a0, eq1			#  "Test #"
		syscall
		
		li		$v0, 1				#  Print test number
		move	$a0, $s7
		syscall
		
		li		$v0, 4				#  Print string
		la		$a0, d1				#  " has not yet been implemented.\n"
		syscall
		
		jr		$ra					#  Procedure has not yet been implemented
		
		
		#  Assertion Success
		#######################################################################
		.data
s1:		.asciiz	" passed.\n"
		.text
Pass:	li		$v0, 4				#  Print string
		la		$a0, eq1			#  "Test #"
		syscall
		
		li		$v0, 1				#  Print test number
		move	$a0, $s7
		syscall
		
		li		$v0, 4				#  Print string
		la		$a0, s1				#  " passed.\n"
		syscall
		
		jr		$ra					#  Successfully checked all numbers in the matrix
		

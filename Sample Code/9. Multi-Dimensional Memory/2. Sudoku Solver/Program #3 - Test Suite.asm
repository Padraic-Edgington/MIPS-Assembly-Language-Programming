



#############################################################################################
#                                 Sudoku Solving Test Suite									#
#																							#
#  Padraic Edgington                                                          2 Nov, 2014	#
#																							#
#																							#
#  v. 1		Initial release  (It prints Sudoku grids.)										#
#  v. 1.1	A useful release, it has everything it needs except lots of tests.				#
#  v. 1.2	Added a number of sample problems ranging from easy to EVIL and impossible!		#
#  v. 1.3	Added test 0, which checks to make sure you can recognize a solution.			#
#############################################################################################







		.data
I1:		.word	I1a, I1b, I1c, I1d, I1e, I1f, I1g, I1h, I1i
I1a:	.word	0, 0, 0, 0, 0, 0, 0, 0, 0
I1b:	.word	0, 0, 0, 0, 0, 0, 0, 0, 0
I1c:	.word	0, 0, 0, 0, 0, 0, 0, 0, 0
I1d:	.word	0, 0, 0, 0, 0, 0, 0, 0, 0
I1e:	.word	0, 0, 0, 0, 0, 0, 0, 0, 0
I1f:	.word	0, 0, 0, 0, 0, 0, 0, 0, 0
I1g:	.word	0, 0, 0, 0, 0, 0, 0, 0, 0
I1h:	.word	0, 0, 0, 0, 0, 0, 0, 0, 0
I1i:	.word	0, 0, 0, 0, 0, 0, 0, 0, 0
R1:		.word	R1a, R1b, R1c, R1d, R1e, R1f, R1g, R1h, R1i
R1a:	.word	1, 2, 3, 4, 5, 6, 7, 8, 9
R1b:	.word	4, 5, 6, 7, 8, 9, 1, 2, 3
R1c:	.word	7, 8, 9, 1, 2, 3, 4, 5, 6
R1d:	.word	2, 1, 4, 3, 6, 5, 8, 9, 7
R1e:	.word	3, 6, 5, 8, 9, 7, 2, 1, 4
R1f:	.word	8, 9, 7, 2, 1, 4, 3, 6, 5
R1g:	.word	5, 3, 1, 6, 4, 2, 9, 7, 8
R1h:	.word	6, 4, 2, 9, 7, 8, 5, 3, 1
R1i:	.word	9, 7, 8, 5, 3, 1, 6, 4, 2
I2:		.word	I2a, I2b, I2c, I2d, I2e, I2f, I2g, I2h, I2i
I2a:	.word	1, 2, 3, 4, 5, 6, 7, 8, 9
I2b:	.word	4, 5, 6, 7, 8, 9, 1, 2, 3
I2c:	.word	7, 8, 9, 1, 2, 3, 4, 5, 6
I2d:	.word	2, 3, 4, 5, 6, 7, 8, 9, 1
I2e:	.word	5, 6, 7, 8, 9, 1, 2, 3, 4
I2f:	.word	8, 9, 1, 2, 3, 4, 5, 6, 7
I2g:	.word	3, 4, 5, 6, 7, 8, 9, 1, 2
I2h:	.word	6, 7, 8, 9, 1, 2, 3, 4, 5
I2i:	.word	9, 1, 2, 3, 4, 5, 6, 7, 0
R2:		.word	R2a, R2b, R2c, R2d, R2e, R2f, R2g, R2h, R2i
R2a:	.word	1, 2, 3, 4, 5, 6, 7, 8, 9
R2b:	.word	4, 5, 6, 7, 8, 9, 1, 2, 3
R2c:	.word	7, 8, 9, 1, 2, 3, 4, 5, 6
R2d:	.word	2, 3, 4, 5, 6, 7, 8, 9, 1
R2e:	.word	5, 6, 7, 8, 9, 1, 2, 3, 4
R2f:	.word	8, 9, 1, 2, 3, 4, 5, 6, 7
R2g:	.word	3, 4, 5, 6, 7, 8, 9, 1, 2
R2h:	.word	6, 7, 8, 9, 1, 2, 3, 4, 5
R2i:	.word	9, 1, 2, 3, 4, 5, 6, 7, 8
I3:		.word	I3a, I3b, I3c, I3d, I3e, I3f, I3g, I3h, I3i
I3a:	.word	1, 2, 3, 4, 5, 6, 7, 8, 9
I3b:	.word	4, 5, 6, 7, 8, 9, 1, 2, 3
I3c:	.word	7, 8, 9, 1, 2, 3, 4, 5, 6
I3d:	.word	2, 3, 4, 5, 6, 7, 8, 9, 1
I3e:	.word	5, 6, 7, 8, 0, 1, 2, 3, 4
I3f:	.word	8, 9, 1, 2, 3, 4, 5, 6, 7
I3g:	.word	3, 4, 5, 6, 7, 8, 9, 1, 2
I3h:	.word	6, 7, 8, 9, 1, 2, 3, 4, 5
I3i:	.word	9, 1, 2, 3, 4, 5, 6, 7, 8
I4:		.word	I4a, I4b, I4c, I4d, I4e, I4f, I4g, I4h, I4i
I4a:	.word	7, 0, 0, 6, 0, 4, 5, 0, 0
I4b:	.word	0, 0, 0, 0, 5, 0, 0, 0, 2
I4c:	.word	0, 0, 0, 2, 0, 3, 0, 9, 0
I4d:	.word	1, 3, 0, 9, 2, 0, 6, 0, 0
I4e:	.word	9, 2, 0, 4, 3, 6, 0, 7, 5
I4f:	.word	0, 0, 6, 0, 8, 1, 0, 2, 3
I4g:	.word	0, 1, 0, 3, 0, 9, 0, 0, 0
I4h:	.word	6, 0, 0, 0, 1, 0, 0, 0, 0
I4i:	.word	0, 0, 4, 7, 0, 2, 0, 0, 9
R4:		.word	R4a, R4b, R4c, R4d, R4e, R4f, R4g, R4h, R4i
R4a:	.word	7, 8, 2, 6, 9, 4, 5, 3, 1
R4b:	.word	3, 4, 9, 1, 5, 8, 7, 6, 2
R4c:	.word	5, 6, 1, 2, 7, 3, 4, 9, 8
R4d:	.word	1, 3, 5, 9, 2, 7, 6, 8, 4
R4e:	.word	9, 2, 8, 4, 3, 6, 1, 7, 5
R4f:	.word	4, 7, 6, 5, 8, 1, 9, 2, 3
R4g:	.word	2, 1, 7, 3, 4, 9, 8, 5, 6
R4h:	.word	6, 9, 3, 8, 1, 5, 2, 4, 7
R4i:	.word	8, 5, 4, 7, 6, 2, 3, 1, 9
I5:		.word	I5a, I5b, I5c, I5d, I5e, I5f, I5g, I5h, I5i
I5a:	.word	9, 0, 7, 0, 8, 0, 0, 0, 0
I5b:	.word	0, 0, 5, 0, 0, 9, 0, 0, 0
I5c:	.word	6, 1, 0, 4, 0, 0, 0, 0, 0
I5d:	.word	2, 6, 0, 3, 1, 0, 0, 0, 8
I5e:	.word	0, 0, 8, 0, 6, 0, 3, 0, 0
I5f:	.word	3, 0, 0, 0, 9, 5, 0, 4, 2
I5g:	.word	0, 0, 0, 0, 0, 1, 0, 8, 9
I5h:	.word	0, 0, 0, 6, 0, 0, 7, 0, 0
I5i:	.word	0, 0, 0, 0, 7, 0, 5, 0, 3
R5:		.word	R5a, R5b, R5c, R5d, R5e, R5f, R5g, R5h, R5i
R5a:	.word	9, 2, 7, 1, 8, 6, 4, 3, 5
R5b:	.word	4, 8, 5, 7, 3, 9, 1, 2, 6
R5c:	.word	6, 1, 3, 4, 5, 2, 8, 9, 7
R5d:	.word	2, 6, 4, 3, 1, 7, 9, 5, 8
R5e:	.word	5, 9, 8, 2, 6, 4, 3, 7, 1
R5f:	.word	3, 7, 1, 8, 9, 5, 6, 4, 2
R5g:	.word	7, 3, 6, 5, 4, 1, 2, 8, 9
R5h:	.word	8, 5, 9, 6, 2, 3, 7, 1, 4
R5i:	.word	1, 4, 2, 9, 7, 8, 5, 6, 3
I6:		.word	I6a, I6b, I6c, I6d, I6e, I6f, I6g, I6h, I6i
I6a:	.word	0, 6, 0, 0, 7, 0, 0, 0, 9
I6b:	.word	0, 0, 0, 0, 0, 0, 0, 4, 2
I6c:	.word	0, 0, 4, 5, 3, 0, 0, 0, 0
I6d:	.word	0, 0, 0, 7, 0, 0, 6, 0, 0
I6e:	.word	6, 4, 9, 0, 0, 0, 1, 7, 8
I6f:	.word	0, 0, 7, 0, 0, 8, 0, 0, 0
I6g:	.word	0, 0, 0, 0, 5, 6, 7, 0, 0
I6h:	.word	9, 7, 0, 0, 0, 0, 0, 0, 0
I6i:	.word	2, 0, 0, 0, 4, 0, 0, 5, 0
R6:		.word	R6a, R6b, R6c, R6d, R6e, R6f, R6g, R6h, R6i
R6a:	.word	5, 6, 8, 4, 7, 2, 3, 1, 9
R6b:	.word	7, 9, 3, 6, 8, 1, 5, 4, 2
R6c:	.word	1, 2, 4, 5, 3, 9, 8, 6, 7
R6d:	.word	8, 1, 2, 7, 9, 4, 6, 3, 5
R6e:	.word	6, 4, 9, 3, 2, 5, 1, 7, 8
R6f:	.word	3, 5, 7, 1, 6, 8, 2, 9, 4
R6g:	.word	4, 8, 1, 9, 5, 6, 7, 2, 3
R6h:	.word	9, 7, 5, 2, 1, 3, 4, 8, 6
R6i:	.word	2, 3, 6, 8, 4, 7, 9, 5, 1
I7:		.word	I7a, I7b, I7c, I7d, I7e, I7f, I7g, I7h, I7i
I7a:	.word	4, 2, 0, 8, 0, 0, 0, 0, 0
I7b:	.word	0, 1, 0, 6, 0, 0, 0, 0, 0
I7c:	.word	0, 0, 5, 9, 4, 0, 7, 0, 6
I7d:	.word	0, 0, 0, 0, 0, 0, 1, 0, 0
I7e:	.word	8, 5, 0, 0, 0, 0, 0, 9, 2
I7f:	.word	0, 0, 4, 0, 0, 0, 0, 0, 0
I7g:	.word	6, 0, 1, 0, 7, 8, 5, 0, 0
I7h:	.word	0, 0, 0, 0, 0, 6, 0, 4, 0
I7i:	.word	0, 0, 0, 0, 0, 9, 0, 8, 1
R7:		.word	R7a, R7b, R7c, R7d, R7e, R7f, R7g, R7h, R7i
R7a:	.word	4, 2, 6, 8, 5, 7, 9, 1, 3
R7b:	.word	7, 1, 9, 6, 2, 3, 4, 5, 8
R7c:	.word	3, 8, 5, 9, 4, 1, 7, 2, 6
R7d:	.word	2, 9, 3, 7, 8, 5, 1, 6, 4
R7e:	.word	8, 5, 7, 1, 6, 4, 3, 9, 2
R7f:	.word	1, 6, 4, 3, 9, 2, 8, 7, 5
R7g:	.word	6, 4, 1, 2, 7, 8, 5, 3, 9
R7h:	.word	9, 3, 8, 5, 1, 6, 2, 4, 7
R7i:	.word	5, 7, 2, 4, 3, 9, 6, 8, 1
I8:		.word	I8a, I8b, I8c, I8d, I8e, I8f, I8g, I8h, I8i
I8a:	.word	0, 6, 0, 7, 0, 0, 0, 0, 9
I8b:	.word	0, 0, 0, 0, 0, 0, 0, 4, 2
I8c:	.word	0, 0, 4, 5, 3, 0, 0, 0, 0
I8d:	.word	0, 0, 0, 7, 0, 0, 6, 0, 0
I8e:	.word	6, 4, 9, 0, 0, 0, 1, 7, 8
I8f:	.word	0, 0, 7, 0, 0, 8, 0, 0, 0
I8g:	.word	0, 0, 0, 0, 5, 6, 7, 0, 0
I8h:	.word	9, 7, 0, 0, 0, 0, 0, 0, 0
I8i:	.word	2, 0, 0, 0, 4, 0, 0, 5, 0
Z:		.word	Za, Zb, Zc, Zd, Ze, Zf, Zg, Zh, Zi
Za:		.word	0, 0, 0, 0, 0, 0, 0, 0, 0
Zb:		.word	0, 0, 0, 0, 0, 0, 0, 0, 0
Zc:		.word	0, 0, 0, 0, 0, 0, 0, 0, 0
Zd:		.word	0, 0, 0, 0, 0, 0, 0, 0, 0
Ze:		.word	0, 0, 0, 0, 0, 0, 0, 0, 0
Zf:		.word	0, 0, 0, 0, 0, 0, 0, 0, 0
Zg:		.word	0, 0, 0, 0, 0, 0, 0, 0, 0
Zh:		.word	0, 0, 0, 0, 0, 0, 0, 0, 0
Zi:		.word	0, 0, 0, 0, 0, 0, 0, 0, 0
I9:		.word	I9a, I9b, I9c, I9d, I9e, I9f, I9g, I9h, I9i
I9a:	.word	1, 2, 3, 4, 5, 6, 7, 8, 9
I9b:	.word	4, 5, 6, 7, 8, 9, 1, 2, 3
I9c:	.word	7, 8, 9, 1, 2, 3, 4, 5, 6
I9d:	.word	2, 1, 4, 3, 6, 5, 8, 9, 7
I9e:	.word	3, 6, 5, 8, 9, 7, 2, 1, 4
I9f:	.word	8, 9, 7, 2, 1, 4, 3, 6, 5
I9g:	.word	5, 3, 1, 6, 4, 2, 9, 7, 8
I9h:	.word	6, 4, 2, 9, 7, 8, 5, 3, 1
I9i:	.word	9, 7, 8, 5, 3, 1, 6, 4, 2
R9:		.word	R9a, R9b, R9c, R9d, R9e, R9f, R9g, R9h, R9i
R9a:	.word	1, 2, 3, 4, 5, 6, 7, 8, 9
R9b:	.word	4, 5, 6, 7, 8, 9, 1, 2, 3
R9c:	.word	7, 8, 9, 1, 2, 3, 4, 5, 6
R9d:	.word	2, 1, 4, 3, 6, 5, 8, 9, 7
R9e:	.word	3, 6, 5, 8, 9, 7, 2, 1, 4
R9f:	.word	8, 9, 7, 2, 1, 4, 3, 6, 5
R9g:	.word	5, 3, 1, 6, 4, 2, 9, 7, 8
R9h:	.word	6, 4, 2, 9, 7, 8, 5, 3, 1
R9i:	.word	9, 7, 8, 5, 3, 1, 6, 4, 2



		.text
main:	
		#  Test #0
		#  An already solved grid.
		#######################################################################
		la		$a0, I9
		jal		Sudoku_solver
		
		la		$a0, R9
		move	$a1, $v0
		li		$a3, 0
		jal		assertEqual
		
		#  Test #1
		#  Only missing the last cell.
		#######################################################################
		la		$a0, I2
		jal		Sudoku_solver
		
		la		$a0, R2
		move	$a1, $v0
		li		$a3, 1
		jal		assertEqual
		
		#  Test #2
		#  Only missing the center cell.
		#######################################################################
		la		$a0, I3
		jal		Sudoku_solver
		
		la		$a0, R2
		move	$a1, $v0
		li		$a3, 2
		jal		assertEqual

		#  Test #3
		#  Starting with an empty grid.
		#######################################################################
		la		$a0, I1
		jal		Sudoku_solver
		
		la		$a0, R1
		move	$a1, $v0
		li		$a3, 3
		jal		assertEqual
		
		#  Test #4
		#  An easy problem...
		#######################################################################
		la		$a0, I4
		jal		Sudoku_solver
		
		la		$a0, R4
		move	$a1, $v0
		li		$a3, 4
		jal		assertEqual
		
		#  Test #5
		#  A medium problem...
		#######################################################################
		la		$a0, I5
		jal		Sudoku_solver
		
		la		$a0, R5
		move	$a1, $v0
		li		$a3, 5
		jal		assertEqual
		
		#  Test #6
		#  A hard problem...
		#######################################################################
		la		$a0, I6
		jal		Sudoku_solver
		
		la		$a0, R6
		move	$a1, $v0
		li		$a3, 6
		jal		assertEqual
		
		#  Test #7
		#  An evil problem!
		#######################################################################
		la		$a0, I7
		jal		Sudoku_solver
		
		la		$a0, R7
		move	$a1, $v0
		li		$a3, 7
		jal		assertEqual
		
		
		#  Test #8
		#  An unsolvable problem. =(
		#######################################################################
		la		$a0, I8
		jal		Sudoku_solver
		
		move	$a0, $v0
		li		$a3, 8
		jal		assertNull
		
		
		#  Test #9
		#  A null pointer for a parameter.
		#######################################################################
		li		$a0, 0
		jal		Sudoku_solver
		
		move	$a0, $v0
		li		$a3, 9
		jal		assertNull
		
		
		#  Test #10
		#  A negative/very high number for a pointer.
		#######################################################################
		li		$a0, -9872
		jal		Sudoku_solver
		
		move	$a0, $v0
		li		$a3, 10
		jal		assertNull
		
		
		#  Test #11
		#  A non-word aligned number for a pointer.
		#######################################################################
		li		$a0, 0x60000005
		jal		Sudoku_solver
		
		move	$a0, $v0
		li		$a3, 11
		jal		assertNull
		
		
		.data
Q:		.asciiz	"----------Tests completed.----------\n"
		.text
		li		$v0, 4
		la		$a0, Q
		syscall
		
		li		$v0, 10
		syscall
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
###############################################################################
##                            Assertion functions                            ##
###############################################################################
		#  Assert Equality
		#
		#  Parameters
		#  $a0:  Expected Sudoku grid
		#  $a1:  Observed Sudoku grid
		#######################################################################
assertEqual:
		addi	$sp, $sp, -12
		sw		$a1, 8 ($sp)
		sw		$a0, 4 ($sp)
		sw		$ra, 0 ($sp)
		
		li		$v0, 4
		la		$a0, Test
		syscall
		li		$v0, 1
		move	$a0, $a3
		syscall

		lw		$a1, 8 ($sp)
		lw		$a0, 4 ($sp)
		
		jal		assert_valid_array
		
		lw		$a1, 8 ($sp)
		lw		$a0, 4 ($sp)
		lw		$ra, 0 ($sp)
		addi	$sp, $sp, 12

		beqz	$v0, AE_test_equality
		jr		$ra

AE_test_equality:
		li		$t0, 0
		li		$t1, 0
		li		$t9, 36
AE_Loop:
		add		$t2, $a0, $t0
		add		$t3, $a1, $t0
		lw		$t2, 0 ($t2)
		lw		$t3, 0 ($t3)
		add		$t2, $t2, $t1
		add		$t3, $t3, $t1
		lw		$t2, 0 ($t2)
		lw		$t3, 0 ($t3)
		bne		$t2, $t3, Assert_value_not_equal
		
		addi	$t1, $t1, 4
		bne		$t1, $t9, AE_Loop
		
		li		$t1, 0
		addi	$t0, 4
		bne		$t0, $t9, AE_Loop
		
		.data
Test:	.asciiz	"Test #"
AVNE:	.asciiz	"One or more of the the values in the array are incorrect.\n"
Passed:	.asciiz	" passed.\n"
		.text
		
		li		$v0, 4
		la		$a0, Passed
		syscall
		
		jr		$ra
		
Assert_value_not_equal:
		li		$v0, 4
		la		$a0, Failed
		syscall
		la		$a0, AVNE
		syscall
		
		lw		$a0, -8 ($sp)
		lw		$a1, -4 ($sp)
		j		Print_Sudoku



		
		
		

		#######################################################################
		#  Assert Null Pointer
		#######################################################################
assertNull:
		move	$t0, $a0
		
		li		$v0, 4
		la		$a0, Test
		syscall
		li		$v0, 1
		move	$a0, $a3
		syscall

		bne		$t0, $zero, AN_Failed
		
		li		$v0, 4
		la		$a0, Passed
		syscall
		
		jr		$ra
		
AN_Failed:
		.data
ANF:	.asciiz	"Null pointer expected.  This problem was not solvable.\n"
		.text
		li		$v0, 4
		la		$a0, Failed
		syscall
		la		$a0, ANF
		syscall
		
		jr		$ra






		#######################################################################
		#  Assert Valid Array
		#######################################################################
assert_valid_array:
		#  Step 0:  The two arrays should be different.
		beq		$a0, $a1, Assert_Cheating
		#  Step 1:  Ensure that the parameter points to a valid part of memory
		#  The array should either be on the stack on the heap.
		beq		$a1, $zero, Assert_Null_pointer_recieved
		blt		$a1, 0x10008000, Assert_Pointer_out_of_range
		bgtu	$a1, 0x7FFFFFDC, Assert_Pointer_out_of_range
		
		#  Step 2:  The array should be composed of integers and thus word aligned.
		sll		$t0, $a1, 30
		bne		$t0, $zero, Assert_Not_a_pointer
		
		#  Step 3:  The first level of the array should be composed of addresses.
		li		$t0, 0
		li		$t9, 36
AVA_Loop_1:
		add		$t1, $a1, $t0
		add		$t2, $a0, $t0
		lw		$t1, 0 ($t1)
		lw		$t2, 0 ($t2)
		
		#  The subpointers should not be the same.
		beq		$t1, $t2, Assert_Cheating
		
		#  The subarray should either be on the stack or on the heap.
		blt		$t1, 0x10008000, Assert_Subpointer_out_of_range
		bgtu	$t1, 0x7FFFFFDC, Assert_Subpointer_out_of_range
		
		#  The subarray should be composed of intergers and thus word aligned.
		sll		$t1, $t1, 30
		bne		$t1, $zero, Assert_Not_a_subpointer
		
		addi	$t0, $t0, 4
		bne		$t0, $t9, AVA_Loop_1
		
		#  Step 4:  The second level of the array should be composed of integers from 0 to 9.
		li		$t0, 0
		li		$t1, 0
		li		$t8, 36
		li		$t9, 9
AVA_Loop_2:
		add		$t2, $a1, $t0
		lw		$t2, 0 ($t2)
		add		$t2, $t2, $t1
		lw		$t2, 0 ($t2)
		
		bgtu	$t2, $t9, Assert_Not_a_Sudoku_value
		
		addi	$t1, $t1, 4
		
		bne		$t1, $t8, AVA_Loop_2
		
		li		$t1, 0
		add		$t0, $t0, 4
		bne		$t0, $t8, AVA_Loop_2
		
		#  Array is valid.  Continue testing.
		li		$v0, 0
		jr		$ra
		
		#  Array is invalid.  Throw an error and quit.
		.data
Failed:	.asciiz	" failed.\n"
ANPR:	.asciiz	"A null pointer was returned.  This problem was solvable.\n"
APOOR:	.asciiz	"The value provided was not within the allowable range for dynamic data structures.\n"
ANAP:	.asciiz	"The value provided was not a word aligned address.\n"
ASPOOR:	.asciiz	"The initial pointer given was acceptable, but one of the values in the array was not within the allowable range for dynamic data structures.\n"
ANASP:	.asciiz	"The initial pointer given was acceptable, but one of the values in the array was not a word aligned address.\n"
ANASV:	.asciiz	"One of the values in the Sudoku grid was not on the range [0-9].\n"
AC:		.asciiz	"Cheating is bad, mmmkay?\n"
		.text
Assert_Null_pointer_recieved:
		#  A null pointer was returned, when a solved grid should have been created.
		la		$t0, ANPR
		j		Assert_Failed

Assert_Cheating:
		#  One or more of the array pointers were copied.
		la		$t0, AC
		j		Assert_Failed
		
Assert_Pointer_out_of_range:
		#  The initial pointer is not within the dynamic memory range.
		la		$t0, APOOR
		j		Assert_Failed
		
Assert_Not_a_pointer:
		#  The parameter is not a word aligned address.
		la		$t0, ANAP
		j		Assert_Failed
		
Assert_Subpointer_out_of_range:
		#  A sub-pointer is not within the dynamic memory range.
		la		$t0, ASPOOR
		j		Assert_Failed
		
Assert_Not_a_subpointer:
		#  A sub-pointer is not a word aligned address.
		la		$t0, ANASP
		j		Assert_Failed
		
Assert_Not_a_Sudoku_value:
		la		$t0, ANASV

Assert_Failed:
		li		$v0, 4
		la		$a0, Failed
		syscall
		move	$a0, $t0
		syscall
		
		jr		$ra
		
		
		
		
		
		
		
		
		
		#
		#  Display routines
		#######################################################################
		
		#  Print two Sudoku grids side by side
		#
		#  Parameters
		#  $a0:  Expected Sudoku grid
		#  $a1:  Observed Sudoku grid
		#######################################################################
Print_Sudoku:
		.data
Header:	.asciiz	"      Expected Grid                    Observed Grid\n"
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
		
		lw		$ra, 12 ($sp)				#  Restore the return address
		addi	$sp, $sp, 16
		jr		$ra
		
		#  Print a single Sudoku grid
		#
		#  Parameters
		#  $a0:  Sudoku grid
		#######################################################################
Print_Sudoku_Single:
		beqz	$a0, PSS_Null_Pointer
		addi	$sp, $sp, -108
		sw		$a0,   0 ($sp)				#  Store the Sudoku grid.
		sw		$ra,   8 ($sp)				#  Store the return address.
		sw		$v0,  12 ($sp)
		sw		$v1,  16 ($sp)
		sw		$a0,  20 ($sp)
		sw		$a1,  24 ($sp)
		sw		$a2,  28 ($sp)
		sw		$a3,  32 ($sp)
		sw		$t0,  36 ($sp)
		sw		$t1,  40 ($sp)
		sw		$t2,  44 ($sp)
		sw		$t3,  48 ($sp)
		sw		$t4,  52 ($sp)
		sw		$t5,  56 ($sp)
		sw		$t6,  60 ($sp)
		sw		$t7,  64 ($sp)
		sw		$s0,  68 ($sp)
		sw		$s1,  72 ($sp)
		sw		$s2,  76 ($sp)
		sw		$s3,  80 ($sp)
		sw		$s4,  84 ($sp)
		sw		$s5,  88 ($sp)
		sw		$s6,  92 ($sp)
		sw		$s7,  96 ($sp)
		sw		$t8, 100 ($sp)
		sw		$t9, 104 ($sp)
		
		#  Print the top line of each grid
		jal		Print_Sudoku_Line
		li		$v0, 4
		la		$a0, nl
		syscall
		
		li		$t0, 0
		sw		$t0, 4 ($sp)				#  Store the row counter.
PSS_Loop:
		#  Print the grid data
		lw		$a0, 0 ($sp)
		lw		$a1, 4 ($sp)
		jal		Print_Sudoku_Data			#  Print the expected row.
		
		li		$v0, 4
		la		$a0, nl
		syscall
		
		lw		$t0, 4 ($sp)
		addi	$t0, $t0, 1
		sw		$t0, 4 ($sp)				#  Increment the row counter.
		
		rem		$t2, $t0, 3
		bne		$t2, $zero, PSS_Loop
		
		#  Print a horizontal grid line after every 3 rows.
		jal		Print_Sudoku_Line
		li		$v0, 4
		la		$a0, nl
		syscall
		
		li		$t1, 9
		bne		$t0, $t1, PSS_Loop			#  Print 9 rows.

		li		$v0, 4
		la		$a0, nl
		syscall
		syscall								#  Print two blank lines after the grid.
		
		lw		$ra,   8 ($sp)				#  Restore the return address
		lw		$v0,  12 ($sp)
		lw		$v1,  16 ($sp)
		lw		$a0,  20 ($sp)
		lw		$a1,  24 ($sp)
		lw		$a2,  28 ($sp)
		lw		$a3,  32 ($sp)
		lw		$t0,  36 ($sp)
		lw		$t1,  40 ($sp)
		lw		$t2,  44 ($sp)
		lw		$t3,  48 ($sp)
		lw		$t4,  52 ($sp)
		lw		$t5,  56 ($sp)
		lw		$t6,  60 ($sp)
		lw		$t7,  64 ($sp)
		lw		$s0,  68 ($sp)
		lw		$s1,  72 ($sp)
		lw		$s2,  76 ($sp)
		lw		$s3,  80 ($sp)
		lw		$s4,  84 ($sp)
		lw		$s5,  88 ($sp)
		lw		$s6,  92 ($sp)
		lw		$s7,  96 ($sp)
		lw		$t8, 100 ($sp)
		lw		$t9, 104 ($sp)
		addi	$sp, $sp, 108
		jr		$ra
		
PSS_Null_Pointer:
		.data
NP:		.asciiz	"Null pointer provided as a parameter.\nCannot print.\n"
		.text
		addi	$sp, $sp, -4
		sw		$v0, 0 ($sp)
		
		li		$v0, 4
		la		$a0, NP
		syscall
		
		lw		$v0, 0 ($sp)
		addi	$sp, $sp, 4
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
		li		$v0, 1
		syscall								#  Print the value of the current cell.
		
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
		
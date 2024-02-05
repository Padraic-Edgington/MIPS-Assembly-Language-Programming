


#############################################################################################
#                                 	Maze Test Suite											#
#																							#
#  Padraic Edgington                                                          18 Jan, 2015	#
#																							#
#																							#
#  v. 1		Initial release  (It appears to work.)											#
#  v. 1.01	Fixed a bug in the assert null function.										#
#############################################################################################

main:	addi	$sp, $sp, -4		#  Make space for $ra on stack
		sw		$ra, 0 ($sp)		#  Store the return address on the stack
		
#############################################################################################
#									Functionality Tests										#
		li		$v0, 4
		la		$a0, t1
		syscall
#############################################################################################
		#  Test #1
		#  An open maze.
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d1				#  Maze
		li		$a1, 0				#  Starting at (0, 0)
		li		$a2, 0				#  
		li		$a3, 32				#  At the entrance.
		jal		Maze_Solver
		
		move	$a0, $v0			#  Result
		la		$a1, s1				#  Expected result
		li		$a2, 1				#  Test #1
		la		$a3, c1				#  Description of test
		jal		assertEqual			#  Check for equality
		.data
d1:		.word	d1a
d1a:	.byte	63
s1:		.asciiz	"X"
c1:		.asciiz	"Testing the termination condition."
		.text
		
		
		#  Test #2
		#  A cell:  no way out.
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d6				#  Maze
		li		$a1, 0				#  Starting at (0, 0)
		li		$a2, 0				#  
		li		$a3, 32				#  At the entrance.
		jal		Maze_Solver
		
		move	$a0, $v0			#  Result
		li		$a2, 2				#  Test #2
		la		$a3, c6				#  Description of test
		jal		assertNull			#  Check for null pointer.
		.data
d6:		.word	d6a
d6a:	.byte	32, 0
c6:		.asciiz	"Testing the default block."
		.text
		
		
		#  Test #3
		#  A door:  move right, then quit.
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d2				#  Maze
		li		$a1, 0				#  Starting at (0, 0)
		li		$a2, 0				#  
		li		$a3, 32				#  At the entrance.
		jal		Maze_Solver
		
		move	$a0, $v0			#  Result
		la		$a1, s2				#  Expected result
		li		$a2, 3				#  Test #3
		la		$a3, c2				#  Description of test
		jal		assertEqual			#  Check for equality
		.data
d2:		.word	d2a
d2a:	.byte	33, 18
s2:		.asciiz	"RX"
c2:		.asciiz	"Testing the move right block."
		.text
		
		
		#  Test #4
		#  A door:  move down, then quit.
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d3				#  Maze
		li		$a1, 0				#  Starting at (0, 1)
		li		$a2, 1				#  
		li		$a3, 32				#  At the entrance.
		jal		Maze_Solver
		
		move	$a0, $v0			#  Result
		la		$a1, s3				#  Expected result
		li		$a2, 4				#  Test #4
		la		$a3, c3				#  Description of test
		jal		assertEqual			#  Check for equality
		.data
d3:		.word	d3b, d3a
d3a:	.byte	36
d3b:	.byte	24
s3:		.asciiz	"DX"
c3:		.asciiz	"Testing the move down block."
		.text
		
		
		#  Test #5
		#  A door:  move up, then quit.
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d4				#  Maze
		li		$a1, 0				#  Starting at (0, 0)
		li		$a2, 0				#  
		li		$a3, 32				#  At the entrance.
		jal		Maze_Solver
		
		move	$a0, $v0			#  Result
		la		$a1, s4				#  Expected result
		li		$a2, 5				#  Test #5
		la		$a3, c4				#  Description of test
		jal		assertEqual			#  Check for equality
		.data
d4:		.word	d4b, d4a
d4a:	.byte	20
d4b:	.byte	40
s4:		.asciiz	"UX"
c4:		.asciiz	"Testing the move right block."
		.text
		
		
		#  Test #6
		#  A door:  move left, then quit.
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d5				#  Maze
		li		$a1, 1				#  Starting at (1, 0)
		li		$a2, 0				#  
		li		$a3, 32				#  At the entrance.
		jal		Maze_Solver
		
		move	$a0, $v0			#  Result
		la		$a1, s5				#  Expected result
		li		$a2, 6				#  Test #6
		la		$a3, c5				#  Description of test
		jal		assertEqual			#  Check for equality
		.data
d5:		.word	d5a	
d5a:	.byte	17, 34
s5:		.asciiz	"LX"
c5:		.asciiz	"Testing the move left block."
		.text
		
		
		#  Test #7								|   _X_|
		#  A 2x2 maze:  basic recursion			| E    |
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d7				#  Maze
		li		$a1, 0				#  Starting at (0, 0)
		li		$a2, 0				#  
		li		$a3, 32				#  At the entrance.
		jal		Maze_Solver
		
		move	$a0, $v0			#  Result
		la		$a1, s7				#  Expected result
		li		$a2, 7				#  Test #7
		la		$a3, c7				#  Description of test
		jal		assertEqual			#  Check for equality
		.data
d7:		.word	d7b, d7a	
d7a:	.byte	 5, 18
d7b:	.byte	41, 2
s7:		.asciiz	"URX"
c7:		.asciiz	"Basic recursion test."
		.text
		
		
		#  Test #8											|   | X |
		#  A 2x2 maze:  basic recursion with backtracking.	| E     |
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d8				#  Maze
		li		$a1, 0				#  Starting at (0, 0)
		li		$a2, 0				#  
		li		$a3, 32				#  At the entrance.
		jal		Maze_Solver
		
		move	$a0, $v0			#  Result
		la		$a1, s8				#  Expected result
		li		$a2, 8				#  Test #8
		la		$a3, c8				#  Description of test
		jal		assertEqual			#  Check for equality
		.data
d8:		.word	d8b, d8a	
d8a:	.byte	 4, 20
d8b:	.byte	41, 10
s8:		.asciiz	"RUX"
c8:		.asciiz	"Basic recursion test with backtracking."
		.text
		
		
		#  Test #9
		#  A 4x4 maze:  intermediate recursion
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d9				#  Maze
		li		$a1, 2				#  Starting at (2, 0)
		li		$a2, 0				#  
		li		$a3, 32				#  At the entrance.
		jal		Maze_Solver
		
		move	$a0, $v0			#  Result
		la		$a1, s9				#  Expected result
		li		$a2, 9				#  Test #9
		la		$a3, c9				#  Description of test
		jal		assertEqual			#  Check for equality
		.data
d9:		.word	d9d, d9c, d9b, d9a
d9a:	.byte	 5,  2,  4, 20
d9b:	.byte	13,  7, 11, 10
d9c:	.byte	12,  8,  5,  2
d9d:	.byte	 9,  3, 43,  2
s9:		.asciiz	"LLUURRRUX"
c9:		.asciiz	"Intermediate recursion test."
		.text
		
		
		#  Test #10
		#  A 10x10 maze:  advanced recursion
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d10			#  Maze
		li		$a1, 4				#  Starting at (4, 4)
		li		$a2, 4				#  
		li		$a3, 32				#  At the entrance.
		jal		Maze_Solver
		
		move	$a0, $v0			#  Result
		la		$a1, s10			#  Expected result
		li		$a2, 10				#  Test #10
		la		$a3, c10			#  Description of test
		jal		assertEqual			#  Check for equality
		.data
d10:	.word	d10j, d10i, d10h, d10g, d10f, d10e, d10d, d10c, d10b, d10a	
d10a:	.byte	 4,  1,  6,  5,  3,  2,  1,  6,  5,  2
d10b:	.byte	13,  7, 11, 14,  5,  2,  4, 13, 11,  6
d10c:	.byte	12,  9,  6,  9, 11,  7, 15, 10,  4, 12
d10d:	.byte	12,  5, 10,  4,  5, 10,  8,  5, 11, 10
d10e:	.byte	12,  8,  1, 15, 10, 17,  3, 14,  5,  6
d10f:	.byte	 9,  3,  6,  8, 36,  1,  6,  9, 14,  8
d10g:	.byte	 4,  5, 11,  2, 13,  2, 13,  2,  9,  2
d10h:	.byte	12, 13,  2,  4, 13,  3, 10,  1,  7,  2
d10i:	.byte	13, 11,  6, 12,  9,  6,  4,  4, 13,  6
d10j:	.byte	 9,  2,  9, 11,  3, 11, 11, 11, 10,  8
s10:	.asciiz	"DDDRDLLLULUURULLUUUURRRDRRRRURRDDLLDLLX"
c10:	.asciiz	"Full test."
		.text
		
		
		#  Test #11
		#  A 10x10 maze:  unsolvable
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d11			#  Maze
		li		$a1, 4				#  Starting at (4, 4)
		li		$a2, 4				#  
		li		$a3, 32				#  At the entrance.
		jal		Maze_Solver
		
		move	$a0, $v0			#  Result
		li		$a2, 11				#  Test #11
		la		$a3, c11			#  Description of test
		jal		assertNull			#  Check for equality
		.data
d11:	.word	d11j, d11i, d11h, d11g, d11f, d11e, d11d, d11c, d11b, d11a	
d11a:	.byte	 4,  1,  6,  5,  3,  2,  1,  6,  5,  2
d11b:	.byte	13,  7, 11, 14,  5,  2,  4, 13, 11,  6
d11c:	.byte	12,  9,  6,  9, 11,  7, 15, 10,  4, 12
d11d:	.byte	12,  5, 10,  4,  5, 10,  8,  5, 11, 10
d11e:	.byte	12,  8,  1, 15, 10,  1,  3, 14,  5,  6
d11f:	.byte	 9,  3,  6,  8, 36,  1,  6,  9, 14,  8
d11g:	.byte	 4,  5, 11,  2, 13,  2, 13,  2,  9,  2
d11h:	.byte	12, 13,  2,  4, 13,  3, 10,  1,  7,  2
d11i:	.byte	13, 11,  6, 12,  9,  6,  4,  4, 13,  6
d11j:	.byte	 9,  2,  9, 11,  3, 11, 11, 11, 10,  8
c11:	.asciiz	"Full test with no solution."
		.text
		
		
		
		
#############################################################################################
#									Error Checking Tests									#
		li		$v0, 4
		la		$a0, t2
		syscall
#############################################################################################
		#  Test #101
		#  Null pointer for a maze
		#######################################################################
		jal		setSavedRegisters
		li		$a0, 0				#  Maze
		li		$a1, 0				#  Starting at (0, 0)
		li		$a2, 0				#  
		li		$a3, 32				#  At the entrance.
		jal		Maze_Solver
		
		move	$a0, $v0			#  Result
		li		$a2, 101			#  Test #101
		la		$a3, c101			#  Description of test
		jal		assertError			#  Check for an error.
		.data
c101:	.asciiz	"Null pointer check."
		.text
		
		
		#  Test #102
		#  Pointer outside of memory
		#######################################################################
		jal		setSavedRegisters
		li		$a0, 0xC0000000		#  Maze
		li		$a1, 0				#  Starting at (0, 0)
		li		$a2, 0				#  
		li		$a3, 32				#  At the entrance.
		jal		Maze_Solver
		
		move	$a0, $v0			#  Result
		li		$a2, 102			#  Test #102
		la		$a3, c102			#  Description of test
		jal		assertError			#  Check for an error
		.data
c102:	.asciiz	"Maze pointer too high for dynamic data memory."
		.text
		
		
		#  Test #103
		#  Pointer outside of memory
		#######################################################################
		jal		setSavedRegisters
		li		$a0, -40			#  Maze
		li		$a1, 0				#  Starting at (0, 0)
		li		$a2, 0				#  
		li		$a3, 32				#  At the entrance.
		jal		Maze_Solver
		
		move	$a0, $v0			#  Result
		li		$a2, 103			#  Test #103
		la		$a3, c103			#  Description of test
		jal		assertError			#  Check for an error
		.data
c103:	.asciiz	"Maze pointer below zero."
		.text
		
		
		#  Test #104
		#  Pointer outside of memory
		#######################################################################
		jal		setSavedRegisters
		li		$a0, 0x0FCDA890		#  Maze
		li		$a1, 0				#  Starting at (0, 0)
		li		$a2, 0				#  
		li		$a3, 32				#  At the entrance.
		jal		Maze_Solver
		
		move	$a0, $v0			#  Result
		li		$a2, 104			#  Test #104
		la		$a3, c104			#  Description of test
		jal		assertError			#  Check for an error
		.data
c104:	.asciiz	"Pointer in text range."
		.text

		
		
		
		
		
		
		
		
		#  All tests completed.
		.data
t1:		.asciiz	"----------Starting functionality tests.----------\n"
t2:		.asciiz	"----------Starting parameter checking tests.----------\n"
f:		.asciiz	"----------Testing completed.----------\n"
		.text
		li		$v0, 4
		la		$a0, f
		syscall
		lw		$ra, 0 ($sp)		#  Load return address
		addi	$sp, $sp, 4			#  Pop the stack
		jr		$ra

		
		
		
		
		
###############################################################################
##                            Assertion functions                            ##
###############################################################################
		#  Assert Equality
		#	$a0:  Observed
		#	$a1:  Expected
		#	$a2:  Test #
		#	$a3:  Test description
		#######################################################################
assertEqual:
		#  Check for obviously bad results first.
		beqz	$a0, AEFailNullPointer					#  Check for a null pointer.
		li		$t0, -1
		beq		$a0, $t0, AEFailBadParameter			#  Check for the error condition.
		blt		$a0, 0x10008000, AEFailNotAPointer		#  Check for addresses below the dynamic memory range.
		bgeu	$a0, $sp, AEFailNotAPointer				#  Check for addresses above the dynamic memory range.
		srl		$t0, $a0, 2
		sll		$t0, $t0, 2
		bne		$a0, $t0, AEFailNotAPointer				#  Check for a non-word aligned address.
		
		#  Comparing the results with the expected solution.
		move	$t0, $a0
		move	$t1, $a1
AELoop:	lb		$t2, 0 ($t1)
		beqz	$t0, AEObservedFinished					#  A null pointer indicates the end of the observed result.
		beqz	$t2, AEFailObservedTooLong				#  The expected string is null terminated.
		
		lw		$t3, 0 ($t0)
		bne		$t3, $t2, AEFailMismatch				#  Compare observed to expected.  Yes, the word result really should equal the expected byte.
		
		lw		$t0, 4 ($t0)							#  Get the next direction in the linked list.
		addi	$t1, $t1, 1								#  Get the next character in the string.
		
		j		AELoop
		
AEObservedFinished:
		bnez	$t2, AEFailObservedTooShort				#  The expected string still has more instructions.
		
		#  Correct solution.
		li		$a0, 1
		j		Results
		
		
		#  Failed because a null pointer was observed.
AEFailNullPointer:
		li		$a0, 0
		la		$a1, AEFNP
		j		Results
		.data
AEFNP:	.asciiz	"The function returned a null pointer.\nThis problem was solvable and should return a solution object.\n"
		.text
		
		#  Failed because an error was returned.
AEFailBadParameter:
		li		$a0, 0
		la		$a1, AEFBP
		j		Results
		.data
AEFBP:	.asciiz	"The function returned an error.\nThis problem was solvable and should return a solution object.\n"
		.text
		
		#  Failed because some garbage was returned.
AEFailNotAPointer:
		li		$a0, 0
		la		$a1, AEFNAP
		j		Results
		.data
AEFNAP:	.asciiz	"Your results could not be identified.\nThe function returned something other than a solution object.\n"
		.text
		
		#  Failed because the solution was longer than expected.
AEFailObservedTooLong:
		li		$a0, 0
		la		$a1, AEFOTL
		j		Results
		.data
AEFOTL:	.asciiz	"The function found the correct route, but included additional instructions after 'exit the maze.'\n"
		.text
		
		#  Failed because the solution was shorter than expected.
AEFailObservedTooShort:
		addi	$sp, $sp, -8
		sw		$a0, 0 ($sp)
		sw		$a1, 4 ($sp)
		li		$a0, 0
		la		$a1, AEFOTS
		j		Results
AEFOTS:	li		$v0, 4
		la		$a0, AEFOTS1
		syscall
		j		AEFPrintResults
		.data
AEFOTS1:	.asciiz	"The function was on the correct path, but quit before the end.\n"
		.text
		
		#  Failed because the observed results did not match the expected results.
AEFailMismatch:
		addi	$sp, $sp, -8
		sw		$a0, 0 ($sp)
		sw		$a1, 4 ($sp)
		li		$a0, 0
		la		$a1, AEFM
		j		Results
AEFM:	li		$v0, 4
		la		$a0, AEFM1
		syscall
		j		AEFPrintResults
		.data
AEFM1:	.asciiz	"The instructions returned are incorrect.\n"
		.text
		
		#  Displaying the observed and expected results.
AEFPrintResults:
		lw		$t0, 0 ($sp)						#  Observed result
		lw		$t1, 4 ($sp)						#  Expected result
		addi	$sp, $sp, 8

		li		$v0, 4
		la		$a0, AEFPRO
		syscall
		
AEFPRObservedLoop:
		beqz	$t0, AEFPRObservedLoopEnd
		
		li		$v0, 4
		la		$a0, AEFPRA
		syscall
		
		li		$v0, 11
		lw		$a0, 0 ($t0)
		syscall
		
		lw		$t0, 4 ($t0)
		j		AEFPRObservedLoop
		
AEFPRObservedLoopEnd:

		li		$v0, 4
		la		$a0, nl
		syscall
		la		$a0, AEFPRE
		syscall
		
AEFPRExpectedLoop:
		lb		$t2, 0 ($t1)
		beqz	$t2, AEFPRExpectedLoopEnd
		
		li		$v0, 4
		la		$a0, AEFPRA
		syscall
		
		li		$v0, 11
		move	$a0, $t2
		syscall
		
		addi	$t1, $t1, 1
		j		AEFPRExpectedLoop
		
AEFPRExpectedLoopEnd:
		li		$v0, 4
		la		$a0, nl
		syscall
		syscall
		
		jr		$ra
		
		
		.data
AEFPRO:	.asciiz	"Observed:  E"
AEFPRE:	.asciiz	"Expected:  E"
AEFPRA:	.asciiz	" > "
		.text



		
		#######################################################################
		#  Assert Null Pointer
		#	$a0:  Observed
		#	   :  Expect a null pointer (0).
		#	$a2:  Test #
		#	$a3:  Test description
		#######################################################################
assertNull:
		bnez	$a0, AN_Failed
		
		li		$a0, 1			#  Correct result.
		j		Results
		
AN_Failed:
		li		$a0, 0			#  Incorrect result.
		la		$a1, ANF		#  Description of failure.
		j		Results
		.data
ANF:	.asciiz	"Null pointer expected.  This problem was not solvable.\n"
		.text
		
		



		#######################################################################
		#  Assert Error
		#	$a0:  Observed
		#	   :  Expect an error signal (-1).
		#	$a2:  Test #
		#	$a3:  Test description
		#######################################################################
assertError:
		li		$t0, -1
		bne		$a0, $t0, AE_Failed
		
		li		$a0, 1			#  Correct result.
		j		Results
		
AE_Failed:
		li		$a0, 0			#  Incorrect result.
		la		$a1, AEF		#  Description of failure.
		j		Results
		.data
AEF:	.asciiz	"The parameters were not parsable, the function should have returned an error (-1).\n"
		.text



		
		
		#  Results
		#
		#  Display the results of the test.
		#	$a0:  Pass (1) or fail (0).
		#	$a1:  Description of failure if needed.
		#	$a2:  Test #
		#	$a3:  Test description
		#######################################################################
Results:
		bnez		$a0, checkSavedRegisters
Res1:	move		$t0, $a0
		move		$t1, $a1
		move		$t2, $a2
		move		$t3, $a3
		#  Print the header.
		li		$v0, 4
		la		$a0, R1
		syscall
		li		$v0, 1
		move	$a0, $t2
		syscall
		
		bnez		$t0, RPass

		#  Failed the test.
		li		$v0, 4
		la		$a0, RF
		syscall
		move	$a0, $t3
		syscall
		la		$a0, nl
		syscall
		blt		$t1, 0x10000000, RPrintFunction
		move	$a0, $t1			#  Displaying a simple error message.
		syscall
		la		$a0, nl
		syscall
		jr		$ra
RPrintFunction:						#  Calling a print function for extra detail.
		jr		$t1
		
		#  Passed the test.
RPass:	li		$v0, 4
		la		$a0, RP
		syscall
		move	$a0, $t3
		syscall
		la		$a0, nl
		syscall
		jr		$ra
		
		.data
R1:		.asciiz	"Test #"
nl:		.asciiz	"\n"
RP:		.asciiz	" passed:  "
RF:		.asciiz	" failed:  "
		.text



		
		#  Set Saved Registers
		#######################################################################
setSavedRegisters:
		li		$s0, 14
		li		$s1, 73
		li		$s2, 69
		li		$s3, 46
		li		$s4, 79
		li		$s5, 92
		li		$s6, 37
		li		$s7, 96
		li		$t0, 14
		li		$t1, -72
		li		$t2, 12331
		li		$t3, 18
		li		$t4, 456
		li		$t5, 09876
		li		$t6, 6789
		li		$t7, 3443
		li		$t8, 2343
		li		$t9, 98
		li		$v0, 3876
		li		$v1, 3443
		li		$a0, 23453
		li		$a1, 34432
		li		$a2, 543
		li		$a3, -234543
		jr		$ra
		
		#  Check Saved Registers
		#######################################################################
checkSavedRegisters:
		bne		$s0, 14, regFail
		bne		$s1, 73, regFail
		bne		$s2, 69, regFail
		bne		$s3, 46, regFail
		bne		$s4, 79, regFail
		bne		$s5, 92, regFail
		bne		$s6, 37, regFail
		bne		$s7, 96, regFail
		j		Res1
		
regFail:
		.data
rf:		.asciiz	"Your function returned the correct value, but has changed the saved registers.\nYou must follow the conventions and restore the state of any saved register ($s0-$s7) when you're finished with it.\n"
		.text
		li		$a0, 0
		la		$a1, rf
		j		Res1
		
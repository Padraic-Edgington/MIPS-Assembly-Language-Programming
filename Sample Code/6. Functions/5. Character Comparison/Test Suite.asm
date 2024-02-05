
#############################################################################################
#                          Unit Tests for Recursion & Memory Function						#
#																							#
#  Padraic Edgington                                                          15 Oct, 2013	#
#																							#
#                                            v. 1.0											#
#  If there are bugs in this code, you may check back later for an updated version.			#
#																							#
#  You should write your code in a seperate file and prepend it to this file by running		#
#  either:																					#
#  Windows: copy /Y <Program #4 Name>.asm + "Program #4 - Test Suite.asm" <output>.asm		#
#  Unix:    cat <Program #4 Name>.asm "Program #4 - Test Suite.asm" > <output>.s			#
#																							#
#  v. 1    Initial release																	#
#############################################################################################


main:	addi	$sp, $sp, -4			#  Make space for $ra on stack
		sw		$ra, 0 ($sp)		#  Store the return address on the stack


###############################################################################
##                           Testing memory reading                          ##
###############################################################################
		#  Test #1
		#  compare(A, a);
		#######################################################################
		jal		setSavedRegisters
		li		$a0, 65				#  Character #1
		li		$a1, 97				#  Character #2
		jal		compare
		
		move	$a0, $v0			#  Result
		li		$a1, 1				#  Expected result
		li		$a2, 1				#  Test #1
		jal		assertEqual			#  Check for equality
		
		#  Test #2
		#  compare(q, Q);
		#######################################################################
		jal		setSavedRegisters
		li		$a0, 113			#  Character #1
		li		$a1, 81				#  Character #2
		jal		compare
		
		move	$a0, $v0			#  Result
		li		$a1, 1				#  Expected result
		li		$a2, 2				#  Test #2
		jal		assertEqual			#  Check for equality
		
		#  Test #3
		#  compare(7, 0);
		#######################################################################
		jal		setSavedRegisters
		li		$a0, 55				#  Character #1
		li		$a1, 48				#  Character #2
		jal		compare
		
		move	$a0, $v0			#  Result
		li		$a1, 2				#  Expected result
		li		$a2, 3				#  Test #3
		jal		assertEqual			#  Check for equality
		
		#  Test #4
		#  compare({, z);
		#######################################################################
		jal		setSavedRegisters
		li		$a0, 123			#  Character #1
		li		$a1, 122			#  Character #2
		jal		compare
		
		move	$a0, $v0			#  Result
		li		$a1, 0				#  Expected result
		li		$a2, 4				#  Test #4
		jal		assertEqual			#  Check for equality
		
		#  Test #5
		#  compare(&, %);
		#######################################################################
		jal		setSavedRegisters
		li		$a0, 38				#  Character #1
		li		$a1, 37				#  Character #2
		jal		compare
		
		move	$a0, $v0			#  Result
		li		$a1, 1				#  Expected result
		li		$a2, 5				#  Test #5
		jal		assertEqual			#  Check for equality
		
		#  Test #6
		#  compare( , I);
		#######################################################################
		jal		setSavedRegisters
		li		$a0, 32				#  Character #1
		li		$a1, 73				#  Character #2
		jal		compare
		
		move	$a0, $v0			#  Result
		li		$a1, 0				#  Expected result
		li		$a2, 6				#  Test #6
		jal		assertEqual			#  Check for equality
		
		#  Test #7
		#  compare(, );
		#######################################################################
		jal		setSavedRegisters
		li		$a0, 				#  Character #1
		li		$a1, 				#  Character #2
		jal		compare
		
		move	$a0, $v0			#  Result
		li		$a1, 				#  Expected result
		li		$a2, 7				#  Test #7
		jal		assertEqual			#  Check for equality
		
		#  Test #8
		#  compare(, );
		#######################################################################
		jal		setSavedRegisters
		li		$a0, 				#  Character #1
		li		$a1, 				#  Character #2
		jal		compare
		
		move	$a0, $v0			#  Result
		li		$a1, 				#  Expected result
		li		$a2, 8				#  Test #8
		jal		assertEqual			#  Check for equality
		
		#  Test #9
		#  compare(, );
		#######################################################################
		jal		setSavedRegisters
		li		$a0, 				#  Character #1
		li		$a1, 				#  Character #2
		jal		compare
		
		move	$a0, $v0			#  Result
		li		$a1, 				#  Expected result
		li		$a2, 9				#  Test #9
		jal		assertEqual			#  Check for equality
		
		#  Test #10
		#  compare(, );
		#######################################################################
		jal		setSavedRegisters
		li		$a0, 				#  Character #1
		li		$a1, 				#  Character #2
		jal		compare
		
		move	$a0, $v0			#  Result
		li		$a1, 				#  Expected result
		li		$a2, 10				#  Test #10
		jal		assertEqual			#  Check for equality
		
		
		
		#  All tests completed.
		lw		$ra, 0 ($sp)		#  Load return address
		addi	$sp, $sp, 4			#  Pop the stack
		j		$ra

		
		
###############################################################################
##                            Assertion functions                            ##
###############################################################################
		#  Assert Equality
		#######################################################################
assertEqual:
		.data
eq1:	.asciiz	"Test #"
eq2:	.asciiz " failed:  Expected value:  "
eq3:	.asciiz	" \tObserved value:  "
eq4:	.asciiz "\n"
		.text
		
		addi	$sp, $sp, -12		#  Make space for three variables on the stack
		sw		$a0, 8 ($sp)		#  Store the result
		sw		$a1, 4 ($sp)		#  Store the expected result
		sw		$a2, 0 ($sp)		#  Store the test number
		
		li		$v0, 4
		la		$a0, eq1
		syscall						#  Print "Test #"
		
		li		$v0, 1
		lw		$a0,  0 ($sp)
		syscall						#  Print test number
		
		
		#  If the result matches the expected value, then the test is successful.
		lw		$t0, 8 ($sp)
		lw		$t1, 4 ($sp)
		beq		$t0, $t1, Pass
		#  Otherwise, it failed.
		
		li		$v0, 4
		la		$a0, eq2
		syscall						#  Print " failed:  Expected value:  "
		
		li		$v0, 1
		move	$a0, $t1
		syscall						#  Print expected value
		
		li		$v0, 4
		la		$a0, eq3
		syscall						#  Print " \tObserved value:  "
		
		li		$v0, 1
		move	$a0, $t0
		syscall						#  Print observed value
		
		li		$v0, 4
		la		$a0, eq4
		syscall						#  Add a new line
		
		addi	$sp, $sp, 12		#  Pop the stack
		
		jr		$ra					#  Return to caller
		
		
		#  Assertion Success
		#######################################################################
		.data
s1:		.asciiz	" passed.\n"
		.text
Pass:	
		j		checkSavedRegisters	#  Check the saved registers before signing off.
		
Pass1:	li		$v0, 4				#  Print string
		la		$a0, s1				#  " passed.\n"
		syscall
		
		addi	$sp, $sp, 12		#  Pop the stack
		
		jr		$ra					#  Return to caller
		


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
		j		Pass1
		
regFail:
		.data
rf:		.asciiz	" has changed the saved registers.\n"
		.text
		li		$v0, 4
		la		$a0, rf
		syscall
		
		addi	$sp, $sp, 12		#  Pop the stack
		jr		$ra					#  Return to caller
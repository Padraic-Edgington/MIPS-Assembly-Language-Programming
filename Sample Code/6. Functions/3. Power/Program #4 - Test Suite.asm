
#############################################################################################
#                              Unit Tests for Power Function								#
#																							#
#  Padraic Edgington                                                          12 Feb, 2013	#
#																							#
#                                            v. 1.1											#
#  If there are bugs in this code, you may check back later for an updated version.			#
#																							#
#  You should write your code in a seperate file and prepend it to this file by running		#
#  either:																					#
#  Windows: copy /Y <Power Function Name>.asm + "Program #4 - Test Suite.asm" <output>.asm	#
#  Unix:    cat <Power Function Name>.asm "Program #4 - Test Suite.asm" > <output>.asm		#
#																							#
#  v. 1    Initial release																	#
#  v. 1.1  Added 67^0 as a new test.														#
#############################################################################################


main:	addi	$sp, $sp, -4			#  Make space for $ra on stack
		sw		$ra, 0 ($sp)		#  Store the return address on the stack


###############################################################################
##                          Testing power function                           ##
###############################################################################
		#  Test #1
		#  1^1
		#######################################################################
		jal		setSavedRegisters
		li		$a0, 1				#  Base
		li		$a1, 1				#  Power
		jal		power
		
		move	$a0, $v0			#  Result
		li		$a1, 1				#  Expected result
		li		$a2, 1				#  Test #1
		jal		assertEqual			#  Check for equality
		
		#  Test #2
		#  1^2
		#######################################################################
		jal		setSavedRegisters
		li		$a0, 1				#  Base
		li		$a1, 2				#  Power
		jal		power
		
		move	$a0, $v0			#  Result
		li		$a1, 1				#  Expected result
		li		$a2, 2				#  Test #2
		jal		assertEqual			#  Check for equality
		
		#  Test #3
		#  1^42
		#######################################################################
		jal		setSavedRegisters
		li		$a0, 1				#  Base
		li		$a1, 42				#  Power
		jal		power
		
		move	$a0, $v0			#  Result
		li		$a1, 1				#  Expected result
		li		$a2, 3				#  Test #3
		jal		assertEqual			#  Check for equality
		
		#  Test #4
		#  1^0
		#######################################################################
		jal		setSavedRegisters
		li		$a0, 1				#  Base
		li		$a1, 0				#  Power
		jal		power
		
		move	$a0, $v0			#  Result
		li		$a1, 1				#  Expected result
		li		$a2, 4				#  Test #4
		jal		assertEqual			#  Check for equality
		
		#  Test #5
		#  67^0
		#######################################################################
		jal		setSavedRegisters
		li		$a0, 67				#  Base
		li		$a1, 0				#  Power
		jal		power
		
		move	$a0, $v0			#  Result
		li		$a1, 1				#  Expected result
		li		$a2, 5				#  Test #5
		jal		assertEqual			#  Check for equality
		
		#  Test #6
		#  2^1
		#######################################################################
		jal		setSavedRegisters
		li		$a0, 2				#  Base
		li		$a1, 1				#  Power
		jal		power
		
		move	$a0, $v0			#  Result
		li		$a1, 2				#  Expected result
		li		$a2, 6				#  Test #6
		jal		assertEqual			#  Check for equality
		
		#  Test #7
		#  2^2
		#######################################################################
		jal		setSavedRegisters
		li		$a0, 2				#  Base
		li		$a1, 2				#  Power
		jal		power
		
		move	$a0, $v0			#  Result
		li		$a1, 4				#  Expected result
		li		$a2, 7				#  Test #7
		jal		assertEqual			#  Check for equality
		
		#  Test #8
		#  2^10
		#######################################################################
		jal		setSavedRegisters
		li		$a0, 2				#  Base
		li		$a1, 10				#  Power
		jal		power
		
		move	$a0, $v0			#  Result
		li		$a1, 1024			#  Expected result
		li		$a2, 8				#  Test #8
		jal		assertEqual			#  Check for equality
		
		#  Test #9
		#  10^12
		#######################################################################
		jal		setSavedRegisters
		li		$a0, 1024			#  Base
		li		$a1, 3				#  Power
		jal		power
		
		move	$a0, $v0			#  Result
		li		$a1, 1073741824		#  Expected result
		li		$a2, 9				#  Test #9
		jal		assertEqual			#  Check for equality
		
		#  Test #10
		#  -1^12
		#######################################################################
		jal		setSavedRegisters
		li		$a0, -1				#  Base
		li		$a1, 12				#  Power
		jal		power
		
		move	$a0, $v0			#  Result
		li		$a1, 1				#  Expected result
		li		$a2, 10				#  Test #10
		jal		assertEqual			#  Check for equality
		
		#  Test #11
		#  -3^5
		#######################################################################
		jal		setSavedRegisters
		li		$a0, -3				#  Base
		li		$a1, 5				#  Power
		jal		power
		
		move	$a0, $v0			#  Result
		li		$a1, -243			#  Expected result
		li		$a2, 11				#  Test #11
		jal		assertEqual			#  Check for equality
		
		
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
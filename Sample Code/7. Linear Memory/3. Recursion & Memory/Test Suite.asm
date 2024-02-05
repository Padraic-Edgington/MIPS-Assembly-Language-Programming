
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

		.data
x10:	.word	 1, x10a
x1:		.word	 6, 0
x10a:	.word	 7, x10b
x2:		.word	42, 0
x10b:	.word	 1, x10c
x3:		.word	 3, 0
x10c:	.word	 3, x10d
x4:		.word	-7, 0
x10d:	.word	 2, x10e
x5:		.word	 1, 0
x10e:	.word	 1, x10f
x6:		.word	 1, x6a
x10f:	.word	-5, x10g
x6a:	.word	 5, 0
x10g:	.word	 1, x10h
x7:		.word	 1, x7a
x10h:	.word	 1, x10i
x7a:	.word	 3, 0
x10i:	.word	-3, 0
x8:		.word	 8, x8a
x9c:	.word	 8, 0
x8a:	.word	 3, x8b
x9b:	.word	 1, x9c
x8b:	.word	 7, 0
x9a:	.word	14, x9b
x9:		.word	 2, x9a
x11:	.word	 3, x11a
x11a:	.word	-1, 0

		.text

main:	addi	$sp, $sp, -4			#  Make space for $ra on stack
		sw		$ra, 0 ($sp)		#  Store the return address on the stack


###############################################################################
##                           Testing memory reading                          ##
###############################################################################
		#  Test #1
		#  func(x1, 2);
		#######################################################################
		jal		setSavedRegisters
		la		$a0, x1				#  Linked list
		li		$a1, 2				#  c
		jal		func
		
		move	$a0, $v0			#  Result
		li		$a1, 12				#  Expected result
		li		$a2, 1				#  Test #1
		jal		assertEqual			#  Check for equality
		
		#  Test #2
		#  func(x2, 3);
		#######################################################################
		jal		setSavedRegisters
		la		$a0, x2				#  Linked list
		li		$a1, 3				#  c
		jal		func
		
		move	$a0, $v0			#  Result
		li		$a1, 126			#  Expected result
		li		$a2, 2				#  Test #2
		jal		assertEqual			#  Check for equality
		
		#  Test #3
		#  func(x3, 4);
		#######################################################################
		jal		setSavedRegisters
		la		$a0, x3				#  Linked list
		li		$a1, 4				#  c
		jal		func
		
		move	$a0, $v0			#  Result
		li		$a1, 28				#  Expected result
		li		$a2, 3				#  Test #3
		jal		assertEqual			#  Check for equality
		
		#  Test #4
		#  func(x4, 5)
		#######################################################################
		jal		setSavedRegisters
		la		$a0, x4				#  Linked list
		li		$a1, 5				#  c
		jal		func
		
		move	$a0, $v0			#  Result
		li		$a1, 35				#  Expected result
		li		$a2, 4				#  Test #4
		jal		assertEqual			#  Check for equality
		
		#  Test #5
		#  func(x5, 6)
		#######################################################################
		jal		setSavedRegisters
		la		$a0, x5				#  Linked list
		li		$a1, 6				#  c
		jal		func
		
		move	$a0, $v0			#  Result
		li		$a1, 42				#  Expected result
		li		$a2, 5				#  Test #5
		jal		assertEqual			#  Check for equality

		
###############################################################################
##                           Testing memory writing                          ##
###############################################################################
		#  Test #6
		#  func(x1, 7)
		#######################################################################
		jal		setSavedRegisters
		la		$a0, x1				#  Linked list
		li		$a1, 7				#  c
		jal		func
		
		move	$a0, $v0			#  Result
		li		$a1, 84				#  Expected result
		li		$a2, 6				#  Test #6
		jal		assertEqual			#  Check for equality
		
		#  Test #7
		#  func(x2, 8)
		#######################################################################
		jal		setSavedRegisters
		la		$a0, x2				#  Linked list
		li		$a1, 8				#  c
		jal		func
		
		move	$a0, $v0			#  Result
		li		$a1, 1008			#  Expected result
		li		$a2, 7				#  Test #7
		jal		assertEqual			#  Check for equality
		
		#  Test #8
		#  func(x3, 9)
		#######################################################################
		jal		setSavedRegisters
		la		$a0, x3				#  Linked list
		li		$a1, 9				#  c
		jal		func
		
		move	$a0, $v0			#  Result
		li		$a1, 252			#  Expected result
		li		$a2, 8				#  Test #8
		jal		assertEqual			#  Check for equality
		
		
###############################################################################
##                         Testing function recursion                        ##
###############################################################################
		#  Test #9
		#  func(x11, 3)
		#######################################################################
		jal		setSavedRegisters
		la		$a0, x11			#  Linked list
		li		$a1, 3				#  c
		jal		func
		
		move	$a0, $v0			#  Result
		li		$a1, 63				#  Expected result
		li		$a2, 9				#  Test #9
		jal		assertEqual			#  Check for equality
		
		#  Test #10
		#  func(x6, 10)
		#######################################################################
		jal		setSavedRegisters
		la		$a0, x6				#  Linked list
		li		$a1, 10				#  c
		jal		func
		
		move	$a0, $v0			#  Result
		li		$a1, 25				#  Expected result
		li		$a2, 10				#  Test #10
		jal		assertEqual			#  Check for equality
		
		#  Test #11
		#  func(x7, 11)
		#######################################################################
		jal		setSavedRegisters
		la		$a0, x7				#  Linked list
		li		$a1, 11				#  c
		jal		func
		
		move	$a0, $v0			#  Result
		li		$a1, 49				#  Expected result
		li		$a2, 11				#  Test #11
		jal		assertEqual			#  Check for equality
		
		#  Test #12
		#  func(x8, 12)
		#######################################################################
		jal		setSavedRegisters
		la		$a0, x8				#  Linked list
		li		$a1, 12				#  c
		jal		func
		
		move	$a0, $v0			#  Result
		li		$a1, 96				#  Expected result
		li		$a2, 12				#  Test #12
		jal		assertEqual			#  Check for equality
		
		#  Test #13
		#  func(x9, 13)
		#######################################################################
		jal		setSavedRegisters
		la		$a0, x9				#  Linked list
		li		$a1, 13				#  c
		jal		func
		
		move	$a0, $v0			#  Result
		li		$a1, 364			#  Expected result
		li		$a2, 13				#  Test #13
		jal		assertEqual			#  Check for equality
		
		#  Test #14
		#  func(x10, 14)
		#######################################################################
		jal		setSavedRegisters
		la		$a0, x10			#  Linked list
		li		$a1, 14				#  c
		jal		func
		
		move	$a0, $v0			#  Result
		li		$a1, 49				#  Expected result
		li		$a2, 14				#  Test #14
		jal		assertEqual			#  Check for equality
		
		#  Test #15
		#  func(x10, 15)
		#######################################################################
		jal		setSavedRegisters
		la		$a0, x10			#  Linked list
		li		$a1, 15				#  c
		jal		func
		
		move	$a0, $v0			#  Result
		li		$a1, 735			#  Expected result
		li		$a2, 15				#  Test #15
		jal		assertEqual			#  Check for equality
		
		#  Test #16
		#  func(x10, 16)
		#######################################################################
		jal		setSavedRegisters
		la		$a0, x10			#  Linked list
		li		$a1, 16				#  c
		jal		func
		
		move	$a0, $v0			#  Result
		li		$a1, 11760			#  Expected result
		li		$a2, 16				#  Test #16
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
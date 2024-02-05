#############################################################################################
#                          Unit Tests for String Reversal Function							#
#																							#
#  Padraic Edgington                                                          28 Feb, 2013	#
#																							#
#                                            v. 1.2											#
#  If there are bugs in this code, you may check back later for an updated version.			#
#																							#
#  You should write your code in a seperate file and prepend it to this file by running		#
#  either:																					#
#  Windows: copy /Y <SR Function Name>.asm + "Program #6 - Test Suite.asm" <output>.asm		#
#  Unix:    cat <SR Function Name>.asm "Program #6 - Test Suite.asm" > <output>.asm			#
#																							#
#  v. 1		Initial release																	#
#  v. 1.1	Added fine grained memory tests													#
#  v. 1.2	Fixed fine grained memory tests													#
#############################################################################################


main:	addi	$sp, $sp, -8		#  Make space for $ra on stack
		sw		$ra, 0 ($sp)		#  Store the return address on the stack

		.data
t1:		.asciiz	"a"
t2:		.asciiz	"abba"
t3:		.asciiz	"hello"
t4:		.asciiz	"Able was I ere I saw Elba"
t5:		.asciiz	"A man, a plan, a canal, Panama"
r3:		.asciiz "olleh"
r4:		.asciiz	"ablE was I ere I saw elbA"
r5:		.asciiz	"amanaP ,lanac a ,nalp a ,nam A"
		.text

###############################################################################
##                     Testing string reversal function                      ##
###############################################################################
		#  Test #1
		#  a
		#######################################################################
		jal		setSavedRegisters
		la		$a0, t1				#  String
		li		$a1, 1				#  Length
		jal		String_Reversal
		
		move	$a0, $v0			#  Result
		la		$a1, t1				#  Expected result
		li		$a2, 1				#  Length
		li		$a3, 1				#  Test #1
		jal		assertEqual			#  Check for equality
		
		#  Test #2
		#  abba
		#######################################################################
		jal		setSavedRegisters
		la		$a0, t2				#  String
		li		$a1, 4				#  Length
		jal		String_Reversal
		
		move	$a0, $v0			#  Result
		la		$a1, t2				#  Expected result
		li		$a2, 4				#  Length
		li		$a3, 2				#  Test #2
		jal		assertEqual			#  Check for equality
		
		#  Test #3
		#  hello
		#######################################################################
		jal		setSavedRegisters
		la		$a0, t3				#  String
		li		$a1, 5				#  Length
		jal		String_Reversal
		
		move	$a0, $v0			#  Result
		la		$a1, r3				#  Expected result
		li		$a2, 5				#  Length
		li		$a3, 3				#  Test #3
		jal		assertEqual			#  Check for equality

		#  Test #4
		#  Able was I ere I saw Elba
		#######################################################################
		jal		setSavedRegisters
		la		$a0, t4				#  String
		li		$a1, 25				#  Length
		jal		String_Reversal
		
		move	$a0, $v0			#  Result
		la		$a1, r4				#  Expected result
		li		$a2, 25				#  Length
		li		$a3, 4				#  Test #4
		jal		assertEqual			#  Check for equality

		#  Test #5
		#  A man, a plan, a canal, Panama
		#######################################################################
		jal		setSavedRegisters
		la		$a0, t5				#  String
		li		$a1, 30				#  Length
		jal		String_Reversal
		
		move	$a0, $v0			#  Result
		la		$a1, r5				#  Expected result
		li		$a2, 30				#  Length
		li		$a3, 5				#  Test #5
		jal		assertEqual			#  Check for equality

		#  Test #6
		#  Null pointer
		#######################################################################
		jal		setSavedRegisters
		li		$a0, 0				#  String
		li		$a1, 4				#  Length
		jal		String_Reversal
		
		move	$a0, $v0			#  Result
		li		$a3, 6				#  Test #6
		jal		assertFail			#  Check for failure

		#  Test #7
		#  Zero length string
		#######################################################################
		jal		setSavedRegisters
		la		$a0, t3				#  String
		li		$a1, 0				#  Length
		jal		String_Reversal
		
		move	$a0, $v0			#  Result
		li		$a3, 7				#  Test #7
		jal		assertFail			#  Check for failure

		#  Test #8
		#  Negative length string
		#######################################################################
		jal		setSavedRegisters
		la		$a0, t4				#  String
		li		$a1, -4				#  Length
		jal		String_Reversal
		
		move	$a0, $v0			#  Result
		li		$a3, 8				#  Test #8
		jal		assertFail			#  Check for failure

		#  Test #9
		#  String parameter runs out of bounds
		#######################################################################
		jal		setSavedRegisters
		li		$a0, 0x7FFFFFFC		#  String
		li		$a1, 5				#  Length
		jal		String_Reversal
		
		move	$a0, $v0			#  Result
		li		$a3, 9				#  Test #9
		jal		assertFail			#  Check for failure

		#  Test #10
		#  String parameter starts out of bounds
		#######################################################################
		jal		setSavedRegisters
		li		$a0, 0x9FFFFFFF		#  String
		li		$a1, 5				#  Length
		jal		String_Reversal
		
		move	$a0, $v0			#  Result
		li		$a3, 10				#  Test #10
		jal		assertFail			#  Check for failure

		
		#  Completed Tests
		#######################################################################
		lw		$ra, 0 ($sp)		#  Load return address
		addi	$sp, $sp, 8			#  Pop the stack
		jr		$ra

		
###############################################################################
##                            Assertion functions                            ##
###############################################################################
		#  Assert Equality
		#######################################################################
assertEqual:
		.data
eq1:	.asciiz	"Test #"
eq2:	.asciiz " failed:  Expected string:  "
eq3:	.asciiz	" \tObserved string:  "
eq4:	.asciiz "\n"
		.text
		
		addi	$sp, $sp, -16		#  Make space for four variables on the stack
		sw		$a0, 12 ($sp)		#  Store the result address
		sw		$a1,  8 ($sp)		#  Store the expected result address
		sw		$a2,  4 ($sp)		#  Store the string length
		sw		$a3,  0 ($sp)		#  Store the test number
		
		li		$v0, 4
		la		$a0, eq1
		syscall						#  Print "Test #"
		
		li		$v0, 1
		lw		$a0,  0 ($sp)
		syscall						#  Print test number
		
		lw		$t0, 12 ($sp)		#  Load the result address
		lw		$t1,  8 ($sp)		#  Load the expected result address
		lw		$t2,  4 ($sp)		#  Load the string length
		#  If the result matches the expected value, then the test is successful.
		li		$t3, 0				#  iterator = 0
CheckLoop:
		bgt		$t3, $t2, CheckMemory	#  for (int i = 0; i <= n; i++)
		add		$t4, $t0, $t3
		lbu		$t4, 0 ($t4)		#  $t4 = result[i]
		add		$t5, $t1, $t3
		lbu		$t5, 0 ($t5)		#  $t5 = expected[i]
		addi	$t3, $t3, 1			#  iterator += 1
		beq		$t4, $t5, CheckLoop
		
		#  Otherwise, it failed.
		
		li		$v0, 4
		la		$a0, eq2
		syscall						#  Print " failed:  Expected string:  "
		
		li		$v0, 4
		move	$a0, $t1
		syscall						#  Print expected string
		
		li		$v0, 4
		la		$a0, eq3
		syscall						#  Print " \tObserved string:  "
		
		li		$v0, 4
		move	$a0, $t0
		syscall						#  Print observed string
		
		li		$v0, 4
		la		$a0, eq4
		syscall						#  Add a new line
		
		addi	$sp, $sp, 16		#  Pop the stack
		
		jr		$ra					#  Return to caller
		
CheckMemory:
		lw		$a0, 12 ($sp)
		lw		$a1,  8 ($sp)
		lw		$a2,  4 ($sp)
		la		$t0, t1
		beq		$a0, $t0, MemoryFail	#  The result should be a new object.
		la		$t0, t2
		beq		$a0, $t0, MemoryFail
		la		$t0, t3
		beq		$a0, $t0, MemoryFail
		la		$t0, t4
		beq		$a0, $t0, MemoryFail
		la		$t0, t5
		beq		$a0, $t0, MemoryFail
		beq		$a0, $a1, MemoryFail3	#  Cheating is bad, mmmmkay?
		add		$t0, $a0, $a2
		bge		$t0, $gp, MemoryFail2	#  The result should be managed by the global pointer
		lw		$t0, 4 ($sp)
		bge		$t0, $gp, MemoryFail2	#  The global pointer should be incremented from baseline
		
		j		CheckSavedRegisters		#  Check the saved registers before signing off.
		
		#  Result in bad place in memory
		#######################################################################
		.data
CM1:	.asciiz	" failed.  The result should be placed on the heap.\n"
CM2:	.asciiz " failed.  The heap should be managed by the global pointer.\n"
CM3:	.asciiz	" failed.  Cheating is bad, mmmkay?\n"
		.text
MemoryFail:
		li		$v0, 4				#  Print string
		la		$a0, CM1			#  " failed.  The result should be placed on the heap.\n"
		syscall
		jr		$ra

MemoryFail2:
		li		$v0, 4				#  Print string
		la		$a0, CM2			#  " failed.  The heap should be managed by the global pointer.\n"
		syscall
		jr		$ra
		
MemoryFail3:
		li		$v0, 4				#  Print string
		la		$a0, CM3			#  " failed.  Cheating is bad, mmmkay?\n"
		syscall
		jr		$ra
		
		#  Assertion Success
		#######################################################################
		.data
s1:		.asciiz	" passed.\n"
		.text
Pass:	li		$v0, 4				#  Print string
		la		$a0, s1				#  " passed.\n"
		syscall
		
		addi	$sp, $sp, 16		#  Pop the stack
		
		jr		$ra					#  Return to caller
		


		#  Assert Failure
		#######################################################################
assertFail:
		.data
fail1:	.asciiz	"Test #"
fail2:	.asciiz " failed.  The function returned a pointer.\n"
		.text
		
		move	$t0, $a3			#  Store test number
		move	$t1, $a0
		
		li		$v0, 4				#  Print string
		la		$a0, fail1			#  "Test #"
		syscall
		
		li		$v0, 1				#  Print test number
		move	$a0, $t0
		syscall
		
		bne		$t1, $zero, fFail	#  If the pointer is not null, then fail
		addi	$sp, $sp, -16		#  Cheap hack to balance the stack pushes/pops
		j		Pass

fFail:	li		$v0, 4				#  Print string
		la		$a0, fail2			#  " failed.  The function returned a pointer.\n"
		syscall
		
		jr		$ra					#  Failed null pointer check
		
		
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
		sw		$gp, 4 ($sp)
		jr		$ra
		
		#  Check Saved Registers
		#######################################################################
CheckSavedRegisters:
		bne		$s0, 14, regFail
		bne		$s1, 73, regFail
		bne		$s2, 69, regFail
		bne		$s3, 46, regFail
		bne		$s4, 79, regFail
		bne		$s5, 92, regFail
		bne		$s6, 37, regFail
		bne		$s7, 96, regFail
		j		Pass
		
regFail:
		.data
rf:		.asciiz	" has changed the saved registers.\n"
		.text
		li		$v0, 4
		la		$a0, rf
		syscall
		
		addi	$sp, $sp, 12		#  Pop the stack
		jr		$ra					#  Return to caller
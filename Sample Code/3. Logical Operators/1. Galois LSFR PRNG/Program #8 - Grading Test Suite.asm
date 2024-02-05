
#############################################################################################
#                          Unit Tests for Galois LFSR PRNG Function							#
#																							#
#  Padraic Edgington                                                          13 Mar, 2013	#
#																							#
#                                            v. 1											#
#  If there are bugs in this code, you may check back later for an updated version.			#
#																							#
#  You should write your code in a seperate file and prepend it to this file by running		#
#  either:																					#
#  Windows: copy /Y <PRNG Function Name>.asm + "Program #8 - Test Suite.asm" <output>.asm	#
#  Unix:    cat <PRNG Function Name>.asm "Program #8 - Test Suite.asm" > <output>.asm		#
#																							#
#  v. 1		Initial release																	#
#############################################################################################
#
#  Consider adding a test to check whether the code is able to handle everything except the
#  cross-register shifting.


main:	addi	$sp, $sp, -16		#  Make space for the $ra and the PRNG pointer on the stack
		sw		$ra, 4 ($sp)		#  Store the return address on the stack


###############################################################################
##                     Testing Galois LFSR PRNG function                     ##
###############################################################################
		#  Test #1
		#  Executing the constructor function with a default seed
		#######################################################################
		jal		setSavedRegisters
		li		$a0, 0				#  Upper 32 bits of the seed
		li		$a1, 0				#  Lower 32 bits of the seed
		jal		LFSR_Constructor	#  Create a new LFSR PRNG object with a default seed
		sw		$v0, 0 ($sp)		#  Store the LFSR PRNG object on the stack  (Where we hope it's safe...)
		
		move	$a0, $v0			#  Result
		li		$a3, 1				#  Test #1
		jal		assertObject		#  Check for a proper object
		

		#  Test #2
		#  Checking for the existence of a default seed
		#######################################################################
		jal		setSavedRegisters
		lw		$a0, 0 ($sp)		#  The LFSR PRNG object
		jal		LFSR_Random			#  Get next random number
		
		move	$a0, $v0			#  Upper result
		move	$a1, $v1			#  Lower result
		li		$a2, 0				#  Expected upper result
		li		$a3, 0				#  Expected lower result
		li		$t0, 2
		sw		$t0, -4 ($sp)		#  Test #2
		jal		assertNotEqual_64	#  Check for 64-bit inequality
		

		#  Test #3
		#  Executing the constructor function with a non-zero seed
		#######################################################################
		jal		setSavedRegisters
		li		$a0, 0x4E2A89EF		#  Upper 32 bits of the seed
		li		$a1, 0x84AEBD38		#  Lower 32 bits of the seed
		jal		LFSR_Constructor	#  Create a new LFSR PRNG object with a fixed seed
		sw		$v0, 0 ($sp)		#  Store the LFSR PRNG object on the stack
		
		move	$a0, $v0			#  Result
		li		$a1, 0				#  Expected result
		li		$a3, 3				#  Test #3
		jal		assertNotEqual		#  Check for inequality
		

		#  Test #4
		#  Checking the next random number
		#  This test covers the case where the current state is only shifted
		#  and the xor operation is not performed.
		#######################################################################
		jal		setSavedRegisters
		lw		$a0, 0 ($sp)		#  The LFSR PRNG object
		jal		LFSR_Random			#  Get next random number
		
		move	$a0, $v0			#  Upper result
		move	$a1, $v1			#  Lower result
		li		$a2, 0x271544F7		#  Expected upper result
		li		$a3, 0xC2575E9C		#  Expected lower result
		li		$t0, 4
		sw		$t0, -4 ($sp)		#  Test #4
		jal		assertEqual_64		#  Check for 64-bit equality
		

		#  Test #5
		#  Set a seed and check the next random number
		#  This test covers the case where both shifting and xor occur.
		#######################################################################
		jal		setSavedRegisters
		lw		$a0, 0 ($sp)		#  The LFSR PRNG object
		li		$a1, 0xAE6392D4		#  Upper 32 bits of the seed
		li		$a2, 0x934A7E3D		#  Lower 32 bits of the seed
		jal		LFSR_Seed			#  Seed the random number generator
		
		lw		$a0, 0 ($sp)		#  The LFSR PRNG object
		jal		LFSR_Random			#  Get the next random number
		move	$a0, $v0			#  Upper result
		move	$a1, $v1			#  Lower result
		li		$a2, 0x8F31C96A		#  Expected upper result
		li		$a3, 0x49A53F1E		#  Expected lower result
		li		$t0, 5
		sw		$t0, -4 ($sp)		#  Test #5
		jal		assertEqual_64		#  Check for 64-bit equality
		

		#  Test #6
		#  Set a seed and check the next two random numbers
		#  This test makes sure that the object is updated after each LFSR_Random call.
		#######################################################################
		jal		setSavedRegisters
		lw		$a0, 0 ($sp)		#  The LFSR PRNG object
		li		$a1, 0x5D9E1A39		#  Upper 32 bits of the seed
		li		$a2, 0x5DA94ECB		#  Lower 32 bits of the seed
		jal		LFSR_Seed			#  Seed the random number generator
		
		lw		$a0, 0 ($sp)		#  The LFSR PRNG object
		jal		LFSR_Random			#  Get the next random number
		move	$a0, $v0			#  Upper result
		move	$a1, $v1			#  Lower result
		li		$a2, 0xF6CF0D1C		#  Expected upper result
		li		$a3, 0xAED4A765		#  Expected lower result
		li		$t0, 61
		sw		$t0, -4 ($sp)		#  Test #6-1
		jal		assertEqual_64		#  Check for 64-bit equality

		lw		$a0, 0 ($sp)		#  The LFSR PRNG object
		jal		LFSR_Random			#  Get the next random number
		move	$a0, $v0			#  Upper result
		move	$a1, $v1			#  Lower result
		li		$a2, 0xA367868E		#  Expected upper result
		li		$a3, 0x576A53B2		#  Expected lower result
		li		$t0, 62
		sw		$t0, -4 ($sp)		#  Test #6-2
		jal		assertEqual_64		#  Check for 64-bit equality

		lw		$a0, 0 ($sp)		#  The LFSR PRNG object
		jal		LFSR_Random			#  Get the next random number
		move	$a0, $v0			#  Upper result
		move	$a1, $v1			#  Lower result
		li		$a2, 0x51B3C347		#  Expected upper result
		li		$a3, 0x2BB529D9		#  Expected lower result
		li		$t0, 63
		sw		$t0, -4 ($sp)		#  Test #6-3
		jal		assertEqual_64		#  Check for 64-bit equality
		

		#  Test #7
		#  Set a seed and check the next random number
		#  This test makes sure that the seed function accepts numbers where
		#  the upper half is zero.
		#######################################################################
		jal		setSavedRegisters
		lw		$a0, 0 ($sp)		#  The LFSR PRNG object
		li		$a1, 0x00000000		#  Upper 32 bits of the seed
		li		$a2, 0x5DA94ECB		#  Lower 32 bits of the seed
		jal		LFSR_Seed			#  Seed the random number generator
		
		lw		$a0, 0 ($sp)		#  The LFSR PRNG object
		jal		LFSR_Random			#  Get the next random number
		move	$a0, $v0			#  Upper result
		move	$a1, $v1			#  Lower result
		li		$a2, 0xD8000000		#  Expected upper result
		li		$a3, 0x2ED4A765		#  Expected lower result
		li		$t0, 7
		sw		$t0, -4 ($sp)		#  Test #7
		jal		assertEqual_64		#  Check for 64-bit equality


		#  Test #8
		#  Set a seed and check the next random number.
		#  This test makes sure that the seed function accepts numbers where
		#  the lower half is zero.
		#######################################################################
		jal		setSavedRegisters
		lw		$a0, 0 ($sp)		#  The LFSR PRNG object
		li		$a1, 0x5D9E1A39		#  Upper 32 bits of the seed
		li		$a2, 0x00000000		#  Lower 32 bits of the seed
		jal		LFSR_Seed			#  Seed the random number generator
		
		lw		$a0, 0 ($sp)		#  The LFSR PRNG object
		jal		LFSR_Random			#  Get the next random number
		move	$a0, $v0			#  Upper result
		move	$a1, $v1			#  Lower result
		li		$a2, 0x2ECF0D1C		#  Expected upper result
		li		$a3, 0x80000000		#  Expected lower result
		li		$t0, 8
		sw		$t0, -4 ($sp)		#  Test #8
		jal		assertEqual_64		#  Check for 64-bit equality


		#  Test #9
		#  Set a seed and check the 64th random number.
		#  This test runs multiple random calls and makes sure that no
		#  important information is being kept in temporary registers.
		#######################################################################
		jal		setSavedRegisters
		jal		setTemporaryRegisters
		lw		$a0, 0 ($sp)		#  The LFSR PRNG object
		li		$a1, 0x80000000		#  Upper 32 bits of the seed
		li		$a2, 0x00000000		#  Lower 32 bits of the seed
		jal		LFSR_Seed			#  Seed the random number generator
		
		li		$t0, 0
		sw		$t0, 8 ($sp)		#  A counter
T7Loop:	jal		setTemporaryRegisters
		lw		$a0, 0 ($sp)		#  The LFSR PRNG object
		jal		LFSR_Random			#  Get the next random number
		lw		$t0, 8 ($sp)
		addi	$t0, $t0, 1
		sw		$t0, 8 ($sp)		#  Increment counter
		li		$t1, 64
		blt		$t0, $t1, T7Loop
		move	$a0, $v0			#  Upper result
		move	$a1, $v1			#  Lower result
		li		$a2, 0xD8000000		#  Expected upper result
		li		$a3, 0x00000000		#  Expected lower result
		li		$t0, 9
		sw		$t0, -4 ($sp)		#  Test #9
		jal		assertEqual_64		#  Check for 64-bit equality
		

		#  Test #10
		#  Creates a set of PRNG objects and uses them seperately.
		#  This test makes sure that the constructor is creating individual
		#  objects and that the functions are using them properly.
		#######################################################################
		jal		setSavedRegisters
		jal		setTemporaryRegisters
		li		$a0, 0xEF952100		#  Upper 32 bits of seed #1
		li		$a1, 0xA59D2BE2		#  Lower 32 bits of seed #2
		jal		LFSR_Constructor	#  Create a new LFSR PRNG object with a fixed seed
		sw		$v0, 0 ($sp)		#  Store the LFSR PRNG object on the stack  (Where we hope it's safe...)
		
		jal		setSavedRegisters
		jal		setTemporaryRegisters
		li		$a0, 0x5DE2106E		#  Upper 32 bits of seed #2
		li		$a1, 0x1D9C581A		#  Lower 32 bits of seed #2
		jal		LFSR_Constructor	#  Create a new LFSR PRNG object with a fixed seed
		sw		$v0, 8 ($sp)		#  Store the LFSR PRNG object on the stack  (Where we hope it's safe...)
		
		jal		setSavedRegisters
		jal		setTemporaryRegisters
		li		$a0, 0x000CD59A		#  Upper 32 bits of seed #3
		li		$a1, 0x1AD59EC0		#  Lower 32 bits of seed #3
		jal		LFSR_Constructor	#  Create a new LFSR PRNG object with a fixed seed
		sw		$v0, 12 ($sp)		#  Store the LFSR PRNG object on the stack  (Where we hope it's safe...)
		
		lw		$a0,  0 ($sp)		#  LFSR object #1
		lw		$a1,  8 ($sp)		#  LFSR object #2
		li		$a3, 101			#  Test #10-1
		jal		assertNotEqual		#  Object #1 should not be the same as object #2.
		
		lw		$a0,  0 ($sp)		#  LFSR object #1
		lw		$a1, 12 ($sp)		#  LFSR object #3
		li		$a3, 102			#  Test #10-2
		jal		assertNotEqual		#  Object #1 should not be the same as object #3.
		
		lw		$a0,  8 ($sp)		#  LFSR object #2
		lw		$a1, 12 ($sp)		#  LFSR object #3
		li		$a3, 103			#  Test #10-3
		jal		assertNotEqual		#  Object #2 should not be the same as object #3.
		
		jal		setSavedRegisters
		jal		setTemporaryRegisters
		lw		$a0, 0 ($sp)		#  LFSR object #1
		jal		LFSR_Random			#  Get the next random number from object #1
		move	$a0, $v0			#  Upper result
		move	$a1, $v1			#  Lower result
		li		$a2, 0x77CA9080		#  Expected upper result
		li		$a3, 0x52CE95F1		#  Expected lower result
		li		$t0, 104
		sw		$t0, -4 ($sp)		#  Test #10-4
		jal		assertEqual_64		#  Check for 64-bit equality
		
		jal		setSavedRegisters
		jal		setTemporaryRegisters
		lw		$a0, 8 ($sp)		#  LFSR object #2
		jal		LFSR_Random			#  Get the next random number from object #2
		move	$a0, $v0			#  Upper result
		move	$a1, $v1			#  Lower result
		li		$a2, 0x2EF10837		#  Expected upper result
		li		$a3, 0x0ECE2C0D		#  Expected lower result
		li		$t0, 105
		sw		$t0, -4 ($sp)		#  Test #10-5
		jal		assertEqual_64		#  Check for 64-bit equality
		
		jal		setSavedRegisters
		jal		setTemporaryRegisters
		lw		$a0, 12 ($sp)		#  LFSR object #3
		jal		LFSR_Random			#  Get the next random number from object #3
		move	$a0, $v0			#  Upper result
		move	$a1, $v1			#  Lower result
		li		$a2, 0x00066ACD		#  Expected upper result
		li		$a3, 0x0D6ACF60		#  Expected lower result
		li		$t0, 105
		sw		$t0, -4 ($sp)		#  Test #10-5
		jal		assertEqual_64		#  Check for 64-bit equality


		#  Test #11
		#  Checks to see if the function can handle a null object.
		#  The random function should return 0 and neither function should crash.
		#######################################################################
		jal		setSavedRegisters
		li		$a0, 0				#  A null object
		li		$a1, 0x5D9E1A39		#  Upper 32 bits of the seed
		li		$a2, 0x5DA94ECB		#  Lower 32 bits of the seed
		jal		LFSR_Seed			#  Seed the random number generator
		
		li		$a0, 0				#  A null object
		jal		LFSR_Random			#  Get the next random number
		move	$a0, $v0			#  Upper result
		move	$a1, $v1			#  Lower result
		li		$a2, 0x00000000		#  Expected upper result
		li		$a3, 0x00000000		#  Expected lower result
		li		$t0, 11
		sw		$t0, -4 ($sp)		#  Test #11
		jal		assertEqual_64		#  Check for 64-bit equality


		#  Completed Tests
		#######################################################################
		lw		$ra, 4 ($sp)		#  Load return address
		addi	$sp, $sp, 16			#  Pop the stack
		jr		$ra

		
###############################################################################
##                            Assertion functions                            ##
###############################################################################
		.data
a1:		.asciiz	"Test #"
a2:		.asciiz	" passed.\n"
a3:		.asciiz	" failed.  The result should not have been "
a4:		.asciiz	" has changed a saved register without restoring it.\n"
a5:		.asciiz	".\n"
a6:		.asciiz	" failed:  Observed value:  "
a7:		.asciiz "\tExpected value:  "
		.text
		
		#  Assert Inequality
		#
		#  Parameters:
		#  a0:  Observed value
		#  a1:  Undesired value
		#  a3:  Test #
		#######################################################################
assertNotEqual:
		addi	$sp, $sp, -16
		sw		$a0,  0 ($sp)			#  Store the observed value
		sw		$a1,  4 ($sp)			#  Store the undesired value
		sw		$a3,  8 ($sp)			#  Store the test #
		sw		$ra, 12 ($sp)			#  Store the return address
		
		#  Print the test #
		li		$v0, 4
		la		$a0, a1
		syscall
		li		$v0, 1
		lw		$a0,  8 ($sp)
		syscall
		
		#  Perform the checks for the assertion
		lw		$t0,  0 ($sp)
		lw		$t1,  4 ($sp)
		beq		$t0, $t1, ANE_Fail		#  If the result is equal to the undesired value, then FAIL
		jal		checkSavedRegisters		#  Check to make sure that the saved registers have not been tampered with (or at least have been restored)
		beqz	$v0, ANE_Pass			#  If everything checks out, then PASS
		
		
		#  If the saved registers were tampered with...
		li		$v0, 4
		la		$a0, a4
		syscall							#  Print saved register FAIL
		lw		$ra, 12 ($sp)
		addi	$sp, $sp, 16
		jr		$ra						#  Return to calling test


		#  If the assertion passed...
ANE_Pass:
		li		$v0, 4
		la		$a0, a2
		syscall							#  Print " passed.\n"
		lw		$ra, 12 ($sp)
		addi	$sp, $sp, 16
		jr		$ra						#  Return to calling test
		
		
		#  If the assertion failed...
ANE_Fail:
		li		$v0, 4
		la		$a0, a3
		syscall							#  Print " failed.  The result should not have been "
		li		$v0, 1
		lw		$a0,  4 ($sp)
		syscall							#  Print undesired value
		li		$v0, 4
		la		$a0, a5
		syscall
		lw		$ra, 12 ($sp)
		addi	$sp, $sp, 16
		jr		$ra						#  Return to calling test
		#######################################################################

		
		
		#  Assert 64-bit Equality
		#
		#  Parameters:
		#  a0:  Observed upper 32 bits
		#  a1:  Observed lower 32 bits
		#  a2:  Desired  upper 32 bits
		#  a3:  Desired  lower 32 bits
		#  $sp-4:  Test #
		#######################################################################
assertEqual_64:
		addi	$sp, $sp, -24
		sw		$a0,  0 ($sp)			#  Observed upper 32 bits
		sw		$a1,  4 ($sp)			#  Observed lower 32 bits
		sw		$a2,  8 ($sp)			#  Desired  upper 32 bits
		sw		$a3, 12 ($sp)			#  Desired  lower 32 bits
		sw		$ra, 16 ($sp)			#  Return address
		#  Test # is at 20 ($sp)
		
		#  Print the test #
		li		$v0, 4
		la		$a0, a1
		syscall
		li		$v0, 1
		lw		$a0,  20 ($sp)
		syscall
		
		
		#  Check for 64-bit equality
		lw		$t0,  0 ($sp)
		lw		$t1,  4 ($sp)
		lw		$t2,  8 ($sp)
		lw		$t3, 12 ($sp)
		
		bne		$t0, $t2, AE64_Fail		#  If the upper 32 bits are not equal, then FAIL
		bne		$t1, $t3, AE64_Fail		#  If the lower 32 bits are not equal, then FAIL
		jal		checkSavedRegisters		#  Check to make sure that the saved registers have not been tampered with (or at least have been restored)
		beqz	$v0, AE64_Pass			#  If everything checks out, then PASS

		
		#  If the saved registers were tampered with...
		li		$v0, 4
		la		$a0, a4
		syscall							#  Print saved register FAIL
		lw		$ra, 16 ($sp)
		addi	$sp, $sp, 24
		jr		$ra						#  Return to calling test


		#  If the assertion passed...
AE64_Pass:
		li		$v0, 4
		la		$a0, a2
		syscall							#  Print " passed.\n"
		lw		$ra, 16 ($sp)
		addi	$sp, $sp, 24
		jr		$ra						#  Return to calling test
		
		
		#  If the two 64-bit numbers are not equal...
AE64_Fail:
		li		$v0, 4
		la		$a0, a6
		syscall							#  Print " failed:  Observed value:  "
		lw		$a0,  0 ($sp)
		jal		printHexadecimal
		li		$v0, 4
		la		$a0, nbsp
		syscall							#  Print a space after the first eight characters
		lw		$a0,  4 ($sp)
		jal		printHexadecimal
		li		$v0, 4
		la		$a0, a7
		syscall							#  Print "\tExpected value:  "
		lw		$a0,  8 ($sp)
		jal		printHexadecimal
		li		$v0, 4
		la		$a0, nbsp
		syscall							#  Print a space after the first eight characters
		lw		$a0, 12 ($sp)
		jal		printHexadecimal
		li		$v0, 4
		la		$a0, a5					#  Print ".\n"
		syscall
		
		lw		$ra, 16 ($sp)
		addi	$sp, $sp, 24
		jr		$ra						#  Return to calling test
		#######################################################################
		
		
		
		
		#  Assert 64-bit Inequality
		#
		#  Parameters:
		#  a0:  Observed  upper 32 bits
		#  a1:  Observed  lower 32 bits
		#  a2:  Undesired upper 32 bits
		#  a3:  Undesired lower 32 bits
		#  $sp-4:  Test #
		#######################################################################
assertNotEqual_64:
		addi	$sp, $sp, -24
		sw		$a0,  0 ($sp)			#  Observed upper 32 bits
		sw		$a1,  4 ($sp)			#  Observed lower 32 bits
		sw		$a2,  8 ($sp)			#  Desired  upper 32 bits
		sw		$a3, 12 ($sp)			#  Desired  lower 32 bits
		sw		$ra, 16 ($sp)			#  Return address
		#  Test # is at 20 ($sp)
		
		#  Print the test #
		li		$v0, 4
		la		$a0, a1
		syscall
		li		$v0, 1
		lw		$a0,  20 ($sp)
		syscall
		
		
		#  Check for 64-bit inequality
		lw		$t0,  0 ($sp)
		lw		$t1,  4 ($sp)
		lw		$t2,  8 ($sp)
		lw		$t3, 12 ($sp)
		
		bne		$t0, $t2, ANE64_Pass	#  If the upper 32 bits are not equal, then PASS
		bne		$t1, $t3, ANE64_Pass	#  If the lower 32 bits are not equal, then PASS
		
		#  If the two 64-bit numbers are equal, then FAIL
		li		$v0, 4
		la		$a0, a3
		syscall
		lw		$a0, 8 ($sp)
		jal		printHexadecimal
		li		$v0, 4
		la		$a0, nbsp
		syscall							#  Print a space after the first eight characters
		lw		$a0, 12 ($sp)
		jal		printHexadecimal
		li		$v0, 4
		la		$a0, a5					#  Print ".\n"
		syscall
		
		lw		$ra, 16 ($sp)
		addi	$sp, $sp, 24
		jr		$ra						#  Return to calling test
		
		
		#  If the two 64-bit numbers are not equal...
ANE64_Pass:
		jal		checkSavedRegisters		#  Check to make sure that the saved registers have not been tampered with (or at least have been restored)
		bnez	$v0, ANE64_Saved_Fail	#  If the result is not zero, then FAIL

		#  If everything checks out, then PASS
		li		$v0, 4
		la		$a0, a2
		syscall							#  Print " passed.\n"
		lw		$ra, 16 ($sp)
		addi	$sp, $sp, 24
		jr		$ra						#  Return to calling test
		

		#  If the saved registers were tampered with...
ANE64_Saved_Fail:
		li		$v0, 4
		la		$a0, a4
		syscall							#  Print saved register FAIL
		lw		$ra, 16 ($sp)
		addi	$sp, $sp, 24
		jr		$ra						#  Return to calling test
		#######################################################################
		
		
		
		
		#  Assert is an Object
		#
		#  Parameters:
		#  a0:  An object?
		#######################################################################
assertObject:
		addi	$sp, $sp, -12
		sw		$a0,  0 ($sp)			#  Store the object?
		sw		$a3,  4 ($sp)			#  Store the test #
		sw		$ra,  8 ($sp)			#  Store the return address
		
		li		$v0, 4
		la		$a0, a1
		syscall							#  Print "Test #"
		li		$v0, 1
		lw		$a0, 4 ($sp)
		syscall							#  Print the test #

		lw		$a0, 0 ($sp)			#  Load the object?
		#  Objects are allocated in dynamic data.
		li		$t0, 0x10008000
		blt		$a0, $t0, AOFail
		
		#  Objects are allocated on the heap, not the stack
		addi	$t0, $sp, -100
		bge		$a0, $sp, AOFail
		
		lw		$t0, 0 ($a0)
		bnez	$t0, AOPass
		lw		$t0, 4 ($a0)
		bnez	$t0, AOPass
		j		AOFail

AOPass:		
		jal		checkSavedRegisters		#  Check to make sure that the saved registers have not been tampered with (or at least have been restored)
		bnez	$v0, AO_Saved_Fail	#  If the result is not zero, then FAIL

		li		$v0, 4
		la		$a0, a2
		syscall							#  Print " passed.\n"
		
		lw		$ra, 8 ($sp)			#  Load the return address
		addi	$sp, $sp, 12
		jr		$ra
		
AOFail:	#  It was not an object
		.data
AOF1:	.asciiz	" did not return a proper object.\n"
		.text
		
		li		$v0, 4
		la		$a0, AOF1
		syscall							#  Print " did not return a proper object.\n"
		
		lw		$ra, 8 ($sp)			#  Load the return address
		addi	$sp, $sp, 12
		jr		$ra
		
AO_Saved_Fail:
		li		$v0, 4
		la		$a0, a4
		syscall							#  Print saved register FAIL
		lw		$ra, 16 ($sp)
		addi	$sp, $sp, 24
		jr		$ra						#  Return to calling test
		#######################################################################
		
		
		
		
		#  Check Saved Registers
		#
		#  Results:
		#  $v0:  0 if saved registers were not modified, else 1
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
		li		$v0, 0
		jr		$ra

regFail:
		li		$v0, 1
		jr		$ra					#  Return to caller
		#######################################################################
		

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
		#######################################################################
		
		
		
		#  Reset Temporary Registers
		#######################################################################
setTemporaryRegisters:
		li		$t0, 456
		li		$t1, 789
		li		$t2, 123
		li		$t3, 19
		li		$t4, 4
		li		$t5, 79
		li		$t6, 46
		li		$t7, 132
		li		$t8, 897
		li		$t9, 312
		li		$a0, 12
		li		$a1, 19
		li		$a2, 950005
		jr		$ra
		#######################################################################
		
		
		
		#  Print Hexadecimal Number
		#
		#      This function takes a 32-bit integer as a parameter and prints
		#  it to the console in hexadecimal format.
		#
		#  Parameters:
		#  $a0:  32-bit number
		#######################################################################
		.data
hex:	.ascii	"0123456789ABCDEF"
nbsp:	.asciiz	" "
		.text
printHexadecimal:
		addi	$sp, $sp, -4
		sw		$s0, 0 ($sp)
		move	$s0, $a0


		#  Use a mask to select four bits at a time; move the selected four bits
		#  into the least significant bit positions and use them as an index to
		#  select a hexadecimal character from the hex array and print the character.
		li		$t0, 0				#  Counter
HexLoop:
		bge		$t0, 32, HexEndLoop
		li		$a0, 0xF0000000
		srlv	$a0, $a0, $t0		#  Create a mask for the current 4 bits
		and		$a0, $a0, $s0		#  Apply the mask
		li		$t1, 28
		sub		$t1, $t1, $t0
		srlv	$a0, $a0, $t1		#  Shift the selected 4 bits into the LSB positions
		la		$t1, hex
		add		$a0, $t1, $a0
		lbu		$a0, 0 ($a0)		#  Read the indexed character from the string
		li		$v0, 11
		syscall						#  Print the selected character
		addi	$t0, $t0, 4			#  Increment to the next four bits
		bne		$t0, 16, HexLoop
		li		$v0, 4
		la		$a0, nbsp
		syscall						#  Print a space after the first four characters
		j		HexLoop
		
		
HexEndLoop:
		lw		$s0, 0 ($sp)
		addi	$sp, $sp, 4
		jr		$ra
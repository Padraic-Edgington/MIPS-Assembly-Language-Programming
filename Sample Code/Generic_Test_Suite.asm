


#############################################################################################
#                               	Generic Test Suite										#
#																							#
#  Padraic Edgington                                                          4 Mar, 2017	#
#																							#
#																							#
#				Implemented print functions:												#
#					Print_Divider															#
#					Print_Integer_Array														#
#					Print_Raw_Integer_Array													#
#					Print_Hexadecimal														#
#				Implemented assertion functions:											#
#					Initialize_Test_Suite  (Call before every test case)					#
#					Assert_Equal_Integer													#
#					Assert_Not_Equal_Integer												#
#					Assert_Greater_Than_Integer												#
#					Assert_Less_Than_Integer												#
#					Assert_Greater_Than_Equal_Integer										#
#					Assert_Less_Than_Equal_Integer											#
#					Assert_Equal_Array														#
#					Assert_Null																#
#					Assert_Not_Null															#
#					Assert_Error															#
#					Assert_Equal_Long														#
#					Assert_Not_Equal_Long													#
#  v. 1.2	Added the Print_Divider function.												#
#  v. 1.1	Bug fix in Assert_Null.															#
#			Added Initialize_Test_Suite as a sensible mnemonic.								#
#  v. 1		Initial release  (It appears to work.)											#
#############################################################################################

main:	addi	$sp, $sp, -4		#  Make space for $ra on stack
		sw		$ra, 0 ($sp)		#  Store the return address on the stack

#############################################################################################
#									Functionality Tests										#
		la		$a0, type1
		jal		Print_Divider
#############################################################################################






#############################################################################################
#									Error Checking Tests									#
		la		$a0, type2
		jal		Print_Divider
#############################################################################################






#############################################################################################
#										All Tests Completed									#
Skip_Parameter_Validation_Tests:
		.data
type1:	.asciiz	"Starting functionality tests."
type2:	.asciiz	"Starting parameter checking tests."
finish:	.asciiz	"Testing completed."
		.text
		la		$a0, finish
		jal		Print_Divider
		lw		$ra, 0 ($sp)		#  Load return address
		addi	$sp, $sp, 4			#  Pop the stack
		jr		$ra







##############################################################################################
##############################################################################################
##																							##
##									Printing Functions										##
##																							##
##############################################################################################
##############################################################################################


		#######################################################################
		#							Print Divider
		#
		#  Parameters:
		#	$a0:  A descriptive string to print.
		#
		#		Prints out a divider containing the provided string.
		#######################################################################
Print_Divider:
		#  Saving the existing data on the stack in case someone is carelessly
		#  calling this function.
		addi	$sp, $sp, -16
		sw		$t0,  0 ($sp)
		sw		$t1,  4 ($sp)
		sw		$t2,  8 ($sp)
		sw		$s0, 12 ($sp)

		move	$s0, $a0
		#  Count the number of characters in the string.
		li		$t0, 0
		move	$t1, $a0
PD_Loop:
		lb		$t2, 0 ($t1)
		beqz	$t2, PD_End_Loop
		addi	$t0, $t0, 1
		addi	$t1, $t1, 1
		j		PD_Loop
PD_End_Loop:
		li		$t1, 80
		sub		$t1, $t1, $t0
		srl		$t0, $t1, 1			#  The length of the left half of the divider.
		sub		$t1, $t1, $t0		#  The length of the right half of the divider.
		
		#  Adding a newline character.
		li		$v0, 4
		la		$a0, nl
		syscall
		
		#  Printing the left half of the divider
		li		$v0, 11
		li		$a0, 35
		syscall
		syscall
		li		$a0, 45
		syscall
		li		$t2, 3
PD_Left_Loop:
		beq		$t2, $t0, PD_Print_String
		syscall
		addi	$t2, $t2, 1
		j		PD_Left_Loop

		#  Printing the divider string.
PD_Print_String:
		li		$v0, 4
		move	$a0, $s0
		syscall
		
		#  Printing the right half of the divider.
		li		$t2, 3
		li		$v0, 11
		li		$a0, 45
PD_Right_Loop:
		beq		$t2, $t1, PD_Cleanup
		syscall
		addi	$t2, $t2, 1
		j		PD_Right_Loop
PD_Cleanup:
		syscall
		li		$a0, 35
		syscall
		syscall
		
		#  Adding a newline character.
		li		$v0, 4
		la		$a0, nl
		syscall
		
		lw		$s0, 12 ($sp)
		lw		$t2,  8 ($sp)
		lw		$t1,  4 ($sp)
		lw		$t0,  0 ($sp)
		addi	$sp, $sp, 16
		jr		$ra
		


		#######################################################################
		#						Print Integer Array
		#
		#  Parameters:
		#	$a0:  The array of integers to display.
		#
		#		Assumes that the first element in the data structure is the
		#  length of the array.
		#######################################################################
Print_Integer_Array:
		#  Saving the existing data on the stack in case someone is carelessly
		#  calling this function.
		addi	$sp, $sp, -20
		sw		$t0,  0 ($sp)
		sw		$t1,  4 ($sp)
		sw		$t2,  8 ($sp)
		sw		$t3, 12 ($sp)
		sw		$v0, 16 ($sp)

		#  Check for a valid array, print a simple error message if this is not an array.
		lui		$t0, 0x1000
		blt		$a0, $t0, PA_Outside_of_Memory
		li		$t0, 0xFFFFFFFC
		and		$t0, $a0, $t0						#  Set the last two bits to zero, to force it to be word aligned.
		bne		$a0, $t0, PA_Not_Word_Aligned

		move	$t0, $a0				#  Store the array address in $t0
		lw		$t1, 0 ($t0)			#  Store the length in $t1
		#  First, print the length
		li		$v0, 4
		la		$a0, Length
		syscall
		li		$v0, 1
		move	$a0, $t1
		syscall

		#  If the length is zero, just quit now.
		beqz	$t1, PA_Exit

		#  Next, print the contents of the array.
		li		$v0, 4
		la		$a0, Contents
		syscall

		li		$t2, 1					#  Loop counter is in $t2.
PA_Loop:
		bgt		$t2, $t1, PA_Exit

		li		$v0, 4
		la		$a0, Space
		syscall
		li		$v0, 1
		sll		$t3, $t2, 2				#  One variable is provided for in $t3.
		add		$t3, $t0, $t3
		lw		$a0, 0 ($t3)
		syscall

		addi	$t2, $t2, 1
		j		PA_Loop
		.data
Length:	.asciiz	"Length:  "
Contents:	.asciiz	"  Contents:"
Space:	.asciiz	"  "
		.text


		#  If the "array" is not within data memory, don't try to display it.
PA_Outside_of_Memory:
		li		$v0, 4
		la		$a0, PAOM
		syscall
		j		PA_Exit
		.data
PAOM:	.asciiz	"The provided \"array\" is not inside the viable range for data and thus cannot be displayed."
		.text

		#  If the "array" is not word aligned, don't try to display it.
PA_Not_Word_Aligned:
		li		$v0, 4
		la		$a0, PANWA
		syscall
		j		PA_Exit
		.data
PANWA:	.asciiz	"The provided \"array\" is not word aligned and thus cannot be displayed."
		.text

PA_Exit:#  We've reached the end of the print function, so restore all the registers that we changed
		#  and return to the calling function.
		li		$v0, 4
		la		$a0, nl
		syscall
		lw		$t0,  0 ($sp)
		lw		$t1,  4 ($sp)
		lw		$t2,  8 ($sp)
		lw		$t3, 12 ($sp)
		lw		$v0, 16 ($sp)
		addi	$sp, $sp, 20
		jr		$ra






		#######################################################################
		#					Print Raw Integer Array
		#
		#  Parameters:
		#	$a0:  The array of integers to display.
		#	$a1:  The length of the array.
		#######################################################################
Print_Raw_Integer_Array:
		#  Saving the existing data on the stack in case someone is carelessly
		#  calling this function.
		addi	$sp, $sp, -20
		sw		$t0,  0 ($sp)
		sw		$t1,  4 ($sp)
		sw		$t2,  8 ($sp)
		sw		$t3, 12 ($sp)
		sw		$v0, 16 ($sp)

		#  Check for a valid array, print a simple error message if this is not an array.
		lui		$t0, 0x1000
		blt		$a0, $t0, PA_Outside_of_Memory
		li		$t0, 0xFFFFFFFC
		and		$t0, $a0, $t0						#  Set the last two bits to zero, to force it to be word aligned.
		bne		$a0, $t0, PA_Not_Word_Aligned

		move	$t0, $a0				#  Store the array address in $t0
		move	$t1, $a1				#  Store the length in $t1
		#  First, print the length
		li		$v0, 4
		la		$a0, Length
		syscall
		li		$v0, 1
		move	$a0, $t1
		syscall

		#  If the length is zero, just quit now.
		beqz	$t1, PRIA_Exit

		#  Next, print the contents of the array.
		li		$v0, 4
		la		$a0, Contents
		syscall

		li		$t2, 0					#  Loop counter is in $t2.
PRIA_Loop:
		bge		$t2, $t1, PRIA_Exit

		li		$v0, 4
		la		$a0, Space
		syscall
		li		$v0, 1
		sll		$t3, $t2, 2				#  One variable is provided for in $t3.
		add		$t3, $t0, $t3
		lw		$a0, 0 ($t3)
		syscall

		addi	$t2, $t2, 1
		j		PRIA_Loop


PRIA_Exit:#  We've reached the end of the print function, so restore all the registers that we changed
		#  and return to the calling function.
		li		$v0, 4
		la		$a0, nl
		syscall
		lw		$t0,  0 ($sp)
		lw		$t1,  4 ($sp)
		lw		$t2,  8 ($sp)
		lw		$t3, 12 ($sp)
		lw		$v0, 16 ($sp)
		addi	$sp, $sp, 20
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
Print_Hexadecimal:
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






##############################################################################################
##############################################################################################
##																							##
##									Assertion Functions										##
##																							##
##############################################################################################
##############################################################################################


		#######################################################################
		#  Assert equality for integers
		#	$a0:  Observed
		#	$a1:  Expected
		#	$a2:  Test #
		#	$a3:  Test description
		#######################################################################
Assert_Equal_Integer:
		#  Integers are easy to compare
		bne		$a0, $a1, AEIFail

		#  Correct solution.
		li		$a0, 1
		j		Results



		#  Failed because the observed value did not match the expected result.
AEIFail:
		addi	$sp, $sp, -8					#  Storing the observed and expected values on the stack.
		sw		$a0, 0 ($sp)
		sw		$a1, 4 ($sp)

		li		$a0, 0
		la		$a1, AEIF
		j		Results
		#  Error description print routine.
AEIF:	lw		$t0, 0 ($sp)					#  We can now retrieve the observed and expected values to print.
		lw		$t1, 4 ($sp)
		addi	$sp, $sp, 8

		li		$v0, 4
		la		$a0, AEIF1
		syscall
		la		$a0, Observed
		syscall
		li		$v0, 1
		move	$a0, $t0
		syscall
		li		$v0, 4
		la		$a0, nl
		syscall
		la		$a0, Expected
		syscall
		li		$v0, 1
		move	$a0, $t1
		syscall
		li		$v0, 4
		la		$a0, nl
		syscall
		syscall
		jr		$ra


		.data
AEIF1:	.asciiz	"The observed value did not match the expected result.\n"
Observed:	.asciiz	"Observed:  "
Expected:	.asciiz	"Expected:  "
		.text







		#######################################################################
		#  Assert inequality for integers
		#	$a0:  Observed
		#	$a1:  Undesired
		#	$a2:  Test #
		#	$a3:  Test description
		#######################################################################
Assert_Not_Equal_Integer:
		#  Integers are easy to compare
		beq		$a0, $a1, ANEIFail

		#  Correct solution.
		li		$a0, 1
		j		Results



		#  Failed because the observed value did not match the expected result.
ANEIFail:
		addi	$sp, $sp, -8					#  Storing the observed and expected values on the stack.
		sw		$a0, 0 ($sp)
		sw		$a1, 4 ($sp)

		li		$a0, 0
		la		$a1, ANEIF
		j		Results
		#  Error description print routine.
ANEIF:	lw		$t0, 0 ($sp)					#  We can now retrieve the observed and expected values to print.
		lw		$t1, 4 ($sp)
		addi	$sp, $sp, 8

		li		$v0, 4
		la		$a0, ANEIF1
		syscall
		la		$a0, Observed
		syscall
		li		$v0, 1
		move	$a0, $t0
		syscall
		li		$v0, 4
		la		$a0, nl
		syscall
		la		$a0, Undesired
		syscall
		li		$v0, 1
		move	$a0, $t1
		syscall
		li		$v0, 4
		la		$a0, nl
		syscall
		syscall
		jr		$ra


		.data
ANEIF1:	.asciiz	"The observed value should not match the undesired value.\n"
Undesired:	.asciiz	"Undesired:  "
		.text







		#######################################################################
		#  Assert greater than for integers
		#	$a0:  Observed
		#	$a1:  Greater than
		#	$a2:  Test #
		#	$a3:  Test description
		#######################################################################
Assert_Greater_Than_Integer:
		#  Integers are easy to compare
		ble		$a0, $a1, AGTIFail

		#  Correct solution.
		li		$a0, 1
		j		Results



		#  Failed because the observed value was not greater than the minimum value.
AGTIFail:
		addi	$sp, $sp, -8					#  Storing the observed and expected values on the stack.
		sw		$a0, 0 ($sp)
		sw		$a1, 4 ($sp)

		li		$a0, 0
		la		$a1, AGTIF
		j		Results
		#  Error description print routine.
AGTIF:	lw		$t0, 0 ($sp)					#  We can now retrieve the observed and expected values to print.
		lw		$t1, 4 ($sp)
		addi	$sp, $sp, 8

		li		$v0, 4
		la		$a0, AGTIF1
		syscall
		li		$v0, 1
		move	$a0, $t0
		syscall
		li		$v0, 4
		la		$a0, AGTIF2
		syscall
		li		$v0, 1
		move	$a0, $t1
		syscall
		li		$v0, 4
		la		$a0, $AGTIF3
		syscall
		jr		$ra


		.data
AGTIF1:	.asciiz	"The result ("
AGTIF2:	.asciiz	") should be greater than "
AGTIF3:	.asciiz	".\n\n"
		.text







		#######################################################################
		#  Assert less than for integers
		#	$a0:  Observed
		#	$a1:  Less than
		#	$a2:  Test #
		#	$a3:  Test description
		#######################################################################
Assert_Less_Than_Integer:
		#  Integers are easy to compare
		bge		$a0, $a1, ALTIFail

		#  Correct solution.
		li		$a0, 1
		j		Results



		#  Failed because the observed value was not less than the minimum value.
ALTIFail:
		addi	$sp, $sp, -8					#  Storing the observed and expected values on the stack.
		sw		$a0, 0 ($sp)
		sw		$a1, 4 ($sp)

		li		$a0, 0
		la		$a1, ALTIF
		j		Results
		#  Error description print routine.
ALTIF:	lw		$t0, 0 ($sp)					#  We can now retrieve the observed and expected values to print.
		lw		$t1, 4 ($sp)
		addi	$sp, $sp, 8

		li		$v0, 4
		la		$a0, AGTIF1
		syscall
		li		$v0, 1
		move	$a0, $t0
		syscall
		li		$v0, 4
		la		$a0, ALTIF2
		syscall
		li		$v0, 1
		move	$a0, $t1
		syscall
		li		$v0, 4
		la		$a0, $AGTIF3
		syscall
		jr		$ra


		.data
ALTIF2:	.asciiz	") should be less than "
		.text







		#######################################################################
		#  Assert greater than or equal to for integers
		#	$a0:  Observed
		#	$a1:  Greater than or equal to
		#	$a2:  Test #
		#	$a3:  Test description
		#######################################################################
Assert_Greater_Than_Equal_Integer:
		#  Integers are easy to compare
		blt		$a0, $a1, AGTEIFail

		#  Correct solution.
		li		$a0, 1
		j		Results



		#  Failed because the observed value was not greater than or equal to the minimum value.
AGTEIFail:
		addi	$sp, $sp, -8					#  Storing the observed and expected values on the stack.
		sw		$a0, 0 ($sp)
		sw		$a1, 4 ($sp)

		li		$a0, 0
		la		$a1, AGTEIF
		j		Results
		#  Error description print routine.
AGTEIF:	lw		$t0, 0 ($sp)					#  We can now retrieve the observed and expected values to print.
		lw		$t1, 4 ($sp)
		addi	$sp, $sp, 8

		li		$v0, 4
		la		$a0, AGTIF1
		syscall
		li		$v0, 1
		move	$a0, $t0
		syscall
		li		$v0, 4
		la		$a0, AGTEIF2
		syscall
		li		$v0, 1
		move	$a0, $t1
		syscall
		li		$v0, 4
		la		$a0, $AGTIF3
		syscall
		jr		$ra


		.data
AGTEIF2:	.asciiz	") should be greater than or equal to "
		.text







		#######################################################################
		#  Assert less than or equal to for integers
		#	$a0:  Observed
		#	$a1:  Less than or equal to
		#	$a2:  Test #
		#	$a3:  Test description
		#######################################################################
Assert_Less_Than_Equal_Integer:
		#  Integers are easy to compare
		bgt		$a0, $a1, ALTEIFail

		#  Correct solution.
		li		$a0, 1
		j		Results



		#  Failed because the observed value was not less than the minimum value.
ALTEIFail:
		addi	$sp, $sp, -8					#  Storing the observed and expected values on the stack.
		sw		$a0, 0 ($sp)
		sw		$a1, 4 ($sp)

		li		$a0, 0
		la		$a1, ALTEIF
		j		Results
		#  Error description print routine.
ALTEIF:	lw		$t0, 0 ($sp)					#  We can now retrieve the observed and expected values to print.
		lw		$t1, 4 ($sp)
		addi	$sp, $sp, 8

		li		$v0, 4
		la		$a0, AGTIF1
		syscall
		li		$v0, 1
		move	$a0, $t0
		syscall
		li		$v0, 4
		la		$a0, ALTEIF2
		syscall
		li		$v0, 1
		move	$a0, $t1
		syscall
		li		$v0, 4
		la		$a0, $AGTIF3
		syscall
		jr		$ra


		.data
ALTEIF2:	.asciiz	") should be less than or equal to "
		.text







		#######################################################################
		#  Assert equality for 64-bit integers
		#	$a0:  Observed upper 32 bits
		#	$a1:  Observed lower 32 bits
		#	$a2:  Expected upper 32 bits
		#	$a3:  Expected lower 32 bits
		#	$sp-4:  Test #
		#	$sp-8:  Test description
		#######################################################################
Assert_Equal_Long:
		bne		$a0, $a2, AELFail		#  Comparing longs is almost as easy as ints.
		bne		$a1, $a3, AELFail

		#  Correct solution
		li		$a0, 1
		lw		$a2, -4 ($sp)
		lw		$a3, -8 ($sp)
		j		Results

		#  Failed because the long integers did not match.
AELFail:
		addi	$sp, $sp -24
		sw		$a0,  0 ($sp)			#  Observed upper 32 bits
		sw		$a1,  4 ($sp)			#  Observed lower 32 bits
		sw		$a2,  8 ($sp)			#  Expected upper 32 bits
		sw		$a3, 12 ($sp)			#  Expected lower 32 bits
		#  Test # is at 16 ($sp)
		#  Test description is at 20 ($sp)

		li		$a0, 0
		la		$a1, AELF
		lw		$a2, 16 ($sp)
		lw		$a3, 20 ($sp)
		j		Results
		#  Error description print routine.
AELF:	li		$v0, 4
		la		$a0, AEIF1				#  "The observed value did not match the expected result.\n"
		syscall
		la		$a0, Observed			#  "Observed:  "
		syscall
		lw		$a0, 0 ($sp)
		jal		Print_Hexadecimal
		li		$v0, 4
		la		$a0, nbsp
		syscall
		lw		$a0, 4 ($sp)
		jal		Print_Hexadecimal
		li		$v0, 4
		la		$a0, nl
		syscall

		la		$a0, Expected			#  "Expected:  "
		syscall
		lw		$a0, 8 ($sp)
		jal		Print_Hexadecimal
		li		$v0, 4
		la		$a0, nbsp
		syscall
		lw		$a0, 12 ($sp)
		jal		Print_Hexadecimal
		lw		$v0, 4
		la		$a0, nbsp
		syscall
		syscall

		addi	$sp, $sp, 24
		jr		$ra








		#######################################################################
		#  Assert inequality for 64-bit integers
		#	$a0:  Observed upper 32 bits
		#	$a1:  Observed lower 32 bits
		#	$a2:  Undesired upper 32 bits
		#	$a3:  Undesired lower 32 bits
		#	$sp-4:  Test #
		#	$sp-8:  Test description
		#######################################################################
Assert_Not_Equal_Long:
		bne		$a0, $a2, ANELPass		#  Comparing longs is almost as easy as ints.
		bne		$a1, $a3, ANELPass
		j		ANELFail

ANELPass:
		#  Correct solution
		li		$a0, 1
		lw		$a2, -4 ($sp)
		lw		$a3, -8 ($sp)
		j		Results

		#  Failed because the long integers matched.
ANELFail:
		addi	$sp, $sp -24
		sw		$a0,  0 ($sp)			#  Observed upper 32 bits
		sw		$a1,  4 ($sp)			#  Observed lower 32 bits
		sw		$a2,  8 ($sp)			#  Undesired upper 32 bits
		sw		$a3, 12 ($sp)			#  Undesired lower 32 bits
		#  Test # is at 16 ($sp)
		#  Test description is at 20 ($sp)

		li		$a0, 0
		la		$a1, ANELF
		lw		$a2, 16 ($sp)
		lw		$a3, 20 ($sp)
		j		Results
		#  Error description print routine.
ANELF:	li		$v0, 4
		la		$a0, ANEIF1				#  "The observed value should not match the undesired value.\n"
		syscall
		la		$a0, Observed			#  "Observed:  "
		syscall
		lw		$a0, 0 ($sp)
		jal		Print_Hexadecimal
		li		$v0, 4
		la		$a0, nbsp
		syscall
		lw		$a0, 4 ($sp)
		jal		Print_Hexadecimal
		li		$v0, 4
		la		$a0, nl
		syscall

		la		$a0, Undesired			#  "Undesired:  "
		syscall
		lw		$a0, 8 ($sp)
		jal		Print_Hexadecimal
		li		$v0, 4
		la		$a0, nbsp
		syscall
		lw		$a0, 12 ($sp)
		jal		Print_Hexadecimal
		lw		$v0, 4
		la		$a0, nbsp
		syscall
		syscall

		addi	$sp, $sp, 24
		jr		$ra








		#######################################################################
		#  Assert equality for integer arrays with included size parameter
		#	$a0:  Observed
		#	$a1:  Expected
		#	$a2:  Test #
		#	$a3:  Test description
		#######################################################################
Assert_Equal_Array:
		#  1.  Check for a valid observed array.
		#      It should be a pointer to the data region of memory.
		lui		$t0, 0x1000								#  All data should be above 0x1000 0000 and not negative.
		blt		$a0, $t0, AEA_Failed_Outside_of_Memory
		#      It should also be word aligned, since the first value is an integer.
		li		$t0, 0xFFFFFFFC
		and		$t0, $a0, $t0						#  Set the last two bits to zero, to force it to be word aligned.
		bne		$a0, $t0, AEA_Failed_Not_Word_Aligned	#  The results should be equal.
		#  2.  Check to make sure the student isn't trying to pass off the expected array as the observed array.
		beq		$a0, $a1, AEA_Failed_Cheating
		#  These should pass unless the student has done something catastrophic.

		#  Assume that the data inside the array has been changed improperly and use the expected data for the length of the array.
		li		$t0, 0
		lw		$t1, 0 ($a1)
AEA_Loop:
		bgt		$t0, $t1, AEA_End_Loop

		sll		$t9, $t0, 2
		add		$t2, $a0, $t9
		lw		$t2, 0 ($t2)
		add		$t3, $a1, $t9
		lw		$t3, 0 ($t3)
		bne		$t2, $t3, AEA_Failed_Not_Equal

		addi	$t0, $t0, 1
		j		AEA_Loop
AEA_End_Loop:
		#  All elements are equal, so the arrays are equivalent.
		li		$a0, 1			#  Correct result.
		j		Results

AEA_Failed_Outside_of_Memory:
		li		$a0, 0			#  Incorrect result.
		la		$a1, AEAFOM		#  Description of failure.
		j		Results
		.data
AEAFOM:	.asciiz	"The array pointer is no longer within the data memory range.\nThis is bad, I do not know how you managed to accomplish this.\n"
		.text

AEA_Failed_Not_Word_Aligned:
		li		$a0, 0			#  Incorrect result.
		la		$a1, AEAFNWA	#  Description of failure.
		j		Results
		.data
AEAFNWA:	.asciiz	"The array pointer is no longer word aligned.\nThis is bad, I do now know how you managed to accomplish this.\n"
		.text

AEA_Failed_Cheating:
		li		$a0, 0			#  Incorrect result.
		la		$a1, AEAFC		#  Description of failure.
		j		Results
		.data
AEAFC:	.asciiz	"Cheating is bad, mmmkay?\nQuit trying to game the test suite.\n"
		.text

AEA_Failed_Not_Equal:
		addi	$sp, $sp, -12
		sw		$a0, 0 ($sp)	#  Store the observed array on the stack.
		sw		$a1, 4 ($sp)	#  Store the expected array on the stack.
		sw		$ra, 8 ($sp)	#  Store the return address on the stack.

		beq		$t0, $zero, AEA_Failed_Wrong_Length
		li		$a0, 0			#  Incorrect result.
		la		$a1, AEAFNE		#  Description of failure.
		j		Results
AEAFNE:	li		$v0, 4
		la		$a0, AEAFNE1
		syscall
		j		AEA_Print_Array
		.data
AEAFNE1:	.asciiz	"The observed array does not match the expected array.\n"
		.text

AEA_Failed_Wrong_Length:
		li		$a0, 0			#  Incorrect result.
		la		$a1, AEAFWL		#  Description of failure.
		j		Results
AEAFWL:	li		$v0, 4
		la		$a0, AEAFWL1
		syscall
		.data
AEAFWL1:	.asciiz	"The length of the array has been changed.\nYou should not need to modify the first element in the array.\n"
		.text

		#  Print out the contents of the array to show the student what (s)he did wrong.
AEA_Print_Array:
		lw		$t0, 0 ($sp)	#  Restore the observed array from the stack.
		lw		$t1, 4 ($sp)	#  Restore the expected array from the stack.

		li		$v0, 4
		la		$a0, Observed
		syscall
		move	$a0, $t0
		jal		Print_Integer_Array

		li		$v0, 4
		la		$a0, Expected
		syscall
		move	$a0, $t1
		jal		Print_Integer_Array

		lw		$ra, 8 ($sp)	#  Restore the return address from the stack.
		addi	$sp, $sp, 12
		jr		$ra






		#######################################################################
		#  Assert equal n-dimensional matrix of integers
		#	$a0:  Observed
		#	$a1:  Expected
		#	$a2:  Test #
		#	$a3:  Test description
		#
		#		The expected format has a top-level array where the first
		#  integer specifies the number of dimensions in the matrix.  The next
		#  n integers specify the size of each dimension.  The last value in
		#  the array is a pointer to the first level of the matrix.  Each level
		#  of the matrix contains pointers to an array at the next lower level
		#  until the last, which contains the actual data for that row.
		#######################################################################
Assert_Equal_nD_Matrix:
		#  1.  Check for a valid observed array.
		#      It should be a pointer to the data region of memory.
		lui		$t0, 0x1000								#  All data should be above 0x1000 0000 and not negative.
		blt		$a0, $t0, AEA_Failed_Outside_of_Memory
		#      It should also be word aligned, since the first value is an integer.
		li		$t0, 0xFFFFFFFC
		and		$t0, $a0, $t0						#  Set the last two bits to zero, to force it to be word aligned.
		bne		$a0, $t0, AEA_Failed_Not_Word_Aligned	#  The results should be equal.
		#  2.  Check to make sure the student isn't trying to pass off the expected array as the observed array.
		beq		$a0, $a1, AEA_Failed_Cheating
		#  These should pass unless the student has done something catastrophic.

		lw		$t0, 0 ($a0)
		lw		$t1, 0 ($a1)
		#  3.  Check to see that both data structures report the same number of dimensions.
		bne		$t0, $t1, AEnM_Mismatched_Dimensions

		#  4.  Iterate over the dimension sizes to make sure they all match.
		sll		$t0, $t0, 4
		li		$t1, 4
AEnM_Dimension_Loop:
		bgt		$t1, $t0, AEnMDL_End
		add		$t2, $a0, $t1
		add		$t3, $a1, $t1
		lw		$t2, 0 ($t2)
		lw		$t3, 0 ($t3)
		bne		$t2, $t3, AEnM_Mismatched_Sizes
		addi	$t1, $t1, 4
		j		AEnM_Dimension_Loop
AEnMDL_End:

		#  5.  Check to make sure the student isn't trying to pass off the expected array as the observed array.
		add		$t2, $a0, $t1
		add		$t3, $a0, $t1
		lw		$t2, 0 ($t2)
		lw		$t3, 0 ($t3)
		beq		$t2, $t3, AEA_Failed_Cheating

		#  6.  Iterate over the dimensions loading data and comparing it.
		#	   Data should always be equal, but pointers should never be equal.

#  TODO:  Add code to programmatically walk across the pair of n-dimensional arrays and compare the results.

		#  Failed because the number of dimensions did not match.
AEnM_Mismatched_Dimensions:
		addi	$sp, $sp, -8
		sw		$t0, 0 ($sp)		#  Observed number of dimensions
		sw		$t1, 4 ($sp)		#  Expected number of dimensions

		li		$a0, 0				#  Incorrect result
		la		$a1, AEnMMD_Print_Failure
		j		Results
		#  Display reason for failure.
AEnMMD_Print_Failure:
		li		$v0, 4
		la		$a0, AEnMMD
		syscall
		la		$a0, Observed
		syscall
		li		$v0, 1
		lw		$a0, 0 ($sp)
		syscall
		li		$v0, 4
		la		$a0, nl
		syscall
		la		$a0, Expected
		syscall
		li		$v0, 1
		lw		$a0, 4 ($sp)
		syscall
		li		$v0, 4
		la		$a0, nl
		syscall
		syscall

		addi	$sp, $sp, 8
		jr		$ra

		#  Failed because the size of one or more dimensions did not match.
AEnM_Mismatched_Sizes:
		addi	$sp, $sp, -12
		sw		$a0, 0 ($sp)			#  Observered matrix
		sw		$a1, 4 ($sp)			#  Expected matrix
		sw		$ra, 8 ($sp)			#  Return address

		li		$a0, 0					#  Incorrect result
		la		$a1, AEnMMS_Print_Failure
		j		Results
		#  Display reason for failure.
AEnMMS_Print_Failure:
		li		$v0, 4
		la		$a0, AEnMMS
		syscall

		la		$a0, Observed
		syscall
		lw		$a0, 0 ($sp)
		jal		Print_Integer_Array

		li		$v0, 4
		la		$a0, Expected
		syscall
		lw		$a0, 4 ($sp)
		jal		Print_Integer_Array

		li		$v0, 4
		la		$a0, nl
		syscall
		syscall

		lw		$ra, 8 ($sp)
		addi	$sp, $sp, 12
		jr		$ra

		#  Failed because one or more elements did not match the expected value.
AEnM_Data:
		addi	$sp, $sp, -12
		sw		$a0, 0 ($sp)			#  Observed matrix
		sw		$a1, 4 ($sp)			#  Expected matrix
		sw		$ra, 8 ($sp)			#  Return address

		li		$a0, 0					#  Incorrect result
		la		$a1, AEnMD_Print_Failure
		j		Results
		#  Display reason for failure.
AEnMD_Print_Failure:
#  TODO:  Add code to walk over the matrices and display the data.

		.data
AEnMMD:	.asciiz	"The number of dimensions in the matrix is incorrect.\n"
AEnMMS:	.asciiz	"The size of the matrix is incorrect.\n"
AEnMD:	.asciiz	"The data in the matrix does not match the expected result.\n"
		.text






		#######################################################################
		#  Assert null pointer
		#	$a0:  Observed
		#	   :  Expect a null pointer (0).
		#	$a2:  Test #
		#	$a3:  Test description
		#######################################################################
Assert_Null:
		bne		$a0, $zero, AN_Failed

		li		$a0, 1			#  Correct result.
		j		Results

AN_Failed:
		li		$a0, 0			#  Incorrect result.
		la		$a1, ANF		#  Description of failure.
		j		Results
		.data
ANF:	.asciiz	"Null pointer expected.\n"
		.text





		#######################################################################
		#  Assert valid pointer
		#	$a0:  Observed
		#	   :  Expect a null pointer (0).
		#	$a2:  Test #
		#	$a3:  Test description
		#######################################################################
Assert_Not_Null:
		beq		$t0, $zero, ANN_Failed

		li		$a0, 1			#  Correct result.
		j		Results

ANN_Failed:
		li		$a0, 0			#  Incorrect result.
		la		$a1, ANF		#  Description of failure.
		j		Results
		.data
ANNF:	.asciiz	"Null pointer not expected.\n"
		.text





		#######################################################################
		#  Assert error
		#	$a0:  Observed
		#	   :  Expect an error signal (0x8000 0001).
		#	$a2:  Test #
		#	$a3:  Test description
		#######################################################################
Assert_Error:
		li		$t0, 0x80000001
		bne		$a0, $t0, AE_Failed

		li		$a0, 1			#  Correct result.
		j		Results

AE_Failed:
		li		$a0, 0			#  Incorrect result.
		la		$a1, AEF		#  Description of failure.
		j		Results
		.data
AEF:	.asciiz	"The parameters were not parsable, the function should have returned an error (0x8000 0001).\n"
		.text





		#######################################################################
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
Initialize_Test_Suite:
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

#############################################################################################
#                                 Control Structures and Loops								#
#																							#
#  Padraic Edgington                                                          11 Oct, 2013	#
#																							#
#  Uses control structures and loops to create a diamond from an arbitrary character		#
#  embedded in a box.																		#
#																							#
#  Variables:																				#
#  $s0		Graphic size																	#
#  $s1		Graphic character																#
#  $s2		Size of a quadrant in the graphic												#
#																							#
#  v. 1		Initial release																	#
#############################################################################################


			.data
qSize:		.asciiz	"Enter the size of the graphic or 0 to quit:  "
qCharacter:	.asciiz	"Enter a character to print:  "
horizontal:	.asciiz "-"
vertical:	.asciiz	"|"
space:		.asciiz	" "
newLine:	.asciiz "\n"
eNegative:	.asciiz	"The size must be a positive number.\n\n"
eEven:		.asciiz	"Only odd numbers are allowed.\n\n"
eOne:		.asciiz	"That size is too small.\n\n"
			.text
			
main:
		#  Query the user for the parameters.
		#####################################
		
		
		#  Query the user for the size of the graphic.
		li		$v0, 4						#  System call #4 prints the string referenced in $a0.
		la		$a0, qSize					#  Print "Enter the size of the graphic or 0 to quit:  ".
		syscall
		
		li		$v0, 5						#  System call #5 reads an integer from the console into $v0.
		syscall
		move	$s0, $v0					#  Copy the size into $s0.
		
		
		
		#  Test for a valid size.
		bgez	$s0, negativeOK				#  If the size is negative, then fail.
		li		$v0, 4						#  System call #4 prints the string referenced in $a0.
		la		$a0, eNegative				#  Print "The size must be a positive number.\n\n".
		syscall
		j		main						#  Try again.
negativeOK:

		bnez	$s0, zeroOK					#  If the size is zero, then quit.
		li		$v0, 10						#  System call #10 exits the program.
		syscall
zeroOK:	

		li		$t0, 2
		div		$s0, $t0
		mfhi	$t0							#  $t0 = $(size) % 2
		bnez	$t0, evenOK					#  If the size is evenly divisble by 2, then fail.
		li		$v0, 4						#  System call #4 prints the string referenced in $a0.
		la		$a0, eEven					#  Print "Only odd numbers are allowed.\n\n"
		syscall
		j		main						#  Try again.
evenOK:

		li		$t0, 1
		bne		$s0, $t0, oneOK				#  If the size is 1, then we can't really create a graphic.
		li		$v0, 4						#  System call #4 prints the string referenced in $a0.
		la		$a0, eOne					#  Print "That size is too small.\n\n"
		syscall
		j		main
oneOK:
	
		
		#  Query the user for the character to be used for the graphic.
		li		$v0, 4						#  System call #4 prints the string referenced in $a0.
		la		$a0, qCharacter				#  Print "Enter a character to print:  "
		syscall
		
		li		$v0, 12						#  System call #12 reads a character from the
											#  console into $v0.
		syscall
		move	$s1, $v0					#  Copy the character into $s1.
		
		#  Print a carriage return since the character call doesn't require one.
		li		$v0, 4						#  System call #4 prints the string referenced in $a0.
		la		$a0, newLine				#  Print a "\n".
		syscall

		#  Calculate the size of the quadrants in the graphic.
		sub		$s2, $s0, 2					#  Remove the box from the calculations.
		li		$t0, 2
		div		$s2, $t0
		mflo	$s2							#  floor( ($(size)-2)/2 ) is the number of rows/cols in
											#  each quadrant, excluding the box and the center lines.
											#  This is the largest number of contiguous spaces that
											#  can be present in a single line.
		
		
		#
		#  Print the top half of the graphic
		####################################
		
		#  The first line is a string of $(size) "-"s.
		li		$v0, 4						#  System call #4 prints the string referenced in $a0.
		la		$a0, horizontal				#  Print "-".

		li		$t0, 0						#  $t0 = 0		Initializing loop counter.
hLoop1:	beq		$t0, $s0, hLoop1End			#  If $t0=$(size), quit the loop.
		
		syscall								#  Print a single "-".
		
		addi	$t0, $t0, 1					#  $t0++		Incrementing loop counter.
		j		hLoop1
		
hLoop1End:
		la		$a0, newLine				#  Print "\n".
		syscall
		

		move	$t0, $s2					#  Initialize the main loop counter to the max number of
											#  spaces in a quadrant.
test1:	bltz	$t0, bottomHalf				#  If we don't print any spaces at the beginning of the
											#  line, then we are at the middle of the graphic.
		
		#  The body of the graphic starts with a vertical bar.
		li		$v0, 4						#  System call #4 prints the string referenced in $a0.
		la		$a0, vertical				#  Print a "|".
		syscall
		
		#  Print $t0 spaces.
		li		$t1, 0						#  $t1 = 0		Initializing space counter.
		li		$v0, 4						#  System call #4 prints the string referenced in $a0.
		la		$a0, space					#  Print a " ".
spaceLoop1:
		beq		$t1, $t0, endSpaceLoop1		#  Quit after printing $t0 spaces.
		syscall
		addi	$t1, $t1, 1					#  $t1++		Incrementing space counter.
		j		spaceLoop1
endSpaceLoop1:


		#  Print $(size) - 2 - 2*$t0 of $(character).
		addi	$t2, $s0, -2
		sub		$t2, $t2, $t0
		sub		$t2, $t2, $t0				#  The number of $(character) to print.
		
		li		$t1, 0						#  $t1 = 0		Initializing character counter.
		li		$v0, 11						#  System call #11 prints the character in $a0.
		move	$a0, $s1					#  Copy $(character) to $a0.
		
characterLoop1:
		beq		$t1, $t2, endCharacterLoop1	#  Quit after printing $t2 $(character)s.
		syscall								#  Print a single $(character).
		addi	$t1, $t1, 1					#  $t1++		Incrementing character counter.
		j		characterLoop1
endCharacterLoop1:


		#  Print another $t0 spaces.
		li		$t1, 0						#  $t1 = 0		Initializing space counter.
		li		$v0, 4						#  System call #4 prints the string referenced in $a0.
		la		$a0, space					#  Print a " ".
spaceLoop2:
		beq		$t1, $t0, endSpaceLoop2		#  Quit after printing $t0 spaces.
		syscall
		addi	$t1, $t1, 1					#  $t1++		Incrementing space counter.
		j		spaceLoop2
endSpaceLoop2:


		#  The body of the graphic ends with a vertical bar and a newline character.
		li		$v0, 4						#  System call #4 prints the string referenced in $a0.
		la		$a0, vertical				#  Print a "|".
		syscall
		la		$a0, newLine				#  Print a "\n".
		syscall
		

		addi	$t0, $t0, -1				#  Decrement the space counter.
		j		test1
		
		
		
		
		
		#  Print the bottom half of the graphic.
		################################################
bottomHalf:
		li		$t0, 1						#  Initialize the space counter for the line after the
											#  center line.
		
test2:	bgt		$t0, $s2, endPrinting		#  After printing a line with the maximum number of
											#  spaces in a quadrant, then we're done with this loop.
		
		#  This code is the same as the top half, but with different labels.
		
		#  The body of the graphic starts with a vertical bar.
		li		$v0, 4						#  System call #4 prints the string referenced in $a0.
		la		$a0, vertical				#  Print a "|".
		syscall
		
		#  Print $t0 spaces.
		li		$t1, 0						#  $t1 = 0		Initializing space counter.
		li		$v0, 4						#  System call #4 prints the string referenced in $a0.
		la		$a0, space					#  Print a " ".
spaceLoop3:
		beq		$t1, $t0, endSpaceLoop3		#  Quit after printing $t0 spaces.
		syscall
		addi	$t1, $t1, 1					#  $t1++		Incrementing space counter.
		j		spaceLoop3
endSpaceLoop3:


		#  Print $(size) - 2 - 2*$t0 of $(character).
		addi	$t2, $s0, -2
		sub		$t2, $t2, $t0
		sub		$t2, $t2, $t0				#  The number of $(character) to print.
		
		li		$t1, 0						#  $t1 = 0		Initializing character counter.
		li		$v0, 11						#  System call #11 prints the character in $a0.
		move	$a0, $s1					#  Copy $(character) to $a0.
		
characterLoop2:
		beq		$t1, $t2, endCharacterLoop2	#  Quit after printing $t2 $(character)s.
		syscall								#  Print a single $(character).
		addi	$t1, $t1, 1					#  $t1++		Incrementing character counter.
		j		characterLoop2
endCharacterLoop2:


		#  Print another $t0 spaces.
		li		$t1, 0						#  $t1 = 0		Initializing space counter.
		li		$v0, 4						#  System call #4 prints the string referenced in $a0.
		la		$a0, space					#  Print a " ".
spaceLoop4:
		beq		$t1, $t0, endSpaceLoop4		#  Quit after printing $t0 spaces.
		syscall
		addi	$t1, $t1, 1					#  $t1++		Incrementing space counter.
		j		spaceLoop4
endSpaceLoop4:


		#  The body of the graphic ends with a vertical bar and a newline character.
		li		$v0, 4						#  System call #4 prints the string referenced in $a0.
		la		$a0, vertical				#  Print a "|".
		syscall
		la		$a0, newLine				#  Print a "\n".
		syscall

		
		addi	$t0, $t0, 1					#  $t0++		Increment the space counter.
		j		test2
		
		
endPrinting:
		#  The last line is a string of $(size) "-"s.
		li		$v0, 4						#  System call #4 prints the string referenced in $a0.
		la		$a0, horizontal				#  Print "-".

		li		$t0, 0						#  $t0 = 0		Initializing loop counter.
hLoop2:	beq		$t0, $s0, hLoop2End			#  If $t0=$(size), quit the loop.
		
		syscall								#  Print a single "-".
		
		addi	$t0, $t0, 1					#  $t0++		Incrementing loop counter.
		j		hLoop2
		
hLoop2End:
		la		$a0, newLine				#  Print "\n".
		syscall
		syscall								#  Print an extra carriage return at the end of the
											#  graphic.


											
		#  End of the printing, so go back to the query.
		j		main
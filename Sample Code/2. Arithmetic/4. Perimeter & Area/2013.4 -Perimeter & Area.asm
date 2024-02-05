#############################################################################################
#                                     I/O and Arithmetic									#
#																							#
#  Padraic Edgington                                                          11 Oct, 2013	#
#																							#
#  Introductory example with input, output and arithmetic operations.						#
#																							#
#  v. 1		Initial release																	#
#############################################################################################


			.data
qLength:	.asciiz	"Enter the length of the rectangle:  "
qWidth:		.asciiz	"Enter the width of the rectangle:  "
rPerimeter:	.asciiz	"The perimeter of the rectangle is "
rRecArea:	.asciiz	"The area of the rectangle is "
rTriArea:	.asciiz	"The area of the triangle is "
newLine:	.asciiz	".\n"
			.text

main:	
		#  Print the first query.
		li		$v0, 4					#  System call #4 prints the string referenced in $a0.
		la		$a0, qLength			#  Print "Enter the length of the rectangle:  ".
		syscall
		
		#  Read an integer from the console.
		li		$v0, 5					#  System call #5 reads an integer from the console into $v0.
		syscall
		move	$s0, $v0				#  Copy the length to $s0.
		
		#  Print the second query.
		li		$v0, 4					#  System call #4 prints the string referenced in $a0.
		la		$a0, qWidth				#  Print "Enter the width of the rectangle:  ".
		syscall
		
		#  Read an integer from the console.
		li		$v0, 5					#  System call #5 reads an integer into $v0.
		syscall
		move	$s1, $v0				#  Copy the width to $s1.
		
		#  Perform the calculations.
		add		$s2, $s0, $s1			#  length + width
		sll		$s2, $s2, 1				#  Perimeter = 2 * (length + width).
		
		mult	$s0, $s1				#  Area of a rectangle = length * width.
		mflo	$s3						#  Copy the area into $s3.
		
		li		$t0, 2
		div		$s3, $t0				#  Area of a triangle = 1/2 * length * width.
		mflo	$s4						#  Copy the area into $s4.
		
		#  Print the results.
		li		$v0, 4					#  System call #4 prints the string referenced in $a0.
		la		$a0, rPerimeter			#  Print "The perimeter of the rectangle is ".
		syscall
		
		li		$v0, 1					#  System call #1 prints the integer in $a0.
		move	$a0, $s2				#  Copy the perimeter to $a0.
		syscall
		
		li		$v0, 4					#  System call #4 prints the string referenced in $a0.
		la		$a0, newLine			#  Print ".\n".
		syscall
		
										#  System call #4 prints the string referenced in $a0.
		la		$a0, rRecArea			#  Print "The area of the rectangle is ".
		syscall
		
		li		$v0, 1					#  System call #1 prints the integer in $a0.
		move	$a0, $s3				#  Copy the area to $a0.
		syscall
		
		li		$v0, 4					#  System call #4 prints the string referenced in $a0.
		la		$a0, newLine			#  Print ".\n".
		syscall
		
										#  System call #4 prints the string referenced in $a0.
		la		$a0, rTriArea			#  Print "The area of the triangle is ".
		syscall
		
		li		$v0, 1					#  System call #1 prints the integer in $a0.
		move	$a0, $s4				#  Copy the area to $a0.
		syscall
		
		li		$v0, 4					#  System call #4 prints the string referenced in $a0.
		la		$a0, newLine			#  Print ".\n".
		syscall
		
		li		$v0, 10					#  System call #10 exits the program.
		syscall
		
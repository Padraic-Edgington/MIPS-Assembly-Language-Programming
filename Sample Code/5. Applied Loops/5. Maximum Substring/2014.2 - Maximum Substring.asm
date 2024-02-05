#############################################################################################
#                                 Control Structures and Loops								#
#																							#
#  Padraic Edgington                                                          5 Mar, 2013	#
#																							#
#  Uses control structures and loops to to calculate the maximum value of a substring of a	#
#  set of integers. 																		#
#																							#
#  Variables:																				#
#  $v0		Current integer																	#
#  $t0		Maximum substring summation														#
#  $t1		Summation of current substring													#
#  $t2		Number of integers to process													#
#  $t3		Counter variable																#
#																							#
#  v. 1		Initial release																	#
#############################################################################################


		.data
ints:	.asciiz	"Enter the number of integers in the list:  "
query:	.asciiz	"Enter an integer:  "
result:	.asciiz	"The largest sum of a substring is "
el:		.asciiz	".\n"
		.text
		
main:	
		#  Query the user for the number of integers in the list.
		li		$v0, 4
		la		$a0, ints
		syscall

		#  Read the user's length.
		li		$v0, 5
		syscall
		move	$t2, $v0
		
Loop:	beq		$t2, $t3, Exit
		
		#  Query the user for an integer.
		li		$v0, 4
		la		$a0, query
		syscall
		
		#  Read the user's integer.
		li		$v0, 5
		syscall
		
		#  Calculate value of current substring.
		bge		$t1, $zero, KeepHead			#  If the current summation is < 0...
		move	$t1, $zero						#    then discard it.
KeepHead:
		add		$t1, $t1, $v0					#  $t1 = substring + data
		
		#  Calculate value of maximum substring.
		bge		$t0, $t1, KeepMax				#  If substring > max...
		move	$t0, $t1						#    copy substring to max.
KeepMax:

		#  Print the running result.
		li		$v0, 4
		la		$a0, result
		syscall
		
		li		$v0, 1
		move	$a0, $t0
		syscall
		
		li		$v0, 4
		la		$a0, el
		syscall
		
		#  Increment the counter and repeat.
		addi	$t3, $t3, 1
		j		Loop
		
Exit:	li		$v0, 10
		syscall
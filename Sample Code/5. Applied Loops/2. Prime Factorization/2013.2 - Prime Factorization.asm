#########################
#  Prime Factorization  #
#  Padraic Edgington    #
#  January 24, 2013     #
#########################


main:

		#  Do-While Loop
		.data
query:	.asciiz	"Enter an integer:  "
		.text
loop:	li		$v0, 4
		la		$a0, query
		syscall								#  Print "Enter an integer:  "
		
		li		$v0, 5
		syscall								#  Read the next integer
		
		#  If the number is less than two, then quit
		li		$t9, 2
		blt		$v0, $t9, quit
		
		move	$s0, $v0					#  Copy the entered number into $s0
		
		#  Print intro results
		.data
text1:	.asciiz	"The factors of "
text2:	.asciiz	" are "
text3:	.asciiz	", "
text4:	.asciiz	".\n"
		.text
		li		$v0, 4
		la		$a0, text1
		syscall								#  Print "The factors of "
		
		li		$v0, 1
		move	$a0, $s0
		syscall								#  Print the parameter.
		
		li		$v0, 4
		la		$a0, text2
		syscall								#  Print " are "

		#  For loop
		move	$t0, $s0					#  Initialize the max counter
		li		$t1, 2						#  Initialize the iterator
		
for:	beq		$t0, $t1, endfor			#  If the iterator reaches the entered number, then we're finished
		div		$t0, $t1					#  Divide the number by the iterator
		mfhi	$t2							#  Get the remainder
		
		bne		$t2, $zero, no				#  If the remainder is not zero, then continue
		
		mflo	$t0							#  Store the result of the division as the new number to factor
		
		#  Print the successful divisor
		li		$v0, 1
		move	$a0, $t1
		syscall								#  Print the discovered divisor.
		
		li		$v0, 4
		la		$a0, text3
		syscall								#  Print a separator.
		
		#  Do not increment the potential factor, simply check again.
		j		for
		
		#  If $t1 is not a factor of our number, increment $t1 and try again
no:		addi	$t1, $t1, 1
		j		for
		
		
endfor:	#  The number remaining in $t0 is also a factor.
		li		$v0, 1
		move	$a0, $t0
		syscall								#  Print the last divisor.
		
		li		$v0, 4
		la		$a0, text4
		syscall								#  Print an endline character.
		
		j		loop						#  Go back to the beginning and start again.
		
		
		
quit:	#  When finished, terminate cleanly
		li		$v0, 10
		syscall
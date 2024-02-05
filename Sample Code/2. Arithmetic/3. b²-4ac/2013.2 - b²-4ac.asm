main:	
		
		#  Read the first integer and put it in $s0.
		.data
str1:	.asciiz "Enter a:  "
		.text
		li		$v0, 4					#  Print a string to the console
		la		$a0, str1				#  Print "Enter a:  "
		syscall
		
		li		$v0, 5					#  Read an integer from the console
		syscall
		move	$s0, $v0				#  Store it in $s0
		
		#  Read the second integer and put it in $s1.
		.data
str2:	.asciiz "Enter b:  "
		.text
		li		$v0, 4					#  Print a string to the console
		la		$a0, str2				#  Print "Enter b:  "
		syscall
		
		li		$v0, 5					#  Read an integer from the console
		syscall
		move	$s1, $v0				#  Store it in $s1
		
		#  Read the third integer and put it in $s2.
		.data
str3:	.asciiz "Enter c:  "
		.text
		li		$v0, 4					#  Print a string to the console
		la		$a0, str3				#  Print "Enter c:  "
		syscall
		
		li		$v0, 5					#  Read an integer from the console
		syscall
		move	$s2, $v0				#  Store it in $s2
		
		#  Calculate b^2-4ac
		mul		$t0, $s1, $s1			#  $t0 = $s1 * $s1		($t0 = b^2)
		mul		$t1, $s0, $s2			#  $t1 = $s0 * $s2		($t1 = ac)
		sll		$t1, $t1, 2				#  $t1 = $t1 * 4		($t1 = 4ac)
		sub		$t2, $t0, $t1			#  $t2 = $t0 - $t1		($t2 = b^2-4ac)
		
		#  Print the result
		.data
str4:	.asciiz	"The result is "
str5:	.asciiz	".\n"
		.text
		li		$v0, 4					#  Print a string to the console
		la		$a0, str4				#  Print "The result is "
		syscall
		
		li		$v0, 1					#  Print an integer to the console
		move	$a0, $t2				#  Print b^2-4ac
		syscall
		
		li		$v0, 4					#  Print a string to the console
		la		$a0, str5				#  Print ".\n"
		syscall
		
		#  Quit
		li		$v0, 10					#  Quit
		syscall
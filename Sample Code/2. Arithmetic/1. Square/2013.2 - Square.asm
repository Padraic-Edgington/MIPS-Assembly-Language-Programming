main:	
		
		#  Read the integer and put it in $s0.
		.data
str1:	.asciiz "Enter a number:  "
		.text
		li	 	$v0, 4						#  Load 4 into $v0 as the main parameter for syscall.
		la 		$a0, str1					#  Put the address of str1 in $a0.
		syscall								#  Syscall #4 prints the string referenced in $a0.
		
		li 		$v0, 5						#  Load 5 into $v0 as the main parameter for syscall.
		syscall								#  Syscall #5 reads an integer from the console and copies it into $v0.
		move 	$s0, $v0					#  Copy the integer from $v0 to $s0.
		
		#  Calculate $t0 = $s0 * $s0.
		mul		$t0, $s0, $s0				#  Multiply $s0 by $s0 and store in $t0.
		
		#  Display the results.
		.data
str2:	.asciiz	" squared is "
str3:	.asciiz ".\n"
		.text
		li		$v0, 1						#  Load 1 into $v0 as the main parameter for syscall.
		move	$a0, $s0					#  Copy the initial parameter into $a0.
		syscall								#  Syscall #1 prints the integer in $a0 to the console.
		
		li		$v0, 4						#  Load 4 into $v0 as the main parameter for syscall.
		la		$a0, str2					#  Put the address of str2 in $a0.
		syscall								#  Syscall #4 prints the string referenced in $a0.
		
		li		$v0, 1						#  Load 1 into $v0 as the main parameter for syscall.
		move	$a0, $t0					#  Copy the result into $a0.
		syscall								#  Syscall #1 prints the integer in $a0 to the console.
		
		li		$v0, 4						#  Load 4 into $v0 as the main parameter for syscall.
		la		$a0, str3					#  Put the address of str3 in $a0.
		syscall								#  Syscall #4 prints the string referenced in $a0.
		
		li		$v0, 10						#  Load 10 into $v0 as the main parameter for syscall.
		syscall								#  Syscall #10 exits the program.
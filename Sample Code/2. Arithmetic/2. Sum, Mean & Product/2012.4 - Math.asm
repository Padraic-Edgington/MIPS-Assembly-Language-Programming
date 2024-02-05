main:	
		
		#  Read the first integer and put it in $s0.
		.data
str1:	.asciiz "Enter an integer:  "
		.text
		li $v0, 4						#  Put 4 into $v0 as the main parameter for syscall.
		la $a0, str1					#  Put the address of str1 into $a0.
		syscall							#  Syscall #4 prints the string at the address given in $a0.
		
		li $v0, 5						#  Put 5 into $v0 as the main paramter for syscall.
		syscall							#  Syscall #5 reads an integer from the console and stores it in $v0.
		move $s0, $v0					#  Copy the read integer to $s0.
		
		#  Read the second integer and put it in $s1.
		.data
str2:	.asciiz "Enter a second integer:  "
		.text
		li $v0, 4						#  Put 4 into $v0 as the main parameter for syscall.
		la $a0, str2					#  Put the address of str2 into $a0.
		syscall							#  Syscall #4 prints the string at the address given in $a0.
		
		li $v0, 5						#  Put 5 into $v0 as the main parameter for syscall.
		syscall							#  Syscall #5 reads an integer from the console and stores it in $v0.
		move $s1, $v0					#  Copy the read integer to $s1.
		
		#  Read the third integer and put it in $s2.
		.data
str3:	.asciiz "Enter a third integer:  "
		.text
		li $v0, 4						#  Put 4 into $v0 as the main parameter for syscall.
		la $a0, str3					#  Put the address of str3 into $a0.
		syscall							#  Syscall #4 prints the string at the address given in $a0.
		
		li $v0, 5						#  Put 5 into $v0 as the main parameter for syscall.
		syscall							#  Syscall #5 reads an integer from the consol and stores it in $v0.
		move $s2, $v0					#  Copy the read integer to $s2.
		
		#  Calculate $t0 = $s0 + $s1 + $s2.
		add $t0, $s0, $s1				#  Calculate $s0 + $s1 and store in $t0.
		add $t0, $t0, $s2				#  Calculate $s0 + $s1 ($t0) + $s2 and store in $t0.
		
		#  Print the sum.
		.data
str4:	.asciiz "\nThe sum of the numbers is "
		.text
		li $v0, 4						#  Put 4 into $v0 as the main parameter for syscall.
		la $a0, str4					#  Put the address of str4 into $a0.
		syscall							#  Syscall #4 prints the string at the address given in $a0.
		li $v0, 1						#  Put 1 into $v0 as the main parameter for syscall.
		move $a0, $t0					#  Copy the summation into $a0.
		syscall							#  Syscall #1 prints the integer given in $a0.
		.data
str5:	.asciiz ".\n"
		.text
		li $v0, 4						#  Put 4 into $v0 as the main parameter for syscall.
		la $a0, str5					#  Put the address of str5 into $a0.
		syscall							#  Syscall #4 prints the string at the address given in $a0.
		
		#  Calculate $t0 = ($s0 + $s1 + $s2) / 3.
		li $t1, 3						#  Put the immediate 3 into $t1.
		div $t2, $t0, $t1				#  Divide the summation ($t0) by 3 ($t1) and store the result in $t2.
		
		#  Print the mean.
		.data
str6:	.asciiz "The mean of the numbers is "
		.text
		li $v0, 4						#  Put 4 into $v0 as the main parameter for syscall.
		la $a0, str6					#  Put the address of str6 into $a0.
		syscall							#  Syscall #4 prints the string at the address given in $a0.
		li $v0, 1						#  Put 1 into $v0 as the main parameter for syscall.
		move $a0, $t2					#  Copy the results of the division from $t2 into $a0.
		syscall							#  Syscall #1 prints the integer given in $a0.
		li $v0, 4						#  Put 4 into $v0 as the main parameter for syscall.
		la $a0, str5					#  Put the address of str5 into $a0.
		syscall							#  Syscall #4 prints the string at the address given in $a0.
		
		#  Calculate $t0 = $s0 * $s1 * $s2.
		mul $t0, $s0, $s1				#  Multiply $s0 by $s1 and store the result in $t0.
		mul $t2, $t0, $s2				#  Multiply $t0 ($s0 x $s1) by $s2 and store the result in $t2.
		
		#  Print the product
		.data
str7:	.asciiz "The product of the numbers is "
		.text
		li $v0,4						#  Put 4 into $v0 as the main parameter for syscall.
		la $a0, str7					#  Put the address of str7 into $a0.
		syscall							#  Syscall #4 prints the string at the address given in $a0.
		li $v0, 1						#  Put 1 into $v0 as the main parameter for syscall.
		move $a0, $t2					#  Copy the results of the multiplication into $a0.
		syscall							#  Syscall #1 prints the integer given in $a0.
		li $v0, 4						#  Put 4 into $v0 as the main parameter for syscall.
		la $a0, str5					#  Put the address of str5 into $a0.
		syscall							#  Syscall #4 prints the string at the address given in $a0.
		
		#  Exit
		li $v0, 10						#  Put 10 into $v0 as the main parameter for syscall.
		syscall							#  Syscall #10 exits the program.
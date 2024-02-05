		.data
Q1:		.asciiz	"Enter the principal:  $"
Q1a:	.asciiz	"Enter the principal or 0 to quit:  "
Q2:		.asciiz	"Enter the interest rate:  "
Q3:		.asciiz	"Enter the amount of time:  "
R1:		.asciiz	"The ending balance is $"
R2:		.asciiz	"."
R3:		.asciiz	"\n\n"
		.text

		#  Query for initial principal.
main:	li		$v0, 4				#  Print a string.
		la		$a0, Q1				#  Print Q1.
		syscall						#  Print Q1 to the console.
		
		li		$v0, 5				#  Read an integer from the console.
		syscall						#  Read an integer from the console and save it in $v0.
		move	$s0, $v0			#  $s0 = p
		
		#  Start of a do-while loop.
		#  Query for the interest rate.
loop:	li		$v0, 4				#  Print a string.
		la		$a0, Q2				#  Print Q2.
		syscall						#  Print Q2 to the console.
		
		li		$v0, 5				#  Read an integer from the console.
		syscall						#  Read an integer from the console and save it in $v0.
		move	$s1, $v0			#  $s1 = r
		
		#  Query for the time.
		li		$v0, 4				#  Print a string.
		la		$a0, Q3				#  Print Q3.
		syscall						#  Print Q3 to the console.
		
		li		$v0, 5				#  Read an integer from the console.
		syscall						#  Read an integer from the console and save it in $v0.
		move	$s2, $v0			#  $s2 = t
		
		#  $s0 = p
		#  $s1 = r
		#  $s2 = t
		#  Compute the resulting balance.
		li		$t0, 100
		add		$s1, $s1, $t0		#  $s1 = 100 + r	:: Our kludge to make up for not using floating-point numbers.
		mul		$t1, $s0, $t0		#  $t1 = principal ¢
		
		li		$t2, 0				#  for ( int i = 0;
for:	beq		$t2, $s2, endfor	#    i < t;
		addi	$t2, $t2, 1			#    i++ )
		
		mul		$t1, $t1, $s1		#  p¢ * 100
		div		$t1, $t1, $t0		#  p¢
		
		j		for					#  Repeat the loop if needed.
endfor:	div		$t1, $t0			#  Convert from ¢ to $ and ¢.
		mflo	$s4					#  balance $
		mfhi	$s5					#  balance ¢
		
		
		#  $s0 = p
		#  $s1 = r+100
		#  $s2 = t
		#  $s3 = floor(b)
		#  $HI = rem(b)
		#  Print the results
		li		$v0, 4				#  Print a string.
		la		$a0, R1				#  Print R1.
		syscall						#  Print R1 to the console.
		
		li		$v0, 1				#  Print an integer.
		move	$a0, $s4			#  Copy the whole number part of the balance to $a0.
		syscall						#  Print the whole number part of the balance.
		
		li		$v0, 4				#  Print a string.
		la		$a0, R2				#  Print R2.
		syscall						#  Print R2 to the console.
		
		li		$t9, 10
		bge		$s5, $t9, lotsofcents
		li		$v0, 1
		move	$a0, $zero
		syscall

lotsofcents:		
		li		$v0, 1				#  Print an integer.
		move	$a0, $s5			#  Copy the fraction part of the balance to $a0.
		syscall						#  Print the fraction part of the balance.
		
		li		$v0, 4				#  Print a string.
		la		$a0, R3				#  Print R3.
		syscall						#  Print R3 to the console.
		
		
		#  Query for a new principal.
		li		$v0, 4				#  Print a string.
		la		$a0, Q1a			#  Print Q1a.
		syscall						#  Print Q1a to the console.
		
		li		$v0, 5				#  Read an integer.
		syscall						#  Read an integer from the console and store it in $v0.
		move	$s0, $v0			#  $s0 = p
		
		bne		$s0, $zero, loop	#  Repeat the calculations if the principal isn't 0.
		
		#  Since the principal is 0, exit the program.
		li		$v0, 10				#  Exit.
		syscall						#  Syscall #10 exits the program.
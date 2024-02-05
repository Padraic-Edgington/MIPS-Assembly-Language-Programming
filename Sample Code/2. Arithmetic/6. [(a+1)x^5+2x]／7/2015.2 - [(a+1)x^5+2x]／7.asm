		.data
Q1:		.asciiz	"Enter a value for a:  "
Q2:		.asciiz	"Enter a value for x:  "
R1:		.asciiz	"y="
R2:		.asciiz	" R"
R3:		.asciiz	".\n"
		.text

		#  Request the first integer (a).
main:	li		$v0, 4				#  Put 4 into $v0 as the main parameter for syscall.
		la		$a0, Q1				#  Address of query string #1.
		syscall						#  Syscall #4 prints the string at Q1.
		
		li		$v0, 5				#  Put 5 into $v0 as the main parameter for syscall.
		syscall						#  Syscall #5 reads an integer from the console and stores it in $v0.
		move	$s0, $v0			#  Copy the read integer to $s0.
		
		#  Request the second integer (x).
		li		$v0, 4				#  Put 4 into $v0 as the main parameter for syscall.
		la		$a0, Q2				#  Address of query string #2.
		syscall						#  Syscall #4 prints the string at Q2.
		
		li		$v0, 5				#  Put 5 into $v0 as the main parameter for syscall.
		syscall						#  Syscall #5 reads an integer from the console and stores it in $v0.
		move	$s1, $v0			#  Copy the read integer to $s1.
		
		#  $s0 = a
		#  $s1 = x
		#  Calculate y(a, x).
		#  Calculate the numerator:  (a+1)x^5+2x.
		add		$t1, $s1, $s1		#  $t1 = x+x
		addi	$t0, $s0, 1			#  $t0 = a+1
		mul		$t2, $s1, $s1		#  $t2 = x * x
		mul		$t2, $t2, $t2		#  $t2 = x^2 * x^2
		mul		$t0, $t2, $s1		#  $t0 = x^4 * x
		addi	$t2, $s0, 1			#  $t2 = a + 1
		mul		$t0, $t2, $t0		#  $t0 = (a+1) * x^5
		add		$t0, $t0, $t1		#  $t0 = (a+1)x^5 + 2x
		
		#  Divide by the denominator:  7
		li		$t1, 7				#  $t1 = 7
		div		$t0, $t1			#  ((a+1)^5 + 2x) / 7
		mflo	$t0					#  Copy the quotient to $t0.
		mfhi	$t1					#  Copy the remainder to $t1.
		
		#  Print the results to the console.
		li		$v0, 4				#  Put 4 into $v0 as the main parameter for syscall.
		la		$a0, R1				#  Address of result string #1.
		syscall						#  Syscall #4 prints the string found at the address in $a0
		
		li		$v0, 1				#  Put 1 into $v0 as the main parameter for syscall.
		move	$a0, $t0			#  Copy the quotient to $a0.
		syscall						#  Syscall #1 prints the integer in $a0.
		
		li		$v0, 4				#  Put 4 into $v0 as the main parameter for syscall.
		la		$a0, R2				#  Address of result string #2.
		syscall						#  Sycall #4 prints the string found at the address in $a0.
		
		li		$v0, 1				#  Put 1 into $v0 as the main parameter for syscall.
		move	$a0, $t1			#  Copy the remainder to $a0.
		syscall						#  Syscall #1 prints the integer in $a0.
		
		li		$v0, 4				#  Put 4 into $v0 as the main parameter for syscall.
		la		$a0, R3				#  Address of result string #3.
		syscall						#  Sycall #4 prints the string found at the address in $a0.
		
		#  Exit the program
		li		$v0, 10				#  Put 10 into $v0 as the main parameter for syscall.
		syscall						#  Syscall #10 exits the program.
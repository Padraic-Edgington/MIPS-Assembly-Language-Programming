		.data
q:		.asciiz	"Enter an integer:  "
r:		.asciiz	"! = "
nl:		.asciiz	"\n"
		.text
		
		#  Query for an integer.
main:	li		$v0, 4
		la		$a0, q
		syscall
		
		li		$v0, 5
		syscall
		move	$t0, $v0			#  The requested integer is in $t0.
		
		
		#  for (int i = 1, x = 1; i <= n; i++)
		#		x *= i;
		
		li		$t2, 1				#  Counter
		li		$t1, 1				#  Result
		
loop:	bgt		$t2, $t0, endLoop
		
		mul		$t1, $t1, $t2
		
		addi	$t2, $t2, 1
		j		loop

endLoop:		
		
		#  Display the results of the computation.
		li		$v0, 1
		move	$a0, $t0
		syscall
		
		li		$v0, 4
		la		$a0, r
		syscall
		
		li		$v0, 1
		move	$a0, $t1
		syscall
		
		li		$v0, 4
		la		$a0, nl
		syscall
		
		li		$v0, 10
		syscall
		
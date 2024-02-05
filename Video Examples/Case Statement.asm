main:
		li		$t0, -1
		li		$t1, 0
		#  case (i) {
		#		0:			print "Zero"
		#		1:			print "One"
		#		2:			print "Two"
		#		default:	print "Default"
		#  }
		.data
zero_string:	.asciiz	"Zero\n"
one_string:		.asciiz	"One\n"
two_string:		.asciiz	"Two\n"
default_string:	.asciiz	"Default\n"
		.text
		
		beq		$t0, $zero, zero
		li		$t9, 1
		beq		$t0, $t9, one
		li		$t9, 2
		beq		$t0, $t9, two
		j		default
		
zero:	li		$v0, 4
		la		$a0, zero_string
		syscall
		j		end_case
		
one:	li		$v0, 4
		la		$a0, one_string
		syscall
		j		end_case
		
two:	li		$v0, 4
		la		$a0, two_string
		syscall
		j		end_case
		
default:
		li		$v0, 4
		la		$a0, default_string
		syscall
		j		end_case
		
		
		
		
		
		
		
end_case:
		
		li		$t0, 0
		li		$t1, 1
		
		#  if ($t0 = $t1)
		#		print "Hello"
		#  else
		#		print "world!"
		beq		$t0, $t1, if
		j		else
		
if:		.data
Hello:	.asciiz	"Hello\n"
		.text
		li		$v0, 4
		la		$a0, Hello
		syscall
		
		j		end_if
		
else:	.data
world:	.asciiz	"world!"
		.text
		li		$v0, 4
		la		$a0, world
		syscall
		
end_if:
		
		
		
		
		
		
		li		$v0, 10
		syscall
main:

		li		$t0, 1
		li		$t1, 0
		#  if ($t0 = $t1)
		#		print "Hello"
		#  print "world!"
		.data
Hello:	.asciiz	"Hello "
world:	.asciiz	"world!\n"
		.text
		bne		$t0, $t1, print_world
		
		li		$v0, 4
		la		$a0, Hello
		syscall
		
print_world:	
		li		$v0, 4
		la		$a0, world
		syscall
		
		
		
		#  if ($t0 != $t1)
		#		print "Hello"
		#  print "world!"
		beq		$t0, $t1, end_if
		
		li		$v0, 4
		la		$a0, Hello
		syscall
		
end_if:		
		li		$v0, 4
		la		$a0, world
		syscall
		
		
		#  if ($t0 < $t1)
		#		print "If"
		#	else
		#		print "Else"
		.data
if:		.asciiz	"If\n"
else:	.asciiz	"Else\n"
		.text
		bge		$t0, $t1, else1
		
		la		$a0, if
		syscall
		
		j		end_else
else1:		
		
		la		$a0, else
		syscall
		
end_else:
		
		#  if ($t0 <= $t1)
		#		print "If 2"
		#	else
		#		print "Else 2"
		.data
if2:	.asciiz	"If 2\n"
else2:	.asciiz	"Else 2\n"
		.text
		bgt		$t0, $t1, else3
		
		la		$a0, if2
		syscall
		
		j		end_else2
else3:
		
		la		$a0, else2
		syscall

end_else2:
		
		
		#  if ($t0 > $t1)
		#		print "Greater"
		#  else
		#		print "Not greater"
		.data
g:		.asciiz	"Greater\n"
ng:		.asciiz	"Not greater\n"
		.text
		ble		$t0, $t1, else4
		
		la		$a0, g
		syscall
		j		end_else3
		
else4:	la		$a0, ng
		syscall
		
end_else3:
		
		
		
		
		
		
		#  if ($t0 >= $t1)
		#		print "Greater or equal"
		#  else
		#		print "Not greater or equal"
		.data
ge:		.asciiz	"Greater or equal\n"
nge:	.asciiz	"Not greater or equal\n"
		.text
		blt		$t0, $t1, else5
		
		la		$a0, ge
		syscall
		j		end_else4
		
else5:	la		$a0, nge
		syscall
		
end_else4:
		
		
		
		
		li		$v0, 10
		syscall
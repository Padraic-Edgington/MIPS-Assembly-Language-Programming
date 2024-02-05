#######################
#  Tower of Hanoi     #
#  Padraic Edgington  #
#  January 31, 2013   #
#######################
main:
#  Query the user for a size for the stack of disks.
		.data
query:	.asciiz	"How many disks need to be moved?  "
		.text
start:	li		$v0, 4
		la		$a0, query
		syscall
		
		li		$v0, 5
		syscall
		move	$s0, $v0
		
		slt		$t0, $zero, $s0	#  If the number is less than one then quit
		beq		$t0, $zero, exit
		beq		$s0, $zero, exit
		
#  Call the tower function to solve the problem recursively.
		move	$a0, $s0		#  # of disks
		li		$a1, 1			#  Origin is peg #1
		li		$a2, 3			#  Destination is peg #3
		li		$a3, 2			#  Temporary holding area is peg #2
		jal		Tower			#  Call the Tower of Hanoi function
		
		j		start			#  Ask for another round
		
exit:	li		$v0, 10
		syscall					#  Quit gracefully
		
		
		#  The Tower of Hanoi function
		#  $a0:  # of disks
		#  $a1:  Origin peg
		#  $a2:  Destination peg
		#  $a3:  Temporary holding peg
		#######################################################################
Tower:	
		#  Check for termination condition
		li		$t0, 1
		bne		$a0, $t0, TowerRecursion
		
		.data
arrow:	.asciiz	" -> "
nl:		.asciiz "\n"
		.text
		li		$v0, 1
		move	$a0, $a1
		syscall					#  Print the origin peg
		
		li		$v0, 4
		la		$a0, arrow
		syscall					#  Print the arrow
		
		li		$v0, 1
		move	$a0, $a2
		syscall					#  Print the destination peg
		
		li		$v0, 4
		la		$a0, nl
		syscall					#  Print the new line character
		
		jr		$ra

TowerRecursion:
		#  Save our parameters and return address
		addi	$sp, $sp, -20
		sw		$ra, 16 ($sp)
		sw		$a0, 12 ($sp)
		sw		$a1,  8 ($sp)
		sw		$a2,  4 ($sp)
		sw		$a3,  0 ($sp)
		
		#  Call the Tower function with one less disk and swap the holding and
		#  destination pegs
		
		addi	$a0, $a0, -1	#  Disks -1
		xor		$a3, $a2, $a3
		xor		$a2, $a2, $a3
		xor		$a3, $a2, $a3	#  Swap the values in $a2 and $a3
		jal		Tower			#  Call the Tower function
		
		
		#  Now that the origin and destination are clear, move the remaining
		#  disk
		lw		$a1,  8 ($sp)	#  Restore the origin peg
		lw		$a2,  4 ($sp)	#  Restore the destination peg
		
		li		$v0, 1
		move	$a0, $a1
		syscall					#  Print the origin peg
		
		li		$v0, 4
		la		$a0, arrow
		syscall					#  Print the arrow
		
		li		$v0, 1
		move	$a0, $a2
		syscall					#  Print the destination peg
		
		li		$v0, 4
		la		$a0, nl
		syscall					#  Print the new line character
		
		#  Finally, use the Tower function to move the rest of the stack from
		#  the temporary holding peg to the destination peg using the origin
		#  peg as the temporary holding peg
		lw		$a0, 12 ($sp)	#  Restore the number of disks
		lw		$a3,  0 ($sp)	#  Restore the temporary holding peg
		
		addi	$a0, $a0, -1	#  Disks -1
		xor		$a1, $a1, $a3
		xor		$a3, $a1, $a3
		xor		$a1, $a1, $a3	#  Swap the values in $a1 and $a3
		jal		Tower
		
		#  Clean up our function and return
		lw		$ra, 16 ($sp)
		addi	$sp, $sp, 20
		jr		$ra
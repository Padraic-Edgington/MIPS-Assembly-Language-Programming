#  Recursive merge sort program

##########################
#  Merge sort procedure  #
##########################

#  Merge sort requires two parameters:
#  $a0:  A pointer to an array.
#  $a1:  The length of the array.
#  Merge sort computes and stores four variables
#  $s0:  The length of the left sub-array
#  $s1:  The length of the right sub-array
#  $s2:  The address of the left sub-array ($fp-36)
#  $s3:  The address of the right sub-array

		.text
mergesort:	
	#  If (length == 1), then the array is already sorted.
		addi	$t0, $a1, -1	#  $t0 = length - 1
		bne		$t0, $0, sort	#  Check if $t0==0
		jr		$ra				#  length==0 => return

	#  Else, divide the array into two parts and call merge sort on them.
sort:
		#  Save existing registers on the stack.
		move	$t0, $fp		#  Make a temporary frame pointer
		move	$fp, $sp		#  Set the frame pointer
		addi	$sp, $sp, -32	#  Make room on the stack for 8 integers
		sw		$t0, -4 ($fp)	#  Store the old frame pointer in position 1
		sw		$ra, -8 ($fp)	#  Store existing $ra in position 2
		sw		$a0, -12 ($fp)	#  Store the pointer to our array in position 3
		sw		$a1, -16 ($fp)	#  Store the length of our array in position 4
		sw		$s0, -20 ($fp)	#  Store existing $s0 in position 5
		sw		$s1, -24 ($fp)	#  Store existing $s1 in position 6
		sw		$s2, -28 ($fp)	#  Store existing $s2 in position 7
		sw		$s3, -32 ($fp)	#  Store existing $s3 in position 8
		
		#  Calculate the size of both halves of our array.
		li		$t0, 2			#  Store 2 in $t0...
		div		$a1, $t0		#  length / 2
		mflo	$s0				#  left size ($s0) = floor(length / 2)
		sub		$s1, $a1, $s0	#  right size ($s1) = length - $s0
		addi	$s2, $fp, -36	#  left array pointer ($s2) is always at position 9
		li		$t9, 4			#  Store -4 in $t9...
		mult	$s0, $t9		#  Left size * -4
		mflo	$t1				#  $t1 = left * -4 (the offset to the right array)
		add		$s3, $s2, $t1	#  right array pointer ($s3) = left pointer + left size *-4
		
		#  Copy the two sub-arrays onto the stack.
		mult	$a1, $t9		#  length * -4
		mflo	$t0				#  stack offset = length * -4
		add		$sp, $sp, $t0	#  Make room on the stack for the two arrays
		addi	$t0, $fp, -32	#  output counter (initialize to first position + 4)
		addi	$t1, $a0, 4		#  input counter  (initialize to first position + 4)
		#  Do...
copy:	addi	$t0, $t0, -4	#  Increment output counter
		addi	$t1, $t1, -4	#  Increment input counter
		lw		$t2, 0 ($t1)	#  Read array element from stack
		sw		$t2, 0 ($t0)	#  Store array element on stack
		
		#  While (output counter > stack pointer)
		bne		$sp, $t0, copy	#  If $t0 != $sp, then copy another element.
		
		#  Call merge sort on the left array.
		or		$a0, $s2, $0	#  Copy the address of the left array into arg1.
		or		$a1, $s0, $0	#  Copy the length of the left array into arg2.
		jal		mergesort		#  Call merge sort
		
		#  Call merge sort on the right array.
		move	$a0, $s3		#  Copy the address of the right array into arg1.
		move	$a1, $s1		#  Copy the length of the right array into arg2.
		jal		mergesort		#  Call merge sort

		lw		$a0, -12 ($fp)	#  Restore the pointer to our array
		lw		$a1, -16 ($fp)	#  Restore the length of our array
		
	#  Recombine the two sub-arrays, element by element
		move	$t0, $a0		#  Pointer to the next element in the output array
		move	$t1, $s2		#  Pointer to the next element in the left array
		move	$t2, $s3		#  Pointer to the next element in the right array
		li		$t9, -4			#  Store -4 in $t9
		mult	$a1, $t9		#  length * -4
		mflo	$t3				#  $t3 = length * -4
		add		$t3, $a0, $t3	#  Calculate the last address of the output array
		addi	$t4, $sp, -4	#  Calculate the last address of the right array
		
		#  The main merge loop
merge:	beq		$t0, $t3, done	#  If complete, jump to done
		beq		$t1, $s3, right	#  If the left array is empty, copy from the right array
		beq		$t2, $t4, left	#  If the right array is empty, copy from the left array
		
		lw		$t5, 0 ($t1)	#  Put the next element from the left array in $t4
		lw		$t6, 0 ($t2)	#  Put the next element from the right array in $t5
		slt		$t7, $t5, $t6	#  If left[i] < right[i], $t6 = 1, else $6 = 0
		beq		$t7, $0, right	#  If left[i] >= right[i], copy from the right array
	
		#  Copy from the left array
left:	lw		$t5, 0 ($t1)	#  Copy the next element in the left array into a register
		sw		$t5, 0 ($t0)	#  Copy that element into the output array
		add		$t0, $t0, $t9	#  Increment the output pointer
		add		$t1, $t1, $t9	#  Increment the left pointer
		j		merge			#  Go back to the beginning of the loop
		
		#  Copy from the right array
right:	lw		$t5, 0 ($t2)	#  Copy the next element in the right array into a register
		sw		$t5, 0 ($t0)	#  Copy that element into the output array
		add		$t0, $t0, $t9	#  Increment the output pointer
		add		$t2, $t2, $t9	#  Increment the right pointer
		j		merge			#  Go back to the beginning of the loop
		
	#  When finished merging the arrays restore all the registers we used.
done:	move	$sp, $fp		#  Pop the stack
		lw		$s3, -32 ($fp)	#  Restore previous $s3
		lw		$s2, -28 ($fp)	#  Restore previous $s2
		lw		$s1, -24 ($fp)	#  Restore previous $s1
		lw		$s0, -20 ($fp)	#  Restore previous $s0
		lw		$ra, -8 ($fp)	#  Restore the return address
		lw		$fp, -4 ($fp)	#  Restore the frame pointer

		jr		$ra				#  Return to caller




###################
#  MAIN FUNCTION  #
###################
main:	.data
q1:		.asciiz	"Enter an integer:  "
q2:		.asciiz	"Enter an integer (or 0 to stop):  "
r1:		.asciiz	"The sorted list is {"
r2:		.asciiz	", "
r3:		.asciiz	"}.\n"
		.text
		
	#  Query the user for a list of integers to sort
		#  The user must enter at least one integer...
		li		$v0, 4
		la		$a0, q1
		syscall					#  Print string q1
		li		$v0, 5
		syscall					#  Read an integer
		move	$fp, $sp		#  Set the frame pointer
		addi	$sp, $sp, -4	#  Increment the stack pointer
		li		$s0, 1			#  Define a counter for the array
		sw		$v0, 0 ($sp)	#  Copy the integer onto the stack
		
		#  The user can enter additional integers
loop:	li		$v0, 4
		la		$a0, q2
		syscall					#  Print string q2
		li		$v0, 5
		syscall					#  Read an integer
		beq		$v0, $0, quit	#  If the user enters 0, then quit
		addi	$sp, $sp, -4	#  Increment the stack pointer
		addi	$s0, $s0, 1		#  Increment the array counter
		sw		$v0, 0 ($sp)	#  Copy the integer onto the stack
		j		loop			#  Look for another integer
	
	#  When finished entering numbers...
quit:
	#  Call merge sort to sort the array
		addi	$a0, $fp, -4	#  The array starts at the first place on our stack
		move	$a1, $s0		#  Copy the number of elements into #a1
		jal		mergesort		#  Run merge sort
		
	#  Print out the results
		li		$v0, 4
		la		$a0, r1
		syscall					#  Print string r1
		addi	$t0, $fp, -4	#  Set a pointer for the array
		li		$t1, 0			#  Set an iterator
		
print:	li		$v0, 1
		lw		$a0, 0 ($t0)
		syscall					#  Print the indicated element
		
		addi	$t0, $t0, -4	#  Increment the array pointer
		addi	$t1, $t1, 1		#  Increment the iterator
		slt		$t2, $t1, $s0	#  If iterator < length, $t2 = 1, else $t2 = 0
		beq		$t2, $0, finish	#  Finish printing once we've run out of elements
		
		li		$v0, 4
		la		$a0, r2
		syscall					#  Print string r2
		j		print
		
finish:	li		$v0, 4
		la		$a0, r3
		syscall					#  Print string r3
		
		li		$v0, 10
		syscall					#  Exit
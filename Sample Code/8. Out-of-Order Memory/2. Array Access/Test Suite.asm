


#############################################################################################
#                               	Array Access Test Suite									#
#																							#
#  Padraic Edgington                                                          4 Apr, 2015	#
#																							#
#																							#
#  v. 1		Initial release  (It appears to work.)											#
#  v. 1.1	Dynamically calculate the length for test #125.									#
#############################################################################################

main:	addi	$sp, $sp, -4		#  Make space for $ra on stack
		sw		$ra, 0 ($sp)		#  Store the return address on the stack
		
#############################################################################################
#									Functionality Tests										#
		li		$v0, 4
		la		$a0, t1
		syscall
#############################################################################################
		#  Test #1
		#  Read from a one element array.
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d1				#  Array
		li		$a1, 0				#  Element #
		jal		get
		
		move	$a0, $v0			#  Result
		la		$a1, 42				#  Expected result
		li		$a2, 1				#  Test #1
		la		$a3, c1				#  Description of test
		jal		assertEqualInteger	#  Check for equality
		.data
d1:		.word	1, 42
c1:		.asciiz	"Testing the read function for a single element array."
		.text
		
		
		#  Test #2
		#  Read from a 2 element array.
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d2				#  Array
		li		$a1, 0				#  Element #
		jal		get
		
		move	$a0, $v0			#  Result
		la		$a1, 17				#  Expected result
		li		$a2, 2				#  Test #2
		la		$a3, c2				#  Description of test
		jal		assertEqualInteger	#  Check for equality
		.data
d2:		.word	2, 17, 97
c2:		.asciiz	"Testing the read function for a 2 element array."
		.text
		
		
		#  Test #3
		#  Read the second element from a 2 element array.
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d2				#  Array
		li		$a1, 1				#  Element #
		jal		get
		
		move	$a0, $v0			#  Result
		la		$a1, 97				#  Expected result
		li		$a2, 3				#  Test #3
		la		$a3, c3				#  Description of test
		jal		assertEqualInteger	#  Check for equality
		.data
c3:		.asciiz	"Testing the read function for the second element of a 2 element array."
		.text
		
		
		#  Test #4
		#  Repeat to make sure nothing was changed.
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d2				#  Array
		li		$a1, 0				#  Element #
		jal		get
		
		move	$a0, $v0			#  Result
		la		$a1, 17				#  Expected result
		li		$a2, 4				#  Test #4
		la		$a3, c4				#  Description of test
		jal		assertEqualInteger	#  Check for equality
		.data
c4:		.asciiz	"Repeating test #2 to make sure nothing changed."
		.text
		
		
		#  Test #5
		#  Repeat to make sure nothing was changed.
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d2				#  Array
		li		$a1, 1				#  Element #
		jal		get
		
		move	$a0, $v0			#  Result
		la		$a1, 97				#  Expected result
		li		$a2, 5				#  Test #5
		la		$a3, c5				#  Description of test
		jal		assertEqualInteger	#  Check for equality
		.data
c5:		.asciiz	"Repeating test #3 to make sure nothing changed."
		.text
		
		
		#  Test #6
		#  Testing with a large array.
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d3				#  Array
		li		$a1, 15				#  Element #
		jal		get
		
		move	$a0, $v0			#  Result
		la		$a1, 7000			#  Expected result
		li		$a2, 6				#  Test #6
		la		$a3, c6				#  Description of test
		jal		assertEqualInteger	#  Check for equality
		.data
d3:		.word	33, 16, 468, 153, 68, 31, 468, 456, 45, 86, 6345, 645, 645, 456, 465, 49, 7000, 16, 38, 375, 837, 168, 36, 3574, 3574, 378, 397, 37, 379, 489, 678, 897, 46, 53
c6:		.asciiz	"Checking the 16th element of a 33 element array."
		.text
		
		
		#  Test #7
		#  Testing with a large array.
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d3				#  Array
		li		$a1, 7				#  Element #
		jal		get
		
		move	$a0, $v0			#  Result
		la		$a1, 45				#  Expected result
		li		$a2, 7				#  Test #7
		la		$a3, c7				#  Description of test
		jal		assertEqualInteger	#  Check for equality
		.data
c7:		.asciiz	"Checking the 8th element of a 33 element array."
		.text
		
		
		#  Test #8
		#  Testing with a large array.
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d3				#  Array
		li		$a1, 32				#  Element #
		jal		get
		
		move	$a0, $v0			#  Result
		la		$a1, 53				#  Expected result
		li		$a2, 8				#  Test #8
		la		$a3, c8				#  Description of test
		jal		assertEqualInteger	#  Check for equality
		.data
c8:		.asciiz	"Checking the 33rd element of a 33 element array."
		.text
		
		
		#  Test #9
		#  Testing with a large array.
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d3				#  Array
		li		$a1, 0				#  Element #
		jal		get
		
		move	$a0, $v0			#  Result
		la		$a1, 16				#  Expected result
		li		$a2, 9				#  Test #9
		la		$a3, c9				#  Description of test
		jal		assertEqualInteger	#  Check for equality
		.data
c9:		.asciiz	"Checking the 1st element of a 33 element array."
		.text
		
		
		#  Test #10
		#  Testing the set function with a single element array.
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d10			#  Array
		li		$a1, 0				#  Element #
		li		$a2, 14				#  New data
		jal		set
		
		la		$a0, d10			#  Result
		la		$a1, r10			#  Expected result
		li		$a2, 10				#  Test #10
		la		$a3, c10			#  Description of test
		jal		assertEqualArray	#  Check for equality
		.data
d10:	.word	1, 42
r10:	.word	1, 14
c10:	.asciiz	"Setting the 1st element of a single element array."
		.text
		
		
		#  Test #11
		#  Testing the set function with a 2 element array.
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d11			#  Array
		li		$a1, 0				#  Element #
		li		$a2, -63			#  New data
		jal		set
		
		la		$a0, d11			#  Result
		la		$a1, r11			#  Expected result
		li		$a2, 11				#  Test #11
		la		$a3, c11			#  Description of test
		jal		assertEqualArray	#  Check for equality
		.data
d11:	.word	2, 5, 34
r11:	.word	2, -63, 34
c11:	.asciiz	"Setting the 1st element of a 2 element array."
		.text
		
		
		#  Test #12
		#  Testing the set function with a 2 element array.
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d11			#  Array
		li		$a1, 1				#  Element #
		li		$a2, 9876			#  New data
		jal		set
		
		la		$a0, d11			#  Result
		la		$a1, r12			#  Expected result
		li		$a2, 12				#  Test #12
		la		$a3, c12			#  Description of test
		jal		assertEqualArray	#  Check for equality
		.data
r12:	.word	2, -63, 9876
c12:	.asciiz	"Setting the 2nd element of a 2 element array."
		.text
		
		
		#  Test #13
		#  Overwriting the new data just to make sure.
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d11			#  Array
		li		$a1, 0				#  Element #
		li		$a2, 45698765		#  New data
		jal		set
		
		la		$a0, d11			#  Result
		la		$a1, r13			#  Expected result
		li		$a2, 13				#  Test #13
		la		$a3, c13			#  Description of test
		jal		assertEqualArray	#  Check for equality
		.data
r13:	.word	2, 45698765, 9876
c13:	.asciiz	"Repeating test #11."
		.text
		
		
		#  Test #14
		#  Overwriting the new data just to make sure.
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d11			#  Array
		li		$a1, 1				#  Element #
		li		$a2, -634876		#  New data
		jal		set
		
		la		$a0, d11			#  Result
		la		$a1, r14			#  Expected result
		li		$a2, 14				#  Test #14
		la		$a3, c14			#  Description of test
		jal		assertEqualArray	#  Check for equality
		.data
r14:	.word	2, 45698765, -634876
c14:	.asciiz	"Repeating test #12."
		.text
		
		
		#  Test #15
		#  Performing a series of "random" operations on the large array.
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d3				#  Array
		li		$a1, 17				#  Element #
		li		$a2, -634876		#  New data
		jal		set
		
		la		$a0, d3				#  Result
		la		$a1, r15			#  Expected result
		li		$a2, 15				#  Test #15
		la		$a3, c15			#  Description of test
		jal		assertEqualArray	#  Check for equality
		.data
r15:	.word	33, 16, 468, 153, 68, 31, 468, 456, 45, 86, 6345, 645, 645, 456, 465, 49, 7000, 16, -634876, 375, 837, 168, 36, 3574, 3574, 378, 397, 37, 379, 489, 678, 897, 46, 53
c15:	.asciiz	"Testing the get and set functions with a large data set."
		.text
		
		
		#  Test #16
		#  Performing a series of "random" operations on the large array.
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d3				#  Array
		li		$a1, 13				#  Element #
		jal		get
		
		move	$a0, $v0			#  Result
		li		$a1, 465			#  Expected result
		li		$a2, 16				#  Test #16
		la		$a3, c15			#  Description of test
		jal		assertEqualInteger	#  Check for equality
		
		
		#  Test #17
		#  Performing a series of "random" operations on the large array.
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d3				#  Array
		li		$a1, 13				#  Element #
		li		$a2, 09234			#  New data
		jal		set
		
		la		$a0, d3				#  Result
		la		$a1, r17			#  Expected result
		li		$a2, 17				#  Test #17
		la		$a3, c15			#  Description of test
		jal		assertEqualArray	#  Check for equality
		.data
r17:	.word	33, 16, 468, 153, 68, 31, 468, 456, 45, 86, 6345, 645, 645, 456, 9234, 49, 7000, 16, -634876, 375, 837, 168, 36, 3574, 3574, 378, 397, 37, 379, 489, 678, 897, 46, 53
		.text
		
		
		#  Test #18
		#  Performing a series of "random" operations on the large array.
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d3				#  Array
		li		$a1, 17				#  Element #
		jal		get
		
		move	$a0, $v0			#  Result
		li		$a1, -634876		#  Expected result
		li		$a2, 18				#  Test #18
		la		$a3, c15			#  Description of test
		jal		assertEqualInteger	#  Check for equality
		
		
		#  Test #19
		#  Performing a series of "random" operations on the large array.
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d3				#  Array
		li		$a1, 13				#  Element #
		jal		get
		
		move	$a0, $v0			#  Result
		li		$a1, 9234			#  Expected result
		li		$a2, 19				#  Test #19
		la		$a3, c15			#  Description of test
		jal		assertEqualInteger	#  Check for equality
		
		
		#  Test #20
		#  Performing a series of "random" operations on the large array.
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d3				#  Array
		li		$a1, 32				#  Element #
		li		$a2, -6528			#  New data
		jal		set
		
		la		$a0, d3				#  Result
		la		$a1, r20			#  Expected result
		li		$a2, 20				#  Test #20
		la		$a3, c15			#  Description of test
		jal		assertEqualArray	#  Check for equality
		.data
r20:	.word	33, 16, 468, 153, 68, 31, 468, 456, 45, 86, 6345, 645, 645, 456, 9234, 49, 7000, 16, -634876, 375, 837, 168, 36, 3574, 3574, 378, 397, 37, 379, 489, 678, 897, 46, -6528
		.text
		
		
		#  Test #21
		#  Performing a series of "random" operations on the large array.
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d3				#  Array
		li		$a1, 32				#  Element #
		jal		get
		
		move	$a0, $v0			#  Result
		li		$a1, -6528			#  Expected result
		li		$a2, 20				#  Test #20
		la		$a3, c15			#  Description of test
		jal		assertEqualInteger	#  Check for equality
		
		
		#  Test #22
		#  Performing a series of "random" operations on the large array.
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d3				#  Array
		li		$a1, 0				#  Element #
		li		$a2, 78829			#  New data
		jal		set
		
		la		$a0, d3				#  Result
		la		$a1, r22			#  Expected result
		li		$a2, 22				#  Test #22
		la		$a3, c15			#  Description of test
		jal		assertEqualArray	#  Check for equality
		.data
r22:	.word	33, 78829, 468, 153, 68, 31, 468, 456, 45, 86, 6345, 645, 645, 456, 9234, 49, 7000, 16, -634876, 375, 837, 168, 36, 3574, 3574, 378, 397, 37, 379, 489, 678, 897, 46, -6528
		.text
		
		
		#  Test #23
		#  Performing a series of "random" operations on the large array.
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d3				#  Array
		li		$a1, 0				#  Element #
		jal		get
		
		move	$a0, $v0			#  Result
		li		$a1, 78829			#  Expected result
		li		$a2, 23				#  Test #23
		la		$a3, c15			#  Description of test
		jal		assertEqualInteger	#  Check for equality
		
		
#		j		Skip_Parameter_Validation_Tests		
		
		
		
#############################################################################################
#									Error Checking Tests									#
		li		$v0, 4
		la		$a0, nl
		syscall
		la		$a0, t2
		syscall
#############################################################################################
		#  Test #101
		#  Try to read from a null array.
		#######################################################################
		jal		setSavedRegisters
		li		$a0, 0				#  Array
		li		$a1, 0				#  Element #
		jal		get
		
		move	$a0, $v0			#  Result
		li		$a2, 101			#  Test #101
		la		$a3, c101			#  Description of test
		jal		assertError			#  Check for an error.
		.data
c101:	.asciiz	"Null pointer check. (get)"
		.text
		
		
		#  Test #102
		#  Try to change a null array.
		#######################################################################
		jal		setSavedRegisters
		li		$a0, 0				#  Array
		li		$a1, 0				#  Element #
		li		$a2, 42				#  New data
		jal		set
		
		move	$a0, $v0			#  Result
		li		$a2, 102			#  Test #102
		la		$a3, c102			#  Description of test
		jal		assertError			#  Check for an error
		.data
c102:	.asciiz	"Null pointer check. (set)"
		.text
		
		
		#  Test #103
		#  Array begins outside of memory.
		#######################################################################
		jal		setSavedRegisters
		li		$a0, -40			#  Array
		li		$a1, 0				#  Element #
		jal		get
		
		move	$a0, $v0			#  Result
		li		$a2, 103			#  Test #103
		la		$a3, c103			#  Description of test
		jal		assertError			#  Check for an error
		.data
c103:	.asciiz	"Array pointer below zero. (get)"
		.text
		
		
		#  Test #104
		#  Array begins outside of memory.
		#######################################################################
		jal		setSavedRegisters
		li		$a0, -40			#  Array
		li		$a1, 0				#  Element #
		li		$a2, 42				#  New data
		jal		set
		
		move	$a0, $v0			#  Result
		li		$a2, 104			#  Test #103
		la		$a3, c104			#  Description of test
		jal		assertError			#  Check for an error
		.data
c104:	.asciiz	"Array pointer below zero. (set)"
		.text
		
		
		#  Test #105
		#  Pointer begins outside of memory
		#######################################################################
		jal		setSavedRegisters
		li		$a0, 0x0FCDA890		#  Array
		li		$a1, 0				#  Element #
		jal		get
		
		move	$a0, $v0			#  Result
		li		$a2, 105			#  Test #105
		la		$a3, c105			#  Description of test
		jal		assertError			#  Check for an error
		.data
c105:	.asciiz	"Pointer in text range. (get)"
		.text
		
		
		#  Test #106
		#  Pointer begins outside of memory
		#######################################################################
		jal		setSavedRegisters
		li		$a0, 0x0FCDA890		#  Array
		li		$a1, 0				#  Element #
		li		$a2, 42				#  New data
		jal		set
		
		move	$a0, $v0			#  Result
		li		$a2, 106			#  Test #106
		la		$a3, c106			#  Description of test
		jal		assertError			#  Check for an error
		.data
c106:	.asciiz	"Pointer in text range. (set)"
		.text
		
		
		#  Test #107
		#  Pointer outside of memory
		#######################################################################
		jal		setSavedRegisters
		li		$a0, 0xC0000000		#  Array
		li		$a1, 0				#  Element #
		jal		get
		
		move	$a0, $v0			#  Result
		li		$a2, 107			#  Test #107
		la		$a3, c107			#  Description of test
		jal		assertError			#  Check for an error
		.data
c107:	.asciiz	"Pointer too high for dynamic data memory. (get)"
		.text
		
		
		#  Test #108
		#  Pointer outside of memory
		#######################################################################
		jal		setSavedRegisters
		li		$a0, 0xC0000000		#  Array
		li		$a1, 0				#  Element #
		li		$a2, 42				#  New data
		jal		set
		
		move	$a0, $v0			#  Result
		li		$a2, 108			#  Test #108
		la		$a3, c108			#  Description of test
		jal		assertError			#  Check for an error
		.data
c108:	.asciiz	"Pointer too high for dynamic data memory. (set)"
		.text
		
		
		#  Test #109
		#  Non-word aligned array
		#######################################################################
		jal		setSavedRegisters
		li		$a0, 0x10000002		#  Array
		li		$a1, 0				#  Element #
		jal		get
		
		move	$a0, $v0			#  Result
		li		$a2, 109			#  Test #109
		la		$a3, c109			#  Description of test
		jal		assertError			#  Check for an error
		.data
c109:	.asciiz	"Pointer is not word aligned. (get)"
		.text
		
		
		#  Test #110
		#  Non-word aligned array
		#######################################################################
		jal		setSavedRegisters
		li		$a0, 0x10000013		#  Array
		li		$a1, 0				#  Element #
		jal		get
		
		move	$a0, $v0			#  Result
		li		$a2, 110			#  Test #110
		la		$a3, c109			#  Description of test
		jal		assertError			#  Check for an error
		
		
		#  Test #111
		#  Non-word aligned array
		#######################################################################
		jal		setSavedRegisters
		li		$a0, 0x10000009		#  Array
		li		$a1, 0				#  Element #
		jal		get
		
		move	$a0, $v0			#  Result
		li		$a2, 111			#  Test #111
		la		$a3, c109			#  Description of test
		jal		assertError			#  Check for an error
		
		
		#  Test #112
		#  Non-word aligned array
		#######################################################################
		jal		setSavedRegisters
		li		$a0, 0x10000002		#  Array
		li		$a1, 0				#  Element #
		li		$a2, 42				#  New data
		jal		set
		
		move	$a0, $v0			#  Result
		li		$a2, 112			#  Test #112
		la		$a3, c112			#  Description of test
		jal		assertError			#  Check for an error
		.data
c112:	.asciiz	"Pointer is not word aligned. (set)"
		.text
		
		
		#  Test #113
		#  Non-word aligned array
		#######################################################################
		jal		setSavedRegisters
		li		$a0, 0x10000013		#  Array
		li		$a1, 0				#  Element #
		li		$a2, 42				#  New data
		jal		set
		
		move	$a0, $v0			#  Result
		li		$a2, 113			#  Test #113
		la		$a3, c112			#  Description of test
		jal		assertError			#  Check for an error
		
		
		#  Test #114
		#  Non-word aligned array
		#######################################################################
		jal		setSavedRegisters
		li		$a0, 0x10000009		#  Array
		li		$a1, 0				#  Element #
		li		$a2, 42				#  New data
		jal		set
		
		move	$a0, $v0			#  Result
		li		$a2, 114			#  Test #114
		la		$a3, c112			#  Description of test
		jal		assertError			#  Check for an error
		
		
		#  Test #115
		#  Bad array length
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d115			#  Array
		li		$a1, 0				#  Element #
		jal		get
		
		move	$a0, $v0			#  Result
		li		$a2, 115			#  Test #115
		la		$a3, c115			#  Description of test
		jal		assertError			#  Check for an error
		.data
d115:	.word	-43, 134, 654
c115:	.asciiz	"Negative array length. (get)"
		.text
		
		
		#  Test #116
		#  Bad array length
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d115			#  Array
		li		$a1, 0				#  Element #
		li		$a2, 42				#  New data
		jal		set
		
		move	$a0, $v0			#  Result
		li		$a2, 116			#  Test #115
		la		$a3, c116			#  Description of test
		jal		assertError			#  Check for an error
		.data
c116:	.asciiz	"Negative array length. (set)"
		.text
		
		
		#  Test #117
		#  Bad array length
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d117			#  Array
		li		$a1, 0				#  Element #
		jal		get
		
		move	$a0, $v0			#  Result
		li		$a2, 117			#  Test #117
		la		$a3, c117			#  Description of test
		jal		assertError			#  Check for an error
		.data
d117:	.word	0, 134, 654
c117:	.asciiz	"Zero array length. (get)"
		.text
		
		
		#  Test #118
		#  Bad array length
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d117			#  Array
		li		$a1, 0				#  Element #
		li		$a2, 42				#  New data
		jal		set
		
		move	$a0, $v0			#  Result
		li		$a2, 118			#  Test #118
		la		$a3, c118			#  Description of test
		jal		assertError			#  Check for an error
		.data
c118:	.asciiz	"Zero array length. (set)"
		.text
		
		
		#  Test #119
		#  Array extends outside of memory
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d119			#  Array
		li		$a1, 0				#  Element #
		jal		get
		
		move	$a0, $v0			#  Result
		li		$a2, 119			#  Test #119
		la		$a3, c119			#  Description of test
		jal		assertError			#  Check for an error
		.data
d119:	.word	0x80000000, 134, 654
c119:	.asciiz	"Array extends outside of memory. (get)"
		.text
		
		
		#  Test #120
		#  Array extends outside of memory
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d119			#  Array
		li		$a1, 0				#  Element #
		li		$a2, 42				#  New data
		jal		set
		
		move	$a0, $v0			#  Result
		li		$a2, 120			#  Test #120
		la		$a3, c120			#  Description of test
		jal		assertError			#  Check for an error
		.data
c120:	.asciiz	"Array extends outside of memory. (set)"
		.text
		
		
		#  Test #121
		#  Array extends outside of memory, but wraps around to the beginning of memory again.
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d121			#  Array
		li		$a1, 0				#  Element #
		jal		get
		
		move	$a0, $v0			#  Result
		li		$a2, 121			#  Test #121
		la		$a3, c121			#  Description of test
		jal		assertError			#  Check for an error
		.data
d121:	.word	0xFFFFFFF8, 134, 654
c121:	.asciiz	"Array wraps around to the beginning of memory. (get)"
		.text
		
		
		#  Test #122
		#  Array extends outside of memory, but wraps around to the beginning of memory again.
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d121			#  Array
		li		$a1, 0				#  Element #
		li		$a2, 42				#  New data
		jal		set
		
		move	$a0, $v0			#  Result
		li		$a2, 122			#  Test #122
		la		$a3, c122			#  Description of test
		jal		assertError			#  Check for an error
		.data
c122:	.asciiz	"Array wraps around to the beginning of memory. (set)"
		.text
		
		
		#  Test #123
		#  Array remains inside of memory but attempts to cross from the heap to the stack.
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d123			#  Array
		li		$a1, 0				#  Element #
		sub		$t0, $sp, $a0
		srl		$t0, $t0, 2
		sw		$t0, 0 ($a0)		#  Cracked length of the array.
		jal		get
		
		move	$a0, $v0			#  Result
		li		$a2, 123			#  Test #123
		la		$a3, c123			#  Description of test
		jal		assertError			#  Check for an error
		.data
d123:	.word	0, 134, 654
c123:	.asciiz	"Array is inside of the memory range, but attempts to cross from the heap to the stack. (get)"
		.text
		
		
		#  Test #124
		#  Array remains inside of memory but attempts to cross from the heap to the stack.
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d123			#  Array
		li		$a1, 0				#  Element #
		li		$a2, 42				#  New data
		jal		set
		
		move	$a0, $v0			#  Result
		li		$a2, 124			#  Test #124
		la		$a3, c124			#  Description of test
		jal		assertError			#  Check for an error
		.data
c124:	.asciiz	"Array is inside of the memory range, but attempts to cross from the heap to the stack. (set)"
		.text
		
		
		#  Test #125
		#  But, this one should work...
		#######################################################################
		la		$t1, d125
		sub		$t0, $sp, $t1
		srl		$t0, $t0, 2
		addi	$t0, $t0, -2
		sw		$t0, 0 ($t1)
		
		jal		setSavedRegisters
		la		$a0, d125			#  Array
		li		$a1, 1				#  Element #
		jal		get
		
		move	$a0, $v0			#  Result
		li		$a1, 654			#  Expected
		li		$a2, 125			#  Test #125
		la		$a3, c125			#  Description of test
		jal		assertEqualInteger	#  Check for an error
		.data
d125:	.word	0xB16DA7A, 134, 654
c125:	.asciiz	"Array barely stays below the stack. (get)"
		.text
		
		
		#  Test #126
		#  But, this one should work...
		#######################################################################
#		jal		setSavedRegisters
#		la		$a0, d125			#  Array
#		li		$a1, 1				#  Element #
#		li		$a2, 42				#  New data
#		jal		set
		
#		la		$a0, d125			#  Result
#		la		$a1, r126			#  Expected
#		la		$a2, 126			#  Test #126
#		la		$a3, c126			#  Description of test
#		jal		assertEqualArray	#  Check for an error
#		.data
#r126:	.word	0x1BFFBBB9, 134, 42
#c126:	.asciiz	"Array barely stays below the stack. (set)"
#		.text
		#  Yes, the set operation should work, but we don't really want to try to
		#  test/print every word between the beginning of the array and the top of the stack.
		
		
		#  Test #127
		#  Checking array boundaries.
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d127			#  Array
		li		$a1, -1				#  Element #
		jal		get
		
		move	$a0, $v0			#  Result
		li		$a2, 127			#  Test #127
		la		$a3, c127			#  Description of test
		jal		assertError			#  Check for an error
		.data
d127:	.word	2, 134, 654
c127:	.asciiz	"Array index is negative. (get)"
		.text
		
		
		#  Test #128
		#  Checking array boundaries.
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d127			#  Array
		li		$a1, -1				#  Element #
		li		$a2, 42				#  New data
		jal		set
		
		move	$a0, $v0			#  Result
		li		$a2, 128			#  Test #128
		la		$a3, c128			#  Description of test
		jal		assertError			#  Check for an error
		.data
c128:	.asciiz	"Array index is negative. (set)"
		.text
		
		
		#  Test #129
		#  Checking array boundaries.
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d127			#  Array
		li		$a1, 2				#  Element #
		jal		get
		
		move	$a0, $v0			#  Result
		li		$a2, 129			#  Test #129
		la		$a3, c129			#  Description of test
		jal		assertError			#  Check for an error
		.data
c129:	.asciiz	"Array index is too big for the array. (get)"
		.text
		
		
		#  Test #130
		#  Checking array boundaries.
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d127			#  Array
		li		$a1, 2				#  Element #
		li		$a2, 42				#  New data
		jal		set
		
		move	$a0, $v0			#  Result
		li		$a2, 130			#  Test #130
		la		$a3, c130			#  Description of test
		jal		assertError			#  Check for an error
		.data
c130:	.asciiz	"Array index is too big for the array. (set)"
		.text
		
		
		#  Test #131
		#  Checking array boundaries.
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d131			#  Array
		li		$a1, 0xFDFFFFFC		#  Element #
		jal		get
		
		move	$a0, $v0			#  Result
		li		$a2, 131			#  Test #131
		la		$a3, c131			#  Description of test
		jal		assertError			#  Check for an error
		.data
d131:	.word	2, 134, 654
c131:	.asciiz	"Array index is negative. (get)"
		.text
		
		
		#  Test #128
		#  Checking array boundaries.
		#######################################################################
		jal		setSavedRegisters
		la		$a0, d131			#  Array
		li		$a1, 0xFDFFFFFC		#  Element #
		li		$a2, 42				#  New data
		jal		set
		
		move	$a0, $v0			#  Result
		li		$a2, 132			#  Test #132
		la		$a3, c132			#  Description of test
		jal		assertError			#  Check for an error
		.data
c132:	.asciiz	"Array index is negative. (set)"
		.text
		
		
		
		
		
		
		
Skip_Parameter_Validation_Tests:		
		#  All tests completed.
		.data
t1:		.asciiz	"----------Starting functionality tests.----------\n"
t2:		.asciiz	"----------Starting parameter checking tests.----------\n"
f:		.asciiz	"----------Testing completed.----------\n"
		.text
		li		$v0, 4
		la		$a0, f
		syscall
		lw		$ra, 0 ($sp)		#  Load return address
		addi	$sp, $sp, 4			#  Pop the stack
		jr		$ra

		
		
		
		
		
###############################################################################
##                             Printing function                             ##
##																			 ##
##  Parameters:																 ##
##    $a0:  The array to display.											 ##
###############################################################################
Print_Array:
		#  Saving the existing data on the stack in case someone is carelessly
		#  calling this function.
		addi	$sp, $sp, -20
		sw		$t0,  0 ($sp)
		sw		$t1,  4 ($sp)
		sw		$t2,  8 ($sp)
		sw		$t3, 12 ($sp)
		sw		$v0, 16 ($sp)
		
		#  Check for a valid array, print a simple error message if this is not an array.
		lui		$t0, 0x1000
		blt		$a0, $t0, PA_Outside_of_Memory
		li		$t0, 0xFFFFFFFC
		and		$t0, $a0, $t0						#  Set the last two bits to zero, to force it to be word aligned.
		bne		$a0, $t0, PA_Not_Word_Aligned
		
		move	$t0, $a0				#  Store the array address in $t0
		lw		$t1, 0 ($t0)			#  Store the length in $t1
		#  First, print the length
		li		$v0, 4
		la		$a0, Length
		syscall
		li		$v0, 1
		move	$a0, $t1
		syscall
		
		#  If the length is zero, just quit now.
		beqz	$t1, PA_Exit

		#  Next, print the contents of the array.
		li		$v0, 4
		la		$a0, Contents
		syscall
		
		li		$t2, 1					#  Loop counter is in $t2.
PA_Loop:
		bgt		$t2, $t1, PA_Exit
		
		li		$v0, 4
		la		$a0, Space
		syscall
		li		$v0, 1
		sll		$t3, $t2, 2				#  One variable is provided for in $t3.
		add		$t3, $t0, $t3
		lw		$a0, 0 ($t3)
		syscall
		
		addi	$t2, $t2, 1
		j		PA_Loop
		.data
Length:	.asciiz	"Length:  "
Contents:	.asciiz	"  Contents:"
Space:	.asciiz	"  "
		.text
		
		
		#  If the "array" is not within data memory, don't try to display it.
PA_Outside_of_Memory:
		li		$v0, 4
		la		$a0, PAOM
		syscall
		j		PA_Exit
		.data
PAOM:	.asciiz	"The provided \"array\" is not inside the viable range for data and thus cannot be displayed."
		.text
		
		#  If the "array" is not word aligned, don't try to display it.
PA_Not_Word_Aligned:
		li		$v0, 4
		la		$a0, PANWA
		syscall
		j		PA_Exit
		.data
PANWA:	.asciiz	"The provided \"array\" is not word aligned and thus cannot be displayed."
		.text
		
PA_Exit:#  We've reached the end of the print function, so restore all the registers that we changed
		#  and return to the calling function.
		li		$v0, 4
		la		$a0, nl
		syscall
		lw		$t0,  0 ($sp)
		lw		$t1,  4 ($sp)
		lw		$t2,  8 ($sp)
		lw		$t3, 12 ($sp)
		lw		$v0, 16 ($sp)
		addi	$sp, $sp, 20
		jr		$ra
		
		
		
		
		
		
		
###############################################################################
##                            Assertion functions                            ##
###############################################################################
		#  Assert Equality for Integers
		#	$a0:  Observed
		#	$a1:  Expected
		#	$a2:  Test #
		#	$a3:  Test description
		#######################################################################
assertEqualInteger:
		#  Integers are easy to compare
		bne		$a0, $a1, AEIFail
		
		#  Correct solution.
		li		$a0, 1
		j		Results
		
		
		
		#  Failed because the observed value did not match the expected result.
AEIFail:
		addi	$sp, $sp, -8					#  Storing the observed and expected values on the stack.
		sw		$a0, 0 ($sp)
		sw		$a1, 4 ($sp)
		
		li		$a0, 0
		la		$a1, AEIF
		j		Results
		#  Error description print routine.
AEIF:	lw		$t0, 0 ($sp)					#  We can now retrieve the observed and expected values to print.
		lw		$t1, 4 ($sp)
		addi	$sp, $sp, 8

		li		$v0, 4
		la		$a0, AEIF1
		syscall
		la		$a0, Observed
		syscall
		li		$v0, 1
		move	$a0, $t0
		syscall
		li		$v0, 4
		la		$a0, nl
		syscall
		la		$a0, Expected
		syscall
		li		$v0, 1
		move	$a0, $t1
		syscall
		li		$v0, 4
		la		$a0, nl
		syscall
		syscall
		jr		$ra
		
		
		.data
AEIF1:	.asciiz	"The observed value did not match the expected result.\n"
Observed:	.asciiz	"Observed:  "
Expected:	.asciiz	"Expected:  "
		.text
		
		
		



		
		#######################################################################
		#  Assert Equality for Arrays with included size parameter
		#	$a0:  Observed
		#	$a1:  Expected
		#	$a2:  Test #
		#	$a3:  Test description
		#######################################################################
assertEqualArray:
		#  1.  Check for a valid observed array.
		#      It should be a pointer to the data region of memory.
		lui		$t0, 0x1000								#  All data should be above 0x1000 0000 and not negative.
		blt		$a0, $t0, AEA_Failed_Outside_of_Memory
		#      It should also be word aligned, since the first value is an integer.
		li		$t0, 0xFFFFFFFC
		and		$t0, $a0, $t0						#  Set the last two bits to zero, to force it to be word aligned.
		bne		$a0, $t0, AEA_Failed_Not_Word_Aligned	#  The results should be equal.
		#  2.  Check to make sure the student isn't trying to pass off the expected array as the observed array.
		beq		$a0, $a1, AEA_Failed_Cheating
		#  These should pass unless the student has done something catastrophic.
		
		#  Assume that the data inside the array has been changed improperly and use the expected data for the length of the array.
		li		$t0, 0
		lw		$t1, 0 ($a1)
AEA_Loop:
		bgt		$t0, $t1, AEA_End_Loop
		
		sll		$t9, $t0, 2
		add		$t2, $a0, $t9
		lw		$t2, 0 ($t2)
		add		$t3, $a1, $t9
		lw		$t3, 0 ($t3)
		bne		$t2, $t3, AEA_Failed_Not_Equal
		
		addi	$t0, $t0, 1
		j		AEA_Loop
AEA_End_Loop:
		#  All elements are equal, so the arrays are equivalent.
		li		$a0, 1			#  Correct result.
		j		Results
		
AEA_Failed_Outside_of_Memory:
		li		$a0, 0			#  Incorrect result.
		la		$a1, AEAFOM		#  Description of failure.
		j		Results
		.data
AEAFOM:	.asciiz	"The array pointer is no longer within the data memory range.\nThis is bad, I do not know how you managed to accomplish this.\n"
		.text
		
AEA_Failed_Not_Word_Aligned:
		li		$a0, 0			#  Incorrect result.
		la		$a1, AEAFNWA	#  Description of failure.
		j		Results
		.data
AEAFNWA:	.asciiz	"The array pointer is no longer word aligned.\nThis is bad, I do now know how you managed to accomplish this.\n"
		.text
		
AEA_Failed_Cheating:
		li		$a0, 0			#  Incorrect result.
		la		$a1, AEAFC		#  Description of failure.
		j		Results
		.data
AEAFC:	.asciiz	"Cheating is bad, mmmkay?\nQuit trying to game the test suite.\n"
		.text

AEA_Failed_Not_Equal:
		addi	$sp, $sp, -12
		sw		$a0, 0 ($sp)	#  Store the observed array on the stack.
		sw		$a1, 4 ($sp)	#  Store the expected array on the stack.
		sw		$ra, 8 ($sp)	#  Store the return address on the stack.
		
		beq		$t0, $zero, AEA_Failed_Wrong_Length
		li		$a0, 0			#  Incorrect result.
		la		$a1, AEAFNE		#  Description of failure.
		j		Results
AEAFNE:	li		$v0, 4
		la		$a0, AEAFNE1
		syscall
		j		AEA_Print_Array
		.data
AEAFNE1:	.asciiz	"The observed array does not match the expected array.\n"
		.text
		
AEA_Failed_Wrong_Length:
		li		$a0, 0			#  Incorrect result.
		la		$a1, AEAFWL		#  Description of failure.
		j		Results
AEAFWL:	li		$v0, 4
		la		$a0, AEAFWL1
		syscall
		.data
AEAFWL1:	.asciiz	"The length of the array has been changed.\nYou should not need to modify the first element in the array.\n"
		.text
		
		#  Print out the contents of the array to show the student what (s)he did wrong.
AEA_Print_Array:
		lw		$t0, 0 ($sp)	#  Restore the observed array from the stack.
		lw		$t1, 4 ($sp)	#  Restore the expected array from the stack.
		
		li		$v0, 4
		la		$a0, Observed
		syscall
		move	$a0, $t0
		jal		Print_Array
		
		li		$v0, 4
		la		$a0, Expected
		syscall
		move	$a0, $t1
		jal		Print_Array
		
		lw		$ra, 8 ($sp)	#  Restore the return address from the stack.
		addi	$sp, $sp, 12
		jr		$ra
		
		



		
		#######################################################################
		#  Assert Null Pointer
		#	$a0:  Observed
		#	   :  Expect a null pointer (0).
		#	$a2:  Test #
		#	$a3:  Test description
		#######################################################################
assertNull:
		bne		$t0, $zero, AN_Failed
		
		li		$a0, 1			#  Correct result.
		j		Results
		
AN_Failed:
		li		$a0, 0			#  Incorrect result.
		la		$a1, ANF		#  Description of failure.
		j		Results
		.data
ANF:	.asciiz	"Null pointer expected.  This problem was not solvable.\n"
		.text
		
		



		#######################################################################
		#  Assert Error
		#	$a0:  Observed
		#	   :  Expect an error signal (0x8000 0001).
		#	$a2:  Test #
		#	$a3:  Test description
		#######################################################################
assertError:
		li		$t0, 0x80000001
		bne		$a0, $t0, AE_Failed
		
		li		$a0, 1			#  Correct result.
		j		Results
		
AE_Failed:
		li		$a0, 0			#  Incorrect result.
		la		$a1, AEF		#  Description of failure.
		j		Results
		.data
AEF:	.asciiz	"The parameters were not parsable, the function should have returned an error (0x8000 0001).\n"
		.text



		
		
		#  Results
		#
		#  Display the results of the test.
		#	$a0:  Pass (1) or fail (0).
		#	$a1:  Description of failure if needed.
		#	$a2:  Test #
		#	$a3:  Test description
		#######################################################################
Results:
		bnez		$a0, checkSavedRegisters
Res1:	move		$t0, $a0
		move		$t1, $a1
		move		$t2, $a2
		move		$t3, $a3
		#  Print the header.
		li		$v0, 4
		la		$a0, R1
		syscall
		li		$v0, 1
		move	$a0, $t2
		syscall
		
		bnez		$t0, RPass

		#  Failed the test.
		li		$v0, 4
		la		$a0, RF
		syscall
		move	$a0, $t3
		syscall
		la		$a0, nl
		syscall
		blt		$t1, 0x10000000, RPrintFunction
		move	$a0, $t1			#  Displaying a simple error message.
		syscall
		la		$a0, nl
		syscall
		jr		$ra
RPrintFunction:						#  Calling a print function for extra detail.
		jr		$t1
		
		#  Passed the test.
RPass:	li		$v0, 4
		la		$a0, RP
		syscall
		move	$a0, $t3
		syscall
		la		$a0, nl
		syscall
		jr		$ra
		
		.data
R1:		.asciiz	"Test #"
nl:		.asciiz	"\n"
RP:		.asciiz	" passed:  "
RF:		.asciiz	" failed:  "
		.text



		
		#  Set Saved Registers
		#######################################################################
setSavedRegisters:
		li		$s0, 14
		li		$s1, 73
		li		$s2, 69
		li		$s3, 46
		li		$s4, 79
		li		$s5, 92
		li		$s6, 37
		li		$s7, 96
		li		$t0, 14
		li		$t1, -72
		li		$t2, 12331
		li		$t3, 18
		li		$t4, 456
		li		$t5, 09876
		li		$t6, 6789
		li		$t7, 3443
		li		$t8, 2343
		li		$t9, 98
		li		$v0, 3876
		li		$v1, 3443
		li		$a0, 23453
		li		$a1, 34432
		li		$a2, 543
		li		$a3, -234543
		jr		$ra
		
		#  Check Saved Registers
		#######################################################################
checkSavedRegisters:
		bne		$s0, 14, regFail
		bne		$s1, 73, regFail
		bne		$s2, 69, regFail
		bne		$s3, 46, regFail
		bne		$s4, 79, regFail
		bne		$s5, 92, regFail
		bne		$s6, 37, regFail
		bne		$s7, 96, regFail
		j		Res1
		
regFail:
		.data
rf:		.asciiz	"Your function returned the correct value, but has changed the saved registers.\nYou must follow the conventions and restore the state of any saved register ($s0-$s7) when you're finished with it.\n"
		.text
		li		$a0, 0
		la		$a1, rf
		j		Res1
		
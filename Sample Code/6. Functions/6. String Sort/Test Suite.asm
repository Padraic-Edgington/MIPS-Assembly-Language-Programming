
#############################################################################################
#                          Unit Tests for Recursion & Object Function						#
#																							#
#  Padraic Edgington                                                          27 Apr, 2014	#
#																							#
#                                            v. 1.1											#
#  If there are bugs in this code, you may check back later for an updated version.			#
#																							#
#  You should write your code in a seperate file and prepend it to this file by running		#
#  either:																					#
#  Windows: copy /Y <Program #4 Name>.asm + "Program #4 - Test Suite.asm" <output>.asm		#
#  Unix:    cat <Program #4 Name>.asm "Program #4 - Test Suite.asm" > <output>.s			#
#																							#
#  v. 1    Initial release																	#
#  v. 1.1  Added a test to ensure that the return value from the sort function is actually	#
#          a pointer.																		#
#############################################################################################
		.data
s1:		.asciiz	"alphabet"
s2:		.asciiz	"Johnny"
s3:		.asciiz	"!@#$%^&*()"
s4:		.asciiz	"john"
s5:		.asciiz	"aLpHaBeT"
s6:		.asciiz	"John Hancock"
s7:		.asciiz	"JohnHancock"
s8:		.asciiz	"John_Hancock"
s9:		.asciiz	"John/Hancock"
s10:	.asciiz	"$$$ and sense"
s11:	.asciiz	"% of gain%"
s12:	.asciiz	"$10 a day"
s13:	.asciiz	"1, 2, buckle my shoe"
s14:	.asciiz	"20 funny stories"
s15:	.asciiz	"A-1 steak sauce"
s16:	.asciiz	"A-5 rocket"
s17:	.asciiz	"A 99"
s18:	.asciiz	"A and G motor vehicles"
s19:	.asciiz	"A B C"
s20:	.asciiz	"A la mode"
s21:	.asciiz	"Abalone"
s22:	.asciiz	"A.B.C."
s23:	.asciiz	"abdomen"
s24:	.asciiz	"Ambassador hotel"
s25:	.asciiz	"...and so to bed"
s26:	.asciiz	"Antigone"
s27:	.asciiz	"Andersen, Hans Christian"
s28:	.asciiz	"B*** de B."
s29:	.asciiz	"Ba, Amadou"
s30:	.asciiz	"Balzac, Honore de"
s31:	.asciiz	"Byrum, John"
s32:	.asciiz	"C"
s33:	.asciiz	"C-Vision"
s34:	.asciiz	"C Windows toolkit"
s35:	.asciiz	"C# ballad"
s36:	.asciiz	"C++ debugger"
s37:	.asciiz	"C++ for expert systems"
s38:	.asciiz	"C++ Views"
s39:	.asciiz	"Cabaret"
s40:	.asciiz	"Carmen"
c:		.word	s11, c1
c1:		.word	s10, c2
c2:		.word	s12, c3
c3:		.word	s13, c4
c4:		.word	s14, c5
c5:		.word	s15, c6
c6:		.word	s16, c7
c7:		.word	s17, c8
c8:		.word	s18, c9
c9:		.word	s19, c10
c10:	.word	s20, c11
c11:	.word	s21, c12
c12:	.word	s22, c13
c13:	.word	s23, c14
c14:	.word	s24, c15
c15:	.word	s25, c16
c16:	.word	s27, c17
c17:	.word	s26, c18
c18:	.word	s28, c19
c19:	.word	s29, c20
c20:	.word	s30, c21
c21:	.word	s31, c22
c22:	.word	s32, c23
c23:	.word	s33, c24
c24:	.word	s34, c25
c25:	.word	s35, c26
c26:	.word	s36, c27
c27:	.word	s37, c28
c28:	.word	s38, c29
c29:	.word	s39, c30
c30:	.word	s40, 0
ca:		.word	s1, 0
cb:		.word	s1, cb1
cb1:	.word	s2, 0
cc:		.word	s3, cb
cd:		.word	s6, cd1
cd1:	.word	s9, cd2
cd2:	.word	s8, cd3
cd3:	.word	s7, 0
ce:		.word	s4, ce1
ce1:	.word	s6, ce2
ce2:	.word	s2, 0

		.text
main:	addi	$sp, $sp, -4		#  Make space for $ra on stack
		sw		$ra, 0 ($sp)		#  Store the return address on the stack


###############################################################################
##                           Testing memory reading                          ##
###############################################################################
		#  Test #1
		#  sort("alphabet")
		#######################################################################
		jal		setSavedRegisters
		la		$a0, t1				#  List
		jal		sort
		
		move	$a0, $v0			#  Result
		la		$a1, ca				#  Expected result
		li		$a2, 1				#  Test #1
		jal		assertEqual			#  Check for equality
		.data
t1:		.word	s1, 0				#  alphabet
		.text
		
		
		
		#  Test #2
		#  sort("Johnny", "alphabet")
		#######################################################################
		jal		setSavedRegisters
		la		$a0, t2				#  List
		jal		sort
		
		move	$a0, $v0			#  Result
		la		$a1, cb				#  Expected result
		li		$a2, 2				#  Test #2
		jal		assertEqual			#  Check for equality
		.data
t2:		.word	s2, t2a				#  Johnny
t2a:	.word	s1, 0				#  alphabet
		.text
		
		
		
		#  Test #3
		#  sort("Johnny", "!@#$%^&*()", "alphabet")
		#######################################################################
		jal		setSavedRegisters
		la		$a0, t3				#  List
		jal		sort
		
		move	$a0, $v0			#  Result
		la		$a1, cc				#  Expected result
		li		$a2, 3				#  Test #3
		jal		assertEqual			#  Check for equality
		.data
t3:		.word	s2, t3a				#  Johnny
t3a:	.word	s3, t3b				#  !@#$%^&*()
t3b:	.word	s1, 0				#  alphabet
		.text
		
		
		
		#  Test #4
		#  sort(John Hancocks)
		#######################################################################
		jal		setSavedRegisters
		la		$a0, JH				#  List
		jal		sort
		
		move	$a0, $v0			#  Result
		la		$a1, cd				#  Expected result
		li		$a2, 4				#  Test #4
		jal		assertEqual			#  Check for equality
		.data
JH:		.word	s7, JH1				#  JohnHancock
JH1:	.word	s8, JH2				#  John_Hancock
JH2:	.word	s9, JH3				#  John Hancock
JH3:	.word	s6, 0				#  John/Hancock
		.text
		
		
		
		#  Test #5
		#  sort(Johns)
		#######################################################################
		jal		setSavedRegisters
		la		$a0, Johns			#  List
		jal		sort
		
		move	$a0, $v0			#  Result
		la		$a1, ce				#  Expected result
		li		$a2, 5				#  Test #5
		jal		assertEqual			#  Check for equality
		.data
Johns:	.word	s2, J2				#  Johnny
J2:		.word	s4, J3				#  john
J3:		.word	s6, 0				#  John Hancock
		.text
		
		
		
		#  Test #6
		#  sort(The big list)
		#######################################################################
		jal		setSavedRegisters
		la		$a0, big			#  List
		jal		sort
		
		move	$a0, $v0			#  Result
		la		$a1, c				#  Expected result
		li		$a2, 6				#  Test #6
		jal		assertEqual			#  Check for equality
		.data
big:	.word	s39, b1
b1:		.word	s16, b2
b2:		.word	s19, b3
b3:		.word	s10, b4
b4:		.word	s15, b5
b5:		.word	s29, b6
b6:		.word	s18, b7
b7:		.word	s26, b8
b8:		.word	s40, b9
b9:		.word	s32, b10
b10:	.word	s14, b11
b11:	.word	s17, b12
b12:	.word	s22, b13
b13:	.word	s27, b14
b14:	.word	s12, b15
b15:	.word	s37, b16
b16:	.word	s38, b17
b17:	.word	s24, b18
b18:	.word	s23, b19
b19:	.word	s11, b20
b20:	.word	s25, b21
b21:	.word	s20, b22
b22:	.word	s13, b23
b23:	.word	s28, b24
b24:	.word	s35, b25
b25:	.word	s30, b26
b26:	.word	s21, b27
b27:	.word	s36, b28
b28:	.word	s33, b29
b29:	.word	s34, b30
b30:	.word	s31, 0
		.text
		
		
		


		#  All tests completed.
		lw		$ra, 0 ($sp)		#  Load return address
		addi	$sp, $sp, 4			#  Pop the stack
		j		$ra

		
		
###############################################################################
##                            Assertion functions                            ##
###############################################################################
		#  Assert Equality
		#######################################################################
assertEqual:
		.data
eq1:	.asciiz	"Test #"
eq2:	.asciiz " failed:\n    Observed value:                       Expected value:\n"
eq3:	.asciiz	" "
eq4:	.asciiz "\n"
		.text
		
		addi	$sp, $sp, -12		#  Make space for three variables on the stack
		sw		$a0, 8 ($sp)		#  Store the result
		sw		$a1, 4 ($sp)		#  Store the expected result
		sw		$a2, 0 ($sp)		#  Store the test number
		
		li		$v0, 4
		la		$a0, eq1
		syscall						#  Print "Test #"
		
		li		$v0, 1
		lw		$a0,  0 ($sp)
		syscall						#  Print test number
		
		
		lw		$t0, 8 ($sp)
		lw		$t1, 4 ($sp)
		
		#  Check for a valid pointer.
		blt		$t0, 0x10000000, NotAPointer		#  A pointer to data should be in the data segment of memory.
		srl		$t2, $t0, 2
		sll		$t2, $t2, 2
		bne		$t0, $t2, NotAPointer				#  A pointer should be divisible by 4.  (The last two bits are 0.)
		

		#  If the string pointers match at each node, then the test is successful.
		beq		$t0, $t1, Cheat		#  The two lists should occupy different spots in memory.

AssertEqualLoop:
		lw		$t2, 0 ($t0)		#  Observed string
		lw		$t3, 0 ($t1)		#  Expected string
		
		bne		$t2, $t3, AssertEqualFail
		
		lw		$t0, 4 ($t0)		#  Next observed
		lw		$t1, 4 ($t1)		#  Next expected
		
		beqz	$t0, AssertEqualFinishedCheck
		beqz	$t1, AssertEqualFail
		j		AssertEqualLoop
		
AssertEqualFinishedCheck:
		bnez	$t1, AssertEqualFail
		j		Pass
		
		#  Otherwise, it failed.
AssertEqualFail:		
		li		$v0, 4
		la		$a0, eq2
		syscall						#  Print " failed:\n  Observed value:                         Expected value:\n"
		
		lw		$t0, 8 ($sp)		#  Observed list
		lw		$t1, 4 ($sp)		#  Expected list
		
		#  Print each string in each list.
AssertEqualFailLoop:
		lw		$t2, 0 ($t0)		#  Fetch the first string
		lw		$t3, 0 ($t1)		#  Fetch the second string
		
		#  Calculate the length of the observed string.
		li		$t4, 0
AEFStringLength:
		add		$t5, $t4, $t2		#  Address of the next character
		lbu		$t6, 0 ($t5)		#  Read next character
		beqz	$t6, AEFStringLengthDone
		
		addi	$t4, $t4, 1			#  Increment length counter
		j		AEFStringLength
		
AEFStringLengthDone:
		li		$v0, 4
		la		$a0, eq3
		syscall
		syscall
		move	$a0, $t2
		syscall						#  Print the observed string

		#  Print spaces to fill the first column.
		li		$t5, 38
		sub		$t4, $t5, $t4
		li		$t5, 0
		la		$a0, eq3
AEFColumn:
		beq		$t4, $t5, AEFColumnDone
		syscall
		addi	$t5, $t5, 1
		j		AEFColumn

AEFColumnDone:
		move	$a0, $t3
		syscall						#  Print the expected string
		
		la		$a0, eq4
		syscall						#  Add a new line
		
		lw		$t0, 4 ($t0)		#  cdr(observed)
		lw		$t1, 4 ($t1)		#  cdr(observed)
		
		beqz	$t1, AEFFinishedCheck
		beqz	$t0, AEFPrintExpectedColumn
		
		j		AssertEqualFailLoop
		
AEFFinishedCheck:
		beqz	$t0, AEFFinished
		
		li		$v0, 4
AEFFCLoop:
		la		$a0, eq3
		syscall
		syscall
		lw		$a0, 0 ($t0)		#  Fetch the observed string
		syscall						#  Print the observed string
		la		$a0, eq4
		syscall						#  Add a new line
		lw		$t0, 4 ($t0)		#  cdr(observed)
		beqz	$t0, AEFFinished
		j		AEFFCLoop
		
AEFPrintExpectedColumn:
		.data
AEFPEC:	.asciiz	"                                        "
		.text
		li		$v0, 4
		la		$a0, AEFPEC
		syscall						#  Print the left column offset
		lw		$a0, 0 ($t1)		#  Fetch the second string
		syscall						#  Print the observed string
		la		$a0, eq4
		syscall						#  Add a new line
		lw		$t1, 4 ($t1)		#  cdr(observed)
		bnez	$t1, AEFPrintExpectedColumn
		
AEFFinished:		
		addi	$sp, $sp, 12		#  Pop the stack
		
		jr		$ra					#  Return to caller
		
		
		#  Assertion Success
		#######################################################################
		.data
pass:	.asciiz	" passed.\n"
		.text
Pass:	
		j		checkSavedRegisters	#  Check the saved registers before signing off.
		
Pass1:	li		$v0, 4				#  Print string
		la		$a0, pass			#  " passed.\n"
		syscall
		
		addi	$sp, $sp, 12		#  Pop the stack
		
		jr		$ra					#  Return to caller
		
		
		
		#  Return value was not a pointer.
		#######################################################################
		.data
nap:	.asciiz	" did not return a pointer to a list object.\n"
		.text
NotAPointer:
		li		$v0, 4				#  Print string
		la		$a0, nap			#  " did not return a pointer to a list object.\n"
		syscall
		
		addi	$sp, $sp, 12		#  Pop the stack
		jr		$ra					#  Return to caller
		
		
		
		#  Cheating detected
		#######################################################################
		.data
cheat:	.asciiz	" failed.  Cheating is bad, mmmkay?\n"
		.text
Cheat:	li		$v0, 4				#  Print string
		la		$a0, cheat
		syscall
		
		addi	$sp, $sp, 12		#  Pop the stack
		
		jr		$ra					#  Return to caller
		


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
		j		Pass1
		
regFail:
		.data
rf:		.asciiz	" successfully sorted the list; however, MIPS assembly language conventions were violated by changing and not restoring the saved registers.\n"
		.text
		li		$v0, 4
		la		$a0, rf
		syscall
		
		addi	$sp, $sp, 12		#  Pop the stack
		jr		$ra					#  Return to caller
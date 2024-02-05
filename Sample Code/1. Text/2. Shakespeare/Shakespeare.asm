main:
		.data
Line1:	.asciiz "If we shadows have offended,\n"
Line2:	.asciiz "\tThink but this and all is mended,\n"
Line3:	.asciiz "That you have but slumber'd here\n"
Line4:	.asciiz	"\tWhile these visions did appear.\n"
Line5:	.asciiz	"And this weak and idle theme,\n"
Line6:	.asciiz	"\tNo more yielding but a dream,\n"
Line7:	.asciiz	"Gentles, do not reprehend:\n"
Line8:	.asciiz	"\tIf you pardon, we will mend:\n"
		.text
		li	$v0, 4						#  Put 4 into $v0 as the main parameter for syscall.
		la	$a0, Line1					#  Put the address of Line1 in $a0.
		syscall							#  Syscall #4 prints the string referenced in $a0.
		
		la	$a0, Line2					#  Put the address of Line2 in $a0.
		syscall							#  Syscall #4 prints the string referenced in $a0.
		
		la	$a0, Line3					#  Put the address of Line3 in $a0.
		syscall							#  Syscall #4 prints the string referenced in $a0.
		
		la	$a0, Line4					#  Put the address of Line4 in $a0.
		syscall							#  Syscall #4 prints the string referenced in $a0.
		
		la	$a0, Line5					#  Put the address of Line5 in $a0.
		syscall							#  Syscall #4 prints the string referenced in $a0.
		
		la	$a0, Line6					#  Put the address of Line6 in $a0.
		syscall							#  Syscall #4 prints the string referenced in $a0.
		
		la	$a0, Line7					#  Put the address of Line7 in $a0.
		syscall							#  Syscall #4 prints the string referenced in $a0.

		la	$a0, Line8					#  Put the address of Line8 in $a0.
		syscall							#  Syscall #4 prints the string referenced in $a0.
		
		la	$a0, Line9					#  Put the address of Line9 in $a0.
		syscall							#  Syscall #4 prints the string referenced in $a0.
		
		la	$a0, Line10					#  Put the address of Line10 in $a0.
		syscall							#  Syscall #4 prints the string referenced in $a0.
		
		la	$a0, Line11					#  Put the address of Line11 in $a0.
		syscall							#  Syscall #4 prints the string referenced in $a0.
		
		la	$a0, Line12					#  Put the address of Line12 in $a0.
		syscall							#  Syscall #4 prints the string referenced in $a0.
		
		la	$a0, Line13					#  Put the address of Line13 in $a0.
		syscall							#  Syscall #4 prints the string referenced in $a0.
		
		la	$a0, Line14					#  Put the address of Line14 in $a0.
		syscall							#  Syscall #4 prints the string referenced in $a0.
		
		la	$a0, Line15					#  Put the address of Line15 in $a0.
		syscall							#  Syscall #4 prints the string referenced in $a0.
		
		la	$a0, Line16					#  Put the address of Line16 in $a0.
		syscall							#  Syscall #4 prints the string referenced in $a0.
		
		li $v0, 10						#  Put 10 into $v0 as the main parameter for syscall.
		syscall							#  Syscall #10 exits the program.
		
		.data
Line9:	.asciiz	"And, as I am an honest Puck,\n"
Line10:	.asciiz	"\tIf we have unearned luck,\n"
Line11:	.asciiz	"Now to Åescape the serpent's tongue,\n"
Line12:	.asciiz	"\tWe will make amends ere long;\n"
Line13:	.asciiz	"Else the Puck a liar call;\n"
Line14:	.asciiz	"\tSo goodnight unto you all.\n"
Line15:	.asciiz	"Give me your hands if we be friends,\n"
Line16:	.asciiz	"\tAnd Robin shall restore amends.\n"

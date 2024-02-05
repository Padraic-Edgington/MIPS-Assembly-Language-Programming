#############################################################################################
#                                 			Functions										#
#																							#
#  Padraic Edgington                                                          2 Apr, 2014	#
#																							#
#  Compare:																					#
#  This function takes two English ASCII characters as parameters and returns an integer	#
#  representing the relationship between the two characters in alphabetical ordering.		#
#    0:		$a0 precedes $a1																#
#    1:		$a0 has the same precedence as $a1												#
#    2:		$a0 succeeds $a1																#
#    3:		One or more of the characters is not present in English alphabetical ordering.	#
#																							#
#  Parameters:																				#
#  $a0		First character																	#
#  $a1		Second character																#
#																							#
#  Return Values:																			#
#  $v0		Result of comparison															#
#																							#
#  v. 1		Initial release																	#
#############################################################################################


		.text
compare:
		move	$t9, $ra		#  Lazy $ra store
		jal		Categorize		#  Find the alphabetical position of $a0
		move	$t0, $v0
		move	$a0, $a1
		jal		Categorize		#  Find the alphabetical position of $a1
		move	$t1, $v0
		move	$ra, $t9		#  Lazy $ra load
		
		beq		$t0, -1, R3		#  If $a0 is not a valid alphabetical character, return 3
		beq		$t1, -1, R3		#  If $a1 is not a valid alphabetical character, return 3
		blt		$t0, $t1, R0	#  If $a0 < $a1, return 0
		beq		$t0, $t1, R1	#  If $a0 = $a1, return 1
								#  If $a0 > $a1, return 2
		li		$v0, 2
		jr		$ra
		
R0:		li		$v0, 0
		jr		$ra
		
R1:		li		$v0, 1
		jr		$ra
		
		#  This function categorizes the parameter given to it based on its alphabetical order.
Categorize:
		#  Visible ASCII character are only defined on the range 32-126.
		#  If the parameter is outside of this range, then no comparison is possible.
		blt		$a0, 32, Garbage
		bgt		$a0, 126, Garbage
		#  English punctuation marks are also not sorted.
		beq		$a0, 21, Garbage	#  !
		beq		$a0, 22, Garbage	#  "
		beq		$a0, 39, Garbage	#  '
		beq		$a0, 40, Garbage	#  (
		beq		$a0, 41, Garbage	#  )
		beq		$a0, 44, Garbage	#  ,
		beq		$a0, 46, Garbage	#  .
		beq		$a0, 58, Garbage	#  :
		beq		$a0, 59, Garbage	#  ;
		beq		$a0, 60, Garbage	#  <
		beq		$a0, 62, Garbage	#  >
		beq		$a0, 63, Garbage	#  ?
		beq		$a0, 91, Garbage	#  [
		beq		$a0, 93, Garbage	#  ]
		beq		$a0, 123, Garbage	#  {
		beq		$a0, 125, Garbage	#  }

		#  If $a0 represents a space character...
		beq		$a0, 32, Space		#  Space
		beq		$a0, 45, Space		#  -
		beq		$a0, 47, Space		#  /
		beq		$a0, 92, Space		#  \
		
		#  If $a0 represents a symbol...
		beq		$a0, 35, Symbol		#  #
		beq		$a0, 36, Symbol		#  $
		beq		$a0, 37, Symbol		#  %
		beq		$a0, 38, Symbol		#  &
		beq		$a0, 42, Symbol		#  *
		beq		$a0, 43, Symbol		#  +
		beq		$a0, 61, Symbol		#  =
		beq		$a0, 64, Symbol		#  @
		beq		$a0, 94, Symbol		#  ^
		beq		$a0, 95, Symbol		#  _
		beq		$a0, 96, Symbol		#  `
		beq		$a0, 124, Symbol	#  |
		beq		$a0, 126, Symbol	#  ~
		
		
		#  Spaces have highest precedence.
Space:	li		$v0, 1
		jr		$ra
		
		#  Symbols have the second highest precedence.
Symbol:	li		$v0, 2
		jr		$ra
		
		#  Numbers have the third highest precedence.
Number:	addi	$v0, $a0, -45	#  Rebase numbers to range from 3-12.
		jr		$ra
		
		#  Letters have the lowest precedence.
Letter:	bgt		$a0 90, 2
		addi	$v0, $a0, -52	#  Rebase uppercase letters to range from 13-38.
		jr		$ra
		addi	$v0, $a0, -84	#  Rebase lowercase letters to range from 13-38.
		jr		$ra
		
Garbage:#  If one or more of the parameters is not a character in the English language, then
		#  return -1.
		li		$v0, -1
		jr		$ra
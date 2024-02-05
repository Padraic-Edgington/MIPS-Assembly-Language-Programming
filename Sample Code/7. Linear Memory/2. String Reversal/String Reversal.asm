#######################
#  String Reversal    #
#  Padraic Edgington  #
#  February 26, 2013  #
#######################

		#
		#  String reversal function
		#
		#  $a0:  The address of the string
		#  $a1:  The integer length of the string
		#  $v0:  The address of the reversed string on the heap
		#
		#  This function returns the address of a string of the same length as
		#  the provided string, but with its values in reverse order.  If the
		#  input is not useful, then it returns a null pointer.
		#######################################################################
String_Reversal:
		beq		$a0, $zero, SRFail	#  If the address is null, then fail
		ble		$a1, $zero, SRFail	#  If the length of the string is less than 1, then fail

		li		$t0, 0x7FFFFFFF
		addu	$t1, $a0, $a1
		bgtu	$t1, $t0, SRFail	#  If the address of the last cell is outside of memory, then fail
		
		move	$v0, $gp			#  Save the address of the output string
		add		$gp, $gp, $a1		#  Allocate space on the heap for the output string
		addi	$gp, $gp, 1			#  Make the output a null terminated string
		
		li		$t0, 0				#  iterator = 0;
SRLoop:	beq		$t0, $a1, SREnd		#  for (int i = 0; i < n; i++)
		
		add		$t1, $t0, $a0		#  $t1 = &array[i]
		lbu		$t1, 0 ($t1)		#  $t1 = array[i]
		
		add		$t2, $v0, $a1
		addi	$t2, $t2, -1
		sub		$t2, $t2, $t0		#  $t4 = &output[n-i]
		sb		$t1, 0 ($t2)		#  output[n-i] = array[i]
		
		addi	$t0, $t0, 1			#  iterator += 1
		
		j		SRLoop
		
SRFail:	li		$v0, 0
		
SREnd:	jr		$ra
###########################
#  Power (x, y) Function  #
#  Padraic Edgington      #
#  January 23, 2013       #
###########################

#  $a0:  The base
#  $a1:  The power
power:	move	$t0, $zero				#  loop counter
		li		$v0, 1					#  result
		
for:	beq		$t0, $a1, powerDone
		mul		$v0, $v0, $a0			#  result *= base
		addi	$t0, $t0, 1				#  increment the loop counter
		j		for
		
powerDone:
		jr		$ra						#  Return to the calling function.
		

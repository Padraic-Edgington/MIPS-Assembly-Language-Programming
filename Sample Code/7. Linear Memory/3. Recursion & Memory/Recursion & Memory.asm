#############################################################################################
#                                     Recursion & Memory									#
#																							#
#  Padraic Edgington                                                          21, Nov, 2013	#
#																							#
#  Calculates a rather arbitrary function.													#
#																							#
#  Functions:																				#
#  func:	Calculates the provided function.												#
#																							#
#  v. 1		Initial release																	#
#############################################################################################


		#  func
		#
		#		Calculates the result of an arbitrary function with side-effects.
		#
		#  Parameters:
		#		$a0:  the address of a linked list:  x
		#		$a1:  a constant:  c
		#
		#  Results:
		#		$v0:  the data contained in the first element of the linked list.
		#####################################################################################
func:	addi	$sp, $sp, -16			#  Store the parameters for this frame on the stack.
		sw		$a0, 0 ($sp)			#  $sp +  0 <- x
		sw		$a1, 4 ($sp)			#  $sp +  4 <- c
										#  $sp +  8 <- y
		sw		$ra, 12 ($sp)			#  $sp + 12 <- $ra


		#  if (x.next != 0) {
		#    y = func ( x.next, x.data );
		lw		$t0, 4 ($a0)
		beq		$t0, $zero, else_1		# if (x.next != 0)
		
		lw		$a1, 0 ($a0)			# c = x.data
		move	$a0, $t0				# x = x.next
		jal		func					# func (x.next, x.data);
		sw		$v0, 8 ($sp)			# y = func (x.next, x.data);
		j		end_if_1
		
		#  } else {
		#    y = 7;
		#  }
else_1:	li		$a2, 7
		sw		$a2, 8 ($sp)			# y = 7;
		
		
		#  if (x.data == 1 && x.next != 0) {
		#    x.data = func ( x.next, y );
end_if_1:
		lw		$a0, 0 ($sp)			# x
		
		lw		$t0, 0 ($a0)			# $t0 <- x.data
		li		$t1, 1
		bne		$t0, $t1, else_2		# if (x.data == 1
		lw		$t0, 4 ($a0)
		beq		$t0, $zero, else_2		# && x.next != 0) 
		
		lw		$a0, 4 ($a0)			# x = x.next
		lw		$a1, 8 ($sp)			# c = y
		jal		func					# func(x.next, y)
		lw		$a0, 0 ($sp)			# $a0 = x
		sw		$v0, 0 ($a0)			# x.data = func(x.next, y);
		j		end_if_2
		
		#  } else if ( x.data < 5 ) {
		#    x.data = y * c;
else_2:	lw		$t0, 0 ($a0)			# $t0 <- x.data
		li		$t1, 5
		bge		$t0, $t1, else_3		# if (x.data < 5)
		
		lw		$a1, 4 ($sp)			# c
		lw		$a2, 8 ($sp)			# y
		mult	$a1, $a2				# c * y
		mflo	$v0						# $v0 <- c * y
		sw		$v0, 0 ($a0)			# x.data <- c * y;
		j		end_if_2
		
		#  } else {
		#    x.data *= c;
		#  }
else_3:	lw		$a1, 4 ($sp)			# c
		mult	$t0, $a1				# x.data * c
		mflo	$v0						# $t0 <- x.data * c
		sw		$v0, 0 ($a0)			# x.data <- x.data * c;
		
		#  return x.data;
end_if_2:
		
		lw		$ra, 12 ($sp)
		addi	$sp, $sp, 16
		jr		$ra						# return x.data;
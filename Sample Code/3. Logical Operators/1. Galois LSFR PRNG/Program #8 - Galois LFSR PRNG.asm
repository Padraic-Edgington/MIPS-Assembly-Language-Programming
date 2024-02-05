#############################################################################################
#                                 Galois LFSR PRNG Function									#
#																							#
#  Padraic Edgington                                                          13 Mar, 2013	#
#																							#
#  Functions:																				#
#  LFSR_Constructor:	Takes a 64-bit non-zero seed as a parameter and returns a new PRNG	#
#						object.  Uses a default seed value if the parameter is zero.		#
#  LFSR_Seed:			Takes a 64-bit non-zero seed as a parameter and sets the current	#
#						state of the PRNG object.  Does not update the state if the			#
#						parameter is zero.													#
#  LFSR_Random:			Returns the next 64-bit random integer.								#
#																							#
#  v. 1		Initial release																	#
#############################################################################################


		#  LFSR_Constructor
		#
		#      Creates a new 64-bit random number generater using the provided
		#  64-bit seed.  If the state is zero, then the algorithm will not
		#  produce any other numbers; thus, a default seed is used if the
		#  parameter is zero.
		#
		#  Parameters:
		#    $a0:  Upper 32 bits of the seed
		#    $a1:  Lower 32 bits of the seed
		#
		#  Results:
		#    $v0:  A new PRNG object
		#######################################################################
LFSR_Constructor:
		addi	$sp, $sp, -16
		sw		$ra, 12 ($sp)
		sw		$a1,  4 ($sp)
		sw		$a0,  0 ($sp)
		
		#  Create a new 64-bit PRNG object
		li		$v0, 9
		li		$a0, 8
		syscall							#  Request a 64 bit sized block of memory
		sw		$v0, 8 ($sp)

		lw		$a0, 8 ($sp)
		lw		$a1, 0 ($sp)
		lw		$a2, 4 ($sp)
		#  If the provided 64-bit parameter is not zero, then use it as a seed
		bnez	$a1, LFSR_Constructor_Valid_Seed
		bnez	$a2, LFSR_Constructor_Valid_Seed
		#  Otherwise, use a default 64-bit seed
		li		$a1, 0x739E930A			#  Upper 32 bits of the default seed
		li		$a2, 0xB93ACE48			#  Lower 32 bits of the default seed
		
		#  Call the seed function with a useful seed
LFSR_Constructor_Valid_Seed:
		jal		LFSR_Seed
		
		lw		$v0,  8 ($sp)
		lw		$ra, 12 ($sp)
		addi	$sp, $sp, 16
		jr		$ra
		#######################################################################


		
		
		#  LFSR_Seed
		#
		#      Uses a 64-bit parameter to set the state of the PRNG.  If the
		#  parameter is zero, then the state is not changed.  If the PRNG 
		#  object is null, then no actions are taken.
		#
		#  Parameters:
		#    $a0:  A 64-bit PRNG object
		#    $a1:  Upper 32 bits of the seed
		#    $a2:  Lower 32 bits of the seed
		#######################################################################
LFSR_Seed:
		#  If the provided object is null, then do not perform any actions
		beqz	$a0, LFSR_Seed_Invalid_Object
		#  If the provided 64-bit parameter is not zero, then use it as a seed
		bnez	$a1, LFSR_Seed_Valid_Seed
		bnez	$a2, LFSR_Seed_Valid_Seed
		#  Otherwise, do not change the state of the PRNG
LFSR_Seed_Invalid_Object:
		jr		$ra
		
LFSR_Seed_Valid_Seed:
		sw		$a1, 0 ($a0)		#  Set the upper 32 bits of the PRNG state
		sw		$a2, 4 ($a0)		#  Set the lower 32 bits of the PRNG state
		jr		$ra
		#######################################################################


		
		
		#  LFSR_Random
		#
		#      Generates and returns the next 64-bit random number.
		#
		#  Parameters:
		#    $a0:  A 64-bit PRNG object
		#
		#  Results:
		#    $v0:  The upper 32 bits of a random number
		#    $v1:  The lower 32 bits of a random number
		#######################################################################
LFSR_Random:
		#  If the provided object is null, then return 0
		beqz	$a0, LFSR_Random_Invalid_Object
		
		#  Generate the next random number
		##################################
		lw		$t0, 0 ($a0)		#  Upper 32 bits of the current PRNG state
		lw		$t1, 4 ($a0)		#  Lower 32 bits of the current PRNG state
		
		#  lfsr >> 1
		li		$t2, 0x00000001
		and		$t5, $t0, $t2		#  Select bit #31 of the current PRNG state
		sll		$t5, $t5, 31		#  Push that last bit all the way to the left
		srl		$t3, $t0, 1			#  Shift the upper 32 bits to the right
		srl		$t4, $t1, 1			#  Shift the lower 32 bits to the right
		or		$t4, $t4, $t5		#  Shift the right most upper bit in on the left of the lowerbit string
		
		#  (-(lfsr & lu) & 0xD800 0000 0000 0000)
		li		$t5, 0x1
		and		$t5, $t1, $t5		#  lfsr & 0x1
		sub		$t5, $0,  $t5		#  -(lfsr & 0x1)
		li		$t6, 0xD8000000
		and		$t5, $t5, $t6
		
		#  (lfsr >> 1) ^ (-(lfsr & lu) & 0xD800 0000 0000 0000)
		xor		$t3, $t3, $t5
		
		sw		$t3, 0 ($a0)		#  Store the upper 32 bits of the current PRNG state
		sw		$t4, 4 ($a0)		#  Store the lower 32 bits of the current PRNG state
		
		#  Return the new number
		move	$v0, $t3
		move	$v1, $t4
		jr		$ra
		
LFSR_Random_Invalid_Object:
		li		$v0, 0
		li		$v1, 0
		jr		$ra
		#######################################################################
		
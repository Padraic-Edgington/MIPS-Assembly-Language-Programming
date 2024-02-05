#  Mersenne Twister PRNG Algorithm

#  This algorithm uses two global variables.
#  $s6 = mt[]
#  $s7 = mti

##############################
#  Initialization Procedure  #
##############################

#  Takes one parameter, an integer seed in $a0

sgenrand:
		lui		$t0, 0xFFFF
		ori		$t0, $t0, 0xFFFF		#  $t0 = 0xFFFFFFFF
		and		$t0, $a0, $t0			#  seed & 0xffffffff;
		sw		$t0, 0 ($s6)			#  mt[0] = seed & 0xffffffff;
		ori		$s7, $0, 1				#  mti=1
sgloop:	slti	$t0, $s7, 624			#  $t0 = ($s7 < 624) ? 1 : 0
		beq		$t0, $0, sgend			#  mti<N
		
		addi	$t0, $s7, -1			#  mti-1
		ori		$t9, $0, 4
		mult	$t0, $t9
		mflo	$t0
		add		$t0, $s6, $t0			#  mt[mti-1]
		addi	$t1, $t0, 4				#  mt[mti]
		lw		$t2, 0 ($t0)
		lui		$t3, 0x0001
		ori		$t3, $t3, 0x0DCD		#  $t3=69069
		multu	$t2, $t3				#  (69069 * mt[mti-1])
		mflo	$t2
		lui		$t3, 0xFFFF
		ori		$t3, $t3, 0xFFFF		#  $t3 = 0xFFFFFFFF
		and		$t2, $t2, $t3			#  (69069 & mt[mti-1]) & 0xffffffff;
		sw		$t2, 0 ($t1)			#  mt[mti] = (69069 & mt[mti-1]) & 0xffffff;

		addi	$s7, $s7, 1				#  mti++
		j		sgloop

sgend:	jr		$ra


########################################
#  Random Number Generation Procedure  #
########################################

genrand:
		#  The procedure uses three local variables
		#  $sp+12 = $ra
		#  $sp+8  = y
		#  $sp+4  = mag01[0]
		#  $sp+0  = mag01[1]
		
		addi	$sp, $sp, -16			#  Make room for the three local variables
		sw		$ra, 12 ($sp)
		sw		$0,   4 ($sp)			#  mag01[0] = 0x0
		lui		$t0,  0x9908
		ori		$t0, $t0, 0xB0DF		#  $t0 = MATRIX_A
		sw		$t0,  0 ($sp)			#  mag01[1] = MATRIX_A
		
		ori		$t0, $0, 624
		slt		$t0, $s7, $t0			#  $t0 = (624 < $s7) ? 1 : 0
		bne		$t0, $0, grshift		#  If mti<624, jump to shift
		
	#  Generate N words at one time
		#  $t0 = kk
		ori		$t1, $0, 625
		bne		$s7, $t1, grendif		#  If mti != N+1, skip default initialization
		
		ori		$a0, $0, 4357			#  a default initial seed is used
		jal		sgenrand				#  Call initialization procedure
		
grendif:
		or		$t0, $0, $0				#  kk=0
grfor1:	slti	$t1, $t0, 227			#  kk<N-M
		beq		$t1, $0, grfor2			#  If kk>=N-M, jump to grfor2

		ori		$t1, $0, 4
		mult	$t0, $t1
		mflo	$t1
		add		$t1, $s6, $t1			#  $t1=*mt[kk]
		lw		$t2, 0 ($t1)			#  $t2=mt[kk]
		lui		$t3, 0x8000				#  $t3 = UPPER_MASK (0x80000000)
		and		$t3, $t2, $t3			#  $t3=(mt[kk]&UPPER_MASK)
		addi	$t4, $t1, 4				#  $t4=*mt[kk+1]
		lw		$t5, 0 ($t4)			#  $t5=mt[kk+1]
		lui		$t6, 0x7FFF
		ori		$t6, $t6, 0xFFFF		#  $t6 = LOWER_MASK (0x7FFFFFFF)
		and		$t6, $t5, $t6			#  $t6=(mt[kk+1]&LOWER_MASK)
		or		$t9, $t3, $t6			#  $t9=(mt[kk]&UPPER_MASK) | (mt[kk+1]&LOWER_MASK)
		sw		$t9, 8 ($sp)			#  y = (mt[kk]&UPPER_MASK) | (mt[kk+1]&LOWER_MASK);

		addi	$t2, $t1, 1588			#  $t2=*mt[kk+M]
		lw		$t3, 0 ($t2)			#  $t3=mt[kk+M]
		srl		$t4, $t9, 1				#  (y >> 1)
		xor		$t5, $t3, $t4			#  $t5 = mt[kk+M] ^ (y >> 1)
		andi	$t6, $t9, 0x1			#  y & 0x1
		addi	$t7, $0, -4
		mult	$t6, $t7
		mflo	$t6
		addi	$t6, $t6, 4
		add		$t6, $sp, $t6			#  $t6=*mag01[y & 0x1]
		lw		$t7, 0 ($t6)			#  $t7=mag01[y & 0x1]
		xor		$t8, $t5, $t7			#  $t8=mt[kk+M] ^ (y >> 1) ^ mag01[y & 0x1]
		sw		$t8, 0 ($t1)			#  mt[kk] = mt[kk+M] ^ (y >> 1) ^ mag01[y & 0x1];
		
		addi	$t0, $t0, 1				#  kk++
		j		grfor1
		
grfor2:	slti	$t1, $t0, 623			#  kk<N-1
		beq		$t1, $0, grendfor		#  If kk>=N-1, jump to grendfor
		
		ori		$t1, $0, 4
		mult	$t0, $t1
		mflo	$t1
		add		$t1, $s6, $t1			#  $t1=*mt[kk]
		lw		$t2, 0 ($t1)			#  $t2=mt[kk]
		lui		$t3, 0x8000				#  $t3 = UPPER_MASK (0x80000000)
		and		$t3, $t2, $t3			#  $t3=(mt[kk]&UPPER_MASK)
		addi	$t4, $t1, 4				#  $t4=*mt[kk+1]
		lw		$t5, 0 ($t4)			#  $t5=mt[kk+1]
		lui		$t6, 0x7FFF
		ori		$t6, $t6, 0xFFFF		#  $t6 = LOWER_MASK (0x7FFFFFFF)
		and		$t6, $t5, $t6			#  $t6=(mt[kk+1]&LOWER_MASK)
		or		$t9, $t3, $t6			#  $t7=(mt[kk]&UPPER_MASK) | (mt[kk+1]&LOWER_MASK)
		sw		$t9, 8 ($sp)			#  y = (mt[kk]&UPPER_MASK) | (mt[kk+1]&LOWER_MASK);
		
		addi	$t2, $t1, -908			#  $t2=*mt[kk+(M-N)]
		lw		$t3, 0 ($t2)			#  $t3=mt[kk+(M-N)]
		srl		$t4, $t9, 1				#  (y >> 1)
		xor		$t5, $t3, $t4			#  $t5 = mt[kk+(M-N)] ^ (y >> 1)
		andi	$t6, $t9, 0x1			#  y & 0x1
		addi	$t7, $0, -4
		mult	$t6, $t7
		mflo	$t6
		addi	$t6, $t6, 4
		add		$t6, $sp, $t6			#  $t6=*mag01[y & 0x1]
		lw		$t7, 0 ($t6)			#  $t7=mag01[y & 0x1]
		xor		$t8, $t5, $t7			#  $t8=mt[kk+(M-N)] ^ (y >> 1) ^ mag01[y & 0x1]
		sw		$t8, 0 ($t1)			#  mt[kk] = mt[kk+(M-N)] ^ (y >> 1) ^ mag01[y & 0x1];
		
		addi	$t0, $t0, 1				#  kk++
		j		grfor2
		
grendfor:
		addi	$t0, $s6, 2492			#  $t0=*mt[N-1]
		lw		$t1, 0 ($t0)			#  $t1=mt[N-1]
		lui		$t2, 0x8000				#  $t2 = UPPERMASK (0x80000000)
		and		$t2, $t1, $t2			#  $t2=(mt[N-1]&UPPER_MASK)
		lw		$t3, 0 ($s6)			#  $t3=mt[0]
		lui		$t4, 0x7FFF
		ori		$t4, $t4, 0xFFFF		#  $t4 = LOWER_MASK (0x7FFFFFFF)
		and		$t4, $t3, $t4			#  $t4=(mt[0]&LOWER_MASK)
		or		$t9, $t2, $t4			#  $t9=(mt[N-1]&UPPER_MASK) | (mt[0]&LOWER_MASK)
		sw		$t9, 8 ($sp)			#  y=(mt[N-1]&UPPER_MASK) | mt[0]&LOWER_MASK)
		
		addi	$t1, $s6, 1584			#  $t1=*mt[M-1]
		lw		$t2, 0 ($t1)			#  $t2=mt[M-1]
		srl		$t3, $t9, 1				#  $t3=(y >> 1)
		andi	$t4, $t9, 0x1			#  $t4=[y & 0x1]
		ori		$t5, $0, 4
		mult	$t4, $t5
		mflo	$t5
		add		$t5, $sp, $t5			#  $t5=*mag01[y & 0x1]
		lw		$t6, 0 ($t5)			#  $t6=mag01[y & 0x1]
		xor		$t7, $t2, $t3			#  $t7=mt[M-1] ^ (y >> 1)
		xor		$t8, $t7, $t6			#  $t8=mt[M-1] ^ (y >> 1) ^ mag01[y & 0x1]
		sw		$t8, 0 ($t0)			#  mt[N-1]=mt[M-1] ^ (y >> 1) ^ mag01[y & 0x1]
		
		or		$s7, $0, $0				#  mti=0;
		
grshift:
		ori		$t0, $0, 4				#  $t0=4
		mult	$t0, $s7				#  mti*4
		mflo	$t0						#  $t0=mti*4
		add		$t0, $s6, $t0			#  $t0=*mt[mti]
		lw		$t0, 0 ($t0)			#  $t0=mt[mti]
		sw		$t0, 8 ($sp)			#  y=mt[mti]
		addi	$s7, $s7, 1				#  mti++
		
		srl		$t1, $t0, 11			#  TEMPERING_SHIFT_U(y)
		xor		$t0, $t0, $t1			#  $t0 = y ^ TEMPERING_SHIFT_U(y)
		
		sll		$t1, $t0, 7				#  TEMPERING_SHIFT_S(y)
		lui		$t2, 0x9d2c
		ori		$t2, $t2, 0x5680		#  $t2=TEMPERING_MASK_B (0x9d2c5680)
		and		$t1, $t1, $t2			#  $a1=TEMPERING_SHIFT_S(y) & TEMPERING_MASK_B
		xor		$t0, $t0, $t1			#  $t0=y ^ TEMPERING_SHIFT_U(y) & TEMPERING_MASK_B
		
		sll		$t1, $t0, 15			#  TEMPERING_SHIFT_T(y)
		lui		$t2, 0xEFC6				#  $t2=TEMPERING_MASK_C (0xefc60000)
		and		$t1, $t1, $t2			#  $a1=TEMPERING_SHIFT_T(y) & TEMPERING_MASK_C
		xor		$t0, $t0, $t1			#  $t0=y ^ TEMPERING_SHIFT_T(y) & TEMPERING_MASK_C
		
		srl		$t1, $t0, 18			#  TEMPERING_SHIFT_L(y)
		xor		$t0, $t0, $t1			#  $t0=y ^ TEMPERING_SHIFT_L(y)
		
		sw		$t0, 8  ($sp)
		lw		$ra, 12 ($sp)
		or		$v0, $t0, $0			#  return y
		addi	$sp, $sp, 16			#  Pop the stack.
		jr		$ra						#  return
		
		
		
######################
#  Driver Procedure  #
######################

main:	.data
q:		.asciiz "How many random numbers would you like to generate?\n"
nl:		.asciiz "\n"
		.text
		
		ori		$v0, $0, 4
		la		$a0, q
		syscall							#  Print the query
		
		ori		$v0, $0, 5
		syscall							#  Read an integer
		or		$s0, $v0, $0
		
		or		$s6, $gp, $0			#  $s6=*mt[0]
		ori		$s7, $0, 625			#  $s7=N+1
		addi	$gp, $gp, 2496			#  Reserve space on the heap for mt[N]
		
		or		$s1, $0, $0				#  $s1 = 0;
dfor:	slt		$s2, $s1, $s0			#  $s2 = ($s1 < $s2) ? 1 : 0
		beq		$s2, $0, dendfor		#  if ($s1 >= $s0) break
		
		ori		$v0, $0, 4
		la		$a0, nl
		syscall
		
		jal		genrand					#  Generate a random number
		or		$a0, $v0, $0
		ori		$v0, $0, 1
		syscall							#  Print the random number
		
		addi	$s1, $s1, 1				#  $s1++
		j		dfor
		
dendfor:
		addi	$v0, $0, 10
		syscall							#  quit
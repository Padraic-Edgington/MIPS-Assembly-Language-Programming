###########################################################################################
#                        Unit Tests for Matrix Arithmetic Homework                        #
#                             An extended version for grading                             #
#                                                                                         #
#  Padraic Edgington                                                         19 Nov, 2012 #
#                                                                                         #
#                                            v1.2                                         #
#  If there are bugs in this code, you may check back later for an updated version.       #
#                                                                                         #
#  You should write your code in a seperate file and prepend it to this file by running   #
#  either:                                                                                #
#  Windows: copy /Y <Matrix Function Name>.asm + MatrixArithmeticGrading.asm <output>.asm #
#  Unix:    cat <Matrix Function Name>.asm MatrixArithmeticGrading.asm > <output>.asm     #
#                                                                                         #
#  v.1    Initial release                                                                 #
#  v.1.1  Added the rest of the expected results, fixed bugs in the assertion functions   #
#  v.1.2  Fixed an error in the size of an identity matrix, added missing syscall         #
###########################################################################################
		.data
		#  Matrices are specified by # of rows and # of cols followed by elements listed in row major format.
A:		.word	5, 3, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
B:		.word	3, 5, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1
C:		.word	3, 3, 1, 2, 3, 4, 5, 6, 7, 8, 9
D:		.word	3, 3, 9, 8, 7, 6, 5, 4, 3, 2, 1
I3:		.word	3, 3, 1, 0, 0, 0, 1, 0, 0, 0, 1
I5:		.word	5, 5, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1
N1:		.word	-42, 3, 0
N2:		.word	3, -42, 0
N3:		.word	0, 3, 0
N4:		.word	3, 0, 0
B1:		.word	5, 15, 15, 23, 42, 12, 32, 74, 12, 93, 85, 12, 83, 28, 32, 73, 42, 83, 39, 27, 39, 17, 93, 73, 12, 73, 31, 32, 52, 53, 81, 32, 83, 52, 43, 25, 74, 83, 37, 74, 81, 97, 99, 10, 40, 38, 52, 90, 30, 38, 82, 74, 38, 93, 85, 28, 24, 20, 70, 48, 76, 50, 28, 95, 84, 72, 84, 28, 94, 83, 29, 10, 34, 88, 83, 92, 83
B1p:	.word	15, 5, 15, 83, 83, 90, 28, 23, 39, 52, 30, 95, 42, 27, 43, 38, 84, 12, 39, 25, 82, 72, 32, 17, 74, 74, 84, 74, 93, 83, 38, 28, 12, 73, 37, 93, 94, 93, 12, 74, 85, 83, 85, 73, 81, 28, 29, 12, 31, 97, 24, 10, 83, 32, 99, 20, 34, 28, 52, 10, 70, 88, 32, 53, 40, 48, 83, 73, 81, 38, 76, 92, 42, 32, 52, 50, 83
B2:		.word	5, 15, 14, 17, 69, 50, 24, 45, 35, 18, 95, 47, 36, 69, 11, 42, 67, 71, 83, 56, 48, 44, 56, 48, 42, 92, 58, 72, 25, 60, 50, 43, 12, 83, 97, 84, 84, 46, 10, 27, 13, 94, 69, 20, 89, 98, 26, 15, 74, 68, 16, 82, 68, 98, 53, 76, 47, 58, 99, 69, 23, 47, 56, 22, 81, 21, 14, 66, 24, 39, 33, 98, 72, 24, 26, 86, 52
B2p:	.word	15, 5, 14, 71, 12, 15, 56, 17, 83, 83, 74, 22, 69, 56, 97, 68, 81, 50, 48, 84, 16, 21, 24, 44, 84, 82, 14, 45, 56, 46, 68, 66, 35, 48, 10, 98, 24, 18, 42, 27, 53, 39, 95, 92, 13, 76, 33, 47, 58, 94, 47, 98, 36, 72, 69, 58, 72, 69, 25, 20, 99, 24, 11, 60, 89, 69, 26, 42, 50, 98, 23, 86, 67, 43, 26, 47, 52


E1:		.word	3, 3, 10, 10, 10, 10, 10, 10, 10, 10, 10
E2:		.word	3, 3, -8, -6, -4, -2, 0, 2, 4, 6, 8
E3:		.word	5, 5, 50, 44, 38, 32, 26, 140, 125, 110, 95, 80, 230, 206, 182, 158, 134, 320, 287, 254, 221, 188, 410, 368, 326, 284, 242
E4:		.word	3, 3, 425, 490, 555, 250, 290, 330, 75, 90, 105
E5:		.word	3, 3, 10, 0, 0, 0, 10, 0, 0, 0, 10
E6:		.word	3, 3, 2, 0, 0, 0, 2, 0, 0, 0, 2
E7:		.word	5, 5, 2, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 2
E8:		.word	3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0
E9:		.word	5, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
R1:		.word	5, 15, 29, 40, 111, 62, 56, 119, 47, 111, 180, 59, 119, 97, 43, 115, 109, 154, 122, 83, 87, 61, 149, 121, 54, 165, 89, 104, 77, 113, 131, 75, 95, 135, 140, 109, 158, 129, 47, 101, 94, 191, 168, 30, 129, 136, 78, 105, 104, 106, 98, 156, 106, 191, 138, 104, 71, 78, 169, 117, 99, 97, 84, 117, 165, 93, 98, 94, 118, 122, 62, 108, 106, 112, 109, 178, 135
R2:		.word	5, 15, 1, 6, -27, -38, 8, 29, -23, 75, -10, -35, 47, -41, 21, 31, -25, 12, -44, -29, -9, -27, 37, 25, -30, -19, -27, -40, 27, -7, 31, -11, 71, -31, -54, -59, -10, 37, 27, 47, 68, 3, 30, -10, -49, -60, 26, 75, -44, -30, 66, -8, -30, -5, 32, -48, -23, -38, -29, -21, 53, 3, -28, 73, 3, 51, 70, -38, 70, 44, -4, -88, -38, 64, 57, 6, 31
R3:		.word	5, 5, 30082, 38504, 35508, 39207, 34170, 32263, 43202, 37486, 43132, 36115, 36429, 53597, 49823, 51202, 46647, 33171, 44350, 43753, 48493, 36371, 40322, 52340, 57926, 61819, 41374
R4:		.word	15, 15, 10017, 21309, 22122, 13734, 18756, 17109, 14831, 11859, 17904, 20295, 19479, 14352, 19470, 17392, 12418, 9485, 12254, 18550, 9865, 10426, 13921, 8417, 8751, 11864, 18951, 15804, 8852, 11761, 16872, 10920, 8295, 11184, 17969, 9380, 10100, 13508, 8936, 8341, 12693, 17600, 14675, 10211, 10715, 15426, 11247, 8499, 13168, 16845, 7396, 11836, 14202, 12306, 9683, 13661, 16086, 14905, 12149, 12227, 12982, 10729, 8357, 15421, 22174, 11580, 14976, 16372, 11944, 10486, 13962, 21156, 17822, 13455, 15248, 18372, 12645, 10773, 19294, 23217, 16332, 16348, 16788, 12280, 10585, 20477, 21204, 19307, 13525, 17131, 19174, 14357, 12454, 18284, 22443, 10674, 15550, 18858, 15664, 12876, 18507, 21859, 20403, 14856, 16666, 18003, 14164, 8965, 16835, 26770, 14545, 17108, 19519, 14893, 11918, 20100, 24152, 20224, 18604, 16352, 20851, 16982, 9389, 16937, 22063, 15615, 14758, 15457, 10729, 9398, 18929, 20001, 17617, 12778, 15210, 18296, 13764, 4453, 12824, 14415, 10830, 11908, 9030, 5470, 5799, 7407, 13588, 11469, 6159, 12541, 12972, 6307, 6826, 14512, 21236, 15036, 13832, 13685, 8207, 7897, 14758, 19335, 15731, 11303, 13908, 18172, 12219, 10182, 12738, 17702, 7704, 10772, 15200, 12548, 10100, 15798, 17186, 15838, 12474, 11436, 13934, 12238, 10059, 13641, 19043, 10015, 11558, 14990, 10760, 9663, 14823, 18728, 16488, 11077, 12562, 16156, 12035, 13521, 18766, 25879, 13878, 16028, 20809, 16479, 13358, 23693, 24289, 22114, 17554, 16681, 20500, 17718, 8882, 13212, 19857, 10547, 12046, 14952, 10418, 9391, 14149, 19202, 16280, 11680, 12618, 16748, 12208
R5:		.word	5, 5, 30082, 32263, 36429, 33171, 40322, 38504, 43202, 53597, 44350, 52340, 35508, 37486, 49823, 43753, 57926, 39207, 43132, 51202, 48493, 61819, 34170, 36115, 46647, 36371, 41374
R6:		.word	15, 15, 10017, 9485, 8295, 8499, 8357, 10773, 12454, 8965, 9389, 4453, 6826, 10182, 10059, 13521, 8882, 21309, 12254, 11184, 13168, 15421, 19294, 18284, 16835, 16937, 12824, 14512, 12738, 13641, 18766, 13212, 22122, 18550, 17969, 16845, 22174, 23217, 22443, 26770, 22063, 14415, 21236, 17702, 19043, 25879, 19857, 13734, 9865, 9380, 7396, 11580, 16332, 10674, 14545, 15615, 10830, 15036, 7704, 10015, 13878, 10547, 18756, 10426, 10100, 11836, 14976, 16348, 15550, 17108, 14758, 11908, 13832, 10772, 11558, 16028, 12046, 17109, 13921, 13508, 14202, 16372, 16788, 18858, 19519, 15457, 9030, 13685, 15200, 14990, 20809, 14952, 14831, 8417, 8936, 12306, 11944, 12280, 15664, 14893, 10729, 5470, 8207, 12548, 10760, 16479, 10418, 11859, 8751, 8341, 9683, 10486, 10585, 12876, 11918, 9398, 5799, 7897, 10100, 9663, 13358, 9391, 17904, 11864, 12693, 13661, 13962, 20477, 18507, 20100, 18929, 7407, 14758, 15798, 14823, 23693, 14149, 20295, 18951, 17600, 16086, 21156, 21204, 21859, 24152, 20001, 13588, 19335, 17186, 18728, 24289, 19202, 19479, 15804, 14675, 14905, 17822, 19307, 20403, 20224, 17617, 11469, 15731, 15838, 16488, 22114, 16280, 14352, 8852, 10211, 12149, 13455, 13525, 14856, 18604, 12778, 6159, 11303, 12474, 11077, 17554, 11680, 19470, 11761, 10715, 12227, 15248, 17131, 16666, 16352, 15210, 12541, 13908, 11436, 12562, 16681, 12618, 17392, 16872, 15426, 12982, 18372, 19174, 18003, 20851, 18296, 12972, 18172, 13934, 16156, 20500, 16748, 12418, 10920, 11247, 10729, 12645, 14357, 14164, 16982, 13764, 6307, 12219, 12238, 12035, 17718, 12208
R7:		.word	5, 15, -1, -6, 27, 38, -8, -29, 23, -75, 10, 35, -47, 41, -21, -31, 25, -12, 44, 29, 9, 27, -37, -25, 30, 19, 27, 40, -27, 7, -31, 11, -71, 31, 54, 59, 10, -37, -27, -47, -68, -3, -30, 10, 49, 60, -26, -75, 44, 30, -66, 8, 30, 5, -32, 48, 23, 38, 29, 21, -53, -3, 28, -73, -3, -51, -70, 38, -70, -44, 4, 88, 38, -64, -57, -6, -31
		.text
		
main:	addi	$sp, $sp, 4			#  Make space for $ra on stack
		sw		$ra, 0 ($sp)		#  Store the return address on the stack

###############################################################################
##                          Testing mAdd function                            ##
###############################################################################
		#  Test #100
		#  I+I #1
		#######################################################################
		la		$a0, I3				#  Left matrix
		la		$a1, I3				#  Right matrix
		jal		mAdd				#  Call matrix addition function
		
		li		$a3, 100			#  Test #100
		move	$a0, $v0			#  Result
		la		$a1, E6				#  Expected result
		jal		assertEqual			#  Check for equality
		
		#  Test #101
		#  I+I #2
		#######################################################################
		la		$a0, I5				#  Left matrix
		la		$a1, I5				#  Right matrix
		jal		mAdd				#  Call matrix addition function
		
		li		$a3, 101			#  Test #101
		move	$a0, $v0			#  Result
		la		$a1, E7				#  Expected result
		jal		assertEqual			#  Check for equality
		
		
		#  Test #102
		#  Run C+D
		#######################################################################
		la		$a0, C				#  Left matrix
		la		$a1, D				#  Right matrix
		jal		mAdd				#  Call add function
		
		li		$a3, 102			#  Test #102
		move	$a0, $v0			#  Result
		la		$a1, E1				#  Expected result
		jal		assertEqual			#  Check for equality
		
		
		#  Test #103
		#  Run B1+B2
		#######################################################################
		la		$a0, B1				#  Left matrix
		la		$a1, B2				#  Right matrix
		jal		mAdd				#  Call matrix addition function
		
		li		$a3, 103			#  Test #104
		move	$a0, $v0			#  Result
		la		$a1, R1				#  Expected result
		jal		assertEqual			#  Check for equality
		
		
		#  Test #104
		#  Run B2+B1
		#######################################################################
		la		$a0, B2				#  Left matrix
		la		$a1, B1				#  Right matrix
		jal		mAdd				#  Call matrix addition function
		
		li		$a3, 104			#  Test #104
		move	$a0, $v0			#  Result
		la		$a1, R1				#  Expected result
		
		
		#  Test #105
		#  Run A+B
		#######################################################################
		la		$a0, A				#  Left matrix
		la		$a1, B				#  Right matrix
		jal		mAdd				#  Call matrix addition function
		
		li		$a3, 105			#  Test #105
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #106
		#  Run B+A
		#######################################################################
		la		$a0, B				#  Left matrix
		la		$a1, A				#  Right matrix
		jal		mAdd				#  Call matrix addition function
		
		li		$a3, 106			#  Test #106
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #108
		#  Addition with missing matrix #1
		#######################################################################
		li		$a0, 0				#  Left matrix
		la		$a1, D				#  Right matrix
		jal		mAdd				#  Call matrix addition function
		
		li		$a3, 108			#  Test #108
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #109
		#  Addition with missing matrix #2
		#######################################################################
		la		$a0, C				#  Left matrix
		li		$a1, 0				#  Right matrix
		jal		mAdd				#  Call matrix addition function
		
		li		$a3, 109			#  Test #109
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #110
		#  Addition with malformed matrix #1
		#######################################################################
		la		$a0, N1				#  Left matrix
		la		$a1, D				#  Right matrix
		jal		mAdd				#  Call matrix addition function
		
		li		$a3, 110			#  Test #110
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #111
		#  Addition with malformed matrix #2
		#######################################################################
		la		$a0, C				#  Left matrix
		la		$a1, N1				#  Right matrix
		jal		mAdd				#  Call matrix addition function
		
		li		$a3, 111			#  Test #111
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #112
		#  Addition with malformed matrix #3
		#######################################################################
		la		$a0, N1				#  Left matrix
		la		$a1, N1				#  Right matrix
		jal		mAdd				#  Call matrix addition function
		
		li		$a3, 112			#  Test #112
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #113
		#  Addition with malformed matrix #4
		#######################################################################
		la		$a0, N2				#  Left matrix
		la		$a1, D				#  Right matrix
		jal		mAdd				#  Call matrix addition function
		
		li		$a3, 113			#  Test #113
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #114
		#  Addition with malformed matrix #5
		#######################################################################
		la		$a0, C				#  Left matrix
		la		$a1, N2				#  Right matrix
		jal		mAdd				#  Call matrix addition function
		
		li		$a3, 114			#  Test #114
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #115
		#  Addition with malformed matrix #6
		#######################################################################
		la		$a0, N2				#  Left matrix
		la		$a1, N2				#  Right matrix
		jal		mAdd				#  Call matrix addition function
		
		li		$a3, 115			#  Test #115
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #116
		#  Addition with malformed matrix #7
		#######################################################################
		la		$a0, N3				#  Left matrix
		la		$a1, D				#  Right matrix
		jal		mAdd				#  Call matrix addition function
		
		li		$a3, 116			#  Test #116
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #117
		#  Addition with malformed matrix #8
		#######################################################################
		la		$a0, C				#  Left matrix
		la		$a1, N3				#  Right matrix
		jal		mAdd				#  Call matrix addition function
		
		li		$a3, 117			#  Test #117
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #118
		#  Addition with malformed matrix #9
		#######################################################################
		la		$a0, N3				#  Left matrix
		la		$a1, N3				#  Right matrix
		jal		mAdd				#  Call matrix addition function
		
		li		$a3, 118			#  Test #118
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #119
		#  Addition with malformed matrix #10
		#######################################################################
		la		$a0, N4				#  Left matrix
		la		$a1, D				#  Right matrix
		jal		mAdd				#  Call matrix addition function
		
		li		$a3, 119			#  Test #119
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #120
		#  Addition with malformed matrix #11
		#######################################################################
		la		$a0, C				#  Left matrix
		la		$a1, N4				#  Right matrix
		jal		mAdd				#  Call matrix addition function
		
		li		$a3, 120			#  Test #120
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #121
		#  Addition with malformed matrix #12
		#######################################################################
		la		$a0, N4				#  Left matrix
		la		$a1, N4				#  Right matrix
		jal		mAdd				#  Call matrix addition function
		
		li		$a3, 121			#  Test #121
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
###############################################################################
##                          Testing mSub function                            ##
###############################################################################
		#  Test #200
		#  I-I  #1
		#######################################################################
		la		$a0, I3				#  Left matrix
		la		$a1, I3				#  Right matrix
		jal		mSub				#  Call matrix subtraction function
		
		li		$a3, 200			#  Test #200
		move	$a0, $v0			#  Result
		la		$a1, E8				#  Expected result
		jal		assertEqual			#  Check for equality
		
		#  Test #201
		#  I-I #2
		#######################################################################
		la		$a0, I5				#  Left matrix
		la		$a1, I5				#  Right matrix
		jal		mSub				#  Call matrix subtraction function
		
		li		$a3, 201			#  Test #201
		move	$a0, $v0			#  Result
		la		$a1, E9				#  Expected result
		jal		assertEqual			#  Check for equality
		
		
		#  Test #202
		#  Run C-D
		#######################################################################
		la		$a0, C				#  Left matrix
		la		$a1, D				#  Right matrix
		jal		mSub				#  Call subtract function
		
		li		$a3, 202			#  Test #202
		move	$a0, $v0			#  Result
		la		$a1, E2				#  Expected result
		jal		assertEqual			#  Check for equality
		
		
		#  Test #203
		#  Run B1-B2
		#######################################################################
		la		$a0, B1				#  Left matrix
		la		$a1, B2				#  Right matrix
		jal		mSub				#  Call subtract function
		
		li		$a3, 203			#  Test #203
		move	$a0, $v0			#  Result
		la		$a1, R2				#  Expected result
		jal		assertEqual			#  Check for equality
		
		
		#  Test #204
		#  Run B2-B1
		#######################################################################
		la		$a0, B2				#  Left matrix
		la		$a1, B1				#  Right matrix
		jal		mSub				#  Call subtract function
		
		li		$a3, 204			#  Test #204
		move	$a0, $v0			#  Result
		la		$a1, R7				#  Expected result
		jal		assertEqual			#  Check for equality
		
		
		#  Test #205
		#  Run A-B
		#######################################################################
		la		$a0, A				#  Left matrix
		la		$a1, B				#  Right matrix
		jal		mSub				#  Call matrix subtraction function
		
		li		$a3, 205			#  Test #205
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #206
		#  Run B-A
		#######################################################################
		la		$a0, B				#  Left matrix
		la		$a1, A				#  Right matrix
		jal		mSub				#  Call matrix subtraction function
		
		li		$a3, 206			#  Test #206
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #207
		#  Subtraction with missing matrix #1
		#######################################################################
		li		$a0, 0				#  Left matrix
		la		$a1, D				#  Right matrix
		jal		mSub				#  Call matrix subtraction function
		
		li		$a3, 207			#  Test #207
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #208
		#  Subtraction with missing matrix #2
		#######################################################################
		la		$a0, C				#  Left matrix
		li		$a1, 0				#  Right matrix
		jal		mSub				#  Call matrix subtraction function
		
		li		$a3, 208			#  Test #208
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #209
		#  Subtraction with malformed matrix #1
		#######################################################################
		la		$a0, N1				#  Left matrix
		la		$a1, D				#  Right matrix
		jal		mSub				#  Call matrix addition function
		
		li		$a3, 209			#  Test #209
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #210
		#  Subtraction with malformed matrix #2
		#######################################################################
		la		$a0, C				#  Left matrix
		la		$a1, N1				#  Right matrix
		jal		mSub				#  Call matrix addition function
		
		li		$a3, 210			#  Test #210
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #211
		#  Subtraction with malformed matrix #3
		#######################################################################
		la		$a0, N1				#  Left matrix
		la		$a1, N1				#  Right matrix
		jal		mSub				#  Call matrix addition function
		
		li		$a3, 211			#  Test #211
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #212
		#  Subtraction with malformed matrix #4
		#######################################################################
		la		$a0, N2				#  Left matrix
		la		$a1, D				#  Right matrix
		jal		mSub				#  Call matrix addition function
		
		li		$a3, 212			#  Test #212
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #213
		#  Subtraction with malformed matrix #5
		#######################################################################
		la		$a0, C				#  Left matrix
		la		$a1, N2				#  Right matrix
		jal		mSub				#  Call matrix addition function
		
		li		$a3, 213			#  Test #213
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #214
		#  Subtraction with malformed matrix #6
		#######################################################################
		la		$a0, N2				#  Left matrix
		la		$a1, N2				#  Right matrix
		jal		mSub				#  Call matrix addition function
		
		li		$a3, 214			#  Test #214
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #215
		#  Subtraction with malformed matrix #7
		#######################################################################
		la		$a0, N3				#  Left matrix
		la		$a1, D				#  Right matrix
		jal		mSub				#  Call matrix addition function
		
		li		$a3, 215			#  Test #215
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #216
		#  Subtraction with malformed matrix #8
		#######################################################################
		la		$a0, C				#  Left matrix
		la		$a1, N3				#  Right matrix
		jal		mSub				#  Call matrix addition function
		
		li		$a3, 216			#  Test #216
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #217
		#  Subtraction with malformed matrix #9
		#######################################################################
		la		$a0, N3				#  Left matrix
		la		$a1, N3				#  Right matrix
		jal		mSub				#  Call matrix addition function
		
		li		$a3, 217			#  Test #217
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #218
		#  Subtraction with malformed matrix #10
		#######################################################################
		la		$a0, N4				#  Left matrix
		la		$a1, D				#  Right matrix
		jal		mSub				#  Call matrix addition function
		
		li		$a3, 218			#  Test #218
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #219
		#  Subtraction with malformed matrix #11
		#######################################################################
		la		$a0, C				#  Left matrix
		la		$a1, N4				#  Right matrix
		jal		mSub				#  Call matrix addition function
		
		li		$a3, 219			#  Test #219
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #220
		#  Subtraction with malformed matrix #12
		#######################################################################
		la		$a0, N4				#  Left matrix
		la		$a1, N4				#  Right matrix
		jal		mSub				#  Call matrix addition function
		
		li		$a3, 220			#  Test #220
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
###############################################################################
##                          Testing cMult function                            ##
###############################################################################
		#  Test #300
		#  Run 10*I3
		#######################################################################
		li		$a0, 10				#  Constant
		la		$a1, I3				#  Matrix
		jal		cMult				#  Call constant multiply function
		
		li		$a3, 300			#  Test #300
		move	$a0, $v0			#  Result
		la		$a1, E5				#  Expected result
		jal		assertEqual			#  Check for equality
		
		
		#  Test #301
		#  Constant multiplication with missing matrix
		#######################################################################
		li		$a0, 5				#  Constant
		li		$a1, 0				#  Matrix
		jal		cMult				#  Call constant multiplication function
		
		li		$a3, 301			#  Test #301
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #302
		#  Constant multiplication with malformed matrix #1
		#######################################################################
		li		$a0, 5				#  Constant
		la		$a1, N1				#  Matrix
		jal		cMult				#  Call constant multiply function
		
		li		$a3, 302			#  Test #302
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #303
		#  Constant multiplication with malformed matrix #2
		#######################################################################
		li		$a0, 5				#  Constant
		la		$a1, N2				#  Matrix
		jal		cMult				#  Call constant multiply function
		
		li		$a3, 303			#  Test #303
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #304
		#  Constant multiplication with malformed matrix #3
		#######################################################################
		li		$a0, 5				#  Constant
		la		$a1, N3				#  Matrix
		jal		cMult				#  Call constant multiply function
		
		li		$a3, 304			#  Test #304
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #305
		#  Constant multiplication with malformed matrix #4
		#######################################################################
		li		$a0, 5				#  Constant
		la		$a1, N4				#  Matrix
		jal		cMult				#  Call constant multiply function
		
		li		$a3, 305			#  Test #305
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
###############################################################################
##                          Testing mMult function                           ##
###############################################################################
		#  Test #400
		#  I*I #1
		#######################################################################
		la		$a0, I3				#  Left matrix
		la		$a1, I3				#  Right matrix
		jal		mMult				#  Call matrix multiplication function
		
		li		$a3, 400			#  Test #400
		move	$a0, $v0			#  Result
		la		$a1, I3				#  Expected result
		jal		assertEqual			#  Check for equality
		
		
		#  Test #401
		#  I*I #2
		#######################################################################
		la		$a0, I5				#  Left matrix
		la		$a1, I5				#  Right matrix
		jal		mMult				#  Call matrix multiplication function
		
		li		$a3, 401			#  Test #401
		move	$a0, $v0			#  Result
		la		$a1, I5				#  Expected result
		jal		assertEqual			#  Check for equality
		
		
		#  Test #402
		#  Run A*B
		#######################################################################
		la		$a0, A				#  Left matrix
		la		$a1, B				#  Right matrix
		jal		mMult				#  Call matrix multiplication function
		
		li		$a3, 402			#  Test #402
		move	$a0, $v0			#  Result
		la		$a1, E3				#  Expected result
		jal		assertEqual			#  Check for equality
		
		
		#  Test #403
		#  Run B*A
		#######################################################################
		la		$a0, B				#  Left matrix
		la		$a1, A				#  Right matrix
		jal		mMult				#  Call matrix multiplication function
		
		li		$a3, 403			#  Test #403
		move	$a0, $v0			#  Result
		la		$a1, E4				#  Expected result
		jal		assertEqual			#  Check for equality
		
		
		#  Test #404
		#  Run I*A
		#######################################################################
		la		$a0, I5				#  Left matrix
		la		$a1, A				#  Right matrix
		jal		mMult				#  Call matrix multiplication function
		
		li		$a3, 404			#  Test #404
		move	$a0, $v0			#  Result
		la		$a1, A				#  Expected result
		jal		assertEqual			#  Check for equality
		
		
		#  Test #405
		#  Run B*I
		#######################################################################
		la		$a0, B				#  Left matrix
		la		$a1, I5				#  Right matrix
		jal		mMult				#  Call matrix multiplication function
		
		li		$a3, 405			#  Test #405
		move	$a0, $v0			#  Result
		la		$a1, B				#  Expected result
		jal		assertEqual			#  Check for equality
		
		
		#  Test #406
		#  Run B1*B2'
		#######################################################################
		la		$a0, B1				#  Left matrix
		la		$a1, B2p			#  Right matrix
		jal		mMult				#  Call matrix multiplication function
		
		li		$a3, 406			#  Test #406
		move	$a0, $v0			#  Result
		la		$a1, R3				#  Expected result
		jal		assertEqual			#  Check for equality
		
		
		#  Test #407
		#  Run B1'*B2
		#######################################################################
		la		$a0, B1p			#  Left matrix
		la		$a1, B2				#  Right matrix
		jal		mMult				#  Call matrix multiplication function
		
		li		$a3, 407			#  Test #407
		move	$a0, $v0			#  Result
		la		$a1, R4				#  Expected result
		jal		assertEqual			#  Check for equality
		
		
		#  Test #408
		#  Run B2*B1'
		#######################################################################
		la		$a0, B2				#  Left matrix
		la		$a1, B1p			#  Right matrix
		jal		mMult				#  Call matrix multiplication function
		
		li		$a3, 408			#  Test #408
		move	$a0, $v0			#  Result
		la		$a1, R5				#  Expected result
		jal		assertEqual			#  Check for equality
		
		
		#  Test #409
		#  Run B2'*B1
		#######################################################################
		la		$a0, B2p			#  Left matrix
		la		$a1, B1				#  Right matrix
		jal		mMult				#  Call matrix multiplication function
		
		li		$a3, 409			#  Test #409
		move	$a0, $v0			#  Result
		la		$a1, R6				#  Expected result
		jal		assertEqual			#  Check for equality
		
		
		#  Test #410
		#  Run A*A
		#######################################################################
		la		$a0, A				#  Left matrix
		la		$a1, A				#  Right matrix
		jal		mMult				#  Call matrix multiplication function
		
		li		$a3, 410			#  Test #410
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #411
		#  Run B*B
		#######################################################################
		la		$a0, B				#  Left matrix
		la		$a1, B				#  Right matrix
		jal		mMult				#  Call matrix multiplication function
		
		li		$a3, 411			#  Test #411
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #412
		#  Matrix multiplication with missing matrix #1
		#######################################################################
		li		$a0, 0				#  Left matrix
		la		$a1, B				#  Right matrix
		jal		mMult				#  Call matrix multiplication function
		
		li		$a3, 412			#  Test #412
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #413
		#  Matrix multiplication with missing matrix #2
		#######################################################################
		la		$a0, A				#  Left matrix
		li		$a1, 0				#  Right matrix
		jal		mMult				#  Call matrix multiplication function
		
		li		$a3, 413			#  Test #413
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #414
		#  Matrix multiplication with malformed matrix #1
		#######################################################################
		la		$a0, N1				#  Left matrix
		la		$a1, B				#  Right matrix
		jal		mMult				#  Call matrix multiplication function
		
		li		$a3, 414			#  Test #414
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #415
		#  Matrix multiplication with malformed matrix #2
		#######################################################################
		la		$a0, A				#  Left matrix
		la		$a1, N1				#  Right matrix
		jal		mMult				#  Call matrix multiplication function
		
		li		$a3, 415			#  Test #415
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #416
		#  Matrix multiplication with malformed matrix #3
		#######################################################################
		la		$a0, N1				#  Left matrix
		la		$a1, N1				#  Right matrix
		jal		mMult				#  Call matrix multiplication function
		
		li		$a3, 416			#  Test #416
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #417
		#  Matrix multiplication with malformed matrix #4
		#######################################################################
		la		$a0, N2				#  Left matrix
		la		$a1, B				#  Right matrix
		jal		mMult				#  Call matrix multiplication function
		
		li		$a3, 417			#  Test #417
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #418
		#  Matrix multiplication with malformed matrix #5
		#######################################################################
		la		$a0, A				#  Left matrix
		la		$a1, N2				#  Right matrix
		jal		mMult				#  Call matrix multiplication function
		
		li		$a3, 418			#  Test #418
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #419
		#  Matrix multiplication with malformed matrix #6
		#######################################################################
		la		$a0, N2				#  Left matrix
		la		$a1, N2				#  Right matrix
		jal		mMult				#  Call matrix multiplication function
		
		li		$a3, 419			#  Test #419
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #420
		#  Matrix multiplication with malformed matrix #7
		#######################################################################
		la		$a0, N1				#  Left matrix
		la		$a1, N2				#  Right matrix
		jal		mMult				#  Call matrix multiplication function
		
		li		$a3, 420			#  Test #420
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #421
		#  Matrix multiplication with malformed matrix #8
		#######################################################################
		la		$a0, N2				#  Left matrix
		la		$a1, N1				#  Right matrix
		jal		mMult				#  Call matrix multiplication function
		
		li		$a3, 421			#  Test #421
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #422
		#  Matrix multiplication with malformed matrix #9
		#######################################################################
		la		$a0, N3				#  Left matrix
		la		$a1, B				#  Right matrix
		jal		mMult				#  Call matrix multiplication function
		
		li		$a3, 422			#  Test #422
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #423
		#  Matrix multiplication with malformed matrix #10
		#######################################################################
		la		$a0, A				#  Left matrix
		la		$a1, N3				#  Right matrix
		jal		mMult				#  Call matrix multiplication function
		
		li		$a3, 423			#  Test #423
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #424
		#  Matrix multiplication with malformed matrix #11
		#######################################################################
		la		$a0, N3				#  Left matrix
		la		$a1, N3				#  Right matrix
		jal		mMult				#  Call matrix multiplication function
		
		li		$a3, 424			#  Test #424
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #425
		#  Matrix multiplication with malformed matrix #12
		#######################################################################
		la		$a0, N4				#  Left matrix
		la		$a1, B				#  Right matrix
		jal		mMult				#  Call matrix multiplication function
		
		li		$a3, 425			#  Test #425
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #426
		#  Matrix multiplication with malformed matrix #13
		#######################################################################
		la		$a0, A				#  Left matrix
		la		$a1, N4				#  Right matrix
		jal		mMult				#  Call matrix multiplication function
		
		li		$a3, 426			#  Test #426
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #427
		#  Matrix multiplication with malformed matrix #14
		#######################################################################
		la		$a0, N4				#  Left matrix
		la		$a1, N4				#  Right matrix
		jal		mMult				#  Call matrix multiplication function
		
		li		$a3, 427			#  Test #427
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #428
		#  Matrix multiplication with malformed matrix #15
		#######################################################################
		la		$a0, N3				#  Left matrix
		la		$a1, N4				#  Right matrix
		jal		mMult				#  Call matrix multiplication function
		
		li		$a3, 428			#  Test #428
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
		#  Test #429
		#  Matrix multiplication with malformed matrix #16
		#######################################################################
		la		$a0, N4				#  Left matrix
		la		$a1, N3				#  Right matrix
		jal		mMult				#  Call matrix multiplication function
		
		li		$a3, 429			#  Test #429
		move	$a0, $v0			#  Result
		jal		assertFail			#  Check for error
		
		
###############################################################################
##                             Quit unit testing                             ##
###############################################################################
		lw		$ra, 0 ($sp)		#  Restore return address
		addi	$sp, $sp, -4		#  Remove the return address from the stack
		jr		$ra					#  Return to caller
		
		
###############################################################################
##                            Assertion functions                            ##
###############################################################################
		#  Assert Equality
		#######################################################################
assertEqual:
		.data
eq1:	.asciiz	"Test #"
eq2:	.asciiz " failed:  Expected value:  "
eq3:	.asciiz	" \tObserved value:  "
eq4:	.asciiz "\n"
eq5:	.asciiz " failed:  The result matrix was not the correct size.\n"
		.text
		
		move	$s7, $a3			#  Save test #
		beq		$a0, $0, default	#  If the result pointer is null, then just fail.
		
		lw		$t0, 0 ($a0)		#  Result # of rows
		lw		$t1, 4 ($a0)		#  Result # of columns
		lw		$s0, 0 ($a1)		#  Expected # of rows
		lw		$s1, 4 ($a1)		#  Expected # of columns
		
		bne		$t0, $s0, failSize	#  If the number of rows does not match, then fail
		bne		$t1, $s1, failSize	#  If the number of columns does not match, then fail
		li		$t3, 8				#  Initialize array counter
		mult	$t0, $t1			#  Calculate number of elements in the matrix
		mflo	$t4
		addi	$t4, $t4, 2	
		sll		$t4, $t4, 2			#  Termination condition
		
aeLoop:	beq		$t3, $t4, Pass		#  If all elements are correct, then the result is correct
		add		$t5, $t3, $a0
		lw		$t5, 0 ($t5)		#  Fetch current element in the result matrix
		add		$t6, $t3, $a1
		lw		$t6, 0 ($t6)		#  Fetch current element in the expected matrix
		
		bne		$t5, $t6, aeFail	#  If the elements are not the same, then fail
		addi	$t3, $t3, 4			#  Increment array counter
		j		aeLoop				#  Check next element
		
aeFail:	li		$v0, 4				#  Print string
		la		$a0, eq1			#  "Test #"
		syscall
		
		li		$v0, 1				#  Print test number
		move	$a0, $s7
		syscall
		
		li		$v0, 4				#  Print string
		la		$a0, eq2			#  " failed:  Expected value:  "
		syscall
		
		li		$v0, 1				#  Print expected value
		move	$a0, $t6
		syscall
		
		li		$v0, 4				#  Print string
		la		$a0, eq3			#  " Observed value:  "
		syscall
		
		li		$v0, 1				#  Print observed value
		move	$a0, $t5
		syscall
		
		li		$v0, 4				#  Print string
		la		$a0, eq4			#  "\n"
		syscall

#  Switch commenting on the next three lines to continue checking after finding inequal numbers.
#  This may help in debugging at the cost of many more lines of error text.
#		addi	$t3, $t3, 4			#  Incerement the array counter
#		j		aeLoop				#  Check next element
		jr		$ra					#  Quit processing this matrix
		
failSize:
		li		$v0, 4				#  Print string
		la		$a0, eq1			#  "Test #"
		syscall
		
		li		$v0, 1				#  Print test number
		move	$a0, $s7
		syscall
		
		li		$v0, 4				#  Print string
		la		$a0, eq5			#  " failed:  The result matrix was not the correct size.\n"
		syscall
		
#  If the matrices are the wrong size, then we should not continue to attempt to read the matrices.
		jr		$ra					#  Incorrect matrix size
		
		
		#  Assert Failure
		#######################################################################
assertFail:
		.data
fail1:	.asciiz	"Test #"
fail2:	.asciiz " failed.  The function returned a pointer.\n"
		.text
		
		move	$s7, $a3			#  Store test number
		bne		$a0, $zero, fFail	#  If the pointer is not null, then fail
		j		Pass

fFail:	li		$v0, 4				#  Print string
		la		$a0, fail1			#  "Test #"
		syscall
		
		li		$v0, 1				#  Print test number
		move	$a0, $s7
		syscall
		
		li		$v0, 4				#  Print string
		la		$a0, fail2			#  " failed.  The function returned a pointer.\n"
		syscall
		
		jr		$ra					#  Failed null pointer check
		
		
		#  Default Failure
		#######################################################################
		.data
d1:		.asciiz	" has not yet been implemented (or for some other reason received a null pointer.)\n"
		.text
default:
		li		$v0, 4				#  Print string
		la		$a0, eq1			#  "Test #"
		syscall
		
		li		$v0, 1				#  Print test number
		move	$a0, $s7
		syscall
		
		li		$v0, 4				#  Print string
		la		$a0, d1				#  " has not yet been implemented.\n"
		syscall
		
		jr		$ra					#  Procedure has not yet been implemented
		
		
		#  Assertion Success
		#######################################################################
		.data
s1:		.asciiz	" passed.\n"
		.text
Pass:	li		$v0, 4				#  Print string
		la		$a0, eq1			#  "Test #"
		syscall
		
		li		$v0, 1				#  Print test number
		move	$a0, $s7
		syscall
		
		li		$v0, 4				#  Print string
		la		$a0, s1				#  " passed.\n"
		syscall
		
		jr		$ra					#  Successfully checked all numbers in the matrix
		

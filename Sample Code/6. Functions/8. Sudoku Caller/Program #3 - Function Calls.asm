#############################################################################################
#                                 Function Call Example										#
#																							#
#  Padraic Edgington                                                          18 Jan, 2015	#
#																							#
#  v. 1		Initial release  (It appears to work.)											#
#############################################################################################

		.text
main:	li		$v0, 4
		la		$a0, Menu
		syscall
		
		li		$v0, 5
		syscall

		#  A case statement in assembly.
		beq		$v0, 1, EasyProblem				#  Chose an easy problem.
		beq		$v0, 2, MediumProblem			#  Chose a medium problem.
		beq		$v0, 3, HardProblem				#  Chose a hard problem.
		beq		$v0, 4, EvilProblem				#  Chose an evil problem.
		beq		$v0, 5, UnsolvableProblem		#  Chose an unsolvable problem.
		beq		$v0, 6, Quit					#  Chose to quit.
		j		main							#  Default.

EasyProblem:
		la		$a0, Easy						#  Select the easy problem.
		j		solve_Problem
MediumProblem:
		la		$a0, Medium						#  Select the medium problem.
		j		solve_Problem
HardProblem:
		la		$a0, Hard						#  Select the hard problem.
		j		solve_Problem
EvilProblem:
		la		$a0, Evil						#  Select the evil problem.
		j		solve_Problem
UnsolvableProblem:
		la		$a0, Unsolvable					#  Select the unsolvable problem.
		j		solve_Problem
Quit:
		li		$v0, 10
		syscall
		
		#  Call the Sudoku solving function then print the results.
solve_Problem:
		move	$s0, $a0
		jal		Sudoku_solver
		move	$s1, $v0
		
		move	$a0, $s0
		move	$a1, $s1
		jal		Print_Sudoku
		
		j		main

		.data
Menu:	.asciiz	"1. An easy puzzle\n2. A medium puzzle\n3. A hard puzzle\n4. An evil puzzle\n5. An unsolvable puzzle\n6. Quit\nChoose an option:  "

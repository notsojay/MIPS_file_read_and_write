.include "file_read_write.asm"

.data
new_line: .asciiz "\n"
space: .asciiz " "
pi_str: .asciiz "Program input:\n" 
po_str: .asciiz "Obtained output:\n" 
eo_str: .asciiz "Expected output:\n"
tl_str: .asciiz "Testing load_pts_file:\n" 
pda_str: .asciiz "Obtained dist_array:\n"
eda_str: .asciiz "Expected dist_array:\n"
ts_str: .asciiz "Testing save_dist_list:\n"
sdl_str: .asciiz "Obtained result:\n(Check your output file)\n"

lpf_expected_outputs:   .word 8
dist_expected_outputs:  .word 3597, 35984, 34939, 37859, 3919, 3839, 3493, 4595, -9, -10


pts_file_name:
	.asciiz	"nums.dat"	# Input Points file name

dist_file_name:
	.asciiz "dist.dat"  # Output Distance file name
	.word	0

size_of_dist_array:	.word 10
dist_array: 		.word -1, -2, -3, -4, -5, -6, -7, -8, -9, -10  # Place to store integers

data_buffer: 
#	.byte 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26
	.space 300  # Place to store characters


###############################################################
#                           Text Section
.text
.globl main

# Utility function to print integer arrays
# a0: array
# a1: length
print_array:

li $t1, 0
move $t2, $a0
print_iter:

lw $a0, ($t2)
li $v0, 1   
syscall

li $v0, 4
la $a0, space
syscall

addi $t2, $t2, 4
addi $t1, $t1, 1
blt $t1, $a1, print_iter

la $a0, new_line
syscall

li $v0, -1
jr $ra

###############################################################
###############################################################
###############################################################

#                          Main Function
main:

###############################################################
# Test load_pts_file function
li $v0, 4
la $a0, tl_str
syscall
la $a0, eo_str
syscall
la $a0, lpf_expected_outputs
li $a1, 1
jal print_array

la $a0, pts_file_name
la $a1, dist_array
jal load_pts_file
move $s0, $v0

li $v0, 4
la $a0, po_str
syscall
li $v0, 1
move $a0, $s0
syscall
li $v0, 4
la $a0, new_line
syscall
la $a0, eda_str
syscall
la $a0, dist_expected_outputs
la $t0, size_of_dist_array
lw $a1, 0($t0)
jal print_array
li $v0, 4
la $a0, pda_str
syscall
la $a0, dist_array
la $t0, size_of_dist_array
lw $a1, 0($t0)
jal print_array

li $v0, 4
la $a0, new_line
syscall

###############################################################
# Test save_dist_list function
###############################################################
la $s1, dist_expected_outputs
la $s2, lpf_expected_outputs
lw $s2, 0($s2)
###############################################################
# If you have finished part3A, you may un-comment the following 
# code block to forward part3A result to be part3B input.
la $s1, dist_array
move $s2, $s0
###############################################################
li $v0, 4
la $a0, ts_str
syscall
la $a0, pi_str
syscall
move $a0, $s1
la $a1, size_of_dist_array
lw $a1, 0($a1)
jal print_array
li $v0, 1
move $a0, $s2
syscall
li $v0, 4
la $a0, new_line
syscall
la $a0, dist_file_name
move $a1, $s1
move $a2, $s2
jal save_dist_list

li $v0, 4
la $a0, sdl_str
syscall

_end:
# end program
li $v0, 10
syscall

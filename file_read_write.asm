#                         ICS 51, Lab #3
#
#      IMPORTANT NOTES:
#
#      Write your assembly code only in the marked blocks.
#
#      DO NOT change anything outside the marked blocks.
#
###############################################################
#                           Text Section
.text


###############################################################
###############################################################
###############################################################
#                           PART 3A (SYSCALL: file read, ASCII to Integer)
#
# $a0: the address of the string that represents the input file name
# $a1: the base address of an integer array that will be used to store distances
# data_buffer : the buffer that you use to hold data for file read (MAXIMUM: 300 bytes)
load_pts_file:
############################### Part 3A: your code begins here ##
# Open the file
move $t9, $a1
li $v0, 13       # system call for open file
#la $a0, pts_file_name
# a0 is already ready for file name
li $a1, 0        # Open for reading (flags are 0: read, 1: write)
li $a2, 0        # mode is ignored
syscall            # open a file (file descriptor returned in $v0)
move $t0, $v0      # save the file descriptor 

li $v0, 14       # system call for read file
move $a0, $t0      # file descriptor 
la  $a1, data_buffer   # address of buffer from which to read
li  $a2, 300       # max hardcoded buffer length
syscall            # read file

li $t1, 0 # index of buffer array
li $t2, 0 # tempVal
li $t3, 0 # index of data array
li $t4, 0
li $t5, 0 # final number in the file separated by spaces
li $t6, 0 # leftVal, and distance
li $t7, 0 # count the number of distances calculated.
move $a1, $t9

read_buffer_loop:
lb $t2, data_buffer($t1)
addi $t1, $t1, 1 # ++i
beq $t2, $zero, exit_buffer_loop # if t2 == null
beq $t2, 0x20, get_left_val # if t2 == whitespace
beq $t2, 0x0A, get_right_val # if t2 == \n
beq $t2, 0x2D, add_negative_sign # if t2 == -, which mean negative sign
subi $t2, $t2, '0'
# eg: How to get 32 from 2 single nums of 3 and 2?
# first: mul 3, 3, 10 to get 30
# second: add 30 and  2, then we get 32
mul $t5, $t5, 10
add $t5, $t5, $t2
j read_buffer_loop

get_left_val:
# Only after the last character of the number,
# we can turn the number into a negative number:
beq $t4, 0, glv_else
mul $t5, $t5, -1
li $t4, 0
glv_else:
move $t6, $t5
li $t5, 0
j read_buffer_loop

get_right_val:
# Only after the last character of the number,
# we can turn the number into a negative number:
beq $t4, 0, grv_else
mul $t5, $t5, -1
li $t4, 0
grv_else:
sub $t6, $t5, $t6 # distance = rightVal - leftVal
bge $t6, 0, positve_else
mul $t6, $t6, -1
positve_else:
sw $t6, 0($t9)
addi $t9, $t9, 4
li $t6, 0
li $t5, 0
addi $t7, $t7, 1
li $t4, 0
j read_buffer_loop

add_negative_sign:
li $t4, 1
j read_buffer_loop

exit_buffer_loop:
li $v0, 16 # close file
move $a0, $t0 # file descrip to close
syscall
move $v0, $t7
############################### Part 3A: your code ends here   ##
jr $ra

###############################################################
###############################################################
###############################################################
#                           PART 3B (SYSCALL: file write, Integer to ASCII)
#
# $a0: the address of the string that represents the output file name
# $a1: the base address of an integer array that stores distances
# $a2: the number of valid distances to the integer array
# data_buffer : the buffer that you use to hold data for file read (MAXIMUM: 300 bytes)
save_dist_list:
############################### Part 3B: your code begins here ##
# open file:
move $t5, $a1
move $t8, $a2
li $v0, 13
li $a1, 1
li $a2, 0
syscall
move $t0, $v0

move $a1, $t5
move $a2, $t8
# write in buffer:
li $t1, 0 # high boundary
li $t5, 0 # lower boundary
li $t8, 0 # total char count in buffer
li $t4, '\n'

int_array_traversal:
beqz $a2, exit_int_array_traversal
lw $t2, 0($a1)
addi $a1, $a1, 4
subi $a2, $a2, 1
blt $t2, 10, store_single
j get_low_boundary

store_single:
addi $t2, $t2, '0'
sb $t2, data_buffer($t8)
li $t1, 0
addi $t8, $t8, 1
sb $t4, data_buffer($t8) # store '\n'
addi $t8, $t8, 1
j int_array_traversal

get_low_boundary:
move $t5, $t8
get_single_char_loop:
beqz $t2, exit_single_char_loop
div $t2, $t2, 10
mfhi $t3
addi $t3, $t3, '0'
sb $t3, data_buffer($t8)
addi $t8, $t8, 1
j get_single_char_loop

exit_single_char_loop:
subi $t1, $t8, 1
reverse_buffer:
bge $t5, $t1, exit_reverse_buffer
lb $t6, data_buffer($t5)
lb $t7, data_buffer($t1)
sb $t6, data_buffer($t1)
sb $t7, data_buffer($t5)
subi $t1, $t1, 1
addi $t5, $t5, 1
j reverse_buffer

exit_reverse_buffer:
sb $t4, data_buffer($t8) # store '\n'
addi $t8, $t8, 1
move $t1, $t8
move $t5, $t8
j int_array_traversal

exit_int_array_traversal:
# write file:
li $v0, 15
move $a0, $t0
la $a1, data_buffer
move $a2, $t8
syscall

# close file:
li $v0, 16
move $a0, $t0
syscall
############################### Part 3B: your code ends here   ##
jr $ra

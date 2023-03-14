# mips_file_read_and_write
## load_pts_file:
Complete load_pts_file function that reads multiple pairs of numbers from a file and finds the distance between every two numbers on a number line:
Few steps as the guidance
        1) Open/Read the .dat file into a pre-allocated given space, data_buffer.
        2) The format is fixed in every single line of the file, parse the content
            and interpret each as an integer number.
        3) Finding distances from the every-two-number, iteratively store the distance to an integer array
            (note: the base address is given in $a1).
        4) Return the number of distances calculated.
For example:
<img width="459" alt="截屏2023-03-14 04 40 56" src="https://user-images.githubusercontent.com/71242774/224990349-162f3cbc-878d-4da1-97d8-92084c746906.png">
The above example shows that load_pts_file function
- opens/reads lab3_pts.dat file (into data_buffer),
- parses and interprets '1' as the integer numbers, 1, and '2' as 2
- finds the distance of 1 and 2 to be 1 and updates the distance array
- repeats the above two until the end of file, then returns 4 distances calculated.

NOTE: you can safely assume
I. the file will strictly follow such <NUMBER> <SPACE> <NUMBER> <NEW LINE> format in every single line.
II. there will be at least one line in the file.
III. The file won't exceed 300 bytes, i.e. you don't need to worry about out of memory in the given space, data_buffer.
IV. The default values in data_buffer were all 0.

Arguments and Given parameters:
>> $a0: the address of the string that represents the input file name, "lab3_pts.dat".
>> $a1: the base address of an integer array that will be used to store distances
>> data_buffer: the buffer that you use to hold data for file read/write (MAXIMUM: 300 bytes)

## save_dist_list:
Complete save_dist_list function that saves N distances' values into a file
For example:
<img width="463" alt="截屏2023-03-14 04 40 43" src="https://user-images.githubusercontent.com/71242774/224990376-864406b3-6e1f-4a54-82e0-5c069b80580c.png">
Note: the NEWLINE character (at the end of every line) is not visible.

The above example shows that save_dist_list function takes 4 distances from the distance array, converts integers into ASCII characters, as a result of "1 <NEWLINE> 1 <NEWLINE> 7 <NEWLINE> 2 3 <NEWLINE>" in the data_buffer, then makes syscall to write 9 characters from this string into lab3_dist.dat file.

Thought before starting to code: How to convert 23 into '2', '3'? other examples, 123 -> '1', '2', '3'?

NOTE: you can safely assume
I. The distances to save are guaranteed positive/valid, e.g. N=4, the first four numbers in the array must be positive.

Arguments and Given parameters:
>> $a0: the address of the string that represents the output file name, "lab3_dist.dat".
>> $a1: the base address of an integer array that stores distances
>> $a2: the number of distances to save from an integer array
>> data_buffer: the buffer that you use to hold data for file read/write (MAXIMUM: 300 bytes)


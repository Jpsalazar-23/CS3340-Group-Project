# CS3340-Group-Project
The most recent upload of the project file reads an asm file and then handles it line by line. Play with it and try to bridge it to your instruction handling functions. Right now it just prints out every instruction line with the number of arguments that each line uses. See the comment for how each argument number should be interpreted.


The .data and .text directives still need to be split and handled separately but right now, there should be enough here to test the instruction-handling routines.

Still working on the R-type file. Need to fix the array declarations as it is not building currently, might have to change syntax or data type. Plan is to compate instruction read from Casey's file with strings in the array to decide appropriate funct code. WIll do the same with registers. After thats figured out I'll need to look at how to handle the immediate values...

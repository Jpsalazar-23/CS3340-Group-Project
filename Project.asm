.data  
file: .asciiz "input.asm"      # filename for input
newline: .byte 0x0A
comma: .byte 0x2C
period: .byte 0x2E
colon: .byte 0x3A
space: .byte 0x20
hashtag: .byte 0x23
zero: .byte 0x00
buffer: .space 2048
line: .space 256
lineBufferSize: .word 255
.text
#open a file for reading
li   $v0, 13       # system call for open file
la   $a0, file     # read file name
li   $a1, 0        # Open for reading
li   $a2, 0
syscall            # open a file (file descriptor returned in $v0)
move $s6, $v0      # save the file descriptor 

#read from file
li   $v0, 14       # system call for read from file
move $a0, $s6      # file address 
la   $a1, buffer   # address of buffer to which to read
li   $a2, 2048     # hardcoded buffer length
syscall            # read from file

# Close the file 
li   $v0, 16       # system call for close file
move $a0, $s6      # file descriptor to close
syscall            # close file

la $a1, buffer        # pass address of str1
la $a2, newline       # pass address of str2
jal getLine      # call methodComp

getLine:  
la $s0,line
add $t0,$a1,$zero
lb $t2, 0($a2)
loop:  
lb $t1($t0)         # load a byte from each string  
beqz $t1, endLine    # str1 end
addi $t0, $t0,1      # t1 points to the next byte of str1
beq $t1,$t2, foundNewline    # compare two bytes
sb $t1, ($s0)
addi $s0, $s0,1
j loop
foundNewline:
la $a0, line
jal handleLine
j clearLineBuffer

handleLine:
la $s0, ($a0)
la $s7, ($a0)
lb $t3, hashtag
lb $t4, comma
lb $t5, period
lb $t6, colon
lb $t7, space
add $t8, $zero, $zero
add $t9, $zero, $zero
loop2:  
lb $t1($s0)         # load a byte from each string  
beqz $t1, handleInstruction   # str1 end
addi $s0, $s0, 1     # t1 points to the next byte of str1
beq $t1, $t3, handleHashtag
beq $t1,$t4, handleSpaceOrComma
beq $t1,$t5, handleDirective
beq $t1, $t6, handleLabel
beq $t1, $t7, handleSpaceOrComma
add $t8, $zero, $zero
j loop2
handleSpaceOrComma:
beqz $t8, handleNewSpace
j loop2
handleNewSpace:
addi $t8, $t8, 1
addi $t9, $t9, 1
j loop2
handleHashtag:
addi $t9, $t9, -1
handleInstruction: # if $t9 is -1: line is a comment; 0: syscall or blank line; 1: J-Type; 2: I-type; 3: R-type.
blt $t9, $zero, handled
beqz $t9, sysc
la $a0, ($t9)
li $v0, 1
syscall
la $a0, ($s7)
li $v0, 4
syscall
sysc: # check that it is not a blank line and handle syscall otherwise

handled:
jr $ra
handleDirective:
handleLabel:
jr $ra

clearLineBuffer:
add $t7, $zero, $zero
lw $t8, lineBufferSize
lb $t9, zero
la $s0, line
loop3:
sb $t9, ($s0)
addi $s0, $s0, 1
addi $t7, $t7, 1
beq $t7, $t8, break3
j loop3
break3:
la $s0, line
j loop

endLine:
la $a0, line
jal handleLine
j endFile

endFile:
li $v0, 10  # exit program
syscall

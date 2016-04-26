.data  
file: .asciiz "input.asm"      # filename for input
characters: .byte 0x0A, 0X2C, 0x2E, 0x3A, 0x20, 0x23
	# newline, comma, period, colon, space, hashtag
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
la $a3, characters       # pass address of str2
jal getLine1      # call methodComp

getLine1:  
add $t0,$a1,$zero # DO NOT OVERWRITE $t0
getLine2:
la $s0, line
lb $t2, 0($a3) # $t2 is newline
loop:  
lb $t1($t0)         # load a byte from string  
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
la $s6, ($a0)
la $s7, ($a0)
add $t8, $zero, $zero
add $t9, $zero, $zero
loop2:  
lb $t1($s6)         # load a byte from each string  
beqz $t1, handleInstruction   # str1 end
addi $s6, $s6, 1     # t1 points to the next byte of str1
lb $t7, 5($a3) # hashtag
beq $t1, $t7, handleHashtag
lb $t7, 1($a3) # comma
beq $t1,$t7, handleSpaceOrComma
lb $t7, 4($a3) # space
beq $t1, $t7, handleSpaceOrComma
lb $t7, 2($a3) # period
beq $t1,$t7, handleDirective
lb $t7, 3($a3) # colon
beq $t1, $t7, handleLabel
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
j getLine2

endLine:
la $a0, line
jal handleLine
j endFile

endFile:
li $v0, 10  # exit program
syscall

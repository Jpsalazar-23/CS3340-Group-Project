.data
#--------------------------------Register String Array-------------------------------------------------#

registerArrayList:	.word	'zero','at', 'v0', 'v1', 'a0', 'a1', 'a2', 'a3', 't0', 't1', 't2', 't3', 't4', 't5', 't6', 't7', 's0', 's1', 's2', 's3', 's4', 's5', 's6', 's7', 't8', 't9', 'k0', 'k1', 'gp', 'sp', 'fp'
registerArraySize:	.word	32

#--------------------------------Register Binary Values Array------------------------------------------#

registerBinaryList:	.word	'00000', '00001', '00010', '00011', '00100', '00101', '00110', '00111', '01000', '01001', '01010', '01011', '01100', '01101', '01110', '01111', '10000', '10001', '10010', '10011', '10100', '10101', '10110', '10111', '11000', '11001', '11010', '11011', '11100', '11101', '11110', '11111'
registerBinarySize:	.word	32

#--------------------------------R-type String Array---------------------------------------------------#

rArrayList:		.word	'add', 'addu', 'and', 'jr', 'nor', 'or', 'slt', 'sltu', 'sll', 'srl', 'sub', 'subu'
rArraySize:		.word	12

#--------------------------------R-type Binary Values Array--------------------------------------------#

rBinaryList:		.word	'100000', '100001', '100100', '001000', '100111', '100101', '101010', '101011', '000000', '000010', '100010', '100011'
rBinarySize:		.word	12

#-----------------------------------Main Program File Prompts and Messages-----------------------------#

instruction:		.word	0

#-----------------------------------R Type Machine Code------------------------------------------------#

.text
main:

lw $t3, registerArraySize
la $t1, registerArrayList	# get array address
li $t2, 0 			# set loop counter

print_loop:
beq $t2, $t3, print_loop_end 	# check for array end
lw $a0, ($t1) 			# print value at the array pointer
li $v0, 1
syscall
addi $t2, $t2, 1 		# advance loop counter
addi $t1, $t1, 4 		# advance array pointer
j print_loop			 # repeat the loop

print_loop_end:

#--------------------------------------------------------------------------------------------------------------
.globl strcmp:
add $t0,$zero,$zero
add $t1,$zero,$a0
add $t2,$zero,$a1

loop:
lb $t3($t1)  #load a byte from each string
lb $t4($t2)
beqz $t3,checkt2 #str1 end
beqz $t4,missmatch
slt $t5,$t3,$t4  #compare two bytes
bnez $t5,missmatch
addi $t1,$t1,1  #t1 points to the next byte of str1
addi $t2,$t2,1
j loop

missmatch: 
addi $v0,$zero,1
j endfunction

checkt2:
bnez $t4,missmatch
add $v0,$zero,$zero

endfunction:
jr $ra

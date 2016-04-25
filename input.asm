.data
prompt: .asciiz "\nGive me an integer: "
result: .asciiz "The summation is: "
.text
addi $s1, $zero, 1
loop1:
li $v0, 4
la $a0, prompt
syscall
li $v0, 5
syscall
add $t0, $v0, $zero

slti $s0, $t0, 2
beq $s0, $s1, end1

li $v0, 4
la $a0, result
syscall
move $t1, $zero

loop2:
slti $s0, $t0, 1
beq $s0, $s1, end2
add $t1, $t1, $t0
addi $t0, $t0, -1
j loop2

end2:
move $a0, $t1
li $v0, 1
syscall

j loop1

end1:
li $v0, 10 # terminate program
syscall

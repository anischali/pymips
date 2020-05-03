.data
nl: .asciiz "\n"

.text
.globl main
main:
move   $fp, $sp
add    $sp, $sp, -52
li     $v0, 1
sw     $v0, 0($fp)
move  $a0, $v0
li    $v0, 1
syscall
la    $a0, nl
li    $v0, 4
syscall
lw     $v0, 0($fp)
add    $sp, $sp, -4
sw     $v0, 0($sp)
li     $v0, 2
lw     $t0, 0($sp)
add    $sp, $sp, 4
move   $t1, $v0
add    $v0, $t0, $t1
sw     $v0, -4($fp)
move  $a0, $v0
li    $v0, 1
syscall
la    $a0, nl
li    $v0, 4
syscall
lw     $v0, 0($fp)
add    $sp, $sp, -4
sw     $v0, 0($sp)
lw     $v0, -4($fp)
lw     $t0, 0($sp)
add    $sp, $sp, 4
move   $t1, $v0
add    $v0, $t0, $t1
sw     $v0, -8($fp)
move  $a0, $v0
li    $v0, 1
syscall
la    $a0, nl
li    $v0, 4
syscall
lw     $v0, 0($fp)
add    $sp, $sp, -4
sw     $v0, 0($sp)
lw     $v0, -4($fp)
lw     $t0, 0($sp)
add    $sp, $sp, 4
move   $t1, $v0
add    $v0, $t0, $t1
add    $sp, $sp, -4
sw     $v0, 0($sp)
lw     $v0, -8($fp)
lw     $t0, 0($sp)
add    $sp, $sp, 4
move   $t1, $v0
add    $v0, $t0, $t1
sw     $v0, -12($fp)
move  $a0, $v0
li    $v0, 1
syscall
la    $a0, nl
li    $v0, 4
syscall
li     $v0, 8
add    $sp, $sp, -4
sw     $v0, 0($sp)
li     $v0, 5
lw     $t0, 0($sp)
add    $sp, $sp, 4
move   $t1, $v0
mul    $v0, $t0, $t1
sw     $v0, -16($fp)
move  $a0, $v0
li    $v0, 1
syscall
la    $a0, nl
li    $v0, 4
syscall
li     $v0, 27
add    $sp, $sp, -4
sw     $v0, 0($sp)
li     $v0, 9
lw     $t0, 0($sp)
add    $sp, $sp, 4
move   $t1, $v0
div    $t0, $t1
mflo   $v0
sw     $v0, -20($fp)
move  $a0, $v0
li    $v0, 1
syscall
la    $a0, nl
li    $v0, 4
syscall
lw     $v0, -20($fp)
add    $sp, $sp, -4
sw     $v0, 0($sp)
li     $v0, 4
lw     $t0, 0($sp)
add    $sp, $sp, 4
move   $t1, $v0
sub    $v0, $t0, $t1
sw     $v0, -24($fp)
move  $a0, $v0
li    $v0, 1
syscall
la    $a0, nl
li    $v0, 4
syscall
li     $v0, 21
add    $sp, $sp, -4
sw     $v0, 0($sp)
li     $v0, 4
lw     $t0, 0($sp)
add    $sp, $sp, 4
move   $t1, $v0
div    $t0, $t1
mfhi   $v0
sw     $v0, -28($fp)
move  $a0, $v0
li    $v0, 1
syscall
la    $a0, nl
li    $v0, 4
syscall
lw     $v0, -20($fp)
add    $sp, $sp, -4
sw     $v0, 0($sp)
lw     $v0, -24($fp)
lw     $t0, 0($sp)
add    $sp, $sp, 4
move   $t1, $v0
seq    $v0, $t0, $t1
sw     $v0, -32($fp)
move  $a0, $v0
li    $v0, 1
syscall
la    $a0, nl
li    $v0, 4
syscall
li     $v0, 0
add    $sp, $sp, -4
sw     $v0, 0($sp)
li     $v0, 1
lw     $t0, 0($sp)
add    $sp, $sp, 4
move   $t1, $v0
seq    $v0, $t0, $t1
sw     $v0, -36($fp)
move  $a0, $v0
li    $v0, 1
syscall
la    $a0, nl
li    $v0, 4
syscall
lw     $v0, 0($fp)
add    $sp, $sp, -4
sw     $v0, 0($sp)
lw     $v0, -4($fp)
lw     $t0, 0($sp)
add    $sp, $sp, 4
move   $t1, $v0
add    $v0, $t0, $t1
add    $sp, $sp, -4
sw     $v0, 0($sp)
lw     $v0, -8($fp)
lw     $t0, 0($sp)
add    $sp, $sp, 4
move   $t1, $v0
add    $v0, $t0, $t1
sw     $v0, -40($fp)
move  $a0, $v0
li    $v0, 1
syscall
la    $a0, nl
li    $v0, 4
syscall
li     $v0, 1
add    $sp, $sp, -4
sw     $v0, 0($sp)
lw     $v0, -24($fp)
lw     $t0, 0($sp)
add    $sp, $sp, 4
move   $t1, $v0
or    $v0, $t0, $t1
sw     $v0, 0($fp)
move  $a0, $v0
li    $v0, 1
syscall
la    $a0, nl
li    $v0, 4
syscall
lw     $v0, -16($fp)
add    $sp, $sp, -4
sw     $v0, 0($sp)
lw     $v0, -24($fp)
lw     $t0, 0($sp)
add    $sp, $sp, 4
move   $t1, $v0
xor    $v0, $t0, $t1
sw     $v0, -4($fp)
move  $a0, $v0
li    $v0, 1
syscall
la    $a0, nl
li    $v0, 4
syscall
li     $v0, 1
add    $sp, $sp, -4
sw     $v0, 0($sp)
li     $v0, 0
lw     $t0, 0($sp)
add    $sp, $sp, 4
move   $t1, $v0
and    $v0, $t0, $t1
sw     $v0, -44($fp)
move  $a0, $v0
li    $v0, 1
syscall
la    $a0, nl
li    $v0, 4
syscall
lw     $v0, -8($fp)
add    $sp, $sp, -4
sw     $v0, 0($sp)
lw     $v0, -4($fp)
lw     $t0, 0($sp)
add    $sp, $sp, 4
move   $t1, $v0
sle    $v0, $t0, $t1
sw     $v0, -48($fp)
move  $a0, $v0
li    $v0, 1
syscall
la    $a0, nl
li    $v0, 4
syscall
li     $v0, 21
add    $sp, $sp, -4
sw     $v0, 0($sp)
li     $v0, 5
lw     $t0, 0($sp)
add    $sp, $sp, 4
move   $t1, $v0
add    $v0, $t0, $t1
add    $sp, $sp, -4
sw     $v0, 0($sp)
li     $v0, 4
add    $sp, $sp, -4
sw     $v0, 0($sp)
li     $v0, 2
lw     $t0, 0($sp)
add    $sp, $sp, 4
move   $t1, $v0
div    $t0, $t1
mflo   $v0
lw     $t0, 0($sp)
add    $sp, $sp, 4
move   $t1, $v0
mul    $v0, $t0, $t1
sw     $v0, -40($fp)
move  $a0, $v0
li    $v0, 1
syscall
la    $a0, nl
li    $v0, 4
syscall
add    $sp, $sp, 52
jr     $ra

.data
nl: .asciiz "\n"

.text
.globl main
main:
move   $fp, $sp
add    $sp, $sp, -16
li     $v0, 1
sw     $v0, 0($fp)
move  $a0, $v0
li    $v0, 1
syscall
la    $a0, nl
li    $v0, 4
syscall
b      cond25051
cond25051:
li     $v0, 0
add    $sp, $sp, -4
sw     $v0, 0($sp)
lw     $v0, 0($fp)
lw     $t0, 0($sp)
add    $sp, $sp, 4
move   $t1, $v0
seq    $v0, $t0, $t1
beqz   $v0,cond54918
li     $v0, 3
sw     $v0, 0($fp)
b      cond38291
cond54918:
lw     $v0, 0($fp)
add    $sp, $sp, -4
sw     $v0, 0($sp)
li     $v0, 7
lw     $t0, 0($sp)
add    $sp, $sp, 4
move   $t1, $v0
sgt    $v0, $t0, $t1
beqz   $v0,cond60172
li     $v0, 0
sw     $v0, 0($fp)
b      cond38291
cond38291:
cond60172:
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
add    $sp, $sp, 16
jr     $ra


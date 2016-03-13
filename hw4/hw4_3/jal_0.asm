// jal_0.asm
// a simplistic call to an add function

lbi r1, 5
lbi r2, 3
jal 2
halt
add r3, r1, r2
jr r7, 0

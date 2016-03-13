// j_2.asm
// A simple goto construct (j with pos displacement)

lbi r1, 5
lbi r2, 3
j 6 
add r3, r1, r2
add r1, r3, r2
add r2, r1, r1
halt

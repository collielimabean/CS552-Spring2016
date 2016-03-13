// jal_1.asm
// a jal that acts like a nop

lbi r1, 1   // filler value
jal 0       // should proceed normally
lbi r2, 1   // filler value to see if proceed normally
halt

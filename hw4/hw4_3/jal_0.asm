// jal_0.asm
// a simplistic call to an add function

lbi r1, 5           // preload value
lbi r2, 3           // preload value
jal 2               // go to add function
halt
add r3, r1, r2      // add registers
jr r7, 0            // ret, should go to halt

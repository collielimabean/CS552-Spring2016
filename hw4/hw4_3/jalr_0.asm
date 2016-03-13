// jalr_0.asm
// Test Rs > 0, Imm = 0  

lbi r1, 5           // preload value
lbi r2, 3           // preload value
lbi r6, 10          // hardcode function address
jalr r6, 0          // go to add function
halt
add r3, r1, r2      // add registers
jr r7, 0            // ret, should go to halt

// j_1.asm
// A jump that acts like a nop

xor r1, r1, r1      // clear r1
j 0                 // do nothing
halt

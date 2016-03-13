// jalr_1.asm
// Test Rs = 0 & Imm > 0

lbi r1, 0           // clear r1
jalr r1, 6          // jump and link to halt
lbi r2, 5           // filler to see if jumped
halt

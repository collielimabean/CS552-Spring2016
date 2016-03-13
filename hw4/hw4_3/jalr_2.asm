// jalr_2.asm
// Test Rs > 0 & Imm < 0

lbi r1, 8       // set r1 to 8
jalr r1, -2         // jalr to address 6 (halt)
xor r1, r1, r1      // filler instr to see if jumped
halt

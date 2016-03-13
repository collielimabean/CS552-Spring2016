// jalr_3.asm
// Test Rs < 0 and Imm > 0

lbi r1, -4     // filler value to test negative reg val
jalr r1, 10     // jump to address 6 (halt)
lbi r2, 5      // filler instr to see if jumped
halt

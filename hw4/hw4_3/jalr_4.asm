// jalr_4.asm
// Test Rs > 0 & Imm > 0

lbi r1, 3       // Rs > 0
jalr r1, 3      // imm > 0, should jump to halt instr
lbi r2, 5       // filler instr to see if jumped
halt

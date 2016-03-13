// j_2.asm
// A simple goto construct (j with pos displacement)

lbi r1, 5       // filler value
lbi r2, 3       // filler value
j 6             // jump to halt
add r3, r1, r2  // instr that should not be run
add r1, r3, r2  // instr that should not be run
add r2, r1, r1  // instr that should not be run
halt

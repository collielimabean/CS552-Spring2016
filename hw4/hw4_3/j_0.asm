// j_0.asm
// a simple counter loop
// for (int i = 4; i > 0; i--);

lbi r1, 4           // set r1 to 4
beqz r1, 4          // if r1 == 0, jump out
addi r1, r1, -1     // decrement r1
j -6                // go back to branch
halt

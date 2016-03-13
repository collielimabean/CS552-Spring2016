// jal_2.asm
// a simple addition function, but the function is defined at the top

j 4                 // skip over function when running
add r3, r1, r2      // add parameters
jr r7, 0            // ret from function, go to halt
lbi r1, 5           // preload value
lbi r2, 3           // preload value
jal -10             // call the add function
halt

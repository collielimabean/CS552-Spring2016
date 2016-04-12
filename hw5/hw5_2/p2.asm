
lbi r1, 10     // change this to modify branch outcome

beqz r1, 2       // if r1 == 0, go to load area
halt
xor r0, r0, r0
xor r1, r1, r1
ld r1, r1, 0
ld r1, r1, 0
ld r1, r1, 0
ld r1, r1, 0
halt

// H5, P1 - Forwarding

lbi r0, 50 ; r0 = 50
lbi r1, 25 ; r1 = 25
stu r0, r0, 0   ; M[50] = 50


add r2, r0, r1  ; r2 = 75
add r0, r2, r2  ; r0 = 150
ld r3, r0, 0    ; r3 = 50
xor r4, r3, r0  ; r4 = 50 ^ 150 = 164

halt

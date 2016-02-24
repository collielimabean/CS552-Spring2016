
module incdec2(A, Inc, Dec);
    input [1:0] A;
    output [1:0] Inc, Dec;

    wire Cin, msb;

    assign Cin = A[0];
    assign msb = A[1] ^ Cin;
    assign Inc[0] = ~A[0];
    assign Inc[1] = msb;
    assign Dec[0] = ~A[0];
    assign Dec[1] = ~msb;
endmodule


module incrementer3(A, S);
    input [2:0] A, S;

    wire [1:0] Cin;

    assign Cin[0] = A[0];
    assign Cin[1] = A[1] & Cin[0];

    assign S[0] = ~A[0];
    assign S[1] = A[1] ^ Cin[0];
    assign S[2] = A[2] ^ Cin[1];
endmodule

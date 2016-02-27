module fifo_full(A, B, Out);
    input [1:0] A, B;
    output Out;

    assign Out = (~A[0] & B[0] & (A[1] ~^ B[1])) | (A[0] & ~B[0] & (A[1] ^ B[1]));

endmodule

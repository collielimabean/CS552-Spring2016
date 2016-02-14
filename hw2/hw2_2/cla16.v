
module cla16(A, B, Cin, S, Cout);
    input [15:0] A, B;
    input Cin;
    output [15:0] S;
    output Cout;

    wire [2:0] block_cout;

    cla4 cla0 (.A(A[3:0]), .B(B[3:0]), .Cin(Cin), .S(S[3:0]), .Cout(block_cout[0]));
    cla4 cla1 (.A(A[7:4]), .B(B[7:4]), .Cin(block_cout[0]), .S(S[7:4]), .Cout(block_cout[1]));
    cla4 cla2 (.A(A[11:8]), .B(B[11:8]), .Cin(block_cout[1]), .S(S[11:8]), .Cout(block_cout[2]));
    cla4 cla3 (.A(A[15:12]), .B(B[15:12]), .Cin(block_cout[2]), .S(S[15:12]), .Cout(Cout));

endmodule


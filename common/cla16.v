
module cla16(A, B, Cin, S, Cout);
    input [15:0] A, B;
    input Cin;
    output [15:0] S;
    output Cout;

    wire [3:0] C, P, G, cout;

    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | ((P[1] & G[0]) | (P[1] & (P[0] & C[0])));
    assign C[3] = G[2] | ((P[2] & G[1]) | ((G[0] & (P[1] & P[2])) | (C[0] & (&P[2:0]))));
    assign Cout = G[3] | ((G[2] & P[3]) | ((G[1] & (P[2] & P[3])) | ((G[0] & (&P[3:1]))) | (C[0] & (&P))));

    cla4 ca0(.A (A[3:0]), .B (B[3:0]), .Cin (C[0]), .S (S[3:0]), .Cout (cout[0]), .PG(P[0]), .GG(G[0]));
    cla4 ca1(.A (A[7:4]), .B (B[7:4]), .Cin (C[1]), .S (S[7:4]), .Cout (cout[1]), .PG(P[1]), .GG(G[1]));
    cla4 ca2(.A (A[11:8]), .B (B[11:8]), .Cin (C[2]), .S (S[11:8]), .Cout (cout[2]), .PG(P[2]), .GG(G[2]));
    cla4 ca3(.A (A[15:12]), .B (B[15:12]), .Cin (C[3]), .S (S[15:12]), .Cout (cout[3]), .PG(P[3]), .GG(G[3]));

endmodule


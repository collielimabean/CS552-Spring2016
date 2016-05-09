
module cla4(A, B, Cin, S, Cout, PG, GG);
    input [3:0] A, B;
    input Cin;
    output [3:0] S;
    output Cout, PG, GG;

    wire [3:0] P, G, C;

    assign P = A ^ B;
    assign G = A & B;

    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | ((P[1] & G[0]) | (P[1] & (P[0] & C[0])));
    assign C[3] = G[2] | ((P[2] & G[1]) | ((G[0] & (P[1] & P[2])) | (C[0] & (&P[2:0]))));
    assign Cout = G[3] | ((G[2] & P[3]) | ((G[1] & (P[2] & P[3])) | ((G[0] & (&P[3:1]))) | (C[0] & (&P))));

    assign PG = &P;
    assign GG = G[3] | ((G[2] & P[3]) | ((G[1] & (P[3] & P[2])) | (G[0] & (&P[3:1]))));

    fulladder1 fa[3:0] (.A (A), .B (B), .Cin (C), .S(S), .P (P), .G (G));

endmodule

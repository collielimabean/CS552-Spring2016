// a 1-bit full adder

module fulladder1(A, B, Cin, S, P, G);
	input A, B, Cin;
	output S, P, G;

    assign S = (A ^ B) ^ Cin;
    assign P = A ^ B;
    assign G = A & B;
endmodule

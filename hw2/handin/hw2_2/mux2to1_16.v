module mux2to1_16(InA, InB, S, Out);
	input [15:0] InA, InB;
	input       S;
	output [15:0] Out;

	mux2to1 m[15:0](.InA(InA), .InB(InB), .S(S), .Out(Out));

endmodule
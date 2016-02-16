module mux2to1_8(InA, InB, S, Out);
	input [7:0] InA, InB;
	input       S;
	output [7:0] Out;

	mux2to1 m[7:0](.InA(InA), .InB(InB), .S(S), .Out(Out));

endmodule
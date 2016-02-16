module mux2to1_4(InA, InB, S, Out);
	input [3:0] InA, InB;
	input       S;
	output [3:0] Out;

	mux2to1 m[3:0](.InA(InA), .InB(InB), .S(S), .Out(Out));

endmodule
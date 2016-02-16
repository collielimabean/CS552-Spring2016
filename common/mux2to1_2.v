module mux2to1_2(InA, InB, S, Out);
	input [1:0] InA, InB;
	input       S;
	output [1:0] Out;

	mux2to1 m[1:0](.InA(InA), .InB(InB), .S(S), .Out(Out));

endmodule

// a 4-to-1 mux
module mux4_1(InA, InB, InC, InD, S, Out);
	input InA, InB, InC, InD;
	input [1:0] S;
	output Out;
	
	wire mux0_out, mux1_out;
	
	mux2_1 mux0(.InA(InA),      .InB(InB),      .S(S[0]), .Out(mux0_out));
	mux2_1 mux1(.InA(InC),      .InB(InD),      .S(S[0]), .Out(mux1_out));
	mux2_1 mux2(.InA(mux0_out), .InB(mux1_out), .S(S[1]), .Out(Out));

endmodule
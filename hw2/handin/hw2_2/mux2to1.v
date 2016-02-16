
// a 2-1 mux module
module mux2to1(InA, InB, S, Out);
	input  InA;
	input  InB;
	input  S;
	output Out;
	
	wire InA_n,InB_n,S_n,InA_s,InB_s,InA_s_n, InB_s_n;
	
	not1 nt0(.in1(InA),   .out(InA_n));
	not1 nt1(.in1(InB),   .out(InB_n));	
	not1 nt2(.in1(S),     .out(S_n));
	not1 nt3(.in1(InA_s), .out(InA_s_n));
	not1 nt4(.in1(InB_s), .out(InB_s_n));
	
	nor2 nr0(.in1(InA_n), .in2(S),   .out(InA_s));
	nor2 nr1(.in1(InB_n), .in2(S_n), .out(InB_s));
	
	nand2 nd0(.in1(InA_s_n), .in2(InB_s_n), .out(Out));

endmodule
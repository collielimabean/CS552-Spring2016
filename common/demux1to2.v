
// a 2-1 demux module
module demux1to2(In, S, Out0, Out1);
	input        In;
	input        S;
	output Out0, Out1;
	
	wire S_n, Out0_n, Out1_n;
	
	not1 nt0(.in1(Out1_n), .out(Out1));
	not1 nt1(.in1(Out0_n), .out(Out0]));	
	not1 nt2(.in1(S),      .out(S_n));
		
	nand2 nd0(.in1(In), .in2(S),   .out(Out1_n));
	nand2 nd1(.in1(In), .in2(S_n), .out(Out0_n));

endmodule
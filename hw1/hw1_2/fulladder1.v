// a 1-bit full adder

module fulladder1(A, B, Cin, S, Cout);
	input A, B, Cin;
	output S, Cout;
	
	wire AB_xor, C_in1_n, C_in2_n, C_in1, C_in2, Cout_n;
	
	xor2  xor0(.in1(A),      .in2(B),   .out(AB_xor));
	xor2  xor1(.in1(AB_xor), .in2(Cin), .out(S));
	
	nand2 nd0(.in1(Cin), .in2(AB_xor), .out(C_in1_n));
	nand2 nd1(.in1(A),   .in2(B),      .out(C_in2_n));
	
	nor2  nr0(.in1(C_in1), .in2(C_in2), .out(Cout_n));

	not1 nt0(.in1(C_in1_n), .out(C_in1));
	not1 nt1(.in1(C_in2_n), .out(C_in2));
	not1 nt2(.in1(Cout_n),   .out(Cout));

endmodule
// a 4-bit ripple-carry adder
module fulladder4(A, B, CI, SUM, CO);
	input  [3:0]   A;
	input  [3:0]   B;
	input         CI;
	output [3:0] SUM;
	output        CO;
	
	wire Cout_0, Cout_1, Cout_2;
	
	fulladder1 fa0(.A(A[0]), .B(B[0]), .Cin(CI),     .S(SUM[0]), .Cout(Cout_0));
	fulladder1 fa1(.A(A[1]), .B(B[1]), .Cin(Cout_0), .S(SUM[1]), .Cout(Cout_1));
	fulladder1 fa2(.A(A[2]), .B(B[2]), .Cin(Cout_1), .S(SUM[2]), .Cout(Cout_2));
	fulladder1 fa3(.A(A[3]), .B(B[3]), .Cin(Cout_2), .S(SUM[3]), .Cout(CO));
	
endmodule

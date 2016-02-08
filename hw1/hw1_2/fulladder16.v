// 16-bit full adder module

module fulladder16(A, B, SUM, CO);
	input  [15:0] A;
	input  [15:0] B;
	output [15:0] SUM;
	output CO;
	
	wire fa0_out, fa1_out, fa2_out;
	
	fulladder4 fa0(.A(A[3:0]),   .B(B[3:0]),   .CI(1'b0),     .SUM(SUM[3:0]),  .CO(fa0_out));
	fulladder4 fa1(.A(A[7:4]),   .B(B[7:4]),   .CI(fa0_out), .SUM(SUM[7:4]),   .CO(fa1_out));
	fulladder4 fa2(.A(A[11:8]),  .B(B[11:8]),  .CI(fa1_out), .SUM(SUM[11:8]),  .CO(fa2_out));
	fulladder4 fa3(.A(A[15:12]), .B(B[15:12]), .CI(fa2_out), .SUM(SUM[15:12]), .CO(CO));

endmodule
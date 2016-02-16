// a 16-bit AND module

module and16(A, B, Out);
	input  [15:0] A;
	input  [15:0] B;
	output [15:0] Out;

	assign Out = A & B;
	
endmodule
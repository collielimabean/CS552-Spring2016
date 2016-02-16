/*
	This module contains the following operations for the following opcodes:
		00: CLA
		01: OR
		10: XOR
		11: AND
*/

module cla_or_xor_and(A, B, Cin, Op, Out, Cout);
	input  [15:0] A, B;
	input Cin;
	input  [1:0]  Op;
	output [15:0] Out;
	output Cout;

	wire cla_cout;
	wire [15:0] A_real, B_real;
	wire [15:0] op0_A, op1_A, op2_A, op3_A;
	wire [15:0] op0_B, op1_B, op2_B, op3_B;
	wire [15:0] op0_out, op1_out, op2_out, op3_out;

	assign Cout = (~(Op[1] | Op[0])) ? cla_cout : 1'b0;

	demux1to4_16 demux0(.In(A_real), .S(Op), .Out0(op0_A), .Out1(op1_A), .Out2(op2_A), .Out3(op3_A));
	demux1to4_16 demux1(.In(B_real), .S(Op), .Out0(op0_B), .Out1(op1_B), .Out2(op2_B), .Out3(op3_B));

	// 00: CLA
	cla16 cla0(.A(op0_A), .B(op0_B), .Cin(Cin), .S(op0_out), .Cout(cla_cout));

	// 01: OR
	or16  or0(.A(op1_A), .B(op1_B), .Out(op1_out));
	
	// 10: XOR
	xor16 xor0(.A(op2_A), .B(op2_B), .Out(op2_out));

	// 11: AND
	and16 and0(.A(op3_A), .B(op3_B), .Out(op3_out));

	// Choose the proper output
	mux4to1_16 mux0(.InA(op0_out), .InB(op1_out), .InC(op2_out), .InD(op3_out), .S(Op), .Out(Out));

endmodule
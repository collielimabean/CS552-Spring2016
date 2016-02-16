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
	wire [15:0] op0_A, op1_A, op2_A, op3_A;
	wire [15:0] op0_B, op1_B, op2_B, op3_B;
	wire [15:0] op0_out, op1_out, op2_out, op3_out;

	assign Cout = (~(Op[1] | Op[0])) ? cla_cout : 1'b0;

	demux1to4_16 demux0(.In(A), .S(Op), .Out0(op0_A), .Out1(op1_A), .Out2(op2_A), .Out3(op3_A));
	demux1to4_16 demux1(.In(B), .S(Op), .Out0(op0_B), .Out1(op1_B), .Out2(op2_B), .Out3(op3_B));

	// 00: CLA
	cla16 cla0(.A(op0_A), .B(op0_B), .Cin(Cin), .S(op0_out), .Cout(cla_cout));

	// 01: OR
	assign op1_out = op1_A | op1_B;
	
	// 10: XOR
	assign op2_out = op2_A ^ op2_B;

	// 11: AND
	assign op3_out = op3_A & op3_B;

	// Choose the proper output
	mux4to1_16 mux0(.InA(op0_out), .InB(op1_out), .InC(op2_out), .InD(op3_out), .S(Op), .Out(Out));

endmodule

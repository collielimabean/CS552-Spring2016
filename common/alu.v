/*
 * ALU Module for 552 project.
 * Opcodes:
 * 000 - Rotate left
 * 001 - Shift left
 * 010 - Rotate right
 * 011 - Logical right shift
 * 100 - A + B
 * 101 - A | B
 * 110 - A ^ B
 * 111 - A & B
 */

module alu (A, B, Cin, Op, invA, invB, sign, Out, Ofl, Z);
    input [15:0] A;
    input [15:0] B;
    input Cin;
    input [2:0] Op;
    input invA;
    input invB;
    input sign;
    output [15:0] Out;
    output Ofl;
    output Z;

    wire cout, is_add_op, signed_ofl;
    wire [15:0] A_real, B_real;
    wire [15:0] op0_A, op0_B, op0_out;
    wire [15:0] op1_A, op1_B, op1_out;

    assign A_real = (invA) ? ~A : A;
    assign B_real = (invB) ? ~B : B;
    assign Out = Op[2] ? op0_out : op1_out;

    assign is_add_op = Op[2] & ~(Op[1] | Op[0]);
    assign signed_ofl = cout & (A_real[15] ^ B_real[15]);
    assign Ofl = is_add_op & ((sign) ? signed_ofl : cout);

    assign Z = ~(|Out);

    demux1to2_16 demux0(.In(A_real), .S(Op[2]), .Out0(op0_A), .Out1(op0_B));
    demux1to2_16 demux1(.In(B_real), .S(Op[2]), .Out0(op1_A), .Out1(op1_B));

    // Opcodes: 0xx
    cla_or_xor_and coxa0(.A(op0_B), .B(op1_B), .Cin(Cin), .Op(Op[1:0]), .Out(op0_out), .Cout(cout));
    
    // Opcodes: 1xx
    shifter shift(.In(op0_A), .Cnt(op1_A[3:0]), .Op(Op[1:0]), .Out(op1_out));
endmodule

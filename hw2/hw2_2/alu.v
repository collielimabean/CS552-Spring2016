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

    wire cla_cout, is_add_op, signed_ofl;
    wire [15:0] A_real, B_real, muxed_out;
    wire [15:0] op0_A, op0_B, op0_out;
    wire [15:0] op1_A, op1_B, op1_out;

    assign A_real = (invA) ? ~A : A;
    assign B_real = (invB) ? ~B : B;
    assign Out = muxed_out;

    assign is_add_op = Op[2] & ~(Op[1] | Op[0]);
    assign signed_ofl = cla_cout & (A_real[15] ^ B_real[15]);
    assign Ofl = (is_add_op) ? ((sign) ? signed_ofl : cla_cout) : 1'b0;

    assign Z = ~(|muxed_out);

    demux1to2_16 demux0(.In(A_real), .S(Op[2]), .Out0(op0_A), .Out1(op1_A));
    demux1to2_16 demux1(.In(B_real), .S(Op[2]), .Out0(op0_B), .Out1(op1_B));

    // Opcodes: 0xx
    cla_or_xor_and coxa0(.A(op0_A), .B(op0_B), .Cin(Cin), .Op(Op[1:0]), .Out(op0_out), .Cout(cla_cout));
    
    // Opcodes: 1xx
    shifter shift(.In(op1_A), .Cnt(op1_B[3:0]), .Op(Op[1:0]), .Out(op1_out));

    // Select the proper output
    mux2to1_16 mux0(.InA(op0_out), .InB(op1_out), .S(Op[2]), .Out(muxed_out));

/*
    wire [15:0] actual_a_operand, actual_b_operand,
                ca_out, and_out, xor_out, or_out,
                alu_out, shifter_out;
    
    wire cout, is_add_op, signed_ofl;

    cla16 ca(.A (actual_a_operand), .B (actual_b_operand), .Cin (Cin), .S (ca_out), .Cout (cout));
    shifter shift_inst (.In (actual_a_operand), .Cnt (actual_b_operand[3:0]), .Op(Op[1:0]), .Out (shifter_out));

    assign actual_a_operand = (invA) ? ~A : A;
    assign actual_b_operand = (invB) ? ~B : B;
    assign and_out = actual_a_operand & actual_b_operand;
    assign or_out = actual_a_operand | actual_b_operand;
    assign xor_out = actual_a_operand ^ actual_b_operand;

    assign is_add_op = Op[2] & ~(Op[1] | Op[0]);
    assign signed_ofl = cout & (actual_a_operand[15] ^ actual_b_operand[15]);

    assign alu_out = (Op[1]) ? ((Op[0] ? and_out : xor_out)) : ((Op[0]) ? or_out : ca_out);

    assign Out = (Op[2]) ? alu_out : shifter_out;
    assign Z = ~(|Out);
    assign Ofl = (is_add_op) ? ((sign) ? signed_ofl : cout) : 1'b0;
*/
endmodule

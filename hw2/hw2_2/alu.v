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

    wire [15:0] actual_a_operand, actual_b_operand,
                ca_out, and_out, xor_out, or_out,
                alu_out, shifter_out;
    
    wire cout, is_add_op, overflow;

    cla16 ca(.A (actual_a_operand), .B (actual_b_operand), .Cin (Cin), .S (ca_out), .Cout (cout));
    shifter shift_inst (.In (actual_a_operand), .Cnt (actual_b_operand[3:0]), .Op(Op[1:0]), .Out (shifter_out));

    assign actual_a_operand = (invA) ? ~A : A;
    assign actual_b_operand = (invB) ? ~B : B;
    assign and_out = actual_a_operand & actual_b_operand;
    assign or_out = actual_a_operand | actual_b_operand;
    assign xor_out = actual_a_operand ^ actual_b_operand;

    assign is_add_op = Op[2] & ~(Op[1] || Op[0]);
    assign unsigned_ofl = actual_a_operand[15] & (actual_b_operand[15] & ~ca_out[15]);
    assign signed_ofl = (actual_a_operand[15] & (actual_b_operand[15] & ~ca_out[15])) | (~actual_a_operand[15] & (~actual_b_operand[15] & ca_out[15]));

    assign alu_out = (Op[1]) ? ((Op[0] ? and_out : xor_out)) : ((Op[0]) ? or_out : ca_out);

    assign Out = (Op[2]) ? alu_out : shifter_out;
    assign Z = ~(|Out);
    assign Ofl = (is_add_op) ? ((sign) ? signed_ofl : unsigned_ofl) : 1'b0;
endmodule

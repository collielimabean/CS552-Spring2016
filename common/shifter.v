module shifter (In, Cnt, Op, Out);   
    input [15:0] In;
    input [3:0]  Cnt;
    input [1:0]  Op;
    output [15:0] Out;

    wire [15:0] ls_out, rs_out;

    lshifter ls(.In (In), .Cnt(Cnt), .Rot_sel (~Op[0]), .Out(ls_out));
    rshifter rs(.In (In), .Cnt(Cnt), .Logical_sel (~Op[0]), .Out(rs_out));

    assign Out = (Op[1]) ? rs_out : ls_out;

endmodule


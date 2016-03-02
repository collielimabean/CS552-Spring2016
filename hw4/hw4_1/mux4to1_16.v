
// a 4-to-1 mux
module mux4to1_16(InA, InB, InC, InD, S, Out);
	input  [15:0] InA, InB, InC, InD;
	input  [1:0]  S;
	output [15:0] Out;
	
	wire [15:0] mux0_out, mux1_out;

    assign mux0_out = (S[0]) ? InB : InA;
    assign mux1_out = (S[0]) ? InD : InC;
	assign Out = (S[1]) ? mux1_out : mux0_out;

endmodule

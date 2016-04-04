
// a 1-4 demux module
module demux1to4(In, S, Out0, Out1, Out2, Out3);
	input          In;
	input  [1:0]   S;
	output         Out0, Out1, Out2, Out3;
	
	wire [3:0] Out;
	
	assign Out0 = Out[0];
	assign Out1 = Out[1];
	assign Out2 = Out[2];
	assign Out3 = Out[3];

	assign Out[0] = (In & ~S[0] & ~S[1]);
    assign Out[1] = (In & S[0]  & ~S[1]);
    assign Out[2] = (In & ~S[0] & S[1]);
    assign Out[3] = (In & S[0]  & S[1]);
endmodule

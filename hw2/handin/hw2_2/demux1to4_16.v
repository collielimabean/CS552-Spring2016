module demux1to4_16(In, S, Out0, Out1, Out2, Out3);
	input [15:0] In;
	input [1:0] S;
	output [15:0] Out0, Out1, Out2, Out3;
	
	demux1to4 demux[15:0](.In(In), .S(S), .Out0(Out0), .Out1(Out1), .Out2(Out2), .Out3(Out3));
	
endmodule
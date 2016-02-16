module demux1to2_16(In, S, Out0, Out1);
	input [15:0] In;
	input       S;
	output [15:0] Out0, Out1;

	demux1to2 d[15:0](.In(In), .S(S), .Out(Out));

endmodule
module demux1to2_8(In, S, Out0, Out1);
	input [7:0] In;
	input       S;
	output [7:0] Out0, Out1;

	demux1to2 d[7:0](.In(In), .S(S), .Out(Out));

endmodule
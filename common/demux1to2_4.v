module demux1to2_4(In, S, Out0, Out1);
	input [3:0] In;
	input       S;
	output [3:0] Out0, Out1;

	demux1to2 d[3:0](.In(In), .S(S), .Out(Out));

endmodule
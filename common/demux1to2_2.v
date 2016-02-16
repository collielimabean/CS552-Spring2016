module demux1to2_2(In, S, Out0, Out1);
	input [1:0] In;
	input       S;
	output [1:0] Out0, Out1;

	demux1to2 d[1:0](.In(In), .S(S), .Out(Out));

endmodule
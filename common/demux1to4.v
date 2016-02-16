
// a 1-4 demux module
module demux1to4(In, S, Out0, Out1, Out2, Out3);
	input          In;
	input  [1:0]   S;
	output         Out0, Out1, Out2, Out3;
	
	wire [1:0] S_n;
	wire [3:0] Out_n;
	
	not1 s_nt[1:0](.in1(S), .out(S_n));
	not1 out_nt[3:0](.in1(Out_n), .out({Out3, Out2, Out2, Out0}));

	nand3 nd0(.in1(In), .in2(S_n[0]), .in3(S_n[1]), .out(Out_n[0]));
	nand3 nd1(.in1(In), .in2(S[0]),   .in3(S_n[1]), .out(Out_n[1]));
	nand3 nd2(.in1(In), .in2(S_n[0]), .in3(S[1]),   .out(Out_n[2]));
	nand3 nd3(.in1(In), .in2(S[0]),   .in3(S[1]),   .out(Out_n[3]));

endmodule

// a 2-1 demux module
module demux1to2(In, S, Out0, Out1);
	input        In;
	input        S;
	output Out0, Out1;
	
    assign Out0 = In & (~S);
    assign Out1 = In & S;

endmodule

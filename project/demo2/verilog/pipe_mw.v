/*
Memory:
	Inputs:
		MemRead
		MemWrite
		Halt
		Address
		WriteData
	Outputs:
		ReadData
		
	Passthrough:
		MemToReg
		
WriteBack
	Inputs:
		ExecuteOut
		MemOut
		MemToReg
	Outputs:
		WriteData
 */
module pipe_mw(
	/* common inputs */
	Stall, rst, clk,
	/* inputs */
	ExecuteOut, MemOut, MemToReg,
	/* outputs */
	ExecuteOut_Out, MemOut_Out, MemToReg_Out
);

	input Stall, rst, clk, MemToReg;
	input [15:0] ExecuteOut, MemOut;
	output MemToReg_Out;
	output [15:0] ExecuteOut_Out, MemOut_Out;
	
	wire [15:0] ExecuteOut_Out, MemOut_Out;
	wire MemToReg_Out;
	
	dff executeout_reg[15:0] (.d(ExecuteOutMuxed), .q(ExecuteOut_Out), .rst(rst), .clk(clk));
	dff memout_reg[15:0] (.d(MemOutMuxed), .q(MemOut_Out), .rst(rst), .clk(clk));
	dff memtoreg_reg (.d(MemToRegMuxed), .q(MemToReg_Out), .rst(rst), .clk(clk));
	
	assign ExecuteOutMuxed = (Stall) ? ExecuteOut_Out : ExecuteOut;
	assign MemOutMuxed = (Stall) ? MemOut_Out : MemOut;
	assign MemToRegMuxed = (Stall) ? MemToReg_Out : MemToReg;
	
endmodule

/*
Execute:
	Outputs:
		Result
		NextPC
		
	Passthrough:
		MemRead
		MemWrite
		MemToReg
		Halt
		
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
		
 */
module pipe_em(
	/* common inputs */
	Stall, rst, clk,
	/* inputs */
	Result, MemRead, MemWrite, MemToReg, Halt, ALUOp2,
	/* outputs */
	Address, MemRead_Out, MemWrite_Out, MemToReg_Out, Halt_Out, WriteData
);

	input Stall, rst, clk, MemRead, MemWrite, MemToReg, Halt;
	input [15:0] Result, ALUOp2;

	output MemRead_Out, MemWrite_Out, MemToReg_Out, Halt_Out;
	output [15:0] Address, WriteData;

	wire [15:0] AddressMuxed;
	wire MemReadMuxed, MemWriteMuxed, MemToRegMuxed, ALUOp2Muxed;

	dff address_reg[15:0](.d (AddressMuxed), .q (Address), .clk(clk), .rst(rst));
	dff memread_reg(.d (MemReadMuxed), .q (MemRead_Out), .clk(clk), .rst(rst));
	dff memwrite_reg(.d (MemWriteMuxed), .q (MemWrite_Out), .clk(clk), .rst(rst));
	dff memtoreg_reg(.d (MemToRegMuxed), .q (MemToReg_Out), .clk(clk), .rst(rst));
	dff writedata_reg[15:0](.d (ALUOp2Muxed), .q (WriteData), .clk(clk), .rst(rst));
	
	assign AddressMuxed = (Stall) ? Address : Result;
	assign MemReadMuxed = (Stall) ? MemRead_Out : MemRead;
	assign MemWriteMuxed = (Stall) ? MemWrite_Out : MemWrite;
	assign MemToRegMuxed = (Stall) ? MemToReg_Out : MemToReg;
	assign ALUOp2Muxed = (Stall) ? WriteData : ALUOp2;
endmodule 

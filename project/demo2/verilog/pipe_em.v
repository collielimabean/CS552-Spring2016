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
	Result, MemRead, MemWrite, MemToReg, Halt, ALUOp2, RegFileWrEn, Rs, Rt, Rd, WriteReg,
    RtValid,
	/* outputs */
	Address, MemRead_Out, MemWrite_Out, MemToReg_Out, Halt_Out, WriteData,
	RegFileWrEn_Out, Rs_Out, Rt_Out, Rd_Out, WriteReg_Out, RtValid_Out
);

	input Stall, rst, clk, MemRead, MemWrite, MemToReg, Halt, RegFileWrEn, RtValid;
	input [2:0] Rs, Rt, Rd, WriteReg;
	input [15:0] Result, ALUOp2;

	output MemRead_Out, MemWrite_Out, MemToReg_Out, Halt_Out, RegFileWrEn_Out, RtValid_Out;
	output [2:0] Rs_Out, Rt_Out, Rd_Out, WriteReg_Out;
	output [15:0] Address, WriteData;

	wire [15:0] AddressMuxed;
	wire [2:0] RsMuxed, RtMuxed, RdMuxed, WriteRegMuxed;
	wire MemReadMuxed, MemWriteMuxed, MemToRegMuxed, ALUOp2Muxed, RegFileWrEnMuxed, HaltMuxed,
         RtValidMuxed;
	
    dff RtValid_reg(.d(RtValidMuxed), .q(RtValid_Out), .rst(rst), .clk(clk));
    
	dff WriteReg_reg[2:0](.d(WriteRegMuxed), .q(WriteReg_Out), .rst(rst), .clk(clk));
	
	dff rs_reg[2:0](.d(RsMuxed), .q(Rs_Out), .rst(rst), .clk(clk));
	dff rt_reg[2:0](.d(RtMuxed), .q(Rt_Out), .rst(rst), .clk(clk));
	dff rd_reg[2:0](.d(RdMuxed), .q(Rd_Out), .rst(rst), .clk(clk));
	
	dff rf_wr_en_reg(.d (RegFileWrEnMuxed), .q(RegFileWrEn_Out), .rst(rst), .clk(clk));
	dff address_reg[15:0](.d (AddressMuxed), .q (Address), .clk(clk), .rst(rst));
	dff memread_reg(.d (MemReadMuxed), .q (MemRead_Out), .clk(clk), .rst(rst));
	dff memwrite_reg(.d (MemWriteMuxed), .q (MemWrite_Out), .clk(clk), .rst(rst));
	dff memtoreg_reg(.d (MemToRegMuxed), .q (MemToReg_Out), .clk(clk), .rst(rst));
	dff writedata_reg[15:0](.d (ALUOp2Muxed), .q (WriteData), .clk(clk), .rst(rst));
	dff halt_reg (.d(HaltMuxed), .q(Halt_Out), .clk(clk), .rst(rst));
	
    assign RtValidMuxed = (Stall) ? RtValid_Out : RtValid;
    
	assign WriteRegMuxed = (Stall) ? WriteReg_Out : WriteReg;
	
	assign RsMuxed = (Stall) ? Rs_Out : Rs;
	assign RtMuxed = (Stall) ? Rt_Out : Rt;
	assign RdMuxed = (Stall) ? Rd_Out : Rd;
	
	assign RegFileWrEnMuxed = (Stall) ? RegFileWrEn_Out : RegFileWrEn;
	assign AddressMuxed = (Stall) ? Address : Result;
	assign MemReadMuxed = (Stall) ? MemRead_Out : MemRead;
	assign MemWriteMuxed = (Stall) ? MemWrite_Out : MemWrite;
	assign MemToRegMuxed = (Stall) ? MemToReg_Out : MemToReg;
	assign ALUOp2Muxed = (Stall) ? WriteData : ALUOp2;
	assign HaltMuxed = (Stall) ? Halt_Out : Halt;
endmodule 

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
	ExecuteOut, MemOut, MemToReg, RegFileWrEn,  Rs, Rt, Rd, WriteReg,
	/* outputs */
	ExecuteOut_Out, MemOut_Out, MemToReg_Out, RegFileWrEn_Out, WriteReg_Out,
	Rs_Out, Rt_Out, Rd_Out
);

	input Stall, rst, clk, MemToReg, RegFileWrEn;
	input [2:0] Rs, Rt, Rd, WriteReg;
	input [15:0] ExecuteOut, MemOut;
	output MemToReg_Out, RegFileWrEn_Out;
	output [2:0] Rs_Out, Rt_Out, Rd_Out, WriteReg_Out;
	output [15:0] ExecuteOut_Out, MemOut_Out;
	
	wire [15:0] MemOut_Out, ExecuteOutMuxed, MemOutMuxed;
	wire [2:0] WriteRegMuxed, RsMuxed, RtMuxed, RdMuxed;
	wire MemToReg_Out, RegFileWrEnMuxed;
	
	dff WriteReg_reg[2:0](.d(WriteRegMuxed), .q(WriteReg_Out), .rst(rst), .clk(clk));
	
	dff rs_reg[2:0](.d(RsMuxed), .q(Rs_Out), .rst(rst), .clk(clk));
	dff rt_reg[2:0](.d(RtMuxed), .q(Rt_Out), .rst(rst), .clk(clk));
	dff rd_reg[2:0](.d(RdMuxed), .q(Rd_Out), .rst(rst), .clk(clk));
	
	dff rf_wr_en_reg(.d (RegFileWrEnMuxed), .q(RegFileWrEn_Out), .rst(rst), .clk(clk));
	dff executeout_reg[15:0] (.d(ExecuteOutMuxed), .q(ExecuteOut_Out), .rst(rst), .clk(clk));
	dff memout_reg[15:0] (.d(MemOutMuxed), .q(MemOut_Out), .rst(rst), .clk(clk));
	dff memtoreg_reg (.d(MemToRegMuxed), .q(MemToReg_Out), .rst(rst), .clk(clk));
	
	assign WriteRegMuxed = (Stall) ? WriteReg_Out : WriteReg;
	
	assign RsMuxed = (Stall) ? Rs_Out : Rs;
	assign RtMuxed = (Stall) ? Rt_Out : Rt;
	assign RdMuxed = (Stall) ? Rd_Out : Rd;
	
	assign RegFileWrEnMuxed = (Stall) ? RegFileWrEn_Out : RegFileWrEn;
	assign ExecuteOutMuxed = (Stall) ? ExecuteOut_Out : ExecuteOut;
	assign MemOutMuxed = (Stall) ? MemOut_Out : MemOut;
	assign MemToRegMuxed = (Stall) ? MemToReg_Out : MemToReg;
	
endmodule

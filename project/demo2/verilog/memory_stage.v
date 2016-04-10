
module memory_stage(
	/* common inputs */
	Stall, Flush, rst, clk, 
	/* inputs */
	MemRead, MemWrite, Halt, Address, WriteData, ExecuteOut,
	/* passthrough inputs */
	MemToReg, RegFileWrEn,
	/* passthrough outputs */
	MemToReg_Out, ExecuteOut_Out, RegFileWrEn_Out,
	/* outputs */
	ReadData
);

	input Stall, Flush, rst, clk;
	input MemRead, MemWrite, Halt;
	input [15:0] ExecuteOut, Address, WriteData;
	input MemToReg, RegFileWrEn;
	output [15:0] ReadData, ExecuteOut_Out;
	output MemToReg_Out, RegFileWrEn_Out;

	wire [15:0] mem_read_data;
	
    memory m(.clk       (clk),
             .rst       (rst),
             .MemRead   (MemRead),
             .MemWrite  (MemWrite),
             .halt      (Halt),
             .Address   (Address),
             .WriteData (WriteData),
             .ReadData  (mem_read_data));
             
	 pipe_mw pmw(	
		.Stall			(Stall),
		.rst			(rst | Flush),
		.clk			(clk),
		.ExecuteOut		(ExecuteOut),
		.MemOut			(mem_read_data),
		.MemToReg		(MemToReg),
		.ExecuteOut_Out	(ExecuteOut_Out),
		.MemOut_Out		(MemOut_Out),
		.MemToReg_Out	(MemToReg_Out),
		.RegFileWrEn	(RegFileWrEn),
		.RegFileWrEn_Out(RegFileWrEn_Out)
	);
endmodule

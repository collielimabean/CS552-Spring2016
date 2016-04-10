
// NOTE: Flush is not needed as an input
// the execute stage is basically all combinational logic anyway
module execute_stage(
	/* common inputs */
	Stall, Flush, rst, clk, 
	/* inputs */
	ALUOp1, ALUOp2, Immediate, ALUOpcode, 
	IncPC, Func, Jump, Branch, JumpReg,
	Set, ALUSrc, InvA, InvB, Cin, Btr,
	/* forwarding inputs and signals */
    ForwardALUOp1, ForwardALUOp2,
    PipeEM_Result, PipeMW_Result,
	/* passthrough inputs */
	MemRead, MemWrite, MemToReg, Halt, RegFileWrEn,
	/* outputs */
	Address, WriteData, NextPC, Err,
	/* passthrough outputs */
	MemRead_Out, MemWrite_Out, MemToReg_Out, Halt_Out, RegFileWrEn_Out
);
	input Stall, Flush, rst, clk;
	input [15:0] ALUOp1, ALUOp2, Immediate, IncPC,
				 PipeEM_ALUOp1, PipeEM_ALUOp2,
				 PipeMW_ALUOp1, PipeMW_ALUOp2;
				 
	input [2:0] ALUOpcode;
	input [1:0] Func, ForwardALUOp1, ForwardALUOp2;
	input Jump, Branch, JumpReg, Set, ALUSrc, InvA, InvB, Cin, Btr,
		  MemRead, MemWrite, MemToReg, Halt;
		  
	output [15:0] Address, WriteData, NextPC;
	output MemRead_Out, MemWrite_Out, Halt_Out, MemToReg_Out;

	wire [15:0] execute_result;

    execute e(.ALUOp1   (ALUOp1),
              .ALUOp2   (ALUOp2),
              .Btr      (Btr),
              .Opcode   (ALUOpcode),
              .IncPC    (IncPC),
              .InvA     (InvA),
              .InvB     (InvB),
              .Cin      (Cin),
              .Jump     (Jump),
              .Branch   (Branch),
              .JumpReg  (JumpReg),
              .Set      (Set),
              .Func     (Func),
              .Imm      (Immediate),
              .ALUSrc   (ALUSrc),
              .Result   (execute_result),
              .NextPC   (NextPC),
              .PipeEM_Result (PipeEM_Result), 
              .PipeMW_Result (PipeMW_Result)
	);      
              
	pipe_em pem(
		.Stall			(Stall),
		.rst			(rst | Flush),
		.clk			(clk),
		.Result			(execute_result),
		.MemRead		(MemRead),
		.MemWrite		(MemWrite),
		.MemToReg		(MemToReg),
		.Halt			(Halt),
		.ALUOp2			(ALUOp2),
		.Address		(Address),
		.MemRead_Out	(MemRead_Out),
		.MemWrite_Out	(MemWrite_Out),
		.MemToReg_Out	(MemToReg_Out),
		.Halt_Out		(Halt_Out),
		.WriteData		(WriteData),
		.RegFileWrEn	(RegFileWrEn),
		.RegFileWrEn_Out(RegFileWrEn_Out)
	);
		
endmodule

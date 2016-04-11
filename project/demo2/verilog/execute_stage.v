
// NOTE: Flush is not needed as an input
// the execute stage is basically all combinational logic anyway
module execute_stage(
	/* common inputs */
	Stall, Flush, rst, clk, 
	/* inputs */
	ALUOp1, ALUOp2, Immediate, ALUOpcode, 
	IncPC, Func, Jump, Branch, JumpReg,
	Set, ALUSrc, InvA, InvB, Cin, Btr,
	Rs, Rt, Rd,
	/* forwarding inputs and signals */
    ForwardALUOp1, ForwardALUOp2,
    PipeEM_Result, PipeMW_Result,
	/* passthrough inputs */
	MemRead, MemWrite, MemToReg, Halt, RegFileWrEn, WriteReg,
	/* outputs */
	Address, WriteData, BranchPC, Err, BranchJumpTaken,
	Rs_Out, Rt_Out, Rd_Out,
	/* passthrough outputs */
	MemRead_Out, MemWrite_Out, MemToReg_Out, Halt_Out, RegFileWrEn_Out,
	WriteReg_Out
);
	input Stall, Flush, rst, clk;
	input [15:0] ALUOp1, ALUOp2, Immediate, IncPC,
				 PipeEM_Result, PipeMW_Result;
				 
	input [2:0] ALUOpcode, Rs, Rt, Rd, WriteReg;
	input [1:0] Func, ForwardALUOp1, ForwardALUOp2;
	input Jump, Branch, JumpReg, Set, ALUSrc, InvA, InvB, Cin, Btr,
		  MemRead, MemWrite, MemToReg, Halt, RegFileWrEn;
		  
	output [15:0] Address, WriteData, BranchPC;
	output [2:0] Rs_Out, Rt_Out, Rd_Out, WriteReg_Out;
	output MemRead_Out, MemWrite_Out, Halt_Out, MemToReg_Out, Err,
		   RegFileWrEn_Out, BranchJumpTaken;

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
              .NextPC   (BranchPC),
              .PipeEM_Result (PipeEM_Result), 
              .PipeMW_Result (PipeMW_Result),
              .BranchJumpTaken (BranchJumpTaken),
              .ForwardALUOp1	(ForwardALUOp1),
              .ForwardALUOp2	(ForwardALUOp2),
              .Err				(Err),
              .rst				(rst)
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
		.RegFileWrEn_Out(RegFileWrEn_Out),
		.Rs				(Rs),
		.Rt				(Rt),
		.Rd				(Rd),
		.Rs_Out			(Rs_Out),
		.Rt_Out			(Rt_Out),
		.Rd_Out			(Rd_Out),
		.WriteReg		(WriteReg),
		.WriteReg_Out	(WriteReg_Out)
	);
		
endmodule

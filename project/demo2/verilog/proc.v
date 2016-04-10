/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
module proc (/*AUTOARG*/
    // Outputs
    err, 
    // Inputs
    clk, rst
    );

    input clk;
    input rst;

    output err;

    // None of the above lines can be modified

    // OR all the err ouputs for every sub-module and assign it as this
    // err output

    // As desribed in the homeworks, use the err signal to trap corner
    // cases that you think are illegal in your statemachines

	wire [15:0] Instr, IncPC, NextPC, D_IncPC, RegWriteData, ALUOP1,
				ALUOp2, Immediate, Address, MemoryWriteData, M_ExecuteOut,
				PipeEM_ALUOp1, PipeEM_ALUOp2, PipeMW_ALUOp1, PipeMW_ALUOp2;
	wire [2:0] ALUOpcode;
	wire [1:0] Func;
	wire Stall, Flush, Halt, Exception, Rti, ALUSrc, Branch, Jump,
		 JumpReg, Set, Btr, MemWrite, MemRead, MemToReg, InvA, InvB,
		 Cin, E_MemRead, E_MemWrite, E_MemToReg, E_Halt, M_MemToReg,
		 d_err, e_err, ForwardALUOp1, ForwardALUOp2;

	assign err = d_err | e_err;

	// fetch
	fetch_stage fs(
		.NextPC		(NextPC), /////// HAZARD //////
		.clk 		(clk),
		.rst 		(rst),
		.Stall		(Stall),
		.Flush		(Flush),
		.Halt 		(Halt), /////// HAZARD //////
		.Exception 	(Exception), /////// HAZARD //////
		.Rti		(Rti), /////// HAZARD //////
		.Instr		(Instr),
		.IncPC		(IncPC)
	);
	
	// hazard detection unit
	
	
	// decode
	decode_stage ds(
		.Stall				(Stall),
		.Flush				(Flush),
		.rst				(rst),
		.clk				(clk),
		.Instr				(Instr),
		.WriteData			(RegWriteData), /////// HAZARD //////
		.IncPC				(IncPC),
		.IncPC_Out			(D_IncPC),
		.ALUOp1				(ALUOp1),
		.ALUOp2				(ALUOp2),
		.Immediate			(Immediate),
		.ALUOpcode			(ALUOpcode),
		.Func				(Func),
		.ALUSrc				(ALUSrc),
		.Branch				(Branch),
		.Jump				(Jump),
		.JumpReg			(JumpReg),
		.Set				(Set),
		.Btr				(Btr),
		.MemWrite			(MemWrite),
		.MemRead			(MemRead),
		.MemToReg			(MemToReg),
		.Halt				(Halt), /////// HAZARD //////
		.Exception			(Exception),
		.Err				(d_err),
		.InvA				(InvA),
		.InvB				(InvB),
		.Cin				(Cin),
		.Rti				(Rti)
		// forwarding signals
	);
	
	// execute
	execute_stage es(
		.Stall				(Stall),
		.Flush				(Flush),
		.rst				(rst),
		.clk				(clk),
		.ALUOp1				(ALUOp1),
		.ALUOp2				(ALUOp2),
		.Immediate			(Immediate),
		.ALUOpcode			(ALUOpcode),
		.Func				(Func),
		.ALUSrc				(ALUSrc),
		.Branch				(Branch),
		.Jump				(Jump),
		.JumpReg			(JumpReg),
		.Set				(Set),
		.Btr				(Btr),
		.MemWrite			(MemWrite),
		.MemRead			(MemRead),
		.MemToReg			(MemToReg),
		.Halt				(Halt),
		.Address			(Address),
		.WriteData			(MemoryWriteData),
		.NextPC				(NextPC), /////// HAZARD //////
		.MemRead_Out		(E_MemRead),
		.MemWrite_Out		(E_MemWrite),
		.MemToReg_Out		(E_MemToReg),
		.Halt_Out			(E_Halt),
		// forwarding signals //
		.ForwardALUOp1      (ForwardALUOp1),
		.ForwardALUOp2		(ForwardALUOp2),
		.PipeEM_ALUOp1		(), 
		.PipeEM_ALUOp2		(),
		.PipeMW_ALUOp1		(), 
		.PipeMW_ALUOp2		(),
	);
	
	// forwarding unit //
	// execute hazard
	// if (P_EM.RegWrite && (P_EM.RegisterRd == P_DE.RegisterRs)) ForwardALUOp1 <= 2'b10
	// if (P_EM.RegWrite && (P_EM.RegisterRd == P_DE.RegisterRt)) ForwardALUOp2 <= 2'b10
	// memory hazard
	// if (P_MW.RegWrite && ~(P_EM.RegWrite) && (P_MW.RegisterRd == P_DE.RegisterRs)) ForwardALUOp1 <= 2'b01
	// if (P_MW.RegWrite && ~(P_EM.RegWrite) && (P_MW.RegisterRd == P_DE.RegisterRt)) ForwardALUOp2 <= 2'b01
	// new required signals that we need to expose: Rs, Rt, Rd - passthrough all
	// supposedly Rt is used for stalling
	// DE: Rs, Rt, Rd
	// EM: Rt|Rd muxed
	// MW: passthrough from EM stage
	
	// memory 
	memory_stage ms(
		.Stall				(Stall),
		.Flush				(1'b0), // we should never have to flush in the memory_stage
		.rst				(rst),
		.clk				(clk),
		.MemRead			(E_MemRead),
		.MemWrite			(E_MemWrite),
		.Halt				(E_Halt),
		.MemToReg			(E_MemToReg),
		.Address			(Address),
		.WriteData			(MemoryWriteData),
		.ExecuteOut			(MemoryWriteData), // note: execute's result is the same as the write data for the memory stage
		.ExecuteOut_Out		(M_ExecuteOut),
		.MemToReg_Out		(M_MemToReg),
		.ReadData			(MemoryReadData)
	);

	// writeback
    writeback w(
		.ExecuteOut (M_ExecuteOut),
		.MemOut     (MemoryReadData),
		.MemToReg   (M_MemToReg),
		.WriteData  (RegWriteData) /////// HAZARD //////
	); 
endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:

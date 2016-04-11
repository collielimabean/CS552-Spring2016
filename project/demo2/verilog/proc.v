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

	wire [15:0] Instr, IncPC, BranchPC, D_IncPC, RegWriteData, ALUOp1,
				ALUOp2, Immediate, Address, MemoryWriteData, M_ExecuteOut,
				MemoryReadData;
	wire [2:0] ALUOpcode, 
			   D_Rs, D_Rt, D_Rd, 
			   E_Rs, E_Rt, E_Rd,
			   M_Rs, M_Rt, M_Rd,
			   D_WriteReg, E_WriteReg, M_WriteReg,
               D_Rs_Imm, D_Rt_Imm, D_Rd_Imm;
	wire [1:0] Func, ForwardALUOp1, ForwardALUOp2;
	wire Stall, Flush, Exception, Rti, ALUSrc, Branch, Jump,
		 JumpReg, Set, Btr, MemWrite, MemRead, MemToReg, InvA, InvB,
		 Cin, E_MemRead, E_MemWrite, E_MemToReg, E_Halt, M_MemToReg,
		 d_err, e_err, D_RegWrite, E_RegWrite, M_RegWrite, BranchJumpTaken,
         D_RtValid_Imm;

	assign err = d_err | e_err;

	// fetch
	fetch_stage fs(
		.BranchPC			(BranchPC),
		.BranchJumpTaken	(BranchJumpTaken), /////// HAZARD //////
		.clk 				(clk),
		.rst 				(rst),
		.Stall				(Stall),
		.Flush				(Flush),
		.Halt 				(E_Halt), /////// HAZARD //////
		.Exception 			(Exception), /////// HAZARD //////
		.Rti				(Rti), /////// HAZARD //////
		.Instr				(Instr),
		.IncPC				(IncPC)
	);
	
	// hazard detection unit
	// TODO: generate Flush & Stall signal(s)
	// WARNING: WE DO NOT DISTINGUISH BETWEEN PIPELINE REGISTERS - WE FLUSH EVERYTHING WHEN BRANCH DETECTED.
	// WE MAY HAVE TO RESTRUCTURE OUR PIPELINE REGISTERS SINCE IT'S NOT SPLIT BY F/D/E/M. 
	assign Flush = rst | BranchJumpTaken;
	assign Stall = 1'b0;
	
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
		.Halt				(D_Halt), /////// HAZARD //////
		.Exception			(Exception),
		.Err				(d_err),
		.InvA				(InvA),
		.InvB				(InvB),
		.Cin				(Cin),
		.Rti				(Rti),
		// forwarding passthrough
        .Rs_Imm             (D_Rs_Imm), // does not go through pipeline register
        .Rt_Imm             (D_Rt_Imm), // does not go through pipeline register
        .Rd_Imm             (D_Rd_Imm), // does not go through pipeline register
        .RtValid_Imm        (D_RtValid_Imm), // does not go through pipeline register
        .RtValid            (D_RtValid),
		.Rs					(D_Rs),
		.Rt					(D_Rt),
		.Rd					(D_Rd),
		// from writeback
		.RegFileWrEn		(M_RegWrite),
		.RegFileWrEn_Out	(D_RegWrite),
		.WriteReg			(M_WriteReg),
		.WriteReg_Out		(D_WriteReg)
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
		.Halt				(D_Halt),
		.Address			(Address),
		.WriteData			(MemoryWriteData),
		.BranchPC			(BranchPC), /////// HAZARD //////
		.MemRead_Out		(E_MemRead),
		.MemWrite_Out		(E_MemWrite),
		.MemToReg_Out		(E_MemToReg),
		.Halt_Out			(E_Halt),
		// forwarding signals //
        .RtValid            (D_RtValid),
        .RtValid_Out        (E_RtValid),
		.Rs					(D_Rs),
		.Rd					(D_Rd),
		.Rt					(D_Rt),
		.Rs_Out				(E_Rs),
		.Rd_Out				(E_Rd),
		.Rt_Out				(E_Rt),
		.ForwardALUOp1      (ForwardALUOp1),
		.ForwardALUOp2		(ForwardALUOp2),
		.PipeEM_Result		(Address), 
		.PipeMW_Result		(RegWriteData), 
		.RegFileWrEn		(D_RegWrite),
		.RegFileWrEn_Out	(E_RegWrite),
		.BranchJumpTaken	(BranchJumpTaken),
		.Cin				(Cin),
		.InvA				(InvA),
		.InvB				(InvB),
		.IncPC				(D_IncPC),
		.Err				(e_err),
		.WriteReg			(D_WriteReg),
		.WriteReg_Out		(E_WriteReg)
	);
	
    assign ForwardALUOp1 = (E_RegWrite & ~(|(E_Rd ^ D_Rs_Imm))) ? 2'b10 :
                    (M_RegWrite & (|M_Rd) & ~(E_RegWrite & (|E_Rd) & ~(|(E_Rd ^ D_Rs_Imm))) & ~(|(M_Rd ^ D_Rs_Imm))) ? 2'b01 :
                    2'b00;

    assign ForwardALUOp2 = (E_RegWrite & (~(|(E_Rd ^ D_Rt_Imm)) & D_RtValid_Imm)) ? 2'b10 : 
                    (M_RegWrite & (|M_Rd) & ~(E_RegWrite & (|E_Rd) & (D_RtValid_Imm & ~(|(E_Rd ^ D_Rt_Imm))))) & (~(|(M_Rd ^ D_Rt_Imm) & D_RtValid_Imm)) ? 2'b01 :
                    2'b00;
	
	// memory 
	memory_stage ms(
		.Stall				(Stall),
		.Flush				(1'b0), // we should never have to flush pipe_mw
		.rst				(rst),
		.clk				(clk),
		.MemRead			(E_MemRead),
		.MemWrite			(E_MemWrite),
		.Halt				(E_Halt),
		.MemToReg			(E_MemToReg),
		.Address			(Address),
		.WriteData			(MemoryWriteData),
		.ExecuteOut			(Address), // note: execute's result is the same as the Address for the memory stage
		.ExecuteOut_Out		(M_ExecuteOut),
		.MemToReg_Out		(M_MemToReg),
		.ReadData			(MemoryReadData),
		// forwarding signals
        .RtValid            (E_RtValid),
        .RtValid_Out        (M_RtValid),
		.Rs					(E_Rs),
		.Rd					(E_Rd),
		.Rt					(E_Rt),
		.Rs_Out				(M_Rs),
		.Rd_Out				(M_Rd),
		.Rt_Out				(M_Rt),
		.RegFileWrEn		(E_RegWrite),
		.RegFileWrEn_Out	(M_RegWrite),
		.WriteReg			(E_WriteReg),
		.WriteReg_Out		(M_WriteReg)
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

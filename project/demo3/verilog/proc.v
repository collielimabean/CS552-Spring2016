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

    wire [15:0] F_Instr, F_IncPC, PFD_Instr, PFD_IncPC, D_ALUOp1, D_ALUOp2,
                D_Immediate, PDE_ALUOp1, PDE_ALUOp2, PDE_Immediate, PDE_IncPC,
                E_ExecuteResult, E_BranchPC, M_ReadData, PEM_Address, PEM_WriteData, PMW_ExecuteOut, 
                PMW_MemOut, W_WriteData, PDE_DecodeIncPC;
    wire [2:0] D_ALUOpcode, D_Rs, D_Rd, D_Rt, D_WriteReg, PDE_ALUOpcode,
               PDE_Rs, PDE_Rd, PDE_Rt, PDE_WriteReg, PEM_Rs, PEM_Rt, PEM_Rd,
               PEM_WriteReg, PMW_Rs, PMW_Rt, PMW_Rd, PMW_WriteReg;
    wire [1:0] D_Func, PDE_Func, ForwardALUOp1, ForwardALUOp2;
    wire Flush, Stall, D_ALUSrc, D_Branch, D_Jump, D_JumpReg, D_Set, D_Btr, 
         D_MemRead, D_MemWrite, D_MemToReg, D_Halt, D_Exception, D_Err, 
         D_InvA, D_InvB, D_Cin, D_Rti, D_RtValid, D_RegFileWrEn, PFD_CPUActive, PDE_ALUSrc,
         PDE_Branch, PDE_Jump, PDE_JumpReg, PDE_Set, PDE_Btr, PDE_MemRead,
         PDE_MemWrite, PDE_MemToReg, PDE_Halt, PDE_InvA, PDE_InvB, PDE_Cin,
         PDE_RegFileWrEn, PDE_RtValid, E_Err, PDE_CPUActive, 
         E_BranchJumpTaken, PEM_MemRead, PEM_MemWrite, PEM_MemToReg, PEM_Halt,
         PEM_RegFileWrEn, PMW_MemToReg, PMW_RegFileWrEn, Saturated,
         D_RsValid, PDE_RsValid, D_RdValid, PDE_RdValid, D_Link, PDE_Link, D_Store,
         F_Err, F_InstrMemStall, F_CacheHit, M_DataMemStall, M_Err;


    assign err = F_Err | M_Err;

	// hazard detection unit
	assign Flush = rst | E_BranchJumpTaken;

    assign ForwardALUOp1 = 2'b00;
    assign ForwardALUOp2 = 2'b00;

    assign StallState = F_InstrMemStall | M_DataMemStall;

    assign Stall =  ~Flush & ((D_RsValid & PDE_RegFileWrEn & (PDE_WriteReg == D_Rs)) | (D_RtValid & PDE_RegFileWrEn & (PDE_WriteReg == D_Rt))
                   | (D_RsValid & PEM_RegFileWrEn & (PEM_WriteReg == D_Rs)) | (D_RtValid & PEM_RegFileWrEn & (PEM_WriteReg == D_Rt))
                   | ((D_Store) & ((D_RdValid & PDE_RegFileWrEn & (PDE_WriteReg == D_Rd)) | (D_RdValid & PEM_RegFileWrEn & (PEM_WriteReg == D_Rd)))));

    fetch f(
        .BranchPC               (E_BranchPC),
        .BranchJumpTaken        (E_BranchJumpTaken),
        .clk                    (clk),
        .rst      	            (rst),
        .Halt     	            (PEM_Halt),
        .Exception              (D_Exception),
        .Rti                    (D_Rti),
        .Stall                  (Stall | StallState),
        .Instr                  (F_Instr),
        .IncPC                  (F_IncPC),
        .InstrMemStall          (F_InstrMemStall),
        .CacheHit               (F_CacheHit),
        .Err                    (F_Err)
    );

    pipe_fd fd(
        .Stall                  (Stall | StallState),
        .Flush                  (Flush),
        .rst                    (rst | Flush),
        .clk                    (clk),
        .Instr                  (F_Instr),
        .IncPC                  (F_IncPC),
        .Instr_Out              (PFD_Instr),
        .IncPC_Out              (PFD_IncPC),
        .CPUActive              (PFD_CPUActive)
    );
               
    decode d(
        .clk                    (clk),
        .rst                    (rst),
        .Stall                  (Stall | StallState),
        .Instr                  (PFD_Instr),
        .IncPC                  (PFD_IncPC),
        .WriteData              (W_WriteData),
        .ALUOp1                 (D_ALUOp1),
        .ALUOp2                 (D_ALUOp2),
        .ALUSrc                 (D_ALUSrc),
        .Branch                 (D_Branch),
        .Jump                   (D_Jump),
        .JumpReg                (D_JumpReg),
        .Set                    (D_Set),
        .Btr                    (D_Btr),
        .ALUOpcode              (D_ALUOpcode),
        .Func                   (D_Func),
        .MemWrite               (D_MemWrite),
        .MemRead                (D_MemRead),
        .MemToReg               (D_MemToReg),
        .Halt                   (D_Halt),
        .Exception              (D_Exception),
        .Err                    (D_Err),
        .Immediate              (D_Immediate),
        .InvA                   (D_InvA),
        .InvB                   (D_InvB),
        .Cin                    (D_Cin),
        .Rti                    (D_Rti),
        .Rs		                (D_Rs),
        .Rt 		            (D_Rt),
        .Rd		                (D_Rd),
        .RegFileWrEn            (PMW_RegFileWrEn),
        .RegFileWrEn_Out	    (D_RegFileWrEn),
        .WriteReg		        (PMW_WriteReg),
        .WriteReg_Out	        (D_WriteReg),
        .RtValid                (D_RtValid),
        .RdValid                (D_RdValid),
        .RsValid                (D_RsValid),
        .Link                   (D_Link),
        .Store                  (D_Store)
     );

    pipe_de pde(
        .IncPC              (F_IncPC),
        .clk                (clk),
        .rst                (rst | Flush),
        .Flush              (Flush),
        .Stall              (StallState),
        .ALUOp1             (D_ALUOp1),
        .ALUOp2             (D_ALUOp2),
        .Immediate          (D_Immediate),
        .ALUOpcode          (D_ALUOpcode),
        .Func               (D_Func & ~(Stall | StallState)),
        .ALUSrc             (D_ALUSrc & ~(Stall | StallState)),
        .Branch             (D_Branch & ~(Stall | StallState)),
        .Jump               (D_Jump & ~(Stall | StallState)),
        .JumpReg            (D_JumpReg & ~(Stall | StallState)),
        .Set                (D_Set & ~(Stall | StallState)),
        .Btr                (D_Btr & ~(Stall | StallState)),
        .MemWrite           (D_MemWrite & ~(Stall | StallState)),
        .MemRead            (D_MemRead & ~(Stall | StallState)),
        .MemToReg           (D_MemToReg & ~(Stall | StallState)),
        .Halt               (D_Halt & ~rst & ~(Stall | StallState)),
        .InvA               (D_InvA & ~(Stall | StallState)),
        .InvB               (D_InvB & ~(Stall | StallState)),
        .Cin                (D_Cin & ~(Stall | StallState)),
        .CPUActive          (PFD_CPUActive),
        .IncPC_Out          (PDE_IncPC),
        .ALUOp1_Out         (PDE_ALUOp1),
        .ALUOp2_Out         (PDE_ALUOp2),
        .Immediate_Out      (PDE_Immediate),
        .ALUOpcode_Out      (PDE_ALUOpcode),
        .Func_Out           (PDE_Func),
        .ALUSrc_Out         (PDE_ALUSrc),
        .Branch_Out         (PDE_Branch),
        .Jump_Out           (PDE_Jump),
        .JumpReg_Out        (PDE_JumpReg),
        .Set_Out            (PDE_Set),
        .Btr_Out            (PDE_Btr),
        .MemWrite_Out       (PDE_MemWrite),
        .MemRead_Out        (PDE_MemRead),
        .MemToReg_Out       (PDE_MemToReg),
        .Halt_Out           (PDE_Halt),
        .InvA_Out           (PDE_InvA),
        .InvB_Out           (PDE_InvB),
        .Cin_Out            (PDE_Cin),
        .RtValid            (D_RtValid & ~(Stall | StallState)),
        .RtValid_Out        (PDE_RtValid),
        .Rs                 (D_Rs),
        .Rt                 (D_Rt),
        .Rd                 (D_Rd),
        .Rs_Out             (PDE_Rs),
        .Rt_Out             (PDE_Rt),
        .Rd_Out             (PDE_Rd),
        .RegFileWrEn        (D_RegFileWrEn & ~(Stall | StallState)),
        .RegFileWrEn_Out    (PDE_RegFileWrEn),
        .WriteReg		    (D_WriteReg),
        .WriteReg_Out	    (PDE_WriteReg),
        .CPUActive_Out      (PDE_CPUActive),
        .RsValid            (D_RsValid),
        .RsValid_Out        (PDE_RsValid),
        .RdValid            (D_RdValid),
        .RdValid_Out        (PDE_RdValid),
        .DecodeIncPC        (PFD_IncPC),
        .DecodeIncPC_Out    (PDE_DecodeIncPC),
        .Link               (D_Link),
        .Link_Out           (PDE_Link)
    );  
 
    execute e(
        .ALUOp1             (PDE_ALUOp1),
        .ALUOp2             (PDE_ALUOp2),
        .Btr                (PDE_Btr),
        .Opcode             (PDE_ALUOpcode),
        .DecodeIncPC        (PDE_DecodeIncPC),
        .IncPC              (PDE_IncPC),
        .InvA               (PDE_InvA),
        .InvB               (PDE_InvB),
        .Cin                (PDE_Cin),
        .Jump               (PDE_Jump),
        .Branch             (PDE_Branch),
        .JumpReg            (PDE_JumpReg),
        .Set                (PDE_Set),
        .Func               (PDE_Func),
        .Imm                (PDE_Immediate),
        .ALUSrc             (PDE_ALUSrc),
        .Result             (E_ExecuteResult),
        .NextPC             (E_BranchPC),
        .PipeEM_Result      (PEM_Address),
        .PipeMW_Result      (PMW_ExecuteOut),
        .BranchJumpTaken    (E_BranchJumpTaken),
        .ForwardALUOp1	    (ForwardALUOp1),
        .ForwardALUOp2	    (ForwardALUOp2),
        .Err				(E_Err),
        .rst				(rst),
        .Link               (PDE_Link)
	);      
              
	pipe_em pem(
		.Stall		    (M_DataMemStall),
		.rst			(rst),
		.clk			(clk),
		.Result			(E_ExecuteResult),
		.MemRead		(PDE_MemRead & ~F_InstrMemStall),
		.MemWrite		(PDE_MemWrite & ~F_InstrMemStall),
		.MemToReg		(PDE_MemToReg),
		.Halt			(PDE_Halt),
		.ALUOp2			(PDE_ALUOp2),
		.Address		(PEM_Address),
		.MemRead_Out	(PEM_MemRead),
		.MemWrite_Out	(PEM_MemWrite),
		.MemToReg_Out	(PEM_MemToReg),
		.Halt_Out		(PEM_Halt),
		.WriteData		(PEM_WriteData),
		.RegFileWrEn	(PDE_RegFileWrEn & ~(F_InstrMemStall & ~PDE_Link)),
		.RegFileWrEn_Out(PEM_RegFileWrEn),
		.Rs				(PDE_Rs),
		.Rt				(PDE_Rt),
		.Rd				(PDE_Rd),
		.Rs_Out			(PEM_Rs),
		.Rt_Out			(PEM_Rt),
		.Rd_Out			(PEM_Rd),
		.WriteReg		(PDE_WriteReg),
		.WriteReg_Out	(PEM_WriteReg)
	);

    memory m(.clk   (clk),
         .rst       (rst),
         .MemRead   (PEM_MemRead),
         .MemWrite  (PEM_MemWrite),
         .halt      (PEM_Halt),
         .Address   (PEM_Address),
         .WriteData (PEM_WriteData),
         .ReadData  (M_ReadData),
         .Err       (M_Err),
         .DataMemStall (M_DataMemStall),
         .CacheHit     (M_CacheHit)
    );
       
    pipe_mw pmw(	
		.Stall			(1'b0),
		.rst			(rst | M_DataMemStall), 
		.clk			(clk),
		.ExecuteOut		(PEM_Address),
		.MemOut			(M_ReadData),
		.MemToReg		(PEM_MemToReg),
		.ExecuteOut_Out	(PMW_ExecuteOut),
		.MemOut_Out		(PMW_MemOut),
		.MemToReg_Out	(PMW_MemToReg),
		.RegFileWrEn	(PEM_RegFileWrEn),
		.RegFileWrEn_Out(PMW_RegFileWrEn),
		.Rs				(PEM_Rs),
		.Rt				(PEM_Rt),
		.Rd				(PEM_Rd),
		.Rs_Out			(PMW_Rs),
		.Rt_Out			(PMW_Rt),
		.Rd_Out			(PMW_Rd),
		.WriteReg		(PEM_WriteReg),
		.WriteReg_Out	(PMW_WriteReg)
	);
    
    // writeback
    writeback w(
		.ExecuteOut (PMW_ExecuteOut),
		.MemOut     (PMW_MemOut),
		.MemToReg   (PMW_MemToReg),
		.WriteData  (W_WriteData) /////// HAZARD //////
	); 
   
endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:

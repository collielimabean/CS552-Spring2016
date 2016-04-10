module decode_stage(
	/* common inputs */
	Stall, Flush, rst, clk, 
	/* inputs */
	Instr, WriteData,
	/* passthrough inputs */
	IncPC, 
	/* outputs */
	ALUOp1, ALUOp2, Immediate, ALUOpcode,
	Func, ALUSrc, Branch, Jump, JumpReg,
	Set, Btr, MemWrite, MemRead, MemToReg,
	Halt, Exception, Err, InvA, InvB, Cin, Rti 
	/* passthrough outputs */
	IncPC_Out
);
	input [15:0] Instr, WriteData, IncPC;
	output[15:0] ALUOp1, ALUOp2, Immediate;
	output [2:0] ALUOpcode;
	output [1:0] Func;
	output ALUSrc, Branch, Jump, JumpReg, Set, Btr, MemWrite, MemRead,
		   MemToReg, Halt, Exception, InvA, InvB, Cin, Rti;

	wire [15:0] aluop1, aluop2, immediate;
	wire [2:0] aluopcode;
	wire [1:0] func;
	wire alusrc, branch, jump, jumpreg, set, btr, memwrite, memtoreg,
		 memread, halt, inva, invb, cin;

    decode d(.clk       (clk),
             .rst       (rst),
             .Instr     (Instr),
             .IncPC     (IncPC),
             .WriteData (WriteData),
             .ALUOp1    (aluop1),
             .ALUOp2    (aluop2),
             .ALUSrc    (alusrc),
             .Branch    (branch),
             .Jump      (jump),
             .JumpReg   (jumpreg),
             .Set       (set),
             .Btr       (btr),
             .ALUOpcode (aluopcode),
             .Func      (func),
             .MemWrite  (memwrite),
             .MemRead   (memread),
             .MemToReg  (memtoreg),
             .Halt      (halt),
             .Exception (Exception),
             .Err       (Err),
             .Immediate (immediate),
             .InvA      (inva),
             .InvB      (invb),
             .Cin       (cin),
             .Rti       (Rti));

    pipe_de(.clk(clk),
            .rst(rst | Flush),
            .Stall(Stall),
            .ALUOp1(aluop1),
            .ALUOp2(aluop2),
            .Immediate(immediate),
            .ALUOpcode(aluopcode),
            .Func(func),
            .ALUSrc(alusrc),
            .Branch(branch),
            .Jump(jump),
            .JumpReg(jumpreg),
            .Set(set),
            .Btr(btr),
            .MemWrite(memwrite),
            .MemRead(memread),
            .MemToReg(memtoreg),
            .Halt(halt),
            .InvA(inva),
            .InvB(invb),
            .Cin(cin),
            .ALUOp1_Out(ALUOp1),
            .ALUOp2_Out(ALUOp2),
            .Immediate_Out(Immediate),
            .ALUOpcode_Out(ALUOpcode),
            .Func_Out(Func),
            .ALUSrc_Out(ALUSrc),
            .Branch_Out(Branch),
            .Jump_Out(Jump),
            .JumpReg_Out(JumpReg),
            .Set_Out(Set),
            .Btr_Out(Btr),
            .MemWrite_Out(MemWrite),
            .MemRead_Out(MemRead),
            .MemToReg_Out(MemToReg),
            .Halt_Out(Halt),
            .InvA_Out(InvA),
            .InvB_Out(InvB),
            .Cin_Out(Cin));

endmodule

// The pipeline stage between the decode and execute stages
module pipe_de(clk, rst, en, ALUOp1, ALUOp2, Immediate, ALUOpcode, Func, 
               ALUSrc, Branch, Jump, JumpReg, Set, Btr, MemWrite, MemRead,
               MemToReg, Halt, Exception, Err, InvA, InvB, Cin, Rti,
               ALUOp1_Out, ALUOp2_Out, Immediate_Out, ALUOpcode_Out, Func_Out,
               ALUSrc_Out, Branch_Out, Jump_Out, JumpReg_Out, Set_Out, Btr_Out,
               MemWrite_Out, MemRead_Out, MemToReg_Out, Halt_Out, 
               Exception_Out, Err_Out, InvA_Out, InvB_Out, Cin_Out, Rti_Out);
    

    input [15:0] ALUOp1, ALUOp2, Immediate;
    input [2:0] ALUOpcode;
    input [1:0] Func;
    input ALUSrc, Branch, Jump, JumpReg, Set, Btr, MemWrite, MemRead, MemToReg, 
          Halt, Exception, Err, InvA, InvB, Cin, Rti;

    output [15:0] ALUOp1_Out, ALUOp2_Out, Immediate_Out;
    output [2:0] ALUOpcode_Out;
    output [1:0] Func_Out;
    output ALUSrc_Out, Branch_Out, Jump_Out, JumpReg_Out, Set_Out, Btr_Out,
           MemWrite_Out, MemRead_Out, MemToReg_Out, Halt_Out, 
           Exception_Out, Err_Out, InvA_Out, InvB_Out, Cin_Out, Rti_Out;

    wire ALUOp1_Muxed, ALUOp2_Muxed, Immediate_Muxed, ALUOpcode_Muxed, 
         Func_Muxed, ALUSrc_Muxed, Branch_Muxed, Jump_Muxed, JumpReg_Muxed,
         Set_Muxed, Btr_Muxed, MemWrite_Muxed, MemRead_Muxed, MemToReg_Muxed,
         Halt_Muxed, Exception_Muxed, Err_Muxed, InvA_Muxed, InvB_Muxed, 
         Cin_Muxed, Rti_Muxed;

    dff ALUOp1_reg[15:0](.d(ALUOp1_Muxed), .q(ALUOp1_Out), .rst(rst), .clk(clk));
    dff ALUOp2_reg[15:0](.d(ALUOp2_Muxed), .q(ALUOp2_Out), .rst(rst), .clk(clk));
    dff Immediate_reg[15:0](.d(Immediate_Muxed), .q(Immediate_Out), .rst(rst), .clk(clk));
    dff ALUOpcode_reg[2:0](.d(ALUOpcode_Muxed), .q(ALUOpcode_Out), .rst(rst), .clk(clk));
    dff Func_reg[1:0](.d(Func_Muxed), .q(Func_Out), .rst(rst), .clk(clk));
    dff ALUSrc_reg(.d(ALUSrc_Muxed), .q(ALUSrc_Out), .rst(rst), .clk(clk));
    dff Branch_reg(.d(Branch_Muxed), .q(Branch_Out), .rst(rst), .clk(clk));
    dff Jump_reg(.d(Jump_Muxed), .q(Jump_Out), .rst(rst), .clk(clk));
    dff JumpReg_reg(.d(JumpReg_Muxed), .q(JumpReg_Out), .rst(rst), .clk(clk));
    dff Set_reg(.d(Set_Muxed), .q(Set_Out), .rst(rst), .clk(clk));
    dff Btr_reg(.d(Btr_Muxed), .q(Btr_Out), .rst(rst), .clk(clk));
    dff MemWrite_reg(.d(MemWrite_Muxed), .q(MemWrite_Out), .rst(rst), .clk(clk));
    dff MemRead_reg(.d(MemRead_Muxed), .q(MemRead_Out), .rst(rst), .clk(clk));
    dff MemToReg_reg(.d(MemToReg_Muxed), .q(MemToReg_Out), .rst(rst), .clk(clk));
    dff Halt_reg(.d(Halt_Muxed), .q(Halt_Out), .rst(rst), .clk(clk));
    dff Exception_reg(.d(Exception_Muxed), .q(Exception_Out), .rst(rst), .clk(clk));
    dff Err_reg(.d(Err_Muxed), .q(Err_Out), .rst(rst), .clk(clk));
    dff InvA_reg(.d(InvA_Muxed), .q(InvA_Out), .rst(rst), .clk(clk));
    dff InvB_reg(.d(InvB_Muxed), .q(InvB_Out), .rst(rst), .clk(clk));
    dff Cin_reg(.d(Cin_Muxed), .q(Cin_Out), .rst(rst), .clk(clk));
    dff Rti_reg(.d(Rti_Muxed), .q(Rti_Out), .rst(rst), .clk(clk));

	assign ALUOp1_Muxed = en ? ALUOp1 : ALUOp1_Out;
	assign ALUOp2_Muxed = en ? ALUOp2 : ALUOp2_Out;
	assign Immediate_Muxed = en ? Immediate : Immediate_Out;
	assign ALUOpcode_Muxed = en ? ALUOpcode : ALUOpcode_Out;
	assign Func_Muxed = en ? Func : Func_Out;
	assign ALUSrc_Muxed = en ? ALUSrc : ALUSrc_Out;
	assign Branch_Muxed = en ? Branch : Branch_Out;
	assign Jump_Muxed = en ? Jump : Jump_Out;
	assign JumpReg_Muxed = en ? JumpReg : JumpReg_Out;
	assign Set_Muxed = en ? Set : Set_Out;
	assign Btr_Muxed = en ? Btr : Btr_Out;
	assign MemWrite_Muxed = en ? MemWrite : MemWrite_Out;
	assign MemRead_Muxed = en ? MemRead : MemRead_Out;
	assign MemToReg_Muxed = en ? MemToReg : MemToReg_Out;
	assign Halt_Muxed = en ? Halt : Halt_Out;
	assign Exception_Muxed = en ? Exception : Exception_Out;
	assign Err_Muxed = en ? Err : Err_Out;
	assign InvA_Muxed = en ? InvA : InvA_Out;
	assign InvB_Muxed = en ? InvB : InvB_Out;
	assign Cin_Muxed = en ? Cin : Cin_Out;
	assign Rti_Muxed = en ? Rti : Rti_Out;

endmodule

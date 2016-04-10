// The pipeline stage betwe~Stall the decode and execute stages
module pipe_de(clk, rst, Stall, ALUOp1, ALUOp2, Immediate, ALUOpcode, Func, 
               ALUSrc, Branch, Jump, JumpReg, Set, Btr, MemWrite, MemRead,
               MemToReg, Halt, InvA, InvB, Cin,
               ALUOp1_Out, ALUOp2_Out, Immediate_Out, ALUOpcode_Out, Func_Out,
               ALUSrc_Out, Branch_Out, Jump_Out, JumpReg_Out, Set_Out, Btr_Out,
               MemWrite_Out, MemRead_Out, MemToReg_Out, Halt_Out, 
               InvA_Out, InvB_Out, Cin_Out, Rs, Rt, Rd, Rs_Out, Rt_Out, Rd_Out,
               RegFileWrEn, RegFileWrEn_Out);
    

    input [15:0] ALUOp1, ALUOp2, Immediate;
    input [2:0] ALUOpcode, Rs, Rt, Rd;
    input [1:0] Func;
    input ALUSrc, Branch, Jump, JumpReg, Set, Btr, MemWrite, MemRead, MemToReg, 
          Halt, InvA, InvB, Cin, Rti, RegFileWrEn;
          
	input clk, rst, Stall;

    output [15:0] ALUOp1_Out, ALUOp2_Out, Immediate_Out;
    output [2:0] ALUOpcode_Out, Rs_Out, Rt_Out, Rd_Out;
    output [1:0] Func_Out;
    output ALUSrc_Out, Branch_Out, Jump_Out, JumpReg_Out, Set_Out, Btr_Out,
           MemWrite_Out, MemRead_Out, MemToReg_Out, Halt_Out, InvA_Out, 
           InvB_Out, Cin_Out, Rti_Out, RegFileWrEn_Out;

	wire [15:0] ALUOp1_Muxed, ALUOp2_Muxed, Immediate_Muxed,
	wire [2:0] ALUOpcode_Muxed, Rs_Muxed, Rt_Muxed, Rd_Muxed;
	wire [1:0] Func_Muxed;
	wire ALUSrc_Muxed, Branch_Muxed, Jump_Muxed, JumpReg_Muxed,
         Set_Muxed, Btr_Muxed, MemWrite_Muxed, MemRead_Muxed, MemToReg_Muxed,
         Halt_Muxed, InvA_Muxed, InvB_Muxed, 
         Cin_Muxed, RegFileWrEnMuxed;
         
	dff rf_wr_en_reg(.d (RegFileWrEnMuxed), .q(RegFileWrEn_Out), .rst(rst), .clk(clk))

	dff rs_reg[2:0](.d(Rs_Muxed), .q(Rs_Out), .rst(rst), .clk(clk));
	dff rt_reg[2:0](.d(Rt_Muxed), .q(Rt_Out), .rst(rst), .clk(clk));
	dff rd_reg[2:0](.d(Rd_Muxed), .q(Rd_Out), .rst(rst), .clk(clk));

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
    dff InvA_reg(.d(InvA_Muxed), .q(InvA_Out), .rst(rst), .clk(clk));
    dff InvB_reg(.d(InvB_Muxed), .q(InvB_Out), .rst(rst), .clk(clk));
    dff Cin_reg(.d(Cin_Muxed), .q(Cin_Out), .rst(rst), .clk(clk));

	assign RegFileWrEnMuxed = ~Stall ? RegFileWrEn : RegFileWrEn_Out;

	assign Rs_Muxed = ~Stall ? Rs : Rs_Out;
	assign Rt_Muxed = ~Stall ? Rt : Rt_Out;
	assign Rd_Muxed = ~Stall ? Rd : Rd_Out;

	assign ALUOp1_Muxed = ~Stall ? ALUOp1 : ALUOp1_Out;
	assign ALUOp2_Muxed = ~Stall ? ALUOp2 : ALUOp2_Out;
	assign Immediate_Muxed = ~Stall ? Immediate : Immediate_Out;
	assign ALUOpcode_Muxed = ~Stall ? ALUOpcode : ALUOpcode_Out;
	assign Func_Muxed = ~Stall ? Func : Func_Out;
	assign ALUSrc_Muxed = ~Stall ? ALUSrc : ALUSrc_Out;
	assign Branch_Muxed = ~Stall ? Branch : Branch_Out;
	assign Jump_Muxed = ~Stall ? Jump : Jump_Out;
	assign JumpReg_Muxed = ~Stall ? JumpReg : JumpReg_Out;
	assign Set_Muxed = ~Stall ? Set : Set_Out;
	assign Btr_Muxed = ~Stall ? Btr : Btr_Out;
	assign MemWrite_Muxed = ~Stall ? MemWrite : MemWrite_Out;
	assign MemRead_Muxed = ~Stall ? MemRead : MemRead_Out;
	assign MemToReg_Muxed = ~Stall ? MemToReg : MemToReg_Out;
	assign Halt_Muxed = ~Stall ? Halt : Halt_Out;
	assign InvA_Muxed = ~Stall ? InvA : InvA_Out;
	assign InvB_Muxed = ~Stall ? InvB : InvB_Out;
	assign Cin_Muxed = ~Stall ? Cin : Cin_Out;
endmodule

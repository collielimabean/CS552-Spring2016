
module decode(clk, rst, Stall, Instr, WriteData, IncPC,
              ALUOp1, ALUOp2, ALUSrc, Immediate, Branch, Jump,
              JumpReg, Set, Btr, InvA, InvB, Cin, 
              ALUOpcode, Func, MemWrite, MemRead,
              MemToReg, Halt, Exception, Err, Rti,
              Rs, Rt, Rd, RegFileWrEn, RegFileWrEn_Out, WriteReg, WriteReg_Out,
              RtValid, RsValid, RdValid);

    input [15:0] Instr, WriteData, IncPC;
    input [2:0] WriteReg;
    input clk, rst, Stall, RegFileWrEn;
    output [15:0] ALUOp1, ALUOp2, Immediate;
    output [2:0] ALUOpcode, Rs, Rt, Rd, WriteReg_Out;
    output [1:0] Func;
    output ALUSrc, Branch, Jump,
           JumpReg, Set, Btr, MemWrite, MemRead, RegFileWrEn_Out,
           MemToReg, Halt, Exception, Err, InvA, InvB, Cin, Rti,
           RtValid, RsValid, RdValid;

    wire [15:0] rs_out, write_data;
    wire If1, If2, Rf, ZeroExt, RfError, slbi, link, lbi, stu;
    reg [15:0] ImmReg;
    reg [2:0] write_reg;
    reg OpError, RegError;

    assign SpecialInstr = ~(|Instr[15:12]);   

    assign RtValid = Rf & ~SpecialInstr;
    assign RsValid = If1 | If2 | (Rf & ~SpecialInstr);
    assign RdValid = (Rf & ~SpecialInstr) | If1;

	assign Rs = Instr[10:8];
	assign Rd = (Rf) ? Instr[4:2] : Instr[7:5];
	assign Rt = Instr[7:5];
	assign write_data = (link) ? IncPC : WriteData;
	
    ///// register file /////
    rf_bypass regfile(.clk         (clk),
					  .rst         (rst),
					  .read1regsel (Instr[10:8]),
                      .read2regsel (Instr[7:5]),
                      .writeregsel (WriteReg),
                      .write       (RegFileWrEn),
                      .writedata   (write_data),
                      .read1data   (rs_out),
                      .read2data   (ALUOp2),
                      .err         (RfError)); 

    always @(If2, If1, Rf, link, Instr) begin
        casex({If2, If1, Rf, link})
            4'b1000: write_reg <= Instr[10:8];
            4'b0100: write_reg <= (stu) ? Instr[10:8] : Instr[7:5];
            4'b0010: write_reg <= Instr[4:2];
            4'bxxx1: write_reg <= 3'd7; // write r7 for link instructions
            default: ; //TODO : Check me for errors! //RegError <= 1'b1;
        endcase
    end

    assign ALUOp1 = {16{~lbi}} & ((slbi) ? rs_out << 8 : rs_out);
        
    assign Func = Instr[12:11];

    assign Err = OpError | RfError | RegError;

    assign Immediate = ImmReg;

	assign WriteReg_Out = write_reg;

    always @(*) begin
        casex({If1, If2, Jump, ZeroExt}) 
            4'b1001: ImmReg <= {{11{1'b0}}, Instr[4:0]};
            4'b1000: ImmReg <= {{11{Instr[4]}}, Instr[4:0]};
            4'b0101: ImmReg <= {{8{1'b0}}, Instr[7:0]};
            4'b01x0: ImmReg <= {{8{Instr[7]}}, Instr[7:0]};
            4'b0010: ImmReg <= {{5{Instr[10]}}, Instr[10:0]};
            4'b11xx, 4'b1x1x, 4'bx11x: ; // OpError <= 1'b1;
            default: ; 
        endcase
    end

    ///// Control unit //////
    control_unit cu(.opcode     (Instr[15:11]),
                    .func       (Instr[1:0]),
                    .Stall      (Stall),
                    .aluop      (ALUOpcode),
                    .alusrc     (ALUSrc),
                    .branch     (Branch),
                    .jump       (Jump),
                    .i1         (If1),
                    .i2         (If2),
                    .r          (Rf),
                    .zeroext    (ZeroExt),
                    .excp       (Exception),
                    .jumpreg    (JumpReg),
                    .set        (Set),
                    .btr        (Btr),
                    .regwrite   (RegFileWrEn_Out),
                    .memwrite   (MemWrite),
                    .memread    (MemRead),
                    .memtoreg   (MemToReg),
                    .invA       (InvA),
                    .invB       (InvB),
                    .cin        (Cin),
                    .halt       (Halt),
                    .slbi       (slbi),
                    .lbi        (lbi),
                    .link       (link),
                    .stu        (stu),
                    .rti        (Rti));
endmodule

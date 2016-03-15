
module decode(clk, rst, Instr, WriteData,
              ALUOp1, ALUOp2, ALUSrc, Immediate, Branch, Jump,
              JumpReg, Set, Btr, InvA, InvB, Cin, 
              ALUOpcode, Func, MemWrite, MemRead,
              MemToReg, Halt, Exception, Err);

    input [15:0] Instr, WriteData;
    input clk, rst;
    output [15:0] ALUOp1, ALUOp2, Immediate;
    output [2:0] ALUOpcode;
    output [1:0] Func;
    output ALUSrc, Branch, Jump,
           JumpReg, Set, Btr, MemWrite, MemRead, 
           MemToReg, Halt, Exception, Err, InvA, InvB, Cin;
    wire [2:0] write_reg;

    wire rf_wr_en, regdst, If1, If2, Rf, ZeroExt, optype, RfError;
    reg OpError, ImmReg;

    ///// register file /////
    rf regfile(.clk         (clk),
               .rst         (rst),
               .read1regsel (Instr[10:8]),
               .read2regsel (Instr[7:5]),
               .writeregsel (write_reg),
               .write       (rf_wr_en),
               .writedata   (WriteData),
               .read1data   (ALUOp1),
               .read2data   (ALUOp2),
               .err         (RfError)); 

    assign write_reg = (regdst) ? Instr[7:5] : Instr[4:2];
        
    assign Func = Instr[12:11];

    assign Err = OpError | RfError;

    assign Immediate = ImmReg;

    always @(*) begin
        casex({If1, If2, Jump, ZeroExt}) 
            4'b1001: ImmReg <= {{11{1'b0}}, Instr[4:0]};
            4'b1000: ImmReg <= {{11{Instr[4]}}, Instr[4:0]};
            4'b0101: ImmReg <= {{8{1'b0}}, Instr[7:0]};
            4'b0100: ImmReg <= {{8{Instr[7]}}, Instr[7:0]};
            4'b0010: ImmReg <= {{5{Instr[10]}}, Instr[10:0]};
            default: OpError <= 1'b1;
        endcase
    end

    ///// Control unit //////
    control_unit cu(.opcode     (Instr[15:11]),
                    .func       (Instr[1:0]),
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
                    .regwrite   (rf_wr_en),
                    .memwrite   (MemWrite),
                    .memread    (MemRead),
                    .memtoreg   (MemToReg),
                    .regdst     (regdst),
                    .invA       (InvA),
                    .invB       (InvB),
                    .cin        (Cin));
endmodule

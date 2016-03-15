
module decode(clk, rst, Instr, WriteData,
              ALUOp1, ALUOp2, ALUSrc, Branch, Jump,
              If1, If2, Rf, ZeroExt, JumpReg, Set, Btr, 
              ALUOpcode, Func, MemWrite, MemRead, 
              MemToReg, Halt, Exception, Err);

    input [15:0] Instr, WriteData;
    input clk, rst;
    output [15:0] ALUOp1, ALUOp2;
    output [2:0] ALUOpcode;
    output [1:0] Func;
    output ALUSrc, Branch, Jump, If1, If2, Rf, ZeroExt,
           JumpReg, Set, Btr, MemWrite, MemRead, 
           MemToReg, Halt, Exception, Err;

    wire [2:0] write_reg;
    wire rf_wr_en, regdst;
 
    ///// register file /////
    rf regfile(.clk         (clk),
               .rst         (rst),
               .read1regsel (Instr[10:8]),
               .read2regsel (Instr[7:5]),
               .writeregsel (write_reg),
               .write       (rf_wr_en),
               .read1data   (ALUOp1),
               .read2data   (ALUOp2),
               .err         (Err)); 

    assign write_reg = (regdst) ? Instr[7:5] : Instr[4:2];
        
    assign Func = Instr[12:11];

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
                    .jumpreg    (JumpReg),
                    .set        (Set),
                    .btr        (Btr),
                    .regwrite   (rf_wr_en),
                    .memwrite   (MemWrite),
                    .memread    (MemRead),
                    .memtoreg   (MemToReg),
                    .regdst     (regdst));
endmodule

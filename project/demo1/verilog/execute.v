
/*
 * Execute module
 * Remarks:
 * Address calcuation:
 * 1) Deviated from figure. Branches/jump addr calculations are all offset
 * based (PC + 2 + sext(Imm) or Rs + sext(Imm)).
 * 2) WISC13 is not word aligned; it's byte aligned. No shift left necessary
 * for the immediate operand.
 */
module execute(ALUOp1, ALUOp2, Opcode, IncPC, 
               Jump, Branch, JumpReg, Set,
               Func, Imm, ALUSrc);
    input [15:0] ALUOp1, ALUOp2, IncPC, Imm;
    input [2:0] Opcode;
    input [1:0] Func;
    input Jump, Branch, JumpReg, Set, ALUSrc;
    output [15:0] Result, NextPC;

    wire [15:0] aluResult, setResult, offsetAddr;
    wire Ofl, Zero, branch_en, isAddOp, invA, invB, cin;

    alu primary_alu(.A      (ALUOp1),
                    .B      ((ALUSrc) ? ALUOp2 : Imm),
                    .Cin    (cin),
                    .Op     (Opcode),
                    .invA   (invA),
                    .invB   (invB),
                    .sign   (1'b1),
                    .Out    (aluResult),
                    .Ofl    (Ofl),
                    .Z      (Zero));

    ////////////// ALU Output Logic //////////////
    // select the correct set comparison
    mux4to1_16 set_mux(.InA ({{15{1'b0}}, Zero}),                   // seq
                       .InB ({{15{1'b0}}, aluResult[15]}),          // slt
                       .InC ({{15{1'b0}}, aluResult[15] | Zero}),   // sle
                       .InD ({{15{1'b0}, Ofl}),                     // sco
                       .Sel (Func),
                       .Out (setResult));

    // Result output logic
    // if (btr) return btr
    // if (set & ~btr) return setResult
    // if (~set & ~btr) return aluResult
    assign Result = (Btr) ? { ALUOp1[0], ALUOp1[1], ALUOp1[2], ALUOp1[3],
                              ALUOp1[4], ALUOp1[5], ALUOp1[6], ALUOp1[7],
                              ALUOp1[8], ALUOp1[9], ALUOp1[10], ALUOp1[11],
                              ALUOp1[12], ALUOp1[13], ALUOp1[14], ALUOp1[15] } :
                    (Set) ? setResult :
                            aluResult;


    //////////// Branch Logic //////////////////
    cla16 addr_adder(.A (IncPC), .B (Imm), .Cin(1'b0), .S (offsetAddr));
    assign NextPC = (JumpReg)                     ? aluResult  :
                    ((branch_en & Branch) | Jump) ? offsetAddr :
                                                    IncPC;

    // branch_en logic
    mux4to1 branchMux(.InA (~(|ALUOp1)),
                      .InB ((|ALUOp1)),
                      .InC (ALUOp[15]),
                      .InD (ALUOp[15]),
                      .Sel (Func),
                      .Out (branch_en));

    // ALU Control Signals
    assign isAddOp = Opcode[2] & ~Opcode[1] & ~Opcode[0];
    assign invB = isAddOp & ((Set) ? (~(&Func)) : (&Func));
    assign invA = isAddOp & ~Set & ~Func[1] & Func[0];
    assign cin = isAddOp & ((Set) ? (Func[1] ^ Func[0]) : (~Func[1] & Func[0]));
endmodule

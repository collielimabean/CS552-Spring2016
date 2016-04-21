module control_unit(opcode, func, Stall, aluop, alusrc, branch, jump, i1, i2, r, jumpreg, set, btr, regwrite, memwrite, memread, memtoreg, invA, invB, cin, excp, zeroext, halt, slbi, link, lbi, stu, rti);
    input [4:0] opcode;
    input [1:0] func;
    input Stall;
    output alusrc, branch, jump, i1, i2, r, jumpreg, set, btr, regwrite, memwrite, memread, memtoreg, invA, invB, cin, excp, zeroext, halt, slbi, link, lbi, stu, rti;
    output [2:0] aluop;

    wire A, B, C, D, E, nA, nB, nC, nD, nE;

    reg [2:0] alu_op_reg;
    assign aluop = alu_op_reg;

    assign A = opcode[4];
    assign B = opcode[3];
    assign C = opcode[2];
    assign D = opcode[1];
    assign E = opcode[0]; 
    assign F = func[1];
    assign G = func[0];
    assign nA = ~A;
    assign nB = ~B;
    assign nC = ~C;
    assign nD = ~D;
    assign nE = ~E;
    assign nF = ~F;
    assign nG = ~G;

    assign alusrc = ~Stall & ((nA & C) |
                    (A ^ B) |
                    (B & nC & nD & nE));

    assign branch = ~Stall & (nA & B & C);
    
    assign jump = ~Stall & (nA & nB & C);

    assign i1 = ~Stall & ((nA & B & nC) | 
                (A & nB & nD & nE) |
                (A & nB & C & D & nE) |
                (A & nB & E));

    assign i2 = ~Stall & ((nA & C & E) |
                (nA & B & C) |
                (A & nB & nC & D & nE) |
                (A & B & nC & nD & nE));

    assign r = ~Stall & (A & B & (C | D | E)); 

    assign jumpreg = ~Stall & (nA & nB & C & E);

    assign set = ~Stall & (A & B & C);

    assign btr = ~Stall & (A & B & nC & nD & E);

    assign regwrite = ~Stall & ((nA & B & nC) | 
                      (nA & nB & C & D) |  
                      (A & nB & C) | 
                      (A & nB & nC & (D | E)) |
                      (A & B & nC) | 
                      (A & B & C));

    assign memwrite = ~Stall & ((A & nB & nC) &
                      (D ~^ E));

    assign memread = ~Stall & (A & nB & nC & nD & E);

    assign memtoreg = ~Stall & (A & nB & nC & nD & E);
    
    assign regdst = ~Stall & ((nA & B & nC) |
                    (A & nB & nD & nE) |
                    (A & nB & C & D & nE) |
                    (A & nB & E));
    
    // subi, sub
    assign invA = ~Stall & ((B & nC & E) &
                   ((nA & nD) |
                    (A & D & nF & G)));

    // andni, andn, slt sle
    assign invB = ~Stall & ((A & B & C & (D ^ E)) | (nA & B & nC & D & E) | (A & B & nC & D & E & F & G)); 
 
    // slt, sle, subi, sub
    assign cin = ~Stall & ((A & B & C & (D ^ E)) | (nA & B & nC & nD & E) | (A & B & nC & D & E & nF & G));
    
    assign excp = ~Stall & (nA & nB & nC & D & nE);

    assign zeroext = ~Stall & ((nA & B & nC & D) | slbi);

    assign halt = ~Stall & (~(|opcode));

    assign slbi = ~Stall & (A & nB & nC & D & nE);

    assign link = ~Stall & (nA & nB & C & D);

    assign lbi = ~Stall & (A & B & nC & nD & nE);

    assign stu = ~Stall & (A & nB & nC & D & E);

    assign rti = ~Stall & (nA & nB & nC & D & E);

    always @(*) begin
        casex({opcode, func})
            // 000: rotate left
                7'b10100xx, 7'b1101000: alu_op_reg <= 3'b000;
            // 001: shift left
                7'b10101xx, 7'b1101001: alu_op_reg <= 3'b001;
            // 010: rotate right
                7'b10110xx, 7'b1101010: alu_op_reg <= 3'b010;
            // 011: shift right logical
                7'b10111xx, 7'b1101011: alu_op_reg <= 3'b011;
            // 100: ADD
                7'b11000xx, 7'b01x0xxx, 7'bx11x1xx, 7'bx111xxx, 7'b1000xxx, 7'b100x1xx, 7'b110110x, 7'b001xxxx: alu_op_reg <= 3'b100;     
            // 101: OR
                7'b10010xx: alu_op_reg <= 3'b101;
            // 110: XOR
                7'b01010xx, 7'b1101110, 7'b11100xx: alu_op_reg <= 3'b110;
            // 111: AND
                7'b01011xx, 7'b1101111: alu_op_reg <= 3'b111;
                default: alu_op_reg <= 3'b000;
        endcase
    end 
  
endmodule

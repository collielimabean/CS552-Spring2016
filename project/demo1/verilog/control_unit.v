module control_unit(opcode, func, aluop, alusrc, branch, jump, i1, i2, r, jumpreg, set, btr, regwrite, memwrite, memread, memtoreg, regdst, invA, invB, cin, excp, zeroext);
    input [4:0] opcode;
    input [1:0] func;
    output alusrc, branch, jump, i1, i2, r, jumpreg, set, btr, regwrite, memwrite, memread, memtoreg, regdst, invA, invB, cin, excp, zeroext;
    output [2:0] aluop;

    wire A, B, C, D, E, nA, nB, nC, nD, nE;

    reg alu_op_reg;
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

    assign alusrc = (nA & C) |
                    (A ^ B) |
                    (B & nC & nD & nE);

    assign branch = nA & B & C;
    
    assign jump = nA & nB & C;

    assign i1 = (nA & B & nC) | 
                (A & nB & nD & nE) |
                (A & nB & C & D & nE) |
                (A & nB & E);

    assign i2 = (nA & C & E) |
                (nA & B & C) |
                (A & nB & nC & D & nE) |
                (A & B & nC & nD & nE);

    assign r = A & B & (C | D | E); 

    assign jumpreg = nA & nB & C & E;

    assign set = A & B & C;

    assign btr = A & B & nC & nD & E;

    assign regwrite =  A |
                      (B & nC) |
                      (nB & C & D);

    assign memwrite = (A & nB & nC) &
                      (D ~^ E);

    assign memread = A & nB & nC & nD & E;

    assign memtoreg = A & nB & nC & nD & E;
    
    assign regdst = (nA & B & nC) |
                    (A & nB & nD & nE) |
                    (A & nB & C & D & nE) |
                    (A & nB & E);
    
    // subi, sub
    assign invA = (B & nC & E) &
                   ((nA & nD) |
                    (A & D & nF & G));

    // andni, andn, seq, slt sle
    assign invB = B & 
                  ((A & C & ~(D & E)) |
                   (nC & D & E & 
                    (nA | (A & F & G))));
    
    // slt, sle, subi, sub
    assign cin = B & 
                ((A & C & (D ^ E)) |
                 (nC & E & (
                  ((nA & nD) | (A & D & nF & G)))));

    assign excp = nA & nB & nC & D & nE;

    assign zeroext = (nC & D & 
                      ((nA & B) |
                       (A & nB & C & nD)));   
   
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
                7'b01x0xxx, 7'bx11x1xx, 7'bx111xxx, 7'b1000xxx, 7'b100x1xx, 7'b110110x: alu_op_reg <= 3'b100;     
            // 101: OR
            // 110: XOR
                7'b01010xx, 7'b1101110, 7'b11100xx: alu_op_reg <= 3'b110;
            // 111: AND
                7'b01011xx, 7'b1101111: alu_op_reg <= 3'b111;
                default: alu_op_reg <= 3'b000;
        endcase
    end 
  
endmodule
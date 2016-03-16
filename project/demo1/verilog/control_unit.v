module control_unit(opcode, func, aluop, alusrc, branch, jump, i1, i2, r, jumpreg, set, btr, regwrite, memwrite, memread, memtoreg, invA, invB, cin, excp, zeroext, halt, slbi, link, lbi);
    input [4:0] opcode;
    input [1:0] func;
    output alusrc, branch, jump, i1, i2, r, jumpreg, set, btr, regwrite, memwrite, memread, memtoreg, invA, invB, cin, excp, zeroext, halt, slbi, link, lbi;
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

    assign regwrite = (nA & B & nC) | 
                      (nA & nB & C & D) |  
                      (A & nB & C) | 
                      (A & nB & nC & (D | E)) |
                      (A & B & nC) | 
                      (A & B & C);

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

    // andni, andn, slt sle
    assign invB = (A & B & C & (D ^ E)) | (nA & B & nC & D & E) | (A & B & nC & D & E & F & G); 
 
    // slt, sle, subi, sub
    assign cin = (A & B & C & (D ^ E)) | (nA & B & nC & nD & E) | (A & B & nC & D & E & nF & G);
/*    assign cin = B & 
                ((A & C & (D ^ E)) |
                 (nC & E & (
                  ((nA & nD) | (A & D & nF & G)))));
*/
    assign excp = nA & nB & nC & D & nE;

    assign zeroext = (nA & B & nC & D) | slbi;

    assign halt = ~(|opcode);

    assign slbi = A & nB & nC & D & nE;

    assign link = nA & nB & C & D;

    assign lbi = A & B & nC & nD & nE;

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

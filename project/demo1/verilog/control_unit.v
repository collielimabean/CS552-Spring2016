module control_unit(opcode, func, regdst, jump, branch, memread, memtoreg, memwrite, alusrc, regwrite, btr, set, opoption, aluop);
    input [4:0] opcode;
    input [1:0] func;
    output regdst, jump, branch, memread, memtoreg, memwrite, alusrc, regwrite, btr, set;
    output [1:0] opoption;
    output [2:0] aluop;    

    wire A, B, C, D, E, nA, nB, nC, nD, nE;
    assign A = opcode[4];
    assign B = opcode[3];
    assign C = opcode[2];
    assign D = opcode[1];
    assign E = opcode[0]; 
    assign nA = ~A;
    assign nB = ~B;
    assign nC = ~C;
    assign nD = ~D;
    assign nE = ~E;

    assign regdst = (nA & B & nC) |
                    (A & nB & nD & nE) |
                    (A & nB & C & D & nE) |
                    (A & nB & E);
    
    assign jump = nA & nB & C;
   
    assign branch = nA & B & C;

    assign memread = A & nB & nC & nD & E;

    assign memtoreg = A & nB & nC & nD & E;
    
    assign memwrite = (A & nB & nC) &
                      (D ~^ E)

    assign alusrc = (nA & C) |
                    (A ^ B) |
                    (B & nC & nD & nE);
    
    assign regwrite =  A |
                      (B & nC) |
                      (nB & C & D);

    assign btr = A & B & nC & nD & E;

    assign set = A & B & C;

    assign opoption = {A, B};

    case({opcode, func})

    // 000: rotate left
        7'b10100xx, 7'b1101000: assign aluop = 3'b000;
    // 001: shift left
        7'b10101xx, 7'b1101001: assign aluop = 3'b001;
    // 010: rotate right
        7'b10110xx, 7'b1101010: assign aluop = 3'b010;
    // 011: shift right logical
        7'b10111xx, 7'b1101011: assign aluop = 3'b011;
    // 100: ADD
        7'b01x0xxx, 7'bx11x1xx, 7'bx111xxx, 7'b1000xxx, 7'b100x1xx, 7'b110110x: assign aluop = 3'b100;     
    // 101: OR
    // 110: XOR
        7'b01010xx, 7'b1101110, 7'b11100xx: assign aluop = 3'b110;
    // 111: AND
        7'b01011xx, 7'b1101111: assign aluop = 3'b111;
        default: assign aluop = 3'b000;
    endcase
    
endmodule

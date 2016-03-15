/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
module proc (/*AUTOARG*/
    // Outputs
    err, 
    // Inputs
    clk, rst
    );

    input clk;
    input rst;

    output err;

    // None of the above lines can be modified

    // OR all the err ouputs for every sub-module and assign it as this
    // err output

    // As desribed in the homeworks, use the err signal to trap corner
    // cases that you think are illegal in your statemachines

    wire [15:0] incPC, nextPC, instr, exec_out, decode_wr_data,
                mem_read_data, epc, aluop1, aluop2, imm;
    wire [2:0] aluopcode;
    wire [1:0] func;
    wire alusrc, branch, jump, jumpreg, set, btr, memwrite,
         memread, memtoreg, halt, exception, invA, invB, cin;

    fetch f(.NextPC     (nextPC),
            .clk        (clk),
            .rst        (rst),
            .Halt       (halt),
            .Exception  (exception),
            .Instr      (instr),
            .IncPC      (incPC),
            .epc        (epc));

    decode d(.clk       (clk),
             .rst       (rst),
             .Instr     (instr),
             .WriteData (decode_wr_data),
             .ALUOp1    (aluop1),
             .ALUOp2    (aluop2),
             .ALUSrc    (alusrc),
             .Branch    (branch),
             .Jump      (jump),
             .JumpReg   (jumpreg),
             .Set       (set),
             .Btr       (btr),
             .ALUOpcode (aluopcode),
             .Func      (func),
             .MemWrite  (memwrite),
             .MemRead   (memread),
             .MemToReg  (memtoreg),
             .Halt      (halt),
             .Exception (exception),
             .Err       (err),
             .Immediate (imm),
             .InvA      (invA),
             .InvB      (invB),
             .Cin       (cin));
    
    execute e(.ALUOp1   (aluop1),
              .ALUOp2   (aluop2),
              .Btr      (btr),
              .Opcode   (aluopcode),
              .IncPC    (incPC),
              .InvA     (invA),
              .InvB     (invB),
              .Cin      (cin),
              .Jump     (jump),
              .Branch   (branch),
              .JumpReg  (jumpreg),
              .Set      (set),
              .Func     (func),
              .Imm      (imm),
              .ALUSrc   (alusrc),
              .Result   (exec_out),
              .NextPC   (nextPC));    

    memory m(.clk       (clk),
             .rst       (rst),
             .MemRead   (memread),
             .MemWrite  (memwrite),
             .halt      (halt),
             .Address   (exec_out),
             .WriteData (aluop2),
             .ReadData  (mem_read_data));

    writeback w(.ExecuteOut (exec_out),
                .MemOut     (mem_read_data),
                .MemToReg   (memtoreg),
                .WriteData  (decode_wr_data));
endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:

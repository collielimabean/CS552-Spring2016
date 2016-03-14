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

    wire [15:0] incPC, nextPC, instr, exec_out,
                mem_read_data ;

    wire halt;

    fetch f(.NextPC     (nextPC),
            .clk        (clk),
            .rst        (rst),
            .halt       (halt),
            .Instr      (instr),
            .IncPC      (incPC));

    decode d();
    
    execute e(.ALUOp1   (),
              .ALUOp2   (),
              .Opcode   (),
              .IncPC    (incPC),
              .Jump     (),
              .Branch   (),
              .JumpReg  (),
              .Set      (),
              .Func     (),
              .Imm      (),
              .ALUSrc   (),
              .Result   (exec_out),
              .NextPC   (nextPC));    

    memory m(.MemRead   (),
             .MemWrite  (),
             .halt      (halt),
             .Address   (exec_out),
             .WriteData (),     // this is sometimes going to be the ALU out....
             .ReadData  (mem_read_data));

    writeback w(.ExecuteOut (exec_out),
                .MemOut     (mem_read_data),
                .MemToReg   (),
                .WriteData  ());
endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:

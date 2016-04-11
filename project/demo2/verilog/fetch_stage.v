module fetch_stage(BranchPC, clk, rst, Stall, Flush, Halt, Exception, Rti, Instr, IncPC, BranchJumpTaken);
    input [15:0] BranchPC;
    input clk, rst, Stall, Flush, Halt, Rti, Exception, BranchJumpTaken;
    
    output [15:0] Instr, IncPC;
  
    wire [15:0] instr, incPC;
    wire pipe_flush;

    assign pipe_flush = rst | Flush;

    fetch f(.BranchPC     (BranchPC),
			.BranchJumpTaken (BranchJumpTaken),
            .clk          (clk),
            .rst      	  (rst),
            .Halt     	  (Halt),
            .Exception    (Exception),
            .Rti          (Rti),
            .Instr        (instr),
            .IncPC        (incPC));

    pipe_fd fd(.Stall(Stall),
			   .Flush(Flush),
               .rst(pipe_flush),
               .clk(clk),
               .Instr(instr),
               .IncPC(incPC),
               .Instr_Out(Instr),
               .IncPC_Out(IncPC));

endmodule

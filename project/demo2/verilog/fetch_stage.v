module fetch_stage(NextPC, clk, rst, Stall, Flush, Halt, Exception, Rti, Instr, IncPC);
    input [15:0] NextPC;
    input clk, rst, Stall, Flush, Halt, Rti, Exception;
    
    output [15:0] Instr, IncPC;
  
    wire [15:0] instr, incPC;
    wire pipe_flush;

    assign pipe_flush = rst | Flush;

    fetch f(.NextPC     (NextPC),
            .clk        (clk),
            .rst        (rst),
            .Halt       (Halt),
            .Exception  (Exception),
            .Rti        (Rti),
            .Instr      (instr),
            .IncPC      (incPC));

    pipe_fd fd(.Stall(Stall),
               .rst(pipe_flush),
               .clk(clk),
               .Instr(instr),
               .IncPC(instr),
               .Instr_Out(Instr),
               .IncPC_Out(IncPC));

endmodule

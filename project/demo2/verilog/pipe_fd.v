// The pipeline stage between the fetch and decode stages
module pipe_fd(Stall, Flush, rst, clk, Instr, IncPC, Instr_Out, IncPC_Out, CPUActive);
    input [15:0] Instr, IncPC;
    input Stall, rst, clk, Flush;
    output [15:0] Instr_Out, IncPC_Out;
    output CPUActive

    wire [15:0] Instr_Muxed, IncPC_Muxed;

    dff instr_reg[15:0](.d(Instr_Muxed), .q(Instr_Out), .rst(1'b0), .clk(clk));
    dff incpc_reg[15:0](.d(IncPC_Muxed), .q(IncPC_Out), .rst(rst), .clk(clk));
    dff rst_ff(.d(~rst), .q(CPUActive), .rst(rst), .clk(clk));
    
    assign Instr_Muxed = (rst | Flush) ? 16'h0800 :
				         (~Stall) ? Instr : Instr_Out;
    assign IncPC_Muxed = ~Stall ? IncPC : IncPC_Out;
endmodule

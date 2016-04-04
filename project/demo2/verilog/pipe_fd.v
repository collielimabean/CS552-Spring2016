// The pipeline stage between the fetch and decode stages
module pipe_fd(Instr, IncPC, en, rst, clk, Instr_Out, IncPC_Out);
    input [15:0] Instr, IncPC;
    input en, rst, clk;
    output [15:0] Instr_Out, IncPC_Out;

    wire Instr_Muxed, IncPC_Muxed;

    dff instr_reg[15:0](.d(Instr_Muxed), .q(Instr_Out), .rst(rst), .clk(clk));
    dff incpc_reg[15:0](.d(IncPC_Muxed), .q(IncPC_Out), .rst(rst), .clk(clk));
    
    assign Instr_Muxed = en ? Instr : Instr_Out;
    assign IncPC_Muxed = en ? IncPC : IncPC_Out;


endmodule

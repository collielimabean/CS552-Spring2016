
module pipe_mw(MemToReg, MemOut, ExecuteOut, en, rst, clk, MemToReg_Out, MemOut_Out, ExecuteOut_Out);
    input  [15:0] MemOut, ExecuteOut;
    input         MemToReg, en, rst, clk;
    output [15:0] MemOut_Out, ExecuteOut_Out;
    output        MemToReg_Out;

    wire [15:0] MemOut_In, ExecuteOut_In;
    wire MemToReg_In;

    dff mem_to_reg(.d (MemToReg_In), .q (MemToReg_Out), .rst (rst), .clk (clk));
    dff mem_out_reg[15:0](.d (MemOut_In), .q (MemOut_Out), .rst (rst), .clk (clk));
    dff exec_out_reg[15:0](.d (ExecuteOut_In), .q(ExecuteOut_Out), .rst (rst), .clk (clk));

    assign MemToReg_In = (en) ? MemToReg : MemToReg_Out;
    assign MemOut_In = (en) ? MemOut : MemOut_Out;
    assign ExecuteOut_In = (en) ? ExecuteOut ? ExecuteOut_Out;
endmodule

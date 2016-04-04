
module pipe_em(ExecuteOut, MemWrite, MemRead, Halt, WriteData,
               en, clk, rst, ExecuteOut_Out, MemWrite_Out,
               MemRead_Out, Halt_Out, WriteData_Out);
    input MemWrite, MemRead, Halt;
    input [15:0] ExecuteOut, WriteData;
    output MemWrite_Out, MemRead_Out, Halt_Out;
    output [15:0] ExecuteOut_Out, WriteData_Out;

    wire MemWrite_In, MemRead_In, Halt_In;
    wire [15:0] ExecuteOut_In, WriteData_In;

    dff memwrite_reg(.d (MemWrite_In), .q (MemWrite_Out), .rst (rst), .clk (clk));
    dff memread_reg(.d (MemRead_In), .q (MemRead_Out), .rst (rst), .clk (clk));
    dff halt_reg(.d (Halt_In), .q (Halt_Out), .rst (rst), .clk (clk));
    dff execute_out_reg[15:0](.d (ExecuteOut_In), .q(ExecuteOut_Out), .rst (rst), .clk (clk));
    dff write_data_reg[15:0](.d (WriteData_In), .q(WriteData_Out), .rst (rst), .clk (clk));


    assign MemWrite_In = (en) ? MemWrite : MemWrite_Out;
    assign MemRead_In = (en) ? MemRead : MemRead_Out;
    assign Halt_In = (en) ? Halt : Halt_Out;
    assign ExecuteOut_In = (en) ? ExecuteOut : ExecuteOut_Out;
    assign WriteData_In = (en) ? WriteData : WriteData_Out;

endmodule 

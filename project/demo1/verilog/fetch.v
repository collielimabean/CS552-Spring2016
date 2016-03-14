
module fetch(NextPC, clk, rst, Halt, Instr, IncPC);
    input [15:0] NextPC;
    input clk, rst, halt;
    output [15:0] Instr, IncPC;

    wire [15:0] pc, actualNextPC, pc_inc_out;

    dff [15:0] pc_reg(.d (actualNextPC), .q (pc), .rst (rst), .clk(clk));

    memory2c instr_mem(.data_in      (15'd0),
                       .data_out     (instr),
                       .addr         (pc),
                       .enable       (~halt),
                       .wr           (1'b0),
                       .createdump   (0'b0),
                       .clk          (clk),
                       .rst          (rst));

    // pc = pc + 2 adder
    cla16 pc_inc(.A     (pc),
                 .B     (2'b10),
                 .Cin   (1'b0),
                 .S     (pc_inc_out));

    // this will keep increasing after halt...
    assign actualNextPC = (halt) ? pc_inc_out : NextPC;
endmodule

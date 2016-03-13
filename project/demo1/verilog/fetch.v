
module fetch(next_pc, clk, rst, halt, instr, inc_pc);
    input [15:0] next_pc;
    input clk, rst, halt;
    output [15:0] instr, inc_pc;

    wire [15:0] pc, true_next_pc;

    dff [15:0] pc_reg(.d (true_next_pc), .q (pc), .rst (rst), .clk(clk));

    memory2c instr_mem(.data_in      (15'd0),
                       .data_out     (instr),
                       .addr         (pc),
                       .enable       (~halt),
                       .wr           (1'b0),
                       .createdump   (0'b0),
                       .clk          (clk),
                       .rst          (rst));

    /* pc = pc + 2 module here */
    /*
     * if (halt) true_next_pc = output of pc + 2 module
     * otherwise true_next_pc = next_pc
     */


endmodule

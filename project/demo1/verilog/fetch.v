
module fetch(NextPC, clk, rst, Halt, Exception, Instr, IncPC, epc);
    input [15:0] NextPC;
    input clk, rst, Halt, Exception;
    output [15:0] Instr, IncPC, epc;

    wire [15:0] pc, actualNextPC, pc_inc_out;
    wire cout;

    dff pc_reg[15:0](.d (actualNextPC), .q (pc), .rst (rst), .clk(clk));
    // dff [15:0] epc_reg(.d (), .q (epc), .rst (rst), .clk (clk));
    // TODO: next EPC value is a state machine! figure it out first!

    memory2c instr_mem(.data_in      (16'd0),
                       .data_out     (Instr),
                       .addr         (pc),
                       .enable       (~halt),
                       .wr           (1'b0),
                       .createdump   (1'b0),
                       .clk          (clk),
                       .rst          (rst));

    // pc = pc + 2 adder
    cla16 pc_inc(.A     (pc),
                 .B     (16'd2),
                 .Cin   (1'b0),
                 .S     (pc_inc_out),
                 .Cout  (cout));

    // TODO: FIX PC logic
    assign actualNextPC = (halt) ? pc_inc_out : 
                          (Exception) ? 16'd2 :
                          actualNextPC;
endmodule

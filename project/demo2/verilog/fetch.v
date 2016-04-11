
module fetch(BranchPC, BranchJumpTaken, clk, rst, Halt, Rti, Exception, Instr, IncPC);
    input [15:0] BranchPC;
    input clk, rst, Halt, Rti, Exception, BranchJumpTaken;
    output [15:0] Instr, IncPC;

    wire [15:0] pc, actualNextPC, nextEPC, pc_inc_out, epc;
    wire cout, nextExcptState, curExcptState;

    dff pc_reg[15:0](.d (actualNextPC), .q (pc), .rst (rst), .clk(clk));
    dff epc_reg[15:0](.d (nextEPC), .q (epc), .rst (rst), .clk (clk));
    dff excpt_reg (.d (nextExcptState), .q(curExcptState), .rst (rst), .clk (clk));

    memory2c instr_mem(.data_in      (16'd0),
                       .data_out     (Instr),
                       .addr         (pc),
                       .enable       (1'b1), // tie high, but it's supposed to be ~halt
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

    assign nextExcptState = ~Rti & (Exception ^ curExcptState);
    assign nextEPC = (~Rti & curExcptState) ? epc : IncPC;

    assign IncPC = pc_inc_out;
    assign actualNextPC = (rst) ? 16'd0 : 
						  (Halt) ? pc_inc_out : 
                          (Exception) ? 16'd2 :
                          (Rti & curExcptState) ? epc :
                          (BranchJumpTaken) ? BranchPC :
											  pc_inc_out;
endmodule

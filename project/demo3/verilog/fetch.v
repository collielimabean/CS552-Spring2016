
module fetch(BranchPC, BranchJumpTaken, clk, rst, Halt, Rti, Exception, Stall, Instr, IncPC, Err, CacheHit, InstrMemStall);
    input [15:0] BranchPC;
    input clk, rst, Halt, Rti, Exception, BranchJumpTaken, Stall;
    output [15:0] Instr, IncPC;
    output Err, CacheHit, InstrMemStall;
    
    wire [15:0] pc, actualNextPC, nextEPC, pc_inc_out, epc, InstrMem;
    wire cout, nextExcptState, curExcptState;

    dff pc_reg[15:0](.d (actualNextPC), .q (pc), .rst (rst), .clk(clk));
    dff epc_reg[15:0](.d (nextEPC), .q (epc), .rst (rst), .clk (clk));
    dff excpt_reg (.d (nextExcptState), .q(curExcptState), .rst (rst), .clk (clk));

    mem_system #(0) instr_mem(.DataOut         (InstrMem),
                       .Done            (InstrMemDone),
                       .Stall           (InstrMemStall),
                       .CacheHit        (CacheHit),
                       .err             (Err),
                       .Addr            (BranchJumpTaken ? BranchPC : pc),
                       .DataIn          (16'b0),
                       .Rd              (InstrMemRead),
                       .Wr              (1'b0),
                       .createdump      (createdump),
                       .clk             (clk),
                       .rst             (rst));

    // pc = pc + 2 adder
    cla16 pc_inc(.A     (pc),
                 .B     (16'd2),
                 .Cin   (1'b0),
                 .S     (pc_inc_out),
                 .Cout  (cout));

    assign InstrMemRead = ~rst;

    assign nextExcptState = ~Rti & (Exception ^ curExcptState);
    assign nextEPC = (~Rti & curExcptState) ? epc : IncPC;
    assign Instr = InstrMem;

    assign IncPC = pc_inc_out;
    reg [15:0] nextPCReg;
    
    assign actualNextPC = nextPCReg;
    
    always @(*) begin
        casex ({Stall, rst, Halt, BranchJumpTaken})
            4'b1000: nextPCReg <= pc;
            4'b0100: nextPCReg <= 16'b0;
            4'b0010: nextPCReg <= pc_inc_out;
            4'bx001: nextPCReg <= BranchPC; 
            default: nextPCReg <= pc_inc_out;
        endcase
    end
endmodule


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


    memory2c instr_mem(.data_in      (16'd0),
                       .data_out     (InstrMem),
                       .addr         (pc),
                       .enable       (1'b1), // tie high, but it's supposed to be ~halt
                       .wr           (1'b0),
                       .createdump   (1'b0),
                       .clk          (clk),
                       .rst          (rst));

assign InstrMemStall = 1'b0;
assign CacheHit = 1'b0;
assign Err = 1'b0;

/*
    stallmem instr_mem(.DataOut         (InstrMem),
                       .Done            (InstrMemDone),
                       .Stall           (InstrMemStall),
                       .CacheHit        (CacheHit),
                       .err             (Err),
                       .Addr            (pc),
                       .DataIn          (16'b0),
                       .Rd              (InstrMemRead),
                       .Wr              (1'b0),
                       .createdump      (createdump),
                       .clk             (clk),
                       .rst             (rst));
*/
    // pc = pc + 2 adder
    cla16 pc_inc(.A     (pc),
                 .B     (16'd2),
                 .Cin   (1'b0),
                 .S     (pc_inc_out),
                 .Cout  (cout));

    assign InstrMemRead = ~rst;

    assign nextExcptState = ~Rti & (Exception ^ curExcptState);
    assign nextEPC = (~Rti & curExcptState) ? epc : IncPC;
    assign Instr = InstrMem;//Stall ? 16'h0800 : InstrMem;

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
    
   /* assign actualNextPC = (rst) ? 16'd0 : 
						  (Halt) ? pc_inc_out : 
                          (Exception) ? 16'd2 :
                          (Rti & curExcptState) ? epc :
                          (BranchJumpTaken) ? BranchPC :
											  pc_inc_out;
    */
endmodule

/*
 * The memory stage.
 * Remarks:
 * None
 */
module memory(MemRead, MemWrite, halt, clk, rst, 
    Address, WriteData, ReadData, Err, DataMemStall,
    CacheHit
);
    input MemRead, MemWrite, halt, clk, rst;
    input [15:0] Address, WriteData;
    output [15:0] ReadData;
    output Err, DataMemStall, CacheHit;

    mem_system #(1) data_mem(.DataOut         (ReadData),
                      .Done            (DataMemDone),
                      .Stall           (DataMemStall),
                      .CacheHit        (CacheHit),
                      .err             (Err),
                      .Addr            (Address),
                      .DataIn          (WriteData),
                      .Rd              (MemRead),
                      .Wr              (MemWrite),
                      .createdump      (halt),
                      .clk             (clk),
                      .rst             (rst)
    );


endmodule

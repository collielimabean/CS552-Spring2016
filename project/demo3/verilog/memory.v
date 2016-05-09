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

/*
    memory2c data_mem(.data_in      (WriteData),
                      .data_out     (ReadData),
                      .addr         (Address),
                      .enable       (~halt),
                      .wr           (MemWrite),
                      .createdump   (halt),
                      .clk          (clk),
                      .rst          (rst));
*/


    stallmem data_mem(.DataOut         (ReadData),
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

/*
 * The memory stage.
 * Remarks:
 * None
 */
module memory(MemRead, MemWrite, halt, clk, rst, Address, WriteData, ReadData);
    input MemRead, MemWrite, halt, clk, rst;
    input [15:0] Address, WriteData;
    output [15:0] ReadData;

    memory2c data_mem(.data_in      (WriteData),
                      .data_out     (ReadData),
                      .addr         (Address),
                      .enable       (~halt),
                      .wr           (MemWrite),
                      .createdump   (halt),
                      .clk          (clk),
                      .rst          (rst));
endmodule

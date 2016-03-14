/*
 * The memory stage.
 * Remarks:
 * None
 */
module memory(MemRead, MemWrite, halt, Address, WriteData, ReadData);
    input MemRead, MemWrite, halt;
    input [15:0] Address, WriteData;
    output [15:0] ReadData;

    memory2c data_mem(.data_in      (Address),
                      .data_out     (ReadData),
                      .addr         (pc),
                      .enable       (~halt & (MemRead | MemWrite)),
                      .wr           (MemWrite),
                      .createdump   (halt),
                      .clk          (clk),
                      .rst          (rst));
endmodule

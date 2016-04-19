/* $Author: karu $ */
/* $LastChangedDate: 2009-04-24 09:28:13 -0500 (Fri, 24 Apr 2009) $ */
/* $Rev: 77 $ */

module mem_system(/*AUTOARG*/
    // Outputs
    DataOut, Done, Stall, CacheHit, err,
    // Inputs
    Addr, DataIn, Rd, Wr, createdump, clk, rst
);

    input [15:0] Addr;
    input [15:0] DataIn;
    input        Rd;
    input        Wr;
    input        createdump;
    input        clk;
    input        rst;

    output [15:0] DataOut;
    output Done;
    output Stall;
    output CacheHit;
    output err;

    wire [15:0] MemDataOut, CacheDataOut;
    wire [4:0] CacheTagOut;
    wire CacheErr, MemErr, MemBusy, MemStall, CacheHit, CacheDirty,
         CacheLineValid;

    /* data_mem = 1, inst_mem = 0 *
    * needed for cache parameter */
    parameter mem_type = 1;
    cache (0 + memtype) c0(// Outputs
                          .tag_out              (CacheTagOut),
                          .data_out             (CacheDataOut),
                          .hit                  (CacheHit),
                          .dirty                (CacheDirty),
                          .valid                (CacheLineValid),
                          .err                  (CacheErr),
                          // Inputs
                          .enable               (1'b1),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),
                          .tag_in               (),
                          .index                (),
                          .offset               (),
                          .data_in              (),
                          .comp                 (),
                          .write                (),
                          .valid_in             ());

    four_bank_mem mem(// Outputs
                     .data_out          (MemDataOut),
                     .stall             (MemStall),
                     .busy              (MemBusy),
                     .err               (MemErr),
                     // Inputs
                     .clk               (clk),
                     .rst               (rst),
                     .createdump        (createdump),
                     .addr              (),
                     .data_in           (),
                     .wr                (),
                     .rd                ());

    assign err = CacheErr | MemErr;


endmodule // mem_system

// DUMMY LINE FOR REV CONTROL :9:

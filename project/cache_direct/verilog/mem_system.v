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

    wire [15:0] MemDataOut, CacheDataOut, MemDataIn, MemAddr, CacheDataIn;
    wire [7:0] CacheIndex;
    wire [4:0] CacheTagOut, CacheTagIn;
    wire [3:0] MemBusy;
    wire [2:0] CacheOffset;
    wire CacheErr, MemErr, MemStall, CacheDirty,
         CacheLineValid, CacheComp, CacheWrite, CacheValidIn,
         MemWrite, MemRead, LocalCacheHit;

    // state related
    wire [12:0] next_state, curr_state;
    wire [2:0] cache_offset, mem_offset;
    wire StateErr;

    /* data_mem = 1, inst_mem = 0 *
    * needed for cache parameter */
    parameter mem_type = 1;
    cache #(0 + mem_type) c0(// Outputs
                          .tag_out              (CacheTagOut),
                          .data_out             (CacheDataOut),
                          .hit                  (LocalCacheHit),
                          .dirty                (CacheDirty),
                          .valid                (CacheLineValid),
                          .err                  (CacheErr),
                          // Inputs
                          .enable               (1'b1),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),
                          .tag_in               (CacheTagIn),
                          .index                (CacheIndex),
                          .offset               (CacheOffset),
                          .data_in              (CacheDataIn),
                          .comp                 (CacheComp),
                          .write                (CacheWrite),
                          .valid_in             (CacheValidIn));

    four_bank_mem mem(// Outputs
                     .data_out          (MemDataOut),
                     .stall             (MemStall),
                     .busy              (MemBusy),
                     .err               (MemErr),
                     // Inputs
                     .clk               (clk),
                     .rst               (rst),
                     .createdump        (createdump),
                     .addr              (MemAddr),
                     .data_in           (MemDataIn),
                     .wr                (MemWrite),
                     .rd                (MemRead));

    dff state[12:0](.d(next_state), .q(curr_state), .clk (clk), .rst({{12{rst}}, 1'b0}));

    wire [15:0] NextReqAddr, NextReqDataIn, ReqAddr, ReqDataIn;
    wire NextReqRd, NextReqWr, ReqRd, ReqWr, NextMiss, Miss;
    
    // miss dff & logic
    dff MissReg(.d (NextMiss), .q (Miss), .clk(clk), .rst(rst | curr_state[0]));
    
    assign NextMiss = ~((curr_state[1]) & (LocalCacheHit & CacheLineValid));    
    
    // store initial request
    dff AddrReqReg[15:0](.d(NextReqAddr), .q(ReqAddr), .rst(rst), .clk(clk));
    dff DataInReqReg[15:0](.d(NextReqDataIn), .q(ReqDataIn), .rst(rst), .clk(clk));
    dff RdReqReg(.d(NextReqRd), .q(ReqRd), .rst(rst), .clk(clk));
    dff WrReqReg(.d(NextReqWr), .q(ReqWr), .rst(rst), .clk(clk));
    
    assign err = CacheErr | MemErr;

    assign NextReqAddr = (curr_state[0]) ? Addr : ReqAddr;
    assign NextReqDataIn = (curr_state[0]) ? DataIn : ReqDataIn;
    assign NextReqRd = (curr_state[0]) ? Rd : (next_state[0] & curr_state[1]) ? 1'b0 : ReqRd;
    assign NextReqWr = (curr_state[0]) ? Wr : (next_state[0] & curr_state[1]) ? 1'b0 : ReqWr;
    
    // move to idle
    assign next_state[0] = rst | (curr_state[0] & (~Rd & ~Wr)) | (curr_state[1] & (LocalCacheHit & CacheLineValid));
    
    // move to compare
    assign next_state[1] = (curr_state[0] & (NextReqRd | NextReqWr)) | (curr_state[7]);
    
    // move to first allocate state (stalls?)
    assign next_state[2] = (curr_state[1] & ~(LocalCacheHit & CacheLineValid) & ~(CacheLineValid & CacheDirty)) | (curr_state[12] & ~(|MemBusy)); // A0
    assign next_state[3] = curr_state[2]; // A1
    assign next_state[4] = curr_state[3]; // A2
    assign next_state[5] = curr_state[4]; // A3
    assign next_state[6] = curr_state[5]; // A4
    assign next_state[7] = curr_state[6]; // A5
    
    // move to first writeback state
    assign next_state[8] = (curr_state[1] & (~LocalCacheHit & CacheLineValid) & (CacheLineValid & CacheDirty)) | (MemStall & curr_state[8]); // WB0
    assign next_state[9] = (~MemStall & curr_state[8]) | (MemStall & curr_state[9]); // WB1
    assign next_state[10] = (~MemStall & curr_state[9]) | (MemStall & curr_state[10]); // WB2
    assign next_state[11] = (~MemStall & curr_state[10]) | (MemStall & curr_state[11]); // WB3
    
    // intermediate
    assign next_state[12] = (~MemStall & curr_state[11]) | (curr_state[12] & (|(MemBusy)));

    // memory_system outputs
    assign CacheHit = ~Miss & (curr_state[1]) & (LocalCacheHit & CacheLineValid);
    assign DataOut = CacheDataOut;
    assign Done = (curr_state[1]) & (LocalCacheHit & CacheLineValid);
    assign Stall = MemStall | (~curr_state[0] & ~Done) | (curr_state[0] & next_state[1]);

    // cache
    assign CacheDataIn = (|(curr_state[7:4])) ? MemDataOut  : ReqDataIn; 
    assign CacheTagIn = ReqAddr[15:11];
    assign CacheIndex = ReqAddr[10:3];
    assign CacheOffset = {3{~rst}} & cache_offset; 
    assign CacheComp = (curr_state[1]);
    assign CacheWrite = (|(curr_state[7:4])) | (curr_state[1] & ReqWr); // allocate states 2-5 write to the cache
    assign CacheValidIn = |(curr_state[7:4]); // allocate states 2-5 write to the cache

    // memory
    assign MemRead = |(curr_state[5:2]);
    assign MemWrite = |(curr_state[11:8]);
    assign MemDataIn = CacheDataOut;
    assign MemAddr = {(|(curr_state[7:4])) ? CacheTagIn : CacheTagOut, CacheIndex, {3{~rst}} & mem_offset};
    
    assign cache_offset = (curr_state[7] | curr_state[11]) ? 3'd6 :
                          (curr_state[6] | curr_state[10]) ? 3'd4 :
                          (curr_state[5] | curr_state[9])  ? 3'd2 :
                          (curr_state[1]) ? ReqAddr[2:0] : 3'd0;
    
    assign mem_offset = (curr_state[5] | curr_state[11]) ? 3'd6 :
                        (curr_state[4] | curr_state[10]) ? 3'd4 :
                        (curr_state[3] | curr_state[9])  ? 3'd2 :
                                                           3'd0;
endmodule // mem_system

// DUMMY LINE FOR REV CONTROL :9:

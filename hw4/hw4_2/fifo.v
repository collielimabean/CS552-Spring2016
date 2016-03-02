/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
module fifo(/*AUTOARG*/
    // Outputs
    data_out, fifo_empty, fifo_full, err,
    // Inputs
    data_in, data_in_valid, pop_fifo, clk, rst
    );
    input [63:0] data_in;
    input        data_in_valid;
    input        pop_fifo;

    input        clk;
    input        rst;
    output [63:0] data_out;
    output        fifo_empty;
    output        fifo_full;
    output        err;


    wire [255:0] entries_in, fifo_out, demux_out;
    wire [1:0] read, write;
    wire [1:0] read_inc, write_inc, next_read, next_write;
    wire entry_wr_en;

    dff read_dff[1:0](.d (next_read), .q (read), .clk (clk), .rst (rst));
    dff write_dff[1:0](.d (next_write), .q (write), .clk (clk), .rst (rst));
    dff64 entries[3:0](.d (entries_in), .q (fifo_out), .clk (clk), .rst(rst));

    mux4to1 dout_mux[63:0] (.InA (fifo_out[63:0]), .InB (fifo_out[127:64]), .InC (fifo_out[191:128]), .InD (fifo_out[255:192]), .S (read), .Out (data_out));
    demux1to4 din_demux[63:0](.In (data_in), .S (write), .Out0 (demux_out[63:0]), .Out1 (demux_out[127:64]), .Out2 (demux_out[191:128]), .Out3 (demux_out[255:192]));

    assign entries_in[63:0] = (~(|demux_out[63:0]) | ~entry_wr_en) ? fifo_out[63:0] : demux_out[63:0];
    assign entries_in[127:64] = (~(|demux_out[127:64]) | ~entry_wr_en) ? fifo_out[127:64] : demux_out[127:64];
    assign entries_in[191:128] = (~(|demux_out[191:128]) | ~entry_wr_en) ? fifo_out[191:128] : demux_out[191:128];
    assign entries_in[255:192] = (~(|demux_out[255:192]) | ~entry_wr_en) ? fifo_out[255:192] : demux_out[255:192];

    assign next_read = (pop_fifo & ~fifo_empty) ? read_inc : read;
    assign next_write = (data_in_valid & ~fifo_full) ? write_inc : write; 

    assign entry_wr_en = data_in_valid & ~fifo_full;

    inc ha (.In (read), .Out (read_inc));
    inc ta (.In (write), .Out (write_inc));
    fifo_size fs(.rst (rst), .clk(clk), .data_in_valid(data_in_valid), .pop_fifo (pop_fifo), .full (fifo_full), .empty (fifo_empty), .err (err));

endmodule
// DUMMY LINE FOR REV CONTROL :1:

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

    wire [255:0] entries_in, demux_out, fifo_out;
    wire [1:0] head, tail, h_inc, t_inc, h_dec, t_dec, head_in, tail_in;

    dff64 entries[3:0](.d (entries_in), .q (fifo_out), .clk (clk), .rst(rst));
    dff2 head_reg(.d (head_in), .q(head), .clk (clk), .rst (rst));
    dff2 tail_reg(.d (tail_in), .q(tail), .clk (clk), .rst (rst));

    mux4to1_64 dout_mux(.InA (fifo_out[63:0]), .InB (fifo_out[127:64]), .InC (fifo_out[191:128]), .InD (fifo_out[255:192]), .S (head), .Out (data_out));
    demux1to4_64 din_demux(.In (data_in), .S (tail), .Out0 (demux_out[63:0]), .Out1 (demux_out[127:64]), .Out2 (demux_out[191:128]), .Out3 (demux_out[255:192]));

    incdec2 ha(.A (head), .Inc (h_inc), .Dec (h_dec));
    incdec2 ta(.A (tail), .Inc (t_inc), .Dec (t_dec));

    assign entries_in[63:0] = (~(|demux_out[63:0])) ? fifo_out[63:0] : demux_out[63:0];
    assign entries_in[127:64] = (~(|demux_out[127:64])) ? fifo_out[127:64] : demux_out[127:64];
    assign entries_in[191:128] = (~(|demux_out[191:128])) ? fifo_out[191:128] : demux_out[191:128];
    assign entries_in[255:192] = (~(|demux_out[255:192])) ? fifo_out[255:192] : demux_out[255:192];

    assign fifo_empty = rst | ~(|(head ^ tail));
    assign fifo_full = ~rst & ~(|(head ^ t_inc));
    assign head_in = (~fifo_empty & pop_fifo) ? h_inc : head;
    assign tail_in = (~fifo_full & data_in_valid) ? t_inc : tail;
endmodule
// DUMMY LINE FOR REV CONTROL :1:

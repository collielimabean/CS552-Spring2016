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


    wire [1:0] read, write;
    wire full, empty;

    wire [1:0] read_inc, write_inc, next_read, next_write;


    dff read_dff[1:0](.d (next_read), .q (read), .clk (clk), .rst (rst));
    dff write_dff[1:0](.d (next_write), .q (write), .clk (clk), .rst (rst));


    /* dff64 [3:0] */
    /* in, out logic */

    assign next_read = (pop_fifo & ~empty) ? read_inc : read;
    assign next_write = (data_in_valid & ~full) ? write_inc : write; 

    inc ha (.In (read), .Out (read_inc));
    inc ta (.In (write), .Out (write_inc));
    fifo_size fs(.rst (rst), .clk(clk), .data_in_valid(data_in_valid), .pop_fifo (pop_fifo), .full (fifo_full), .empty (fifo_empty), .err (err));

endmodule
// DUMMY LINE FOR REV CONTROL :1:

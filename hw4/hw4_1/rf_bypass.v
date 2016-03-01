/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
module rf_bypass (
           // Outputs
           read1data, read2data, err,
           // Inputs
           clk, rst, read1regsel, read2regsel, writeregsel, writedata, write
           );
    input clk, rst;
    input [2:0] read1regsel;
    input [2:0] read2regsel;
    input [2:0] writeregsel;
    input [15:0] writedata;
    input        write;

    output [15:0] read1data;
    output [15:0] read2data;
    output        err;

    wire [15:0] rf_r1_out, rf_r2_out;


    rf regfile (.clk (clk), .rst (rst), .err (err), .write (write),
                .read1regsel (read1regsel), .read2regsel (read2regsel),
                .writeregsel (writeregsel), .writedata (writedata),
                .read1data (rf_r1_out), .read2data(rf_r2_out));

    assign read1data = (~(|(read1regsel ^ writeregsel)) & write) ? writedata : rf_r1_out;
    assign read2data = (~(|(read2regsel ^ writeregsel)) & write) ? writedata : rf_r2_out;
endmodule
// DUMMY LINE FOR REV CONTROL :1:

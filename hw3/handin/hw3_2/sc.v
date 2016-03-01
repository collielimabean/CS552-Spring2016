/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */

module sc( clk, rst, ctr_rst, out, err);
    input clk;
    input rst;
    input ctr_rst;
    output [2:0] out;
    output err;

    wire [2:0] next_state, inc_out;
    wire cnt_rst, error, cr_error;

    dff count [2:0] (.d (next_state), .q (out), .clk (clk), .rst (cnt_rst));
    clkrst cr(.clk (clk), .rst (rst), .err (cr_error));
    incrementer3 inc(.A (out), .S (inc_out));

    assign next_state = (inc_out[2] & inc_out[1] & ~inc_out[0]) ? out : inc_out;
    assign cnt_rst = ctr_rst | rst;
    assign err = cr_error | (out[2] & out[1]);
endmodule

// DUMMY LINE FOR REV CONTROL :1:

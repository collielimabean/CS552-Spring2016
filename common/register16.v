
module register16(d, clk, wr_en, rst, q);
    input [15:0] d;
    input clk, wr_en, rst;
    output [15:0] q;

    wire [15:0] d_actual;
    assign d_actual = (wr_en) ? d : q;

    dff dff_arr[15:0](.d (d_actual), .q(q), .clk (clk), .rst (rst));
endmodule

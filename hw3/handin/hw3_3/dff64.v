
module dff64(d, q, clk, rst);
    input [63:0] d;
    input clk, rst;
    output [63:0] q;

    dff dff_arr[63:0](.d (d), .q (q), .clk(clk), .rst(rst));
endmodule

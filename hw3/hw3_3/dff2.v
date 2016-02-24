
module dff2(d, q, clk, rst);
    input [1:0] d;
    input clk, rst;
    output [1:0] q;

    dff dff_arr[1:0](.d (d), .q (q), .clk (clk), .rst (rst));
endmodule

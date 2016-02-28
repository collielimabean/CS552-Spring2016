
module fifo_incrementer(en, clk, rst, Out);
    input en, clk, rst;
    output [1:0] Out;

    wire [1:0] inc, next_val;
    
    dff2 state(.d (next_val), .clk (clk), .rst (rst), .q (Out));

    assign inc[0] = ~Out[0];
    assign inc[1] = Out[1] ^ Out[0];
    assign next_val = (en) ? inc : Out;
endmodule

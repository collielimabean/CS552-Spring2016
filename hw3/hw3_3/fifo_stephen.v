module fifo_stephen(data_in, data_in_valid, pop_fifo, clk, rst, data_out, fifo_empty, fifo_full, err);
    input data_in, data_in_valid, pop_fifo, clk, rst;
    output data_out, fifo_empty, fifo_full, err;

    wire [3:0] df_demuxed, df_data, df_muxed;
    wire [1:0] head, tail;
    wire df_switch;

    assign df_switch = data_in_valid & ~rst & ~fifo_full;
    assign df_data = {4{df_switch}} & df_demuxed;

    assign fifo_empty = (tail ~^ head) | rst;
    assign fifo_full = ~rst & ((~A[0] & B[0] & (A[1] ~^ B[1])) | (A[0] & ~B[0] & (A[1] ^ B[1])));
    assign err = fifo_empty & fifo_full;

    fifo_incrementer fi_head(.en(data_in_valid & ~fifo_full), .clk(clk), .rst(rst), .Out(head));
    fifo_incrementer fi_tail(.en(pop_fifo & ~fifo_empty), .clk(clk), .rst(rst), .Out(tail));

    dff dffs[3:0](.d({df_data), .q(df_muxed), .clk(clk), .rst(rst));
    demux1to4 dm0(.In(data_in), .S(head), .Out0(df_demuxed[0]), .Out1(df_demuxed[1]), .Out2(df_demuxed[2]), .Out3(df_demuxed[3]));
    mux4to1 m0(.InA(df_muxed[0]), .InB(df_muxed[1]), .InC(df_muxed[2]), .InD(df_muxed[3]), .S(tail), .Out(data_out));
    
endmodule

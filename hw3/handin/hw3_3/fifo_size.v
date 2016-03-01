
module fifo_size(rst, clk, data_in_valid, pop_fifo, full, empty, err);
    input rst, clk, data_in_valid, pop_fifo;
    output full, empty, err;

    wire [4:0] cur, next;

    assign next[0] = rst | (cur[0] & ~data_in_valid) | (cur[1] & ~data_in_valid & pop_fifo);
    assign next[1] = (cur[1] & ~(pop_fifo ^ data_in_valid)) | (cur[0] & data_in_valid) | (cur[2] & ~data_in_valid & pop_fifo);
    assign next[2] = (cur[2] & ~(pop_fifo ^ data_in_valid)) | (cur[1] & data_in_valid & ~pop_fifo) | (cur[3] & pop_fifo & ~data_in_valid);
    assign next[3] = (cur[3] & ~(pop_fifo ^ data_in_valid)) | (cur[2] & data_in_valid & ~pop_fifo) | (cur[4] & pop_fifo);
    assign next[4] = (cur[4] & ~pop_fifo) | (cur[3] & data_in_valid & ~pop_fifo);

    dff state [4:0] (.d (next), .q (cur), .clk (clk), .rst ({{4{rst}}, 1'b0}));

    assign full = ~rst & cur[4];
    assign empty = rst | cur[0];
endmodule

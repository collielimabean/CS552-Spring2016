
module rshifter(In, Cnt, Logical_sel, Out);
    input [15:0] In;
    input [3:0] Cnt;
    input Logical_sel;
    output [15:0] Out;

    wire [15:0] intermediates[2:0];
    wire [15:0] shifts[3:0];

    assign shifts[0] = In >> 1;
    assign shifts[1] = intermediates[0] >> 2;
    assign shifts[2] = intermediates[1] >> 4;
    assign shifts[3] = intermediates[2] >> 8;

    assign intermediates[0] = (~Cnt[0]) ? In :
                              (Logical_sel) ? {In[15], shifts[0][14:0]} :
                              shifts[0];

    assign intermediates[1] = (~Cnt[1]) ? intermediates[0] :
                              (Logical_sel) ? {{2{intermediates[0][15]}}, shifts[1][13:0]} :
                              shifts[1];

    assign intermediates[2] = (~Cnt[2]) ? intermediates[1] :
                              (Logical_sel) ? {{4{intermediates[1][15]}}, shifts[2][11:0]} :
                              shifts[2];

    assign Out = (~Cnt[3]) ? intermediates[2] :
                 (Logical_sel) ? {{8{intermediates[2][15]}}, shifts[3][7:0]} :
                 shifts[3];

endmodule

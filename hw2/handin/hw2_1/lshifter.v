
module lshifter(In, Cnt, Rot_sel, Out);
    input [15:0] In;
    input [3:0] Cnt;
    input Rot_sel;
    output [15:0] Out;

    wire [15:0] intermediates[2:0];
    wire [15:0] shifts[3:0];

    assign shifts[0] = In << 1;
    assign shifts[1] = intermediates[0] << 2;
    assign shifts[2] = intermediates[1] << 4;
    assign shifts[3] = intermediates[2] << 8;

    assign intermediates[0] = (~Cnt[0]) ? In :
                              (Rot_sel) ? {shifts[0][15:1], In[15]} :
                              shifts[0];

    assign intermediates[1] = (~Cnt[1]) ? intermediates[0] :
                              (Rot_sel) ? {shifts[1][15:2], intermediates[0][15:14]} :
                              shifts[1];

    assign intermediates[2] = (~Cnt[2]) ? intermediates[1] :
                              (Rot_sel) ? {shifts[2][15:4], intermediates[1][15:12]} :
                              shifts[2];

    assign Out = (~Cnt[3]) ? intermediates[2] :
                 (Rot_sel) ? {shifts[3][15:8], intermediates[2][15:8]} :
                 shifts[3];

endmodule

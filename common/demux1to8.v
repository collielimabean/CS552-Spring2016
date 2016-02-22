
// a 1 to 8 demux module
module demux1to8(In, S, Out0, Out1, Out2, Out3, Out4, Out5, Out6, Out7);
    input        In;
    input  [2:0] S;
    output Out0, Out1, Out2, Out3, Out4, Out5, Out6, Out7;

    assign Out0 = In & (~S[2] & ~S[1] & ~S[0]);
    assign Out1 = In & (~S[2] & ~S[1] & S[0]);
    assign Out2 = In & (~S[2] & S[1] & ~S[0]);
    assign Out3 = In & (~S[2] & S[1] & S[0]);
    assign Out4 = In & (S[2] & ~S[1] & ~S[0]);
    assign Out5 = In & (S[2] & ~S[1] & S[0]);
    assign Out6 = In & (S[2] & S[1] & ~S[0]);
    assign Out7 = In & (S[2] & S[1] & S[0]);
endmodule


module demux1to8_16(In, S, Out0, Out1, Out2, Out3, Out4, Out5, Out6, Out7);
    input [15:0] In;
    input [2:0] S;
    output [15:0] Out0, Out1, Out2, Out3, Out4, Out5, Out6, Out7;


    demux1to8 demux[15:0](.In (In), 
                          .S  (S), 
                          .Out0 (Out0), 
                          .Out1 (Out1),
                          .Out2 (Out2), 
                          .Out3 (Out3),
                          .Out4 (Out4),
                          .Out5 (Out5),
                          .Out6 (Out6),
                          .Out7 (Out7));

endmodule

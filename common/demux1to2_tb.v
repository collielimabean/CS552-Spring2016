module demux1to2_tb();
    reg In;
    reg S;
    wire [1:0] Out;
    demux1to2 d0(.In(In), .S(S), .Out(Out));

    initial begin
        In <= 1'b0;
        S <= 1'b0;

        #20 In <= 1'b1;
        #20 In <= 1'b0; S <= 1'b1;
        #20 In <= 1'b1;
        #20;

    end

    always @(*) begin
        if ((In & ~S != Out[0]) | (In & S != Out[1])) begin
            $display("Demux fail at time %d: In: %d | S: %d | expected: %d", $time, In, S, (In & ~S != Out[0]) | (In & S != Out[1]));
        end
    end


endmodule


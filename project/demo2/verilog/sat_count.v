module sat_count(clk, rst, Saturated);

    input clk, rst;
    output Saturated;

    wire [2:0] nextState, currentState;

    dff state[2:0](.p(nextState), .q(currentState), .clk(clk), .rst({{2{rst}}, 1'b0}));

    assign nextState[0] = rst;
    assign nextState[1] = currentState[0] & ~rst;
    assign nextState[2] = currentState[1] | currentState[2];

    assign Saturated = nextState[2]; 

endmodule

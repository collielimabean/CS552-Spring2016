
module clamodule4_tb;

    reg [3:0] a, b, s;
    reg cin, cout;

    clamodule cla(.A (a), .B(b), .Cin(cin), .S(s), .Cout(cout));

    initial begin
        a = 4'b0000;
        b = 4'b0000;
        cin = 1'b0;

        // tests C[0]
        #5 cin = 1'b1;

        // tests generate on cout
        #5 a = 4'b1111; b = 4'b1111; cin = 1'b0;
        #5 cin = 1'b1;

        // test C[1]
        #5 a = 4'b0001; b = 4'b0000; cin = 1'b1;
        #5 b = 4'b0001; cin = 1'b0;        

        // test C[2]
        #5 a = 4'b0010; b = 4'b0010; cin = 1'b0;
        #5 a = 4'b0011; b = 4'b0001;
        #5 a = 4'b0010; b = 4'b0001; cin = 1'b1;      
 
        // test C[3]        

        // test other cout cases

    end

    always @(*) begin
        if (a + b != {cout, s}) begin
            $display("Add fail at time %d: a: %d | b: %d | s: %d", $time, a, b, s);
        end
    end


endmodule

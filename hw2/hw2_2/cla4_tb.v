
module cla4_tb;
    reg [3:0] a, b;
    reg cin;
    wire [3:0] s;
    wire cout, P, G;
    cla4 cla(.A (a), .B(b), .Cin(cin), .S(s), .Cout(cout), .PG(P), .GG(G));

    initial begin
        a <= 4'b0000;
        b <= 4'b0000;
        cin <= 1'b0;

        // tests C[0]
        #20 cin <= 1'b1;

        // test C[1]
        #20 a <= 4'b0001; b <= 4'b0000; cin <= 1'b1;
        #20 b <= 4'b0001; cin <= 1'b0;        

        // test C[2]
        #20 a <= 4'b0010; b <= 4'b0010; cin <= 1'b0;
        #20 a <= 4'b0011; b <= 4'b0001;
        #20 a <= 4'b0011; b <= 4'b0000; cin <= 1'b1;      
 
        // test C[3]        
        #20 a <= 4'b0100; b <= 4'b0100; cin <= 1'b0;
        #20 a <= 4'b0110; b <= 4'b0010;
        #20 a <= 4'b0111; b <= 4'b0001;
        #20 a <= 4'b0111; b <= 4'b0000; cin <= 1'b1;

        // test other cout cases
        #20 a <= 4'b1000; b <= 4'b1000; cin <= 1'b0;
        #20 a <= 4'b1100; b <= 4'b0100;
        #20 a <= 4'b1110; b <= 4'b0010;
        #20 a <= 4'b1111; b <= 4'b0001;
        #20 a <= 4'b1111; b <= 4'b0000; cin <= 1'b1;
    end

    always @(*) begin
        if (a + b + cin!= {cout, s}) begin
            $display("Add fail at time %d: a: %d | b: %d | s: %d | expected: %d", $time, a, b, s, a + b + cin);
        end
    end


endmodule

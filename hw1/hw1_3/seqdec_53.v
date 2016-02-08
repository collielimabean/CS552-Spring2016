// Moore state machine to detect "53" in BCD
// ID number: 906 443 7073

module seqdec_53(InA, Clk, Reset, Out);
	input  InA, Clk, Reset;
	output Out;

	wire d0_in, d1_in, d2_in,
		d3_in, d4_in, d5_in,
		d6_in, d7_in, d8_in;
		
	wire d0_out, d1_out, d2_out,
		d3_out, d4_out, d5_out,
	 	d6_out, d7_out, d8_out;
	
	assign d0_in = Reset | 
		       (InA & 
		       (d0_out | 
		       (d2_out | 
		       (d4_out | d8_out))));
	
	assign d1_in = ~InA & 
		        (d0_out | 
		        (d1_out | 
		        (d3_out | 
		        (d6_out | d8_out))));
		       
	assign d2_in = InA & d1_out;
	
	assign d3_in = ~InA & 
		        (d2_out | d7_out);
		       
	assign d4_in = InA &
		        (d3_out | d5_out);
		    
	assign d5_in = ~InA & d4_out;
	
	assign d6_in = ~InA & d5_out;
	
	assign d7_in = InA & d6_out;
	
	assign d8_in = InA & d7_out;
	
	assign Out = d8_out;

	dff d0(.d(d0_in), .q(d0_out), .clk(Clk), .rst(1'b0));
	dff d1(.d(d1_in), .q(d1_out), .clk(Clk), .rst(Reset));
	dff d2(.d(d2_in), .q(d2_out), .clk(Clk), .rst(Reset));
	dff d3(.d(d3_in), .q(d3_out), .clk(Clk), .rst(Reset));
	dff d4(.d(d4_in), .q(d4_out), .clk(Clk), .rst(Reset));
	dff d5(.d(d5_in), .q(d5_out), .clk(Clk), .rst(Reset));
	dff d6(.d(d6_in), .q(d6_out), .clk(Clk), .rst(Reset));
	dff d7(.d(d7_in), .q(d7_out), .clk(Clk), .rst(Reset));
	dff d8(.d(d8_in), .q(d8_out), .clk(Clk), .rst(Reset));

endmodule

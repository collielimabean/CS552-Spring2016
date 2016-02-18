module demux1to4_tb();
	reg [2:0] inputs;
	wire [3:0] out;
	
	demux1to4 d0(.In(inputs[2]), .S(inputs[1:0]),. Out0(out[0]), .Out1(out[1]), .Out2(out[2]), .Out3(out[3]));
	
	initial begin
		    inputs = 3'b000;
		#20 inputs = 3'b001;
		#20 inputs = 3'b010;
		#20 inputs = 3'b011;
		#20 inputs = 3'b100;
		#20 inputs = 3'b101;
		#20 inputs = 3'b110;
		#20 inputs = 3'b111;
		#20;
	end


endmodule

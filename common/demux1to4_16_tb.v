module demux1to4_16_tb();
	reg [17:0] inputs;
	wire [15:0] out0, out1, out2, out3;
	
	demux1to4_16 d0(.In(inputs[17:2]), .S(inputs[1:0]),. Out0(out0), .Out1(out1), .Out2(out2), .Out3(out3));
	
	initial begin
		    inputs = 18'h00000;
		#20 inputs = 18'h00001;
		#20 inputs = 18'h00002;
		#20 inputs = 18'h00003;
		#20 inputs = 18'h30a00;
		#20 inputs = 18'h30101;
		#20 inputs = 18'h30102;
		#20 inputs = 18'h30103;
		#20;
	end


endmodule
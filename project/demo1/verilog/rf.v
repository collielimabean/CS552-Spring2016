/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
module rf (
            // Outputs
            read1data, read2data, err,
            // Inputs
            clk, rst, read1regsel, read2regsel, writeregsel, writedata, write
          );
    input clk, rst;
    input [2:0] read1regsel;
    input [2:0] read2regsel;
    input [2:0] writeregsel;
    input [15:0] writedata;
    input        write;

    output [15:0] read1data;
    output [15:0] read2data;
    output        err;

    wire [127:0] reg_in;
    wire [127:0] reg_out;
    wire [7:0]  write_en, rf_wr_en;

    assign rf_wr_en = (write) ? write_en : 8'd0;
    assign err = 1'b0;

    clkrst cr(.clk (clk), .rst(rst), .err(err));
    register16 registers [7:0] (.d(reg_in), .q(reg_out), .clk (clk), .wr_en(rf_wr_en), .rst(rst));
    decoder3to8 wr_dec(.In (writeregsel), .Out (write_en));

    mux8to1_16 read1_mux(.In (reg_out), .Sel (read1regsel), .Out(read1data));
    mux8to1_16 read2_mux(.In (reg_out), .Sel (read2regsel), .Out(read2data));
    demux1to8_16 wr_demux(.In (writedata), .S(writeregsel), .Out0 (reg_in[15:0]), .Out1 (reg_in[31:16]), .Out2 (reg_in[47:32]), .Out3 (reg_in[63:48]), .Out4 (reg_in[79:64]), .Out5 (reg_in[95:80]), .Out6 (reg_in[111:96]), .Out7 (reg_in[127:112]));

endmodule
// DUMMY LINE FOR REV CONTROL :1:

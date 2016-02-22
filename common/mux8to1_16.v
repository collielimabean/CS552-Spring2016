
module mux8to1_16(In, Sel, Out);
    input [127:0]  In;
    input [2:0]   Sel;
    output [15:0] Out;

    wire [15:0] mux0_out;
    wire [15:0] mux1_out;

    mux4to1_16 mux0(.InA(In[15:0]), .InB(In[31:16]), .InC (In[47:32]), .InD (In[63:48]), .S (Sel[1:0]), .Out(mux0_out));
    mux4to1_16 mux1(.InA(In[79:64]), .InB(In[95:80]), .InC (In[111:96]), .InD (In[127:112]), .S (Sel[1:0]), .Out(mux1_out));

    assign Out = (Sel[2]) ? mux1_out : mux0_out;
endmodule

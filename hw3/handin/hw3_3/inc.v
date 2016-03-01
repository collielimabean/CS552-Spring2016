
module inc(In, Out);
    input [1:0] In;
    output [1:0] Out;

    assign Out[0] = ~In[0];
    assign Out[1] = In[1] ^ In[0];
endmodule

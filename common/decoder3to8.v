
module decoder3to8(In, Out);
    input  [2:0] In;
    output [7:0] Out;

    assign Out[0] = ~In[2] & ~In[1] & ~In[0];
    assign Out[1] = ~In[2] & ~In[1] & In[0];
    assign Out[2] = ~In[2] & In[1] & ~In[0];
    assign Out[3] = ~In[2] & In[1] & In[0];
    assign Out[4] = In[2] & ~In[1] & ~In[0];
    assign Out[5] = In[2] & ~In[1] & In[0];
    assign Out[6] = In[2] & In[1] & ~In[0];
    assign Out[7] = In[2] & In[1] & In[0];
endmodule

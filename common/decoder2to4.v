
module decoder2to4(In, OutA, OutB, OutC, OutD);
    input [1:0] In;
    output OutA, OutB, OutC, OutD;

    assign OutA = ~(&In);
    assign OutB = ~In[1] & In[0];
    assign OutC = In[1] & ~In[0];
    assign OutD = &In;
endmodule

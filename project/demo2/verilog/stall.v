module stall(rst, clk, RtValid, MemWrite, MemToReg, RegFileWrEn, PMW_WriteReg, Rd, Rs, Rt, Stall);
    input rst, clk, RtValid, MemWrite, MemToReg, RegFileWrEn;
    input [2:0] Rd, Rs, Rt, PMW_WriteReg;
    output Stall;
    
    wire StallState;
    wire [2:0] RegDepIn, RegDep;
    
    dff stall_state_reg(.d (StallState), .q (Stall), .rst (rst), .clk(clk));
    dff reg_dependency_reg[2:0](.d (RegDepIn), .q (RegDep), .rst (rst), .clk(clk));

    assign StallState = Stall ? !(PMW_WriteReg == RegDep)
                              : ((Rd == Rs) || ((Rd == Rt) && RtValid) || MemWrite || MemToReg || RegFileWrEn)
                              ;
    
    assign RegDepIn = (Stall) ? RegDep : Rd;
                        
                        
   
/*
    wire [2:0] Next_DepReg, DepReg;
    dff depreg[2:0](.d(Next_DepReg), .q(DepReg), .rst(rst), .clk(clk)); 
    dff stallreg(.d(Next_Stall), .q(Stall), .rst(rst), .clk(clk));
    
 assign Next_Stall = (Stall) ? ~(|(DepReg ^ PMW_WriteReg)) :
                                  ((~(|(PDE_Rd ^ D_Rs))) | (D_RtValid & (~(|(PDE_Rd ^ D_Rt))))) & PDE_StageValid | D_MemRead;
              
    assign Next_DepReg = (Stall) ? DepReg : PDE_Rd;   
                          
assign Next_Stall = (Stall) ? ~(|(DepReg ^ PMW_WriteReg)) :
                              (~(|(PDE_Rd ^ D_Rs))) | (D_RtValid & (~(|(PDE_Rd ^ D_Rt))));
          
assign Next_DepReg = (Stall) ? DepReg : PDE_Rd;

    DependentReg;
    if (~Stall)
    {
        DependentReg = PDE_Rd;
        if (PDE_Rd == D_Rs || ((PDE_Rd == D_Rt) && D_RtValid)
        {
            
            Next_Stall = 1; 
        }
    }
    else
    {
        DependentReg = DependentReg; // no change
        if (DependentReg == PMW_WriteReg)
        {
            Next_Stall = 0;
        }
    }
*/  
endmodule

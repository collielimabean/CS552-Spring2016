module writeback(ExecuteOut, MemOut, MemToReg, WriteData);
    input [15:0] ExecuteOut, MemOut;
    input MemToReg;
    output [15:0] WriteData;

    assign WriteData = (MemToReg) ? MemOut : ExecuteOut;
endmodule

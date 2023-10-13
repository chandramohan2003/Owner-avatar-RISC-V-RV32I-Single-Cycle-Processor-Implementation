module reg_file (
    output  [31:0] rs1,
    output  [31:0] rs2,
    input   [4:0] rs1_adds,
    input   [4:0] rs2_adds,
    input   [4:0] rs3_adds,
    input    reg_write ,
    input clk,
    input   [31:0] w_data
    
    
);
    reg [31:0]  regs [31:0] ;
    initial $readmemh ("init_reg.mem",regs);
   
   always @(posedge clk)
   begin
        regs[0] <= 32'h0;
		if (reg_write) regs[rs3_adds] <= w_data;

   end

   assign rs1 =  regs[rs1_adds];
   assign rs2 =  regs[rs2_adds];
    
endmodule
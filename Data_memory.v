module data_memory (
output [31:0] out_mem,
input [31:0] in_data,
input [31:0] w_addr,
input clk,
input dm_write
);
  

    reg [31:0]  data_reg [0:31];
    // initial $readmemh ("Data_mem.mem",data_reg);
   
always @(posedge clk)
    begin
		if (dm_write)
         data_reg[w_addr>>2] = in_data;
    end


    assign out_mem = data_reg[w_addr>>2];
endmodule
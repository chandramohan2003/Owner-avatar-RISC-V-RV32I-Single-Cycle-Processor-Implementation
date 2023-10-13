
module instr_mem( 
                  input [31:0] instr_addr,
                  output reg [31:0] instr_data

                  );
                  
  reg [31:0] instr_mem [0:15];

  initial $readmemh ("program.mem",instr_mem);

  always @(instr_addr)
    instr_data= instr_mem[instr_addr>>2];
 
endmodule
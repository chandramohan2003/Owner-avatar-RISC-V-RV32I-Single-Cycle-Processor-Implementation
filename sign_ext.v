module sign_ext(  
     instr,
    
     imm_select,
     pc_4,
     out_mux,
     out_b
);
  
  input [31:0]pc_4;
  input [2:0] imm_select;

  input [31:0] instr;
  output [31:0] out_mux;
  output [31:0] out_b;
    // assign opcode = instr[6:0];

  assign opS=7'b0100011;
  assign opI=7'b0010011;
  assign opB=7'b1100011;
  assign opU=7'b0110111;
  assign opJ=7'b1101111;
  // assinging all variable

  wire [31:0] M1,M2,M3,M4,M5;


  
       
            // Check for opcode matches
             
           assign  M1 = {{20{instr[31]}},instr[31:20]};
         
             assign M2 = {{21{instr[31]}}, instr[30:25],instr[11:7]};
            
             assign M3 = {{20{instr[31]}}, instr[7],instr[30:25],instr[11:8],1'b0};
            
                assign M4 = {instr[31],instr[30:12],{12{1'b0}}}; 
           
                assign M5 = {{12{instr[31]}}, instr[19:12],instr[20],instr[30:21],1'b0};
     
   
    assign out_mux = (imm_select == 3'b000) ? M1 :
                (imm_select == 3'b001) ? M2 :
                (imm_select == 3'b010) ? M3 :
                (imm_select == 3'b011) ? M4 :
                (imm_select == 3'b100) ? M5 :
                32'b0; // selecting the default pin
         
    
     assign out_b=out_mux+pc_4;

endmodule
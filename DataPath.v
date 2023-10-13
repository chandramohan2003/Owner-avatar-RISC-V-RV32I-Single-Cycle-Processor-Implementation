module datapath( // 
                input clk_in,
                 input rst,
                 input preset,
                 input hlt,
                 // control signal (ctrl -> data path)

                 input [3:0] alu_control,
                 input [4:0] rs1_addr,
                 input [4:0] rs2_addr,
                 input [4:0] rd_addr,
                 input [1:0] store_sel,
                 input [2:0] dm_sel,
                 input [2:0] imm_sel,
                 input[2:0] wd_src,
                 input [2:0] br_sel,
                 input reg_write,
                 input dm_write,
                 input A_sel,
                 input B_sel,
                 input [1:0] pc_src,
                 input [31:0] start_addr,
                 // control signal (ctrl <- data path)
                 output [31:0] instr,
                 output [31:0] result,
                 output br_taken
               );
               
               reg clk;
               
                always @(*)
                if(hlt==0)
                    clk = clk_in;
                else 
                    clk = 0;
                    
              wire [31:0] current_addr;
              //   reg [31:0] next_addr;
              wire [31:0] pc_plus4,imm_out_addr,alu_out;
              wire [31:0] load_in,load_out; // output from load block
              wire [31:0] pc_next;
                
               
              assign load_in=load_out;

             
            // prog counter
              Prog_counter pc(.clk(clk),.reset(rst),.preset(preset),.pc_next(pc_next),.Pc_out(current_addr),.starting_addr(start_addr)); 

            // pc adder
              PC_next_add pc_adder(.current_addr(current_addr),.pc_next(pc_plus4));

            //   instruction memory
             instr_mem ins_mem(.instr_addr(current_addr),.instr_data(instr));
            
              wire [31:0]  instr_fetched;
              wire [31:0]Imm_out;
              assign instr_fetched=instr;

            // wire [31:0] imm_out_addr;

              sign_ext imm_extend(.out_mux(Imm_out),.out_b(imm_out_addr),.instr(instr_fetched),.imm_select(imm_sel),.pc_4(current_addr));
              
              wire [31:0] reg_in;
             reg_mux reg_mux(.reg_mux_out(reg_in),.inp1(alu_out),.inp2(load_in),.inp3(pc_plus4),.inp4(Imm_out),.inp5(imm_out_addr),.wd_src(wd_src));

            wire [31:0] A,B;

            // reg file
             reg_file registers(.rs1(A),.rs2(B),.rs1_adds(rs1_addr),.rs2_adds(rs2_addr),.rs3_adds(rd_addr),.reg_write(reg_write),.clk(clk),.w_data(reg_in));

            wire [31:0] alu_A,alu_B;
            assign alu_A= (A_sel)? current_addr:A;
            assign alu_B= (B_sel)?Imm_out:B; 

            wire [31:0] store_out;

            ALU alu(.in1(alu_A),.in2(alu_B),.alu_control(alu_control),.alu_out(alu_out));
            
            PcMux pcmux(.pc_mux_out(pc_next),.pc_add_4(pc_plus4),.imm_address(imm_out_addr),.pc_next(alu_out),.PC_src(pc_src));

            assign result=alu_out;
              
            wire [31:0] dmem_out; // wire for data mem

            data_memory data_mem(.out_mem(dmem_out),.in_data(store_out),.w_addr(alu_out),.clk(clk),.dm_write(dm_write));

            LoadBlock load_unit(.data_memory(dmem_out),.block_output(load_out),.dm_select(dm_sel));

            StoreBlock store_unit (.source_2_in(B),.out_mux(store_out),.store_sel(store_sel));

            branch_unit branch_unit (.in1(A),.in2(B),.br_sel(br_sel),.branch_taken(br_taken));
            
endmodule
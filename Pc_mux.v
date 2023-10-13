module PcMux (
    output reg [31:0] pc_mux_out,
    input [31:0]pc_add_4,
    input [31:0]imm_address,
    input [31:0] pc_next,
    input [1:0]PC_src
);
   
        always @(*)
            begin
            case (PC_src)

                2'b01:  pc_mux_out = pc_next;
                2'b10:  pc_mux_out = imm_address;
                2'b00:  pc_mux_out = pc_add_4;
                default:pc_mux_out = pc_add_4;
                
            endcase
        end
    
endmodule
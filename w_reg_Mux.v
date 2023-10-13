module reg_mux (
    output reg [31:0] reg_mux_out,
    input [2:0] wd_src,
    input [31:0]inp1,
    input [31:0]inp2,
    input [31:0]inp3,
    input [31:0]inp4,
    input [31:0]inp5

);

always @(*)
    begin
        case (wd_src)
            3'b000: reg_mux_out = inp1; 
            3'b001: reg_mux_out = inp2; 
            3'b010: reg_mux_out = inp3; 
            3'b011: reg_mux_out = inp4; 
            3'b100: reg_mux_out = inp5; 
            default : reg_mux_out = 32'b0; 
        endcase
    end
    
endmodule
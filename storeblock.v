module StoreBlock(
   source_2_in,
   store_sel,
   out_mux
);
   input [31:0] source_2_in;
   input [1:0] store_sel;
   wire [31:0] sw,sb,sh;
   output reg [31:0] out_mux;
    assign sw=source_2_in[31:0];
    assign sh={ 16'b0 ,source_2_in[15:0]};          
    assign sb={ 24'b0 ,source_2_in[7:0]};
       always @(*) begin
        case (store_sel)
            3'b00: out_mux = sb; // Select sw
            3'b01: out_mux = sh; // Select sh
            3'b10: out_mux = sw; // Select sb
            default: out_mux = 32'b0; // Default case 
        endcase
    end
endmodule
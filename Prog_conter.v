module Prog_counter (
                    output [31:0] Pc_out,
                    input clk,
                    input [31:0] pc_next,
                    input [31:0] starting_addr,
                    input reset,
                    input preset        

                    );
        reg [31:0] pc_data = 32'b0;

        always @(posedge clk)
        begin
            if(reset==1) pc_data <= 32'b0;

            else if(preset) pc_data <= starting_addr;

            else 
                pc_data <= pc_next;
        end
        assign Pc_out = pc_data;
endmodule
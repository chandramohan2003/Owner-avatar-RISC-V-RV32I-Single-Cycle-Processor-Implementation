module LoadBlock(data_memory,block_output,dm_select);

  input [31:0] data_memory;
  output reg [31:0] block_output;
  input [2:0] dm_select;
    assign lb={ {24{data_memory[7]}},data_memory[7:0]};
    assign lh={ {16{data_memory[15]}} ,data_memory[15:0]};
    assign lw=data_memory[31:0];
    assign lbu={ 24'b0,data_memory[7:0]};
    assign lhu={ 16'b0,data_memory[15:0]};

     always @(*) begin
        case (dm_select)
            3'b000: block_output = lb; // Select lb
            3'b001: block_output = lh; // Select lh
            3'b010: block_output = lw; // Select lw
            3'b100: block_output = lbu; // Select lbu
            3'b101: block_output = lhu; // Select lhu
            default: block_output = 32'b0; // default case
        endcase
    end


endmodule

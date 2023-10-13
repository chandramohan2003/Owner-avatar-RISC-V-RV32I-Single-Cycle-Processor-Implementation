module ALU (
    output reg [31:0] alu_out,
    input [31:0] in1,
    input [31:0] in2,
    input wire [3:0] alu_control
);

always @(*) begin
    case (alu_control)
        4'b0000: alu_out = $signed(in1)+$signed(in2); // add
        4'b1000: alu_out = $signed(in1)-$signed(in2);  //sub
        4'b0100: alu_out = $signed(in1)^$signed(in2); // XOR
        4'b0110: alu_out = $signed(in1)|$signed(in2); // or
        4'b0111: alu_out = $signed(in1)&$signed(in2); // and
        4'b0001: alu_out = $signed(in1)<<$signed(in2); // shift left logical
        4'b0101: alu_out = $signed(in1)>>$signed(in2); // shift right logical
        4'b1101: alu_out = $signed(in1)>>>$signed(in2); // shift right arthamatic
        4'b0010: alu_out = ($signed(in1)<$signed(in2))?1:0; // set less than
        4'b0011: alu_out =     (in1)<(in2)?1:0; // shift less then U


        default: alu_out = 32'hxxxxxxxx;
    endcase
end

    
endmodule
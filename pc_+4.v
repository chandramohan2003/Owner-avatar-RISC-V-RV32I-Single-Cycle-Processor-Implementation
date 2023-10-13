module PC_next_add (
    output [31:0] pc_next,
    input [31:0] current_addr
);

    assign pc_next = current_addr+32'd4;
    
endmodule 
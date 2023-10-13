module control_unit(
    input [31:0] instr,         // Input instruction
    input branch_taken,         // Signal indicating a branch is taken
    output [3:0] alu_control,// ALU control signals
    output reg [1:0] store_sel, // Store select signals
    output reg [2:0] dm_sel,    // Data memory select signals
    output reg [2:0] imm_sel,   // Immediate select signals
    output reg [2:0] br_sel,   // for branch select signals
    output reg_write,       // Register write control
    output reg dm_write,        // Data memory write control
    output reg [2:0] wd_src,    // Write data source select
    output reg A_sel,           // A source select
    output reg B_sel,           // B source select
    output reg [1:0] pc_src,    // PC source select
    output [4:0] rd,            // Destination register address
    output [4:0] rs1,           // Source register 1 address
    output [4:0] rs2,
    output reg hlt            // Source register 2 address
);

    wire [6:0] funct7;
    wire [6:0] opcode;
    wire [2:0] funct3;
  
    
    // Extract opcode, funct7, rs2, rs1, funct3, and rd from the instruction
    assign opcode = instr[6:0];
    assign funct7 = instr[31:25];
    assign rs2 = instr[24:20];
    assign rs1 = instr[19:15];
    assign funct3 = instr[14:12];
    assign rd = instr[11:7];
    
    wire isALUreg, isALUimm, isBranch, isJALR, isJAL, isAUIPC, isLUI, isLoad, isStore, isSYSTEM;
    
    // Instruction decode based on opcode
    assign isALUreg = (opcode == 7'b0110011); // rd <- rs1 OP rs2
    assign isALUimm = (opcode == 7'b0010011); // rd <- rs1 OP Iimm
    assign isBranch = (opcode == 7'b1100011); // if (rs1 OP rs2) PC <- PC + Bimm
    assign isJALR   = (opcode == 7'b1100111);   // rd <- PC + 4; PC <- rs1 + Iimm
    assign isJAL    = (opcode == 7'b1101111);    // rd <- PC + 4; PC <- PC + Jimm
    assign isAUIPC  = (opcode == 7'b0010111);  // rd <- PC + Uimm
    assign isLUI    = (opcode == 7'b0110111);    // rd <- Uimm
    assign isLoad   = (opcode == 7'b0000011);   // rd <- mem[rs1 + Iimm]
    assign isStore  = (opcode == 7'b0100011);  // mem[rs1 + Simm] <- rs2
    assign isSYSTEM = (opcode == 7'b1110011); // special
    
    // Determine if a register write is needed
    assign reg_write = isALUreg || isALUimm || isLoad || isLUI || isAUIPC || isJAL || isJALR;
    
    // Select ALU operation based on ALU control signals
    assign alu_control =(isALUreg)? {funct7[5], funct3}:{1'b0, funct3};
    
    

    // Branch select signals based on funct3

    always @(*) begin
       
        if (isBranch) begin
            case (funct3)
                3'b000: br_sel = 3'b000; // beq
                3'b001: br_sel = 3'b001; // bne
                3'b100: br_sel = 3'b100; // blt
                3'b101: br_sel = 3'b101; // bge
                3'b110: br_sel = 3'b110; // bltu
                3'b111: br_sel = 3'b111; // bgeu
                default:br_sel = 3'b010; 
            endcase
        end else if (isJAL || isJALR) begin
            br_sel = 3'b110; // Jump instructions
        end else begin
            br_sel = 3'b010; // Default to not taken
        end
    end

    // Data memory select signals based on funct3 for load instructions
    always @(*) begin
        if (isLoad) begin
            case (funct3)
                3'b000: dm_sel = 3'b000; // lb
                3'b001: dm_sel = 3'b001; // lh
                3'b010: dm_sel = 3'b010; // lw
                3'b100: dm_sel = 3'b100; // lbu
                3'b101: dm_sel = 3'b101; // lhu
                default: dm_sel = 3'b111; // Default to no data memory access
            endcase
        end else begin
            dm_sel = 3'b111; // Default to no data memory access
        end
    end

    // Store select signals based on funct3 for store instructions
    always @(*) begin
        if (isStore) begin
            case (funct3[1:0])
                2'b00: store_sel = 2'b00; // sb
                2'b01: store_sel = 2'b01; // sh
                2'b10: store_sel = 2'b10; // sw
                default: store_sel = 2'b11; // Default to no data memory access
            endcase
        end else begin
            store_sel = 2'b11; // Default to no data memory access
        end
    end

    // Immediate select signals based on instruction type
    always @(*) begin
        if (isALUimm || isLoad) begin
            imm_sel = 3'b000; // I-type and load instructions
        end else if (isBranch) begin
            imm_sel = 3'b010; // B-type instructions
        end else if (isStore) begin
            imm_sel = 3'b001; // S-type instructions
        end else if (isJAL || isJALR) begin
            imm_sel = 3'b100; // J-type instructions
        end else if (isLUI || isAUIPC) begin
            imm_sel = 3'b011; // U-type instructions
        end else begin
            imm_sel = 3'b111; // Default to no immediate value
        end
    end

    // Data memory write control signal for store instructions
    always @(*) begin
        if (isStore) begin
            dm_write = 1'b1;
        end else begin
            dm_write = 1'b0;
        end
    end

    // A and B source select signals
    always @(*) begin
        if (isALUreg) begin
            A_sel = 1'b0; // A source is rs1
            B_sel = 1'b0; // B source is rs2
        end else if (isBranch || isAUIPC || isJAL) begin
            A_sel = 1'b1; // A source is PC
            B_sel = 1'b1; // B source is immediate
        end else if (isJALR || isALUimm || isLoad || isStore) begin
            A_sel = 1'b0; // A source is rs1
            B_sel = 1'b1; // B source is immediate
        end else begin
            A_sel = 1'b0; // Default to rs1 for A source
            B_sel = 1'b0; // Default to rs2 for B source
        end
    end

    // Write data source select signal
    
    always @(*) begin
        if (isALUreg || isALUimm) begin
            wd_src = 3'b000; // ALU result
        end else if (isLoad) begin
            wd_src = 3'b001; // Load data
        end else if (isJAL || isJALR) begin
            wd_src = 3'b010; // PC + 4
        end else if (isLUI) begin
            wd_src = 3'b011; // immediate
        end else if (isAUIPC) begin
            wd_src = 3'b100; // PC + U-type immediate
        end else begin
            wd_src = 3'b111; // Default to no write data source
        end
    end


    always @ (*)
    begin
    if (isJALR)
      pc_src=2'b01;  //load alu_out to to pc
    else if (isJAL || branch_taken)
      pc_src=2'b10;  //load pc+imm to pc
    else 
      pc_src=2'b00;   //pc=pc+4
    end

    always @(*) begin
        if(isSYSTEM)
        hlt = 1'b1;
        else 
            hlt = 1'b0;

    end
endmodule

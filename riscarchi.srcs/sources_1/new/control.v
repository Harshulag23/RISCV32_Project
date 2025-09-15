module control(
input wire [6:0] opcode,
input wire [2:0] funct3,
input wire [6:0] funct7,
output reg alu_src,
output reg mem_to_reg,
output reg reg_write,
output reg mem_read,
output reg mem_write,
output reg branch,
output reg jal,
output reg [3:0] alu_ctrl);

always @(*) begin
// defaults
alu_src = 1'b0;
mem_to_reg = 1'b0;
reg_write = 1'b0;
mem_read = 1'b0;
mem_write = 1'b0;
branch = 1'b0;
jal = 1'b0;
alu_ctrl = 4'b0000;


case (opcode)
7'b0110011: begin // R-type (add, sub, and, or)
alu_src = 1'b0;
mem_to_reg = 1'b0;
reg_write = 1'b1;
mem_read = 1'b0;
mem_write = 1'b0;
branch = 1'b0;
// decode funct3/funct7
if (funct3 == 3'b000) begin
if (funct7 == 7'b0100000) alu_ctrl = 4'b0001; // sub
else alu_ctrl = 4'b0000; // add
end else if (funct3 == 3'b111) alu_ctrl = 4'b0010; // and
else if (funct3 == 3'b110) alu_ctrl = 4'b0011; // or
else alu_ctrl = 4'b0000;
end

7'b0010011: begin // I-type (addi)
alu_src = 1'b1;
mem_to_reg = 1'b1;
reg_write = 1'b1;
mem_read = 1'b1;
alu_ctrl = 4'b0000; // compute address with add
end


7'b0100011: begin // sw
alu_src = 1'b1;
mem_to_reg = 1'b0;
reg_write = 1'b0;
mem_write = 1'b1;
alu_ctrl = 4'b0000; // compute address with add
end


7'b1100011: begin // beq
alu_src = 1'b0;
mem_to_reg = 1'b0;
reg_write = 1'b0;
branch = 1'b1;
alu_ctrl = 4'b0001; // sub to compare
end


7'b1101111: begin // jal
alu_src = 1'b0;
mem_to_reg = 1'b0;
reg_write = 1'b1; // write PC+4 to rd
jal = 1'b1;
end


7'b1100111: begin // jalr
alu_src = 1'b1; // compute target rs1+imm
mem_to_reg = 1'b0;
reg_write = 1'b1;
jal = 1'b1; // treat as jump
alu_ctrl = 4'b0000;
end


default: begin
// nop / unsupported
end
endcase
end
endmodule

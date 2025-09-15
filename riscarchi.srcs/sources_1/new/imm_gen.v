module imm_gen(
input wire [31:0] instr,
output reg [31:0] imm_out
);
wire [6:0] opcode = instr[6:0];
always @(*) begin
case (opcode)
7'b0010011: begin // I-type (addi)
imm_out = {{20{instr[31]}}, instr[31:20]};
end
7'b0000011: begin // lw (I-type)
imm_out = {{20{instr[31]}}, instr[31:20]};
end
7'b1100111: begin // jalr (I-type)
imm_out = {{20{instr[31]}}, instr[31:20]};
end
7'b0100011: begin // S-type (sw)
imm_out = {{20{instr[31]}}, instr[31:25], instr[11:7]};
end
7'b1100011: begin // B-type (beq)
// imm = {instr[31], instr[7], instr[30:25], instr[11:8], 1'b0}
imm_out = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
end
7'b1101111: begin // J-type (jal)
// imm = {instr[31], instr[19:12], instr[20], instr[30:21], 1'b0}
imm_out = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
end
7'b0110111: begin // LUI (U-type)
imm_out = {instr[31:12], 12'b0};
end
7'b0010111: begin // AUIPC (U-type)
imm_out = {instr[31:12], 12'b0};
end
default: imm_out = 32'd0;
endcase
end
endmodule
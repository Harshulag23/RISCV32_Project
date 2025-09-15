// ---------------------------------
// File: riscv_core_top.v
// Single-cycle RISC-V (RV32I subset) CPU core
// ---------------------------------
module riscv_core_top(
    input wire clk,
    input wire rst
);
    // Program Counter
    reg [31:0] pc;
    wire [31:0] instr;

    // Instruction Memory
    imem imem_i(.addr(pc), .instr(instr));

    // Instruction fields
    wire [6:0] opcode = instr[6:0];
    wire [4:0] rd     = instr[11:7];
    wire [2:0] funct3 = instr[14:12];
    wire [4:0] rs1    = instr[19:15];
    wire [4:0] rs2    = instr[24:20];
    wire [6:0] funct7 = instr[31:25];

    // Immediate Generator
    wire [31:0] imm;
    imm_gen immgen(.instr(instr), .imm_out(imm));

    // Register File
    wire [31:0] reg_r1, reg_r2;
    reg reg_we;
    reg [4:0] reg_rd;
    reg [31:0] reg_wd;
    regfile regs(
        .clk(clk),
        .we(reg_we),
        .rs1(rs1),
        .rs2(rs2),
        .rd(reg_rd),
        .wd(reg_wd),
        .rd1(reg_r1),
        .rd2(reg_r2)
    );

    // Control Unit
    wire alu_src, mem_to_reg, reg_write, mem_read, mem_write, branch, jal;
    wire [3:0] alu_ctrl;
    control ctrl(
        .opcode(opcode), .funct3(funct3), .funct7(funct7),
        .alu_src(alu_src), .mem_to_reg(mem_to_reg), .reg_write(reg_write),
        .mem_read(mem_read), .mem_write(mem_write),
        .branch(branch), .jal(jal), .alu_ctrl(alu_ctrl)
    );

    // ALU
    reg [31:0] alu_b;
    wire [31:0] alu_result;
    wire alu_zero;
    alu alu_i(.a(reg_r1), .b(alu_b), .ctrl(alu_ctrl), .y(alu_result), .zero(alu_zero));

    // Data Memory
    wire [31:0] dmem_rdata;
    dmem dmem_i(.clk(clk), .we(mem_write), .addr(alu_result), .wdata(reg_r2), .rdata(dmem_rdata));

    // Next PC
    reg [31:0] pc_next;

    // Main control and writeback
    always @(*) begin
        // Defaults
        alu_b   = reg_r2;
        reg_we  = 1'b0;
        reg_rd  = rd;
        reg_wd  = 32'd0;
        pc_next = pc + 4;

        // ALU operand select
        if (alu_src) alu_b = imm;

        // Branch target
        if (branch && alu_zero) begin
            pc_next = pc + imm;
        end

        // Jump target
        if (jal) begin
            pc_next = pc + imm;
        end

        // Write-back data
        if (mem_to_reg) begin
            reg_wd = dmem_rdata;
        end else begin
            if (jal) reg_wd = pc + 4;  // for JAL, write return address
            else reg_wd = alu_result;
        end

        // Register write enable
        if (reg_write) reg_we = 1'b1;
    end

    // PC update
    always @(posedge clk or posedge rst) begin
        if (rst) pc <= 32'd0;
        else pc <= pc_next;
    end

endmodule

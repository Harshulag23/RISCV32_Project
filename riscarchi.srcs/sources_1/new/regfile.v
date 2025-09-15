module regfile(
input wire clk,
input wire we, // write enable
input wire [4:0] rs1,
input wire [4:0] rs2,
input wire [4:0] rd,
input wire [31:0] wd,
output wire [31:0] rd1,
output wire [31:0] rd2
);
reg [31:0] regs [0:31];
integer i;
initial begin
for (i=0;i<32;i=i+1) regs[i] = 32'b0;
end


// reads are asynchronous (combinational)
assign rd1 = (rs1 == 0) ? 32'b0 : regs[rs1];
assign rd2 = (rs2 == 0) ? 32'b0 : regs[rs2];


// write on rising edge
always @(posedge clk) begin
if (we && rd != 5'd0) begin
regs[rd] <= wd;
// optional debug
// $display("RF: write x%0d = %0d (0x%h)", rd, regs[rd], regs[rd]);
end
end
endmodule
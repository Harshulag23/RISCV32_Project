module alu(
input wire [31:0] a,
input wire [31:0] b,
input wire [3:0] ctrl, // 4-bit alu control
output reg [31:0] y,
output wire zero
);
always @(*) begin
case (ctrl)
4'b0000: y = a + b; // add
4'b0001: y = a - b; // sub
4'b0010: y = a & b; // and
4'b0011: y = a | b; // or
4'b0100: y = (a < b) ? 32'd1 : 32'd0; // slt (unsigned not implemented)
default: y = 32'd0;
endcase
end


assign zero = (y == 32'd0);
endmodule
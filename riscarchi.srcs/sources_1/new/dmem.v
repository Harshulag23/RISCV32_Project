module dmem(
input wire clk,
input wire we, // store when 1
input wire [31:0] addr, // byte address
input wire [31:0] wdata,
output reg [31:0] rdata
);
parameter SIZE = 256;
reg [31:0] mem [0:SIZE-1];
wire [31:0] idx = addr >> 2;


// synchronous write
always @(posedge clk) begin
if (we) begin
mem[idx] <= wdata;
// optional debug
// $display("DMEM: write addr=%0d data=%0h", idx, wdata);
end
end


// asynchronous read (simple)
always @(*) begin
rdata = mem[idx];
end
endmodule
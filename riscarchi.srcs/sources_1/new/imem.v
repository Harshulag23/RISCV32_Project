module imem(
input wire [31:0] addr, // byte address
output wire [31:0] instr
);
parameter SIZE = 256; // number of 32-bit words
reg [31:0] mem [0:SIZE-1];
wire [31:0] idx = addr >> 2;


initial begin
// Default program file name. Create program.mem next to your sources
// Format: one 32-bit hex word per line (e.g. 00500093)
$display("IMEM: Loading program.mem (make sure the file exists in simulation directory)");
$readmemh("program.mem", mem);
end


assign instr = mem[idx];
endmodule
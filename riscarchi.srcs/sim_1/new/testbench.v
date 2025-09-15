module tb_riscv;
reg clk;
reg rst;


riscv_core_top dut(.clk(clk), .rst(rst));


initial begin
//$dumpfile("wave.vcd");
//$dumpvars(0, tb_riscv);


clk = 0;
rst = 1;
#20;
rst = 0;


// run for a while
#1000;
$display("Simulation finished");
$finish;
end


always #5 clk = ~clk; // 100MHz-ish clock in simulation time units
endmodule
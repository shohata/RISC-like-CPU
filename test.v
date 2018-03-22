`timescale 1ps/1ps

module test;
  reg         clk;
  reg         rst_n;
  reg  [4:0]  pb;
  wire [11:0] led;

  /* top */
  top top_inst
  (
    .clk   (clk),
    .rst_n (rst_n),
    .pb    (pb),
    .led   (led)
  );

	always #5 clk = ~clk;

	initial begin
		$dumpfile("top_test.vcd");
		$dumpvars(0, top_inst);
		$dumplimit(10000000);
		$monitor($stime, "clk:%b rst:%b pb:%b led:%b", clk, rst_n, pb, led);
		rst_n <= 0;
		clk <= 0;
    pb <= 0;
#150
		rst_n <= 1;
#1000
		$finish;
	end

endmodule

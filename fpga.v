`timescale 1ps/1ps

module fpga
(
  input  wire        clk,
  input  wire        rst_n,
  input  wire [4:0]  pb,
  output wire [11:0] led
);

  wire clk_out;
  wire rst_n_out;
  wire locked;

  /* clock wizard */
  clk_wiz clk_wiz_inst
  (
    .clkin1  (clk),
    .clkout1 (clk_out),
    .resetn  (rst_n),
    .locked  (locked)
  );

  /* synqhronous reset */
  synqrst synqrst_inst
  (
    .clk         (clk_out),
    .asynq_rst_n (locked),
    .synq_rst_n  (rst_n_out)
  );

  /* top */
  top top_inst
  (
    .clk   (clk_out),
    .rst_n (rst_n_out),
    .pb    (pb),
    .led   (led)
  );

endmodule

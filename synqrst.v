`timescale 1ps/1ps

module synqrst
(
  input  wire clk,
  input  wire asynq_rst_n,
  output wire synq_rst_n
);
  reg [2:0] synq = 3'b000;

  always @(posedge clk) begin
    synq[2] <= synq[1];
    synq[1] <= synq[0];
    synq[0] <= asynq_rst_n;
  end
  assign synq_rst_n = synq[2];

endmodule

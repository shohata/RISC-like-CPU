`timescale 1ps/1ps

module pc
(
  input  wire       clk,
  input  wire       rst_n,
  input  wire [7:0] pc_in,
  output reg  [7:0] pc_out
);

  always @(posedge clk) begin
    if(!rst_n) begin
      pc_out <= 0;
    end else begin
      pc_out <= pc_in;
    end
  end

endmodule

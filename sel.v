`timescale 1ps/1ps

module sel
(
  input  wire       sel,
  input  wire [7:0] in0,
  input  wire [7:0] in1,
  output reg  [7:0] out
);

  always @(*) begin
    if (!sel) begin
      out = in0;
    end else begin
      out = in1;
    end
  end

endmodule

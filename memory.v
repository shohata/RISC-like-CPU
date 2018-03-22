`timescale 1ps/1ps

module memory
(
  input  wire       clk,
  input  wire       rst_n,
  input  wire       we,
  input  wire [7:0] in,
  input  wire [7:0] addr,
  output wire [7:0] out
);

  integer i;
  reg [7:0] mem [255:0];

  always @(posedge clk) begin
    if (!rst_n) begin
      for(i = 0; i <= 256; i = i + 1) begin
        mem[i] <= 8'h0;
      end
    end else begin
      if (we) begin
        mem[addr] <= in;
      end else begin
        mem[addr] <= mem[addr];
      end
    end
  end

  assign out = mem[addr];

endmodule

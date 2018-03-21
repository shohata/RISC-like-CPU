module adec
(
  input  wire [7:0] addr,
  output reg        mem_io
);

  always @(*) begin
    if (addr == 8'hf4) begin
      mem_io = 1'b1;
    end else begin
      mem_io = 1'b0;
    end
  end

endmodule

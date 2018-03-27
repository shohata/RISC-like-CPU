`timescale 1ps/1ps

module pb
(
  input  wire       clk,
  input  wire       rst_n,
  input  wire [7:0] addr,
  output wire [7:0] out,
  input  wire [4:0] pb
);

  reg [2:0]  debounce [4:0];
  reg [11:0] cnt;
  reg [4:0]  state;

  always @(posedge clk) begin
    if (!rst_n) begin
      debounce[0] <= 3'b0;
      debounce[1] <= 3'b0;
      debounce[2] <= 3'b0;
      debounce[3] <= 3'b0;
      debounce[4] <= 3'b0;
      cnt         <= 12'b0;
      state       <= 5'b0;
    end else begin
      cnt <= cnt + 1;
      if (!cnt) begin
        debounce[0] <= {debounce[0][1:0], pb[0]};
        debounce[1] <= {debounce[1][1:0], pb[1]};
        debounce[2] <= {debounce[2][1:0], pb[2]};
        debounce[3] <= {debounce[3][1:0], pb[3]};
        debounce[4] <= {debounce[4][1:0], pb[4]};
      end
      state[0] <= (|debounce[0] == 1'b0)? 1'b0 :
                  (&debounce[0] == 1'b1)? 1'b1 : state[0];
      state[1] <= (|debounce[1] == 1'b0)? 1'b0 :
                  (&debounce[1] == 1'b1)? 1'b1 : state[1];
      state[2] <= (|debounce[2] == 1'b0)? 1'b0 :
                  (&debounce[2] == 1'b1)? 1'b1 : state[2];
      state[3] <= (|debounce[3] == 1'b0)? 1'b0 :
                  (&debounce[3] == 1'b1)? 1'b1 : state[3];
      state[4] <= (|debounce[4] == 1'b0)? 1'b0 :
                  (&debounce[4] == 1'b1)? 1'b1 : state[4];
    end
  end

  assign out = (addr == 8'hfb)? {3'b0, state} : 8'b0;

endmodule

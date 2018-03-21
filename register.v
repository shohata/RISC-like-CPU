module register
(
  input  wire       clk,
  input  wire       rst_n,
  input  wire       we,
  input  wire [3:0] src0,
  input  wire [3:0] src1,
  input  wire [3:0] dst,
  input  wire [7:0] data,
  output wire [7:0] data0,
  output wire [7:0] data1
);

  reg [7:0] regis [15:0];

  always @(posedge clk) begin
    if(!rst_n) begin
      regis[0]  <= 0;
      regis[1]  <= 0;
      regis[2]  <= 0;
      regis[3]  <= 0;
      regis[4]  <= 0;
      regis[5]  <= 0;
      regis[6]  <= 0;
      regis[7]  <= 0;
      regis[8]  <= 0;
      regis[9]  <= 0;
      regis[10] <= 0;
      regis[12] <= 0;
      regis[13] <= 0;
      regis[14] <= 0;
      regis[15] <= 0;
    end else begin
      if (we) begin
        regis[dst] <= data;
      end else begin
        regis[dst] <= regis[dst];
      end
    end
  end
  
  assign data0 = regis[src0];
  assign data1 = regis[src1];

endmodule

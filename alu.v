`timescale 1ps/1ps

module alu
(
  input  wire [7:0] in0,
  input  wire [7:0] in1,
  input  wire [3:0] op,
  output reg        zf,
  output reg  [7:0] out
);

`include "def.h"

  always @(*) begin
    case (op)
      AND     : out = in0 & in1;
      OR      : out = in0 | in1;
      ADD     : out = in0 + in1;
      SUB     : out = in1 - in0;
      CMP     : out = (in0 == in1);
      ADDI    : out = in0 + in1;
      SUBI    : out = in1 - in0;
      CMPI    : out = (in0 == in1);
      LOAD    : out = in0 + in1;
      STORE   : out = in0 + in1;
      JMP     : out = in0;
      JMPR    : out = in0 + in1;
      JNZ     : out = in0;
      LI      : out = in0;
      default : out = 8'bx;
    endcase
    zf = (out)? 1'b1 : 1'b0;
  end

endmodule

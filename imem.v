module imem
(
  input  wire [7:0]  pc,
  output reg  [15:0] op
);

`include "def.h"

  always @(*) begin
    case (pc)
      0  : op = {LI, 8'd5, 4'h0};           // reg0 = 5;
      1  : op = {LI, 8'd6, 4'h1};           // reg1 = 6;
      2  : op = {ADD, 4'h1, 4'h0, 4'h2};    // reg2 = reg1 + reg0;
      3  : op = {LI, 8'd0, 4'h3};           // reg3 = 0;
      4  : op = {ADDI, 4'h3, 8'd1};         // do { reg3 += 1;
      5  : op = {STORE, 4'h3, 4'h3, 4'd0};  // mem[reg3+0] = reg3;
      6  : op = {CMP, 4'h3, 4'h2, 4'b0};    //
      7  : op = {JNZ, 8'd4, 4'hf};          // } while(reg2 == reg3);
      8  : op = {JMP, 8'd20, 4'he};         // func();
      9  : op = {JMP, 8'd9, 4'hf};          // while(1);

      // func()
      20 : op = {LOAD, 4'h3, 4'd0, 4'h4};   // reg4 = mem[reg3+0];
      21 : op = {CMPI, 8'd11, 4'h4};        //
      22 : op = {JNZ, 8'd25, 4'hf};         // if(!(reg4 == 11)){
      23 : op = {LI, 8'd1, 4'h5};           // reg5 = 1;
      24 : op = {JMP, 8'd26, 4'hf};         // } else {
      25 : op = {LI, 8'd2, 4'h5};           // reg5 = 2; }
      26 : op = {JMPR, 4'he, 4'd0, 4'hf};   // return;
      default: op = 16'bx;
    endcase
  end

endmodule

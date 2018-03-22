`timescale 1ps/1ps

module decoder
(
  input  wire [15:0] op,
  input  wire        zf,
  output reg  [3:0]  alu_op,
  output reg  [3:0]  dst,
  output reg  [3:0]  src0,
  output reg  [3:0]  src1,
  output reg  [7:0]  data,
  output reg         reg_we,
  output reg         mem_we,
  output reg         reg0,
  output reg         reg1,
  output reg         jmp,
  output reg         load,
  output reg         link
);

`include "def.h"

  always @(*) begin
    case (op[15:12])
      /*
      format: {ADD,OR,ADD,SUB} rs1 rs0 rd
      code: rd = rs1 {&,|,+,-} rs0
            pc = pc + 1
      */
      AND, OR, ADD, SUB : begin
        alu_op = op[15:12];
        src1   = op[11:8];
        src0   = op[7:4];
        dst    = op[3:0];
        data   = 8'b0;
        reg_we = 1'b1;
        mem_we = 1'b0;
        reg1   = 1'b1;
        reg0   = 1'b1;
        jmp    = 1'b0;
        load   = 1'b0;
        link   = 1'b0;
      end

      /*
      format: CMP rs1 rs0
      code: zf = (rs1 == rs0)? 1'b1 : 1'b0;
            pc = pc + 1
      */
      CMP : begin
        alu_op = op[15:12];
        src1   = op[11:8];
        src0   = op[7:4];
        dst    = 4'b0;
        data   = 8'b0;
        reg_we = 1'b0;
        mem_we = 1'b0;
        reg1   = 1'b1;
        reg0   = 1'b1;
        jmp    = 1'b0;
        load   = 1'b0;
        link   = 1'b0;
      end

      /*
      format: {ADDI,SUBI} rs1 imm
      code: rs1 = rs1 {+,-} imm
            pc = pc + 1
      */
      ADDI, SUBI : begin
        alu_op = op[15:12];
        src1   = op[11:8];
        src0   = 4'b0;
        dst    = op[11:8];
        data   = op[7:0];
        reg_we = 1'b1;
        mem_we = 1'b0;
        reg1   = 1'b1;
        reg0   = 1'b0;
        jmp    = 1'b0;
        load   = 1'b0;
        link   = 1'b0;
      end

      /*
      format: CMPI rs1 imm
      code: zf = (rs1 == imm)? 1'b1 : 1'b0;
            pc = pc + 1
      */
      CMPI : begin
        alu_op = op[15:12];
        src1   = op[11:8];
        src0   = 4'b0;
        dst    = 4'b0;
        data   = op[7:0];
        reg_we = 1'b0;
        mem_we = 1'b0;
        reg1   = 1'b1;
        reg0   = 1'b0;
        jmp    = 1'b0;
        load   = 1'b0;
        link   = 1'b0;
      end

      /*
      format: LOAD rs1 rd imm
      code: rd = mem[rs1+imm]
            pc = pc + 1
      */
      LOAD : begin
        alu_op = op[15:12];
        src1   = op[11:8];
        src0   = 4'b0;
        dst    = op[3:0];
        data   = {4'b0, op[7:4]};
        reg_we = 1'b1;
        mem_we = 1'b0;
        reg1   = 1'b1;
        reg0   = 1'b0;
        jmp    = 1'b0;
        load   = 1'b1;
        link   = 1'b0;
      end

      /*
      format: STORE rs1 rs0 imm
      code: mem[rs1+imm] = rs0
            pc = pc + 1
      */
      STORE : begin
        alu_op = op[15:12];
        src1   = op[11:8];
        src0   = op[7:4];
        dst    = 4'b0;
        data   = {4'b0, op[3:0]};
        reg_we = 1'b0;
        mem_we = 1'b1;
        reg1   = 1'b1;
        reg0   = 1'b0;
        jmp    = 1'b0;
        load   = 1'b0;
        link   = 1'b0;
      end

      /*
      format: JMP rd imm
      code: rd = pc + 1
            pc = imm
      */
      JMP : begin
        alu_op = op[15:12];
        src1   = 4'b0;
        src0   = 4'b0;
        dst    = op[3:0];
        data   = op[11:4];
        reg_we = 1'b1;
        mem_we = 1'b0;
        reg1   = 1'b0;
        reg0   = 1'b0;
        jmp    = 1'b1;
        load   = 1'b0;
        link   = 1'b1;
      end

      /*
      format: JMPR rs1 rd imm
      code: rd = pc + 1
            pc = rs1 + imm
      */
      JMPR : begin
        alu_op = op[15:12];
        src1   = op[11:8];
        src0   = 4'b0;
        dst    = op[3:0];
        data   = {4'b0, op[7:4]};
        reg_we = 1'b1;
        mem_we = 1'b0;
        reg1   = 1'b1;
        reg0   = 1'b0;
        jmp    = 1'b1;
        load   = 1'b0;
        link   = 1'b1;
      end

      /*
      format: JNZ rd imm
      code: rd = pc + 1
            pc = (zf)? imm : (pc + 1)
      */
      JNZ : begin
        alu_op = op[15:12];
        src1   = 4'b0;
        src0   = 4'b0;
        dst    = op[3:0];
        data   = op[11:4];
        reg_we = 1'b1;
        mem_we = 1'b0;
        reg1   = 1'b0;
        reg0   = 1'b0;
        jmp    = zf;
        load   = 1'b0;
        link   = zf;
      end

      /*
      format: LI rd imm
      code: rd = imm
            pc = pc + 1
      */
      LI : begin
        alu_op = op[15:12];
        src1   = 4'b0;
        src0   = 4'b0;
        dst    = op[3:0];
        data   = op[11:4];
        reg_we = 1'b1;
        mem_we = 1'b0;
        reg1   = 1'b1;
        reg0   = 1'b0;
        jmp    = 1'b0;
        load   = 1'b0;
        link   = 1'b0;
      end

      default : begin
        alu_op = 4'bx;
        src1   = 4'bx;
        src0   = 4'bx;
        dst    = 4'bx;
        data   = 8'bx;
        reg_we = 1'bx;
        mem_we = 1'bx;
        reg1   = 1'bx;
        reg0   = 1'bx;
        jmp    = 1'bx;
        load   = 1'bx;
        link   = 1'bx;
      end
    endcase
  end

endmodule

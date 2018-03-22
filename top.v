`timescale 1ps/1ps

module top
(
  input  wire        clk,
  input  wire        rst_n,
  input  wire [4:0]  pb,
  output wire [11:0] led
);

  /* write enable */
  wire reg_we;
  wire mem_we;

  /* pc */
  wire [7:0]  pc_in;
  wire [7:0]  pc_out;
  wire [7:0]  pc_next;

  /* imem */
  wire [15:0] op;

  /* decoder */
  wire [3:0] dst;
  wire [3:0] src0;
  wire [3:0] src1;
  wire [7:0] dec_data;

  /* alu */
  wire [7:0] alu_in0;
  wire [7:0] alu_in1;
  wire [3:0] alu_op;
  wire [7:0] alu_out;

  /* zf */
  wire zf;
  wire zf_out;

  /* selector */
  wire reg0;
  wire reg1;
  wire jmp;
  wire load;
  wire link;
  wire mem_io;

  /* register */
  wire [7:0] reg_in;
  wire [7:0] reg_data;
  wire [7:0] reg_data0;
  wire [7:0] reg_data1;

  /* memory */
  wire [7:0] mem_out;
  wire [7:0] pb_out;
  wire [7:0] mem_io_out;

  /* selector */
  sel sel_reg0
  (
    .sel (reg0),
    .in0 (dec_data),
    .in1 (reg_data0),
    .out (alu_in0)
  );

  sel sel_reg1
  (
    .sel (reg1),
    .in0 (pc_next),
    .in1 (reg_data1),
    .out (alu_in1)
  );

  sel sel_jmp
  (
    .sel (jmp),
    .in0 (pc_next),
    .in1 (alu_out),
    .out (pc_in)
  );

  sel sel_link
  (
    .sel (link),
    .in0 (reg_in),
    .in1 (pc_next),
    .out (reg_data)
  );

  sel sel_load
  (
    .sel (load),
    .in0 (alu_out),
    .in1 (mem_io_out),
    .out (reg_in)
  );

  sel sel_mem
  (
    .sel (mem_io),
    .in0 (mem_out),
    .in1 (pb_out),
    .out (mem_io_out)
  );
  
  /* address decoder */
  adec adec_inst
  (
    .addr   (alu_out),
    .mem_io (mem_io)
  );

  /* register */
  register register_inst
  (
    .clk   (clk),
    .rst_n (rst_n),
    .we    (reg_we),
    .src0  (src0),
    .src1  (src1),
    .dst   (dst),
    .data  (reg_data),
    .data0 (reg_data0),
    .data1 (reg_data1)
  );

  /* arithmetic logic unit */
  alu alu_inst
  (
    .in0 (alu_in0),
    .in1 (alu_in1),
    .op  (alu_op),
    .zf  (zf),
    .out (alu_out)
  );

  /* memory */
  memory memory_inst
  (
    .clk   (clk),
    .rst_n (rst_n),
    .we    (mem_we),
    .in    (reg_data0),
    .addr  (alu_out),
    .out   (mem_out)
  );

  /* push button */
  pb pb_inst
  (
    .clk   (clk),
    .rst_n (rst_n),
    .addr  (alu_out),
    .out   (pb_out),
    .pb    (pb)
  );

  /* led */
  led led_inst
  (
    .clk   (clk),
    .rst_n (rst_n),
    .we    (mem_we),
    .in    (reg_data0),
    .addr  (alu_out),
    .led   (led)
  );

  /* program counter */
  pc pc_inst
  (
    .clk    (clk),
    .rst_n  (rst_n),
    .pc_in  (pc_in),
    .pc_out (pc_out)
  );
  assign pc_next = pc_out + 1;

  /* instruction memory */
  imem imem_inst
  (
    .pc (pc_out),
    .op (op)
  );

  /* zero flag */
  zf zf_inst (
    .clk(clk),
    .rst_n(rst_n),
    .zf_in(zf),
    .zf_out(zf_out)
  );

  /* decoder */
  decoder decoder_inst
  (
    .op     (op),
    .zf     (zf_out),
    .alu_op (alu_op),
    .dst    (dst),
    .src0   (src0),
    .src1   (src1),
    .data   (dec_data),
    .reg_we (reg_we),
    .mem_we (mem_we),
    .reg0   (reg0),
    .reg1   (reg1),
    .jmp    (jmp),
    .load   (load),
    .link   (link)
  );

endmodule

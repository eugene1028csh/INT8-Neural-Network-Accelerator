module mac
  (input  clk,
   input  reset,
   input  enable,
   input  [7:0] a,
   input  [7:0] b,
   output [31:0] result);
  wire [31:0] accumulator;
  wire [15:0] n724_o;
  wire [15:0] n725_o;
  wire [15:0] n726_o;
  wire [31:0] n727_o;
  wire [31:0] n728_o;
  wire [31:0] n729_o;
  wire [31:0] n731_o;
  reg [31:0] n734_q;
  assign result = accumulator;
  /* src/mac.vhd:20:10  */
  assign accumulator = n734_q; // (signal)
  /* src/mac.vhd:29:46  */
  assign n724_o = {{8{a[7]}}, a}; // sext
  /* src/mac.vhd:29:46  */
  assign n725_o = {{8{b[7]}}, b}; // sext
  /* src/mac.vhd:29:46  */
  assign n726_o = n724_o * n725_o; // smul
  /* src/mac.vhd:29:38  */
  assign n727_o = {{16{n726_o[15]}}, n726_o}; // sext
  /* src/mac.vhd:29:36  */
  assign n728_o = accumulator + n727_o;
  /* src/mac.vhd:28:7  */
  assign n729_o = enable ? n728_o : accumulator;
  /* src/mac.vhd:26:7  */
  assign n731_o = reset ? 32'b00000000000000000000000000000000 : n729_o;
  /* src/mac.vhd:25:5  */
  always @(posedge clk)
    n734_q <= n731_o;
endmodule

module pe
  (input  clk,
   input  reset,
   input  enable,
   input  [7:0] a_in,
   input  [7:0] b_in,
   output [7:0] a_out,
   output [7:0] b_out,
   output [31:0] result);
  wire [7:0] a_reg;
  wire [7:0] b_reg;
  wire [7:0] n708_o;
  wire [7:0] n709_o;
  wire [7:0] n711_o;
  wire [7:0] n713_o;
  wire [31:0] mac_unit_result;
  reg [7:0] n718_q;
  reg [7:0] n719_q;
  assign a_out = a_reg;
  assign b_out = b_reg;
  assign result = mac_unit_result;
  /* src/pe.vhd:22:10  */
  assign a_reg = n718_q; // (signal)
  /* src/pe.vhd:23:10  */
  assign b_reg = n719_q; // (signal)
  /* src/pe.vhd:31:7  */
  assign n708_o = enable ? a_in : a_reg;
  /* src/pe.vhd:31:7  */
  assign n709_o = enable ? b_in : b_reg;
  /* src/pe.vhd:28:7  */
  assign n711_o = reset ? 8'b00000000 : n708_o;
  /* src/pe.vhd:28:7  */
  assign n713_o = reset ? 8'b00000000 : n709_o;
  /* src/pe.vhd:40:3  */
  mac mac_unit (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .a(a_in),
    .b(b_in),
    .result(mac_unit_result));
  /* src/pe.vhd:27:5  */
  always @(posedge clk)
    n718_q <= n711_o;
  /* src/pe.vhd:27:5  */
  always @(posedge clk)
    n719_q <= n713_o;
endmodule

module pe_array_4x4
  (input  clk,
   input  reset,
   input  enable,
   input  [7:0] a_row0_in,
   input  [7:0] a_row1_in,
   input  [7:0] a_row2_in,
   input  [7:0] a_row3_in,
   input  [7:0] b_col0_in,
   input  [7:0] b_col1_in,
   input  [7:0] b_col2_in,
   input  [7:0] b_col3_in,
   output [7:0] a_row0_out,
   output [7:0] a_row1_out,
   output [7:0] a_row2_out,
   output [7:0] a_row3_out,
   output [7:0] b_col0_out,
   output [7:0] b_col1_out,
   output [7:0] b_col2_out,
   output [7:0] b_col3_out,
   output [31:0] result00,
   output [31:0] result01,
   output [31:0] result10,
   output [31:0] result11,
   output [31:0] result02,
   output [31:0] result03,
   output [31:0] result12,
   output [31:0] result13,
   output [31:0] result20,
   output [31:0] result21,
   output [31:0] result30,
   output [31:0] result31,
   output [31:0] result22,
   output [31:0] result23,
   output [31:0] result32,
   output [31:0] result33);
  wire [7:0] a_00_01;
  wire [7:0] a_01_02;
  wire [7:0] a_02_03;
  wire [7:0] a_10_11;
  wire [7:0] a_11_12;
  wire [7:0] a_12_13;
  wire [7:0] a_20_21;
  wire [7:0] a_21_22;
  wire [7:0] a_22_23;
  wire [7:0] a_30_31;
  wire [7:0] a_31_32;
  wire [7:0] a_32_33;
  wire [7:0] b_00_10;
  wire [7:0] b_10_20;
  wire [7:0] b_20_30;
  wire [7:0] b_01_11;
  wire [7:0] b_11_21;
  wire [7:0] b_21_31;
  wire [7:0] b_02_12;
  wire [7:0] b_12_22;
  wire [7:0] b_22_32;
  wire [7:0] b_03_13;
  wire [7:0] b_13_23;
  wire [7:0] b_23_33;
  wire [7:0] pe00_a_out;
  wire [7:0] pe00_b_out;
  wire [31:0] pe00_result;
  wire [7:0] pe01_a_out;
  wire [7:0] pe01_b_out;
  wire [31:0] pe01_result;
  wire [7:0] pe02_a_out;
  wire [7:0] pe02_b_out;
  wire [31:0] pe02_result;
  wire [7:0] pe03_a_out;
  wire [7:0] pe03_b_out;
  wire [31:0] pe03_result;
  wire [7:0] pe10_a_out;
  wire [7:0] pe10_b_out;
  wire [31:0] pe10_result;
  wire [7:0] pe11_a_out;
  wire [7:0] pe11_b_out;
  wire [31:0] pe11_result;
  wire [7:0] pe12_a_out;
  wire [7:0] pe12_b_out;
  wire [31:0] pe12_result;
  wire [7:0] pe13_a_out;
  wire [7:0] pe13_b_out;
  wire [31:0] pe13_result;
  wire [7:0] pe20_a_out;
  wire [7:0] pe20_b_out;
  wire [31:0] pe20_result;
  wire [7:0] pe21_a_out;
  wire [7:0] pe21_b_out;
  wire [31:0] pe21_result;
  wire [7:0] pe22_a_out;
  wire [7:0] pe22_b_out;
  wire [31:0] pe22_result;
  wire [7:0] pe23_a_out;
  wire [7:0] pe23_b_out;
  wire [31:0] pe23_result;
  wire [7:0] pe30_a_out;
  wire [7:0] pe30_b_out;
  wire [31:0] pe30_result;
  wire [7:0] pe31_a_out;
  wire [7:0] pe31_b_out;
  wire [31:0] pe31_result;
  wire [7:0] pe32_a_out;
  wire [7:0] pe32_b_out;
  wire [31:0] pe32_result;
  wire [7:0] pe33_a_out;
  wire [7:0] pe33_b_out;
  wire [31:0] pe33_result;
  assign a_row0_out = pe03_a_out;
  assign a_row1_out = pe13_a_out;
  assign a_row2_out = pe23_a_out;
  assign a_row3_out = pe33_a_out;
  assign b_col0_out = pe30_b_out;
  assign b_col1_out = pe31_b_out;
  assign b_col2_out = pe32_b_out;
  assign b_col3_out = pe33_b_out;
  assign result00 = pe00_result;
  assign result01 = pe01_result;
  assign result10 = pe10_result;
  assign result11 = pe11_result;
  assign result02 = pe02_result;
  assign result03 = pe03_result;
  assign result12 = pe12_result;
  assign result13 = pe13_result;
  assign result20 = pe20_result;
  assign result21 = pe21_result;
  assign result30 = pe30_result;
  assign result31 = pe31_result;
  assign result22 = pe22_result;
  assign result23 = pe23_result;
  assign result32 = pe32_result;
  assign result33 = pe33_result;
  /* src/pe_array_4x4.vhd:52:8  */
  assign a_00_01 = pe00_a_out; // (signal)
  /* src/pe_array_4x4.vhd:52:17  */
  assign a_01_02 = pe01_a_out; // (signal)
  /* src/pe_array_4x4.vhd:52:26  */
  assign a_02_03 = pe02_a_out; // (signal)
  /* src/pe_array_4x4.vhd:53:8  */
  assign a_10_11 = pe10_a_out; // (signal)
  /* src/pe_array_4x4.vhd:53:17  */
  assign a_11_12 = pe11_a_out; // (signal)
  /* src/pe_array_4x4.vhd:53:26  */
  assign a_12_13 = pe12_a_out; // (signal)
  /* src/pe_array_4x4.vhd:54:8  */
  assign a_20_21 = pe20_a_out; // (signal)
  /* src/pe_array_4x4.vhd:54:17  */
  assign a_21_22 = pe21_a_out; // (signal)
  /* src/pe_array_4x4.vhd:54:26  */
  assign a_22_23 = pe22_a_out; // (signal)
  /* src/pe_array_4x4.vhd:55:8  */
  assign a_30_31 = pe30_a_out; // (signal)
  /* src/pe_array_4x4.vhd:55:17  */
  assign a_31_32 = pe31_a_out; // (signal)
  /* src/pe_array_4x4.vhd:55:26  */
  assign a_32_33 = pe32_a_out; // (signal)
  /* src/pe_array_4x4.vhd:57:8  */
  assign b_00_10 = pe00_b_out; // (signal)
  /* src/pe_array_4x4.vhd:57:17  */
  assign b_10_20 = pe10_b_out; // (signal)
  /* src/pe_array_4x4.vhd:57:26  */
  assign b_20_30 = pe20_b_out; // (signal)
  /* src/pe_array_4x4.vhd:58:8  */
  assign b_01_11 = pe01_b_out; // (signal)
  /* src/pe_array_4x4.vhd:58:17  */
  assign b_11_21 = pe11_b_out; // (signal)
  /* src/pe_array_4x4.vhd:58:26  */
  assign b_21_31 = pe21_b_out; // (signal)
  /* src/pe_array_4x4.vhd:59:8  */
  assign b_02_12 = pe02_b_out; // (signal)
  /* src/pe_array_4x4.vhd:59:17  */
  assign b_12_22 = pe12_b_out; // (signal)
  /* src/pe_array_4x4.vhd:59:26  */
  assign b_22_32 = pe22_b_out; // (signal)
  /* src/pe_array_4x4.vhd:60:8  */
  assign b_03_13 = pe03_b_out; // (signal)
  /* src/pe_array_4x4.vhd:60:17  */
  assign b_13_23 = pe13_b_out; // (signal)
  /* src/pe_array_4x4.vhd:60:26  */
  assign b_23_33 = pe23_b_out; // (signal)
  /* src/pe_array_4x4.vhd:64:1  */
  pe pe00 (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .a_in(a_row0_in),
    .b_in(b_col0_in),
    .a_out(pe00_a_out),
    .b_out(pe00_b_out),
    .result(pe00_result));
  /* src/pe_array_4x4.vhd:79:1  */
  pe pe01 (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .a_in(a_00_01),
    .b_in(b_col1_in),
    .a_out(pe01_a_out),
    .b_out(pe01_b_out),
    .result(pe01_result));
  /* src/pe_array_4x4.vhd:94:1  */
  pe pe02 (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .a_in(a_01_02),
    .b_in(b_col2_in),
    .a_out(pe02_a_out),
    .b_out(pe02_b_out),
    .result(pe02_result));
  /* src/pe_array_4x4.vhd:109:1  */
  pe pe03 (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .a_in(a_02_03),
    .b_in(b_col3_in),
    .a_out(pe03_a_out),
    .b_out(pe03_b_out),
    .result(pe03_result));
  /* src/pe_array_4x4.vhd:125:1  */
  pe pe10 (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .a_in(a_row1_in),
    .b_in(b_00_10),
    .a_out(pe10_a_out),
    .b_out(pe10_b_out),
    .result(pe10_result));
  /* src/pe_array_4x4.vhd:140:1  */
  pe pe11 (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .a_in(a_10_11),
    .b_in(b_01_11),
    .a_out(pe11_a_out),
    .b_out(pe11_b_out),
    .result(pe11_result));
  /* src/pe_array_4x4.vhd:155:1  */
  pe pe12 (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .a_in(a_11_12),
    .b_in(b_02_12),
    .a_out(pe12_a_out),
    .b_out(pe12_b_out),
    .result(pe12_result));
  /* src/pe_array_4x4.vhd:170:1  */
  pe pe13 (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .a_in(a_12_13),
    .b_in(b_03_13),
    .a_out(pe13_a_out),
    .b_out(pe13_b_out),
    .result(pe13_result));
  /* src/pe_array_4x4.vhd:185:1  */
  pe pe20 (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .a_in(a_row2_in),
    .b_in(b_10_20),
    .a_out(pe20_a_out),
    .b_out(pe20_b_out),
    .result(pe20_result));
  /* src/pe_array_4x4.vhd:200:1  */
  pe pe21 (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .a_in(a_20_21),
    .b_in(b_11_21),
    .a_out(pe21_a_out),
    .b_out(pe21_b_out),
    .result(pe21_result));
  /* src/pe_array_4x4.vhd:215:1  */
  pe pe22 (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .a_in(a_21_22),
    .b_in(b_12_22),
    .a_out(pe22_a_out),
    .b_out(pe22_b_out),
    .result(pe22_result));
  /* src/pe_array_4x4.vhd:230:1  */
  pe pe23 (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .a_in(a_22_23),
    .b_in(b_13_23),
    .a_out(pe23_a_out),
    .b_out(pe23_b_out),
    .result(pe23_result));
  /* src/pe_array_4x4.vhd:245:1  */
  pe pe30 (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .a_in(a_row3_in),
    .b_in(b_20_30),
    .a_out(pe30_a_out),
    .b_out(pe30_b_out),
    .result(pe30_result));
  /* src/pe_array_4x4.vhd:260:1  */
  pe pe31 (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .a_in(a_30_31),
    .b_in(b_21_31),
    .a_out(pe31_a_out),
    .b_out(pe31_b_out),
    .result(pe31_result));
  /* src/pe_array_4x4.vhd:275:1  */
  pe pe32 (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .a_in(a_31_32),
    .b_in(b_22_32),
    .a_out(pe32_a_out),
    .b_out(pe32_b_out),
    .result(pe32_result));
  /* src/pe_array_4x4.vhd:290:1  */
  pe pe33 (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .a_in(a_32_33),
    .b_in(b_23_33),
    .a_out(pe33_a_out),
    .b_out(pe33_b_out),
    .result(pe33_result));
endmodule

module output_buffer_4
  (input  clk,
   input  reset,
   input  capture_en,
   input  [31:0] data0,
   input  [31:0] data1,
   input  [31:0] data2,
   input  [31:0] data3,
   output [31:0] out0,
   output [31:0] out1,
   output [31:0] out2,
   output [31:0] out3);
  wire [127:0] buffer_reg;
  wire [127:0] n619_o;
  wire [127:0] n620_o;
  wire [127:0] n622_o;
  wire [31:0] n625_o;
  wire [31:0] n626_o;
  wire [31:0] n627_o;
  wire [31:0] n628_o;
  reg [127:0] n629_q;
  assign out0 = n625_o;
  assign out1 = n626_o;
  assign out2 = n627_o;
  assign out3 = n628_o;
  /* src/output_buffer_4.vhd:20:10  */
  assign buffer_reg = n629_q; // (signal)
  assign n619_o = {data0, data1, data2, data3};
  /* src/output_buffer_4.vhd:27:7  */
  assign n620_o = capture_en ? n619_o : buffer_reg;
  /* src/output_buffer_4.vhd:25:7  */
  assign n622_o = reset ? 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000 : n620_o;
  /* src/output_buffer_4.vhd:36:21  */
  assign n625_o = buffer_reg[127:96];
  /* src/output_buffer_4.vhd:37:21  */
  assign n626_o = buffer_reg[95:64];
  /* src/output_buffer_4.vhd:38:21  */
  assign n627_o = buffer_reg[63:32];
  /* src/output_buffer_4.vhd:39:21  */
  assign n628_o = buffer_reg[31:0];
  /* src/output_buffer_4.vhd:24:5  */
  always @(posedge clk)
    n629_q <= n622_o;
endmodule

module relu_2
  (input  [31:0] data0,
   input  [31:0] data1,
   output [31:0] out0,
   output [31:0] out1);
  wire n607_o;
  wire [31:0] n608_o;
  wire n610_o;
  wire [31:0] n611_o;
  assign out0 = n608_o;
  assign out1 = n611_o;
  /* src/relu_2.vhd:14:37  */
  assign n607_o = data0[31];
  /* src/relu_2.vhd:14:27  */
  assign n608_o = n607_o ? 32'b00000000000000000000000000000000 : data0;
  /* src/relu_2.vhd:16:37  */
  assign n610_o = data1[31];
  /* src/relu_2.vhd:16:27  */
  assign n611_o = n610_o ? 32'b00000000000000000000000000000000 : data1;
endmodule

module bias_add_2
  (input  [31:0] data0,
   input  [31:0] data1,
   input  [31:0] bias0,
   input  [31:0] bias1,
   output [31:0] out0,
   output [31:0] out1);
  wire [31:0] n602_o;
  wire [31:0] n603_o;
  assign out0 = n602_o;
  assign out1 = n603_o;
  /* src/bias_add_2.vhd:21:17  */
  assign n602_o = data0 + bias0;
  /* src/bias_add_2.vhd:22:17  */
  assign n603_o = data1 + bias1;
endmodule

module matvec_engine_4x4
  (input  clk,
   input  reset,
   input  start,
   input  [7:0] w00,
   input  [7:0] w01,
   input  [7:0] w02,
   input  [7:0] w03,
   input  [7:0] w10,
   input  [7:0] w11,
   input  [7:0] w12,
   input  [7:0] w13,
   input  [7:0] w20,
   input  [7:0] w21,
   input  [7:0] w22,
   input  [7:0] w23,
   input  [7:0] w30,
   input  [7:0] w31,
   input  [7:0] w32,
   input  [7:0] w33,
   input  [7:0] x0,
   input  [7:0] x1,
   input  [7:0] x2,
   input  [7:0] x3,
   output [31:0] y0,
   output [31:0] y1,
   output [31:0] y2,
   output [31:0] y3,
   output done);
  wire [127:0] w_reg;
  wire [31:0] x_reg;
  reg [1:0] current_state;
  reg [1:0] next_state;
  reg [2:0] cycle_count;
  wire [31:0] array_a_in;
  wire [31:0] array_b_in;
  wire array_reset;
  wire array_enable;
  wire n352_o;
  wire n353_o;
  wire [31:0] n354_o;
  wire [31:0] n355_o;
  wire [31:0] n356_o;
  wire [31:0] n357_o;
  wire [127:0] n358_o;
  wire [31:0] n359_o;
  wire [127:0] n360_o;
  wire [31:0] n361_o;
  wire [127:0] n363_o;
  wire [31:0] n365_o;
  wire [7:0] array_inst_a_row0_out;
  wire [7:0] array_inst_a_row1_out;
  wire [7:0] array_inst_a_row2_out;
  wire [7:0] array_inst_a_row3_out;
  wire [7:0] array_inst_b_col0_out;
  wire [7:0] array_inst_b_col1_out;
  wire [7:0] array_inst_b_col2_out;
  wire [7:0] array_inst_b_col3_out;
  wire [31:0] array_inst_result00;
  wire [31:0] array_inst_result01;
  wire [31:0] array_inst_result10;
  wire [31:0] array_inst_result11;
  wire [31:0] array_inst_result02;
  wire [31:0] array_inst_result03;
  wire [31:0] array_inst_result12;
  wire [31:0] array_inst_result13;
  wire [31:0] array_inst_result20;
  wire [31:0] array_inst_result21;
  wire [31:0] array_inst_result30;
  wire [31:0] array_inst_result31;
  wire [31:0] array_inst_result22;
  wire [31:0] array_inst_result23;
  wire [31:0] array_inst_result32;
  wire [31:0] array_inst_result33;
  wire [7:0] n369_o;
  wire [7:0] n370_o;
  wire [7:0] n371_o;
  wire [7:0] n372_o;
  wire [7:0] n373_o;
  wire [7:0] n374_o;
  wire [7:0] n375_o;
  wire [7:0] n376_o;
  wire n385_o;
  wire n387_o;
  wire [31:0] n388_o;
  wire n390_o;
  wire [31:0] n391_o;
  wire [31:0] n393_o;
  wire [2:0] n394_o;
  wire [2:0] n395_o;
  wire [2:0] n397_o;
  wire [2:0] n399_o;
  wire [1:0] n401_o;
  wire [2:0] n403_o;
  wire [1:0] n410_o;
  wire n412_o;
  wire n414_o;
  wire [31:0] n415_o;
  wire n417_o;
  wire [1:0] n419_o;
  wire n421_o;
  wire n423_o;
  wire [3:0] n424_o;
  reg [1:0] n428_o;
  wire n434_o;
  wire n436_o;
  wire [31:0] n437_o;
  wire [31:0] n439_o;
  wire [31:0] n441_o;
  wire n443_o;
  wire n445_o;
  wire n446_o;
  wire [1:0] n447_o;
  wire [1:0] n449_o;
  wire [7:0] n453_o;
  wire [31:0] n454_o;
  wire [31:0] n456_o;
  wire [31:0] n458_o;
  wire n460_o;
  wire n462_o;
  wire n463_o;
  wire [1:0] n464_o;
  wire [1:0] n466_o;
  wire [7:0] n470_o;
  wire [31:0] n471_o;
  wire [31:0] n473_o;
  wire [31:0] n475_o;
  wire n477_o;
  wire n479_o;
  wire n480_o;
  wire [1:0] n481_o;
  wire [1:0] n483_o;
  wire [7:0] n487_o;
  wire [31:0] n488_o;
  wire [31:0] n490_o;
  wire [31:0] n492_o;
  wire n494_o;
  wire n496_o;
  wire n497_o;
  wire [1:0] n498_o;
  wire [1:0] n500_o;
  wire [7:0] n504_o;
  wire [31:0] n505_o;
  wire n507_o;
  wire [31:0] n508_o;
  wire n510_o;
  wire n511_o;
  wire [31:0] n512_o;
  wire [31:0] n514_o;
  wire [1:0] n515_o;
  wire [1:0] n517_o;
  wire [7:0] n521_o;
  wire n523_o;
  wire n525_o;
  wire [3:0] n526_o;
  reg n530_o;
  reg [7:0] n534_o;
  reg [7:0] n537_o;
  reg [7:0] n540_o;
  reg [7:0] n543_o;
  reg [7:0] n550_o;
  localparam [31:0] n551_o = 32'b00000000000000000000000000000000;
  wire [23:0] n552_o;
  reg n555_o;
  reg n559_o;
  reg [127:0] n564_q;
  reg [31:0] n565_q;
  reg [1:0] n566_q;
  reg [2:0] n567_q;
  wire [31:0] n568_o;
  wire [31:0] n569_o;
  wire [7:0] n570_o;
  wire [7:0] n571_o;
  wire [7:0] n572_o;
  wire [7:0] n573_o;
  wire [1:0] n574_o;
  reg [7:0] n575_o;
  wire [7:0] n576_o;
  wire [7:0] n577_o;
  wire [7:0] n578_o;
  wire [7:0] n579_o;
  wire [1:0] n580_o;
  reg [7:0] n581_o;
  wire [7:0] n582_o;
  wire [7:0] n583_o;
  wire [7:0] n584_o;
  wire [7:0] n585_o;
  wire [1:0] n586_o;
  reg [7:0] n587_o;
  wire [7:0] n588_o;
  wire [7:0] n589_o;
  wire [7:0] n590_o;
  wire [7:0] n591_o;
  wire [1:0] n592_o;
  reg [7:0] n593_o;
  wire [7:0] n594_o;
  wire [7:0] n595_o;
  wire [7:0] n596_o;
  wire [7:0] n597_o;
  wire [1:0] n598_o;
  reg [7:0] n599_o;
  assign y0 = array_inst_result00;
  assign y1 = array_inst_result10;
  assign y2 = array_inst_result20;
  assign y3 = array_inst_result30;
  assign done = n530_o;
  /* src/matvec_engine_4x4.vhd:28:10  */
  assign w_reg = n564_q; // (signal)
  /* src/matvec_engine_4x4.vhd:29:10  */
  assign x_reg = n565_q; // (signal)
  /* src/matvec_engine_4x4.vhd:33:10  */
  always @*
    current_state = n566_q; // (isignal)
  initial
    current_state = 2'b00;
  /* src/matvec_engine_4x4.vhd:34:10  */
  always @*
    next_state = n428_o; // (isignal)
  initial
    next_state = 2'b00;
  /* src/matvec_engine_4x4.vhd:36:10  */
  always @*
    cycle_count = n567_q; // (isignal)
  initial
    cycle_count = 3'b000;
  /* src/matvec_engine_4x4.vhd:38:10  */
  assign array_a_in = n568_o; // (signal)
  /* src/matvec_engine_4x4.vhd:39:10  */
  assign array_b_in = n569_o; // (signal)
  /* src/matvec_engine_4x4.vhd:41:10  */
  assign array_reset = n555_o; // (signal)
  /* src/matvec_engine_4x4.vhd:42:10  */
  assign array_enable = n559_o; // (signal)
  /* src/matvec_engine_4x4.vhd:52:43  */
  assign n352_o = current_state == 2'b00;
  /* src/matvec_engine_4x4.vhd:52:25  */
  assign n353_o = n352_o & start;
  assign n354_o = {w00, w01, w02, w03};
  assign n355_o = {w10, w11, w12, w13};
  assign n356_o = {w20, w21, w22, w23};
  assign n357_o = {w30, w31, w32, w33};
  assign n358_o = {n354_o, n355_o, n356_o, n357_o};
  assign n359_o = {x0, x1, x2, x3};
  /* src/matvec_engine_4x4.vhd:52:7  */
  assign n360_o = n353_o ? n358_o : w_reg;
  /* src/matvec_engine_4x4.vhd:52:7  */
  assign n361_o = n353_o ? n359_o : x_reg;
  /* src/matvec_engine_4x4.vhd:47:7  */
  assign n363_o = reset ? 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000 : n360_o;
  /* src/matvec_engine_4x4.vhd:47:7  */
  assign n365_o = reset ? 32'b00000000000000000000000000000000 : n361_o;
  /* src/matvec_engine_4x4.vhd:67:3  */
  pe_array_4x4 array_inst (
    .clk(clk),
    .reset(array_reset),
    .enable(array_enable),
    .a_row0_in(n369_o),
    .a_row1_in(n370_o),
    .a_row2_in(n371_o),
    .a_row3_in(n372_o),
    .b_col0_in(n373_o),
    .b_col1_in(n374_o),
    .b_col2_in(n375_o),
    .b_col3_in(n376_o),
    .a_row0_out(),
    .a_row1_out(),
    .a_row2_out(),
    .a_row3_out(),
    .b_col0_out(),
    .b_col1_out(),
    .b_col2_out(),
    .b_col3_out(),
    .result00(array_inst_result00),
    .result01(),
    .result10(array_inst_result10),
    .result11(),
    .result02(),
    .result03(),
    .result12(),
    .result13(),
    .result20(array_inst_result20),
    .result21(),
    .result30(array_inst_result30),
    .result31(),
    .result22(),
    .result23(),
    .result32(),
    .result33());
  /* src/matvec_engine_4x4.vhd:74:30  */
  assign n369_o = array_a_in[31:24];
  /* src/matvec_engine_4x4.vhd:75:30  */
  assign n370_o = array_a_in[23:16];
  /* src/matvec_engine_4x4.vhd:76:30  */
  assign n371_o = array_a_in[15:8];
  /* src/matvec_engine_4x4.vhd:77:30  */
  assign n372_o = array_a_in[7:0];
  /* src/matvec_engine_4x4.vhd:79:30  */
  assign n373_o = array_b_in[31:24];
  /* src/matvec_engine_4x4.vhd:80:30  */
  assign n374_o = array_b_in[23:16];
  /* src/matvec_engine_4x4.vhd:81:30  */
  assign n375_o = array_b_in[15:8];
  /* src/matvec_engine_4x4.vhd:82:30  */
  assign n376_o = array_b_in[7:0];
  /* src/matvec_engine_4x4.vhd:126:26  */
  assign n385_o = current_state == 2'b01;
  /* src/matvec_engine_4x4.vhd:129:29  */
  assign n387_o = current_state == 2'b10;
  /* src/matvec_engine_4x4.vhd:130:26  */
  assign n388_o = {29'b0, cycle_count};  //  uext
  /* src/matvec_engine_4x4.vhd:130:26  */
  assign n390_o = $signed(n388_o) < $signed(32'b00000000000000000000000000000111);
  /* src/matvec_engine_4x4.vhd:131:40  */
  assign n391_o = {29'b0, cycle_count};  //  uext
  /* src/matvec_engine_4x4.vhd:131:40  */
  assign n393_o = n391_o + 32'b00000000000000000000000000000001;
  /* src/matvec_engine_4x4.vhd:131:28  */
  assign n394_o = n393_o[2:0];  // trunc
  /* src/matvec_engine_4x4.vhd:130:11  */
  assign n395_o = n390_o ? n394_o : cycle_count;
  /* src/matvec_engine_4x4.vhd:129:9  */
  assign n397_o = n387_o ? n395_o : 3'b000;
  /* src/matvec_engine_4x4.vhd:126:9  */
  assign n399_o = n385_o ? 3'b001 : n397_o;
  /* src/matvec_engine_4x4.vhd:119:7  */
  assign n401_o = reset ? 2'b00 : next_state;
  /* src/matvec_engine_4x4.vhd:119:7  */
  assign n403_o = reset ? 3'b000 : n399_o;
  /* src/matvec_engine_4x4.vhd:150:9  */
  assign n410_o = start ? 2'b01 : current_state;
  /* src/matvec_engine_4x4.vhd:149:7  */
  assign n412_o = current_state == 2'b00;
  /* src/matvec_engine_4x4.vhd:154:7  */
  assign n414_o = current_state == 2'b01;
  /* src/matvec_engine_4x4.vhd:158:24  */
  assign n415_o = {29'b0, cycle_count};  //  uext
  /* src/matvec_engine_4x4.vhd:158:24  */
  assign n417_o = n415_o == 32'b00000000000000000000000000000111;
  /* src/matvec_engine_4x4.vhd:158:9  */
  assign n419_o = n417_o ? 2'b11 : current_state;
  /* src/matvec_engine_4x4.vhd:157:7  */
  assign n421_o = current_state == 2'b10;
  /* src/matvec_engine_4x4.vhd:162:7  */
  assign n423_o = current_state == 2'b11;
  assign n424_o = {n423_o, n421_o, n414_o, n412_o};
  /* src/matvec_engine_4x4.vhd:147:5  */
  always @*
    case (n424_o)
      4'b1000: n428_o = 2'b00;
      4'b0100: n428_o = n419_o;
      4'b0010: n428_o = 2'b10;
      4'b0001: n428_o = n410_o;
      default: n428_o = 2'bX;
    endcase
  /* src/matvec_engine_4x4.vhd:181:7  */
  assign n434_o = current_state == 2'b00;
  /* src/matvec_engine_4x4.vhd:184:7  */
  assign n436_o = current_state == 2'b01;
  /* src/matvec_engine_4x4.vhd:192:39  */
  assign n437_o = {29'b0, cycle_count};  //  uext
  /* src/matvec_engine_4x4.vhd:192:39  */
  assign n439_o = n437_o - 32'b00000000000000000000000000000001;
  /* src/matvec_engine_4x4.vhd:192:43  */
  assign n441_o = n439_o - 32'b00000000000000000000000000000000;
  /* src/matvec_engine_4x4.vhd:194:27  */
  assign n443_o = $signed(n441_o) >= $signed(32'b00000000000000000000000000000000);
  /* src/matvec_engine_4x4.vhd:194:49  */
  assign n445_o = $signed(n441_o) <= $signed(32'b00000000000000000000000000000011);
  /* src/matvec_engine_4x4.vhd:194:32  */
  assign n446_o = n445_o & n443_o;
  /* src/matvec_engine_4x4.vhd:195:65  */
  assign n447_o = n441_o[1:0];  // trunc
  /* src/matvec_engine_4x4.vhd:195:65  */
  assign n449_o = 2'b11 - n447_o;
  /* src/matvec_engine_4x4.vhd:194:11  */
  assign n453_o = n446_o ? n575_o : 8'b00000000;
  /* src/matvec_engine_4x4.vhd:192:39  */
  assign n454_o = {29'b0, cycle_count};  //  uext
  /* src/matvec_engine_4x4.vhd:192:39  */
  assign n456_o = n454_o - 32'b00000000000000000000000000000001;
  /* src/matvec_engine_4x4.vhd:192:43  */
  assign n458_o = n456_o - 32'b00000000000000000000000000000001;
  /* src/matvec_engine_4x4.vhd:194:27  */
  assign n460_o = $signed(n458_o) >= $signed(32'b00000000000000000000000000000000);
  /* src/matvec_engine_4x4.vhd:194:49  */
  assign n462_o = $signed(n458_o) <= $signed(32'b00000000000000000000000000000011);
  /* src/matvec_engine_4x4.vhd:194:32  */
  assign n463_o = n462_o & n460_o;
  /* src/matvec_engine_4x4.vhd:195:65  */
  assign n464_o = n458_o[1:0];  // trunc
  /* src/matvec_engine_4x4.vhd:195:65  */
  assign n466_o = 2'b11 - n464_o;
  /* src/matvec_engine_4x4.vhd:194:11  */
  assign n470_o = n463_o ? n581_o : 8'b00000000;
  /* src/matvec_engine_4x4.vhd:192:39  */
  assign n471_o = {29'b0, cycle_count};  //  uext
  /* src/matvec_engine_4x4.vhd:192:39  */
  assign n473_o = n471_o - 32'b00000000000000000000000000000001;
  /* src/matvec_engine_4x4.vhd:192:43  */
  assign n475_o = n473_o - 32'b00000000000000000000000000000010;
  /* src/matvec_engine_4x4.vhd:194:27  */
  assign n477_o = $signed(n475_o) >= $signed(32'b00000000000000000000000000000000);
  /* src/matvec_engine_4x4.vhd:194:49  */
  assign n479_o = $signed(n475_o) <= $signed(32'b00000000000000000000000000000011);
  /* src/matvec_engine_4x4.vhd:194:32  */
  assign n480_o = n479_o & n477_o;
  /* src/matvec_engine_4x4.vhd:195:65  */
  assign n481_o = n475_o[1:0];  // trunc
  /* src/matvec_engine_4x4.vhd:195:65  */
  assign n483_o = 2'b11 - n481_o;
  /* src/matvec_engine_4x4.vhd:194:11  */
  assign n487_o = n480_o ? n587_o : 8'b00000000;
  /* src/matvec_engine_4x4.vhd:192:39  */
  assign n488_o = {29'b0, cycle_count};  //  uext
  /* src/matvec_engine_4x4.vhd:192:39  */
  assign n490_o = n488_o - 32'b00000000000000000000000000000001;
  /* src/matvec_engine_4x4.vhd:192:43  */
  assign n492_o = n490_o - 32'b00000000000000000000000000000011;
  /* src/matvec_engine_4x4.vhd:194:27  */
  assign n494_o = $signed(n492_o) >= $signed(32'b00000000000000000000000000000000);
  /* src/matvec_engine_4x4.vhd:194:49  */
  assign n496_o = $signed(n492_o) <= $signed(32'b00000000000000000000000000000011);
  /* src/matvec_engine_4x4.vhd:194:32  */
  assign n497_o = n496_o & n494_o;
  /* src/matvec_engine_4x4.vhd:195:65  */
  assign n498_o = n492_o[1:0];  // trunc
  /* src/matvec_engine_4x4.vhd:195:65  */
  assign n500_o = 2'b11 - n498_o;
  /* src/matvec_engine_4x4.vhd:194:11  */
  assign n504_o = n497_o ? n593_o : 8'b00000000;
  /* src/matvec_engine_4x4.vhd:200:24  */
  assign n505_o = {29'b0, cycle_count};  //  uext
  /* src/matvec_engine_4x4.vhd:200:24  */
  assign n507_o = $signed(n505_o) >= $signed(32'b00000000000000000000000000000001);
  /* src/matvec_engine_4x4.vhd:200:45  */
  assign n508_o = {29'b0, cycle_count};  //  uext
  /* src/matvec_engine_4x4.vhd:200:45  */
  assign n510_o = $signed(n508_o) <= $signed(32'b00000000000000000000000000000100);
  /* src/matvec_engine_4x4.vhd:200:29  */
  assign n511_o = n510_o & n507_o;
  /* src/matvec_engine_4x4.vhd:201:68  */
  assign n512_o = {29'b0, cycle_count};  //  uext
  /* src/matvec_engine_4x4.vhd:201:68  */
  assign n514_o = n512_o - 32'b00000000000000000000000000000001;
  /* src/matvec_engine_4x4.vhd:201:68  */
  assign n515_o = n514_o[1:0];  // trunc
  /* src/matvec_engine_4x4.vhd:201:68  */
  assign n517_o = 2'b11 - n515_o;
  /* src/matvec_engine_4x4.vhd:200:9  */
  assign n521_o = n511_o ? n599_o : 8'b00000000;
  /* src/matvec_engine_4x4.vhd:187:7  */
  assign n523_o = current_state == 2'b10;
  /* src/matvec_engine_4x4.vhd:204:7  */
  assign n525_o = current_state == 2'b11;
  assign n526_o = {n525_o, n523_o, n436_o, n434_o};
  /* src/matvec_engine_4x4.vhd:179:5  */
  always @*
    case (n526_o)
      4'b1000: n530_o = 1'b1;
      4'b0100: n530_o = 1'b0;
      4'b0010: n530_o = 1'b0;
      4'b0001: n530_o = 1'b0;
      default: n530_o = 1'bX;
    endcase
  /* src/matvec_engine_4x4.vhd:179:5  */
  always @*
    case (n526_o)
      4'b1000: n534_o = 8'b00000000;
      4'b0100: n534_o = n504_o;
      4'b0010: n534_o = 8'b00000000;
      4'b0001: n534_o = 8'b00000000;
      default: n534_o = 8'bX;
    endcase
  /* src/matvec_engine_4x4.vhd:179:5  */
  always @*
    case (n526_o)
      4'b1000: n537_o = 8'b00000000;
      4'b0100: n537_o = n487_o;
      4'b0010: n537_o = 8'b00000000;
      4'b0001: n537_o = 8'b00000000;
      default: n537_o = 8'bX;
    endcase
  /* src/matvec_engine_4x4.vhd:179:5  */
  always @*
    case (n526_o)
      4'b1000: n540_o = 8'b00000000;
      4'b0100: n540_o = n470_o;
      4'b0010: n540_o = 8'b00000000;
      4'b0001: n540_o = 8'b00000000;
      default: n540_o = 8'bX;
    endcase
  /* src/matvec_engine_4x4.vhd:179:5  */
  always @*
    case (n526_o)
      4'b1000: n543_o = 8'b00000000;
      4'b0100: n543_o = n453_o;
      4'b0010: n543_o = 8'b00000000;
      4'b0001: n543_o = 8'b00000000;
      default: n543_o = 8'bX;
    endcase
  /* src/matvec_engine_4x4.vhd:179:5  */
  always @*
    case (n526_o)
      4'b1000: n550_o = 8'b00000000;
      4'b0100: n550_o = n521_o;
      4'b0010: n550_o = 8'b00000000;
      4'b0001: n550_o = 8'b00000000;
      default: n550_o = 8'bX;
    endcase
  assign n552_o = n551_o[23:0];
  /* src/matvec_engine_4x4.vhd:179:5  */
  always @*
    case (n526_o)
      4'b1000: n555_o = reset;
      4'b0100: n555_o = reset;
      4'b0010: n555_o = 1'b1;
      4'b0001: n555_o = reset;
      default: n555_o = 1'bX;
    endcase
  /* src/matvec_engine_4x4.vhd:179:5  */
  always @*
    case (n526_o)
      4'b1000: n559_o = 1'b0;
      4'b0100: n559_o = 1'b1;
      4'b0010: n559_o = 1'b0;
      4'b0001: n559_o = 1'b0;
      default: n559_o = 1'bX;
    endcase
  /* src/matvec_engine_4x4.vhd:46:5  */
  always @(posedge clk)
    n564_q <= n363_o;
  /* src/matvec_engine_4x4.vhd:46:5  */
  always @(posedge clk)
    n565_q <= n365_o;
  /* src/matvec_engine_4x4.vhd:118:5  */
  always @(posedge clk)
    n566_q <= n401_o;
  initial
    n566_q = 2'b00;
  /* src/matvec_engine_4x4.vhd:118:5  */
  always @(posedge clk)
    n567_q <= n403_o;
  initial
    n567_q = 3'b000;
  /* src/matvec_engine_4x4.vhd:118:5  */
  assign n568_o = {n543_o, n540_o, n537_o, n534_o};
  assign n569_o = {n550_o, n552_o};
  /* src/matvec_engine_4x4.vhd:109:19  */
  assign n570_o = w_reg[103:96];
  /* src/matvec_engine_4x4.vhd:104:19  */
  assign n571_o = w_reg[111:104];
  /* src/matvec_engine_4x4.vhd:99:19  */
  assign n572_o = w_reg[119:112];
  /* src/matvec_engine_4x4.vhd:94:19  */
  assign n573_o = w_reg[127:120];
  /* src/matvec_engine_4x4.vhd:195:64  */
  assign n574_o = n449_o[1:0];
  /* src/matvec_engine_4x4.vhd:195:64  */
  always @*
    case (n574_o)
      2'b00: n575_o = n570_o;
      2'b01: n575_o = n571_o;
      2'b10: n575_o = n572_o;
      2'b11: n575_o = n573_o;
    endcase
  /* src/matvec_engine_4x4.vhd:195:64  */
  assign n576_o = w_reg[71:64];
  /* src/matvec_engine_4x4.vhd:195:65  */
  assign n577_o = w_reg[79:72];
  /* src/matvec_engine_4x4.vhd:18:13  */
  assign n578_o = w_reg[87:80];
  /* src/matvec_engine_4x4.vhd:18:9  */
  assign n579_o = w_reg[95:88];
  /* src/matvec_engine_4x4.vhd:195:64  */
  assign n580_o = n466_o[1:0];
  /* src/matvec_engine_4x4.vhd:195:64  */
  always @*
    case (n580_o)
      2'b00: n581_o = n576_o;
      2'b01: n581_o = n577_o;
      2'b10: n581_o = n578_o;
      2'b11: n581_o = n579_o;
    endcase
  /* src/matvec_engine_4x4.vhd:195:64  */
  assign n582_o = w_reg[39:32];
  /* src/matvec_engine_4x4.vhd:195:65  */
  assign n583_o = w_reg[47:40];
  /* src/matvec_engine_4x4.vhd:179:5  */
  assign n584_o = w_reg[55:48];
  assign n585_o = w_reg[63:56];
  /* src/matvec_engine_4x4.vhd:195:64  */
  assign n586_o = n483_o[1:0];
  /* src/matvec_engine_4x4.vhd:195:64  */
  always @*
    case (n586_o)
      2'b00: n587_o = n582_o;
      2'b01: n587_o = n583_o;
      2'b10: n587_o = n584_o;
      2'b11: n587_o = n585_o;
    endcase
  /* src/matvec_engine_4x4.vhd:195:64  */
  assign n588_o = w_reg[7:0];
  /* src/matvec_engine_4x4.vhd:195:65  */
  assign n589_o = w_reg[15:8];
  assign n590_o = w_reg[23:16];
  assign n591_o = w_reg[31:24];
  /* src/matvec_engine_4x4.vhd:195:64  */
  assign n592_o = n500_o[1:0];
  /* src/matvec_engine_4x4.vhd:195:64  */
  always @*
    case (n592_o)
      2'b00: n593_o = n588_o;
      2'b01: n593_o = n589_o;
      2'b10: n593_o = n590_o;
      2'b11: n593_o = n591_o;
    endcase
  /* src/matvec_engine_4x4.vhd:195:64  */
  assign n594_o = x_reg[7:0];
  /* src/matvec_engine_4x4.vhd:195:65  */
  assign n595_o = x_reg[15:8];
  /* src/matvec_engine_4x4.vhd:169:3  */
  assign n596_o = x_reg[23:16];
  /* src/matvec_engine_4x4.vhd:170:14  */
  assign n597_o = x_reg[31:24];
  /* src/matvec_engine_4x4.vhd:201:55  */
  assign n598_o = n517_o[1:0];
  /* src/matvec_engine_4x4.vhd:201:55  */
  always @*
    case (n598_o)
      2'b00: n599_o = n594_o;
      2'b01: n599_o = n595_o;
      2'b10: n599_o = n596_o;
      2'b11: n599_o = n597_o;
    endcase
endmodule

module bias_buffer_4
  (input  clk,
   input  reset,
   input  write_en,
   input  [1:0] write_addr,
   input  [31:0] write_data,
   output [31:0] bias0,
   output [31:0] bias1,
   output [31:0] bias2,
   output [31:0] bias3);
  wire [127:0] buffer_reg;
  wire [1:0] n310_o;
  wire [127:0] n313_o;
  wire [127:0] n315_o;
  wire [31:0] n318_o;
  wire [31:0] n319_o;
  wire [31:0] n320_o;
  wire [31:0] n321_o;
  reg [127:0] n322_q;
  wire n323_o;
  wire n324_o;
  wire n325_o;
  wire n326_o;
  wire n327_o;
  wire n328_o;
  wire n329_o;
  wire n330_o;
  wire [31:0] n331_o;
  wire [31:0] n332_o;
  wire [31:0] n333_o;
  wire [31:0] n334_o;
  wire [31:0] n335_o;
  wire [31:0] n336_o;
  wire [31:0] n337_o;
  wire [31:0] n338_o;
  wire [127:0] n339_o;
  assign bias0 = n318_o;
  assign bias1 = n319_o;
  assign bias2 = n320_o;
  assign bias3 = n321_o;
  /* src/bias_buffer_4.vhd:24:12  */
  assign buffer_reg = n322_q; // (signal)
  /* src/bias_buffer_4.vhd:35:28  */
  assign n310_o = 2'b11 - write_addr;
  /* src/bias_buffer_4.vhd:33:13  */
  assign n313_o = write_en ? n339_o : buffer_reg;
  /* src/bias_buffer_4.vhd:30:13  */
  assign n315_o = reset ? 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000 : n313_o;
  /* src/bias_buffer_4.vhd:41:24  */
  assign n318_o = buffer_reg[127:96];
  /* src/bias_buffer_4.vhd:42:24  */
  assign n319_o = buffer_reg[95:64];
  /* src/bias_buffer_4.vhd:43:24  */
  assign n320_o = buffer_reg[63:32];
  /* src/bias_buffer_4.vhd:44:24  */
  assign n321_o = buffer_reg[31:0];
  /* src/bias_buffer_4.vhd:29:9  */
  always @(posedge clk)
    n322_q <= n315_o;
  /* src/bias_buffer_4.vhd:35:17  */
  assign n323_o = n310_o[1];
  /* src/bias_buffer_4.vhd:35:17  */
  assign n324_o = ~n323_o;
  /* src/bias_buffer_4.vhd:35:17  */
  assign n325_o = n310_o[0];
  /* src/bias_buffer_4.vhd:35:17  */
  assign n326_o = ~n325_o;
  /* src/bias_buffer_4.vhd:35:17  */
  assign n327_o = n324_o & n326_o;
  /* src/bias_buffer_4.vhd:35:17  */
  assign n328_o = n324_o & n325_o;
  /* src/bias_buffer_4.vhd:35:17  */
  assign n329_o = n323_o & n326_o;
  /* src/bias_buffer_4.vhd:35:17  */
  assign n330_o = n323_o & n325_o;
  assign n331_o = buffer_reg[31:0];
  /* src/bias_buffer_4.vhd:35:17  */
  assign n332_o = n327_o ? write_data : n331_o;
  assign n333_o = buffer_reg[63:32];
  /* src/bias_buffer_4.vhd:35:17  */
  assign n334_o = n328_o ? write_data : n333_o;
  assign n335_o = buffer_reg[95:64];
  /* src/bias_buffer_4.vhd:35:17  */
  assign n336_o = n329_o ? write_data : n335_o;
  assign n337_o = buffer_reg[127:96];
  /* src/bias_buffer_4.vhd:35:17  */
  assign n338_o = n330_o ? write_data : n337_o;
  assign n339_o = {n338_o, n336_o, n334_o, n332_o};
endmodule

module weight_buffer_16
  (input  clk,
   input  reset,
   input  write_en,
   input  [3:0] write_addr,
   input  [7:0] write_data,
   output [7:0] w00,
   output [7:0] w01,
   output [7:0] w02,
   output [7:0] w03,
   output [7:0] w10,
   output [7:0] w11,
   output [7:0] w12,
   output [7:0] w13,
   output [7:0] w20,
   output [7:0] w21,
   output [7:0] w22,
   output [7:0] w23,
   output [7:0] w30,
   output [7:0] w31,
   output [7:0] w32,
   output [7:0] w33);
  wire [127:0] buffer_reg;
  wire [3:0] n207_o;
  wire [127:0] n210_o;
  wire [127:0] n212_o;
  wire [7:0] n215_o;
  wire [7:0] n216_o;
  wire [7:0] n217_o;
  wire [7:0] n218_o;
  wire [7:0] n219_o;
  wire [7:0] n220_o;
  wire [7:0] n221_o;
  wire [7:0] n222_o;
  wire [7:0] n223_o;
  wire [7:0] n224_o;
  wire [7:0] n225_o;
  wire [7:0] n226_o;
  wire [7:0] n227_o;
  wire [7:0] n228_o;
  wire [7:0] n229_o;
  wire [7:0] n230_o;
  reg [127:0] n231_q;
  wire n232_o;
  wire n233_o;
  wire n234_o;
  wire n235_o;
  wire n236_o;
  wire n237_o;
  wire n238_o;
  wire n239_o;
  wire n240_o;
  wire n241_o;
  wire n242_o;
  wire n243_o;
  wire n244_o;
  wire n245_o;
  wire n246_o;
  wire n247_o;
  wire n248_o;
  wire n249_o;
  wire n250_o;
  wire n251_o;
  wire n252_o;
  wire n253_o;
  wire n254_o;
  wire n255_o;
  wire n256_o;
  wire n257_o;
  wire n258_o;
  wire n259_o;
  wire n260_o;
  wire n261_o;
  wire n262_o;
  wire n263_o;
  wire n264_o;
  wire n265_o;
  wire n266_o;
  wire n267_o;
  wire [7:0] n268_o;
  wire [7:0] n269_o;
  wire [7:0] n270_o;
  wire [7:0] n271_o;
  wire [7:0] n272_o;
  wire [7:0] n273_o;
  wire [7:0] n274_o;
  wire [7:0] n275_o;
  wire [7:0] n276_o;
  wire [7:0] n277_o;
  wire [7:0] n278_o;
  wire [7:0] n279_o;
  wire [7:0] n280_o;
  wire [7:0] n281_o;
  wire [7:0] n282_o;
  wire [7:0] n283_o;
  wire [7:0] n284_o;
  wire [7:0] n285_o;
  wire [7:0] n286_o;
  wire [7:0] n287_o;
  wire [7:0] n288_o;
  wire [7:0] n289_o;
  wire [7:0] n290_o;
  wire [7:0] n291_o;
  wire [7:0] n292_o;
  wire [7:0] n293_o;
  wire [7:0] n294_o;
  wire [7:0] n295_o;
  wire [7:0] n296_o;
  wire [7:0] n297_o;
  wire [7:0] n298_o;
  wire [7:0] n299_o;
  wire [127:0] n300_o;
  assign w00 = n215_o;
  assign w01 = n216_o;
  assign w02 = n217_o;
  assign w03 = n218_o;
  assign w10 = n219_o;
  assign w11 = n220_o;
  assign w12 = n221_o;
  assign w13 = n222_o;
  assign w20 = n223_o;
  assign w21 = n224_o;
  assign w22 = n225_o;
  assign w23 = n226_o;
  assign w30 = n227_o;
  assign w31 = n228_o;
  assign w32 = n229_o;
  assign w33 = n230_o;
  /* src/weight_buffer_16.vhd:23:10  */
  assign buffer_reg = n231_q; // (signal)
  /* src/weight_buffer_16.vhd:31:18  */
  assign n207_o = 4'b1111 - write_addr;
  /* src/weight_buffer_16.vhd:30:5  */
  assign n210_o = write_en ? n300_o : buffer_reg;
  /* src/weight_buffer_16.vhd:28:5  */
  assign n212_o = reset ? 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000 : n210_o;
  /* src/weight_buffer_16.vhd:36:18  */
  assign n215_o = buffer_reg[127:120];
  /* src/weight_buffer_16.vhd:37:18  */
  assign n216_o = buffer_reg[119:112];
  /* src/weight_buffer_16.vhd:38:18  */
  assign n217_o = buffer_reg[111:104];
  /* src/weight_buffer_16.vhd:39:18  */
  assign n218_o = buffer_reg[103:96];
  /* src/weight_buffer_16.vhd:41:18  */
  assign n219_o = buffer_reg[95:88];
  /* src/weight_buffer_16.vhd:42:18  */
  assign n220_o = buffer_reg[87:80];
  /* src/weight_buffer_16.vhd:43:18  */
  assign n221_o = buffer_reg[79:72];
  /* src/weight_buffer_16.vhd:44:18  */
  assign n222_o = buffer_reg[71:64];
  /* src/weight_buffer_16.vhd:46:18  */
  assign n223_o = buffer_reg[63:56];
  /* src/weight_buffer_16.vhd:47:18  */
  assign n224_o = buffer_reg[55:48];
  /* src/weight_buffer_16.vhd:48:18  */
  assign n225_o = buffer_reg[47:40];
  /* src/weight_buffer_16.vhd:49:18  */
  assign n226_o = buffer_reg[39:32];
  /* src/weight_buffer_16.vhd:51:18  */
  assign n227_o = buffer_reg[31:24];
  /* src/weight_buffer_16.vhd:52:18  */
  assign n228_o = buffer_reg[23:16];
  /* src/weight_buffer_16.vhd:53:18  */
  assign n229_o = buffer_reg[15:8];
  /* src/weight_buffer_16.vhd:54:18  */
  assign n230_o = buffer_reg[7:0];
  /* src/weight_buffer_16.vhd:27:3  */
  always @(posedge clk)
    n231_q <= n212_o;
  /* src/weight_buffer_16.vhd:31:7  */
  assign n232_o = n207_o[3];
  /* src/weight_buffer_16.vhd:31:7  */
  assign n233_o = ~n232_o;
  /* src/weight_buffer_16.vhd:31:7  */
  assign n234_o = n207_o[2];
  /* src/weight_buffer_16.vhd:31:7  */
  assign n235_o = ~n234_o;
  /* src/weight_buffer_16.vhd:31:7  */
  assign n236_o = n233_o & n235_o;
  /* src/weight_buffer_16.vhd:31:7  */
  assign n237_o = n233_o & n234_o;
  /* src/weight_buffer_16.vhd:31:7  */
  assign n238_o = n232_o & n235_o;
  /* src/weight_buffer_16.vhd:31:7  */
  assign n239_o = n232_o & n234_o;
  /* src/weight_buffer_16.vhd:31:7  */
  assign n240_o = n207_o[1];
  /* src/weight_buffer_16.vhd:31:7  */
  assign n241_o = ~n240_o;
  /* src/weight_buffer_16.vhd:31:7  */
  assign n242_o = n236_o & n241_o;
  /* src/weight_buffer_16.vhd:31:7  */
  assign n243_o = n236_o & n240_o;
  /* src/weight_buffer_16.vhd:31:7  */
  assign n244_o = n237_o & n241_o;
  /* src/weight_buffer_16.vhd:31:7  */
  assign n245_o = n237_o & n240_o;
  /* src/weight_buffer_16.vhd:31:7  */
  assign n246_o = n238_o & n241_o;
  /* src/weight_buffer_16.vhd:31:7  */
  assign n247_o = n238_o & n240_o;
  /* src/weight_buffer_16.vhd:31:7  */
  assign n248_o = n239_o & n241_o;
  /* src/weight_buffer_16.vhd:31:7  */
  assign n249_o = n239_o & n240_o;
  /* src/weight_buffer_16.vhd:31:7  */
  assign n250_o = n207_o[0];
  /* src/weight_buffer_16.vhd:31:7  */
  assign n251_o = ~n250_o;
  /* src/weight_buffer_16.vhd:31:7  */
  assign n252_o = n242_o & n251_o;
  /* src/weight_buffer_16.vhd:31:7  */
  assign n253_o = n242_o & n250_o;
  /* src/weight_buffer_16.vhd:31:7  */
  assign n254_o = n243_o & n251_o;
  /* src/weight_buffer_16.vhd:31:7  */
  assign n255_o = n243_o & n250_o;
  /* src/weight_buffer_16.vhd:31:7  */
  assign n256_o = n244_o & n251_o;
  /* src/weight_buffer_16.vhd:31:7  */
  assign n257_o = n244_o & n250_o;
  /* src/weight_buffer_16.vhd:31:7  */
  assign n258_o = n245_o & n251_o;
  /* src/weight_buffer_16.vhd:31:7  */
  assign n259_o = n245_o & n250_o;
  /* src/weight_buffer_16.vhd:31:7  */
  assign n260_o = n246_o & n251_o;
  /* src/weight_buffer_16.vhd:31:7  */
  assign n261_o = n246_o & n250_o;
  /* src/weight_buffer_16.vhd:31:7  */
  assign n262_o = n247_o & n251_o;
  /* src/weight_buffer_16.vhd:31:7  */
  assign n263_o = n247_o & n250_o;
  /* src/weight_buffer_16.vhd:31:7  */
  assign n264_o = n248_o & n251_o;
  /* src/weight_buffer_16.vhd:31:7  */
  assign n265_o = n248_o & n250_o;
  /* src/weight_buffer_16.vhd:31:7  */
  assign n266_o = n249_o & n251_o;
  /* src/weight_buffer_16.vhd:31:7  */
  assign n267_o = n249_o & n250_o;
  assign n268_o = buffer_reg[7:0];
  /* src/weight_buffer_16.vhd:31:7  */
  assign n269_o = n252_o ? write_data : n268_o;
  assign n270_o = buffer_reg[15:8];
  /* src/weight_buffer_16.vhd:31:7  */
  assign n271_o = n253_o ? write_data : n270_o;
  assign n272_o = buffer_reg[23:16];
  /* src/weight_buffer_16.vhd:31:7  */
  assign n273_o = n254_o ? write_data : n272_o;
  assign n274_o = buffer_reg[31:24];
  /* src/weight_buffer_16.vhd:31:7  */
  assign n275_o = n255_o ? write_data : n274_o;
  assign n276_o = buffer_reg[39:32];
  /* src/weight_buffer_16.vhd:31:7  */
  assign n277_o = n256_o ? write_data : n276_o;
  assign n278_o = buffer_reg[47:40];
  /* src/weight_buffer_16.vhd:31:7  */
  assign n279_o = n257_o ? write_data : n278_o;
  assign n280_o = buffer_reg[55:48];
  /* src/weight_buffer_16.vhd:31:7  */
  assign n281_o = n258_o ? write_data : n280_o;
  assign n282_o = buffer_reg[63:56];
  /* src/weight_buffer_16.vhd:31:7  */
  assign n283_o = n259_o ? write_data : n282_o;
  assign n284_o = buffer_reg[71:64];
  /* src/weight_buffer_16.vhd:31:7  */
  assign n285_o = n260_o ? write_data : n284_o;
  assign n286_o = buffer_reg[79:72];
  /* src/weight_buffer_16.vhd:31:7  */
  assign n287_o = n261_o ? write_data : n286_o;
  assign n288_o = buffer_reg[87:80];
  /* src/weight_buffer_16.vhd:31:7  */
  assign n289_o = n262_o ? write_data : n288_o;
  assign n290_o = buffer_reg[95:88];
  /* src/weight_buffer_16.vhd:31:7  */
  assign n291_o = n263_o ? write_data : n290_o;
  assign n292_o = buffer_reg[103:96];
  /* src/weight_buffer_16.vhd:31:7  */
  assign n293_o = n264_o ? write_data : n292_o;
  assign n294_o = buffer_reg[111:104];
  /* src/weight_buffer_16.vhd:31:7  */
  assign n295_o = n265_o ? write_data : n294_o;
  assign n296_o = buffer_reg[119:112];
  /* src/weight_buffer_16.vhd:31:7  */
  assign n297_o = n266_o ? write_data : n296_o;
  assign n298_o = buffer_reg[127:120];
  /* src/weight_buffer_16.vhd:31:7  */
  assign n299_o = n267_o ? write_data : n298_o;
  assign n300_o = {n299_o, n297_o, n295_o, n293_o, n291_o, n289_o, n287_o, n285_o, n283_o, n281_o, n279_o, n277_o, n275_o, n273_o, n271_o, n269_o};
endmodule

module input_buffer_4
  (input  clk,
   input  reset,
   input  write_en,
   input  [1:0] write_addr,
   input  [7:0] write_data,
   output [7:0] x0,
   output [7:0] x1,
   output [7:0] x2,
   output [7:0] x3);
  wire [31:0] buffer_reg;
  wire [1:0] n156_o;
  wire [31:0] n159_o;
  wire [31:0] n161_o;
  wire [7:0] n164_o;
  wire [7:0] n165_o;
  wire [7:0] n166_o;
  wire [7:0] n167_o;
  reg [31:0] n168_q;
  wire n169_o;
  wire n170_o;
  wire n171_o;
  wire n172_o;
  wire n173_o;
  wire n174_o;
  wire n175_o;
  wire n176_o;
  wire [7:0] n177_o;
  wire [7:0] n178_o;
  wire [7:0] n179_o;
  wire [7:0] n180_o;
  wire [7:0] n181_o;
  wire [7:0] n182_o;
  wire [7:0] n183_o;
  wire [7:0] n184_o;
  wire [31:0] n185_o;
  assign x0 = n164_o;
  assign x1 = n165_o;
  assign x2 = n166_o;
  assign x3 = n167_o;
  /* src/input_buffer_4.vhd:23:10  */
  assign buffer_reg = n168_q; // (signal)
  /* src/input_buffer_4.vhd:32:20  */
  assign n156_o = 2'b11 - write_addr;
  /* src/input_buffer_4.vhd:31:7  */
  assign n159_o = write_en ? n185_o : buffer_reg;
  /* src/input_buffer_4.vhd:28:7  */
  assign n161_o = reset ? 32'b00000000000000000000000000000000 : n159_o;
  /* src/input_buffer_4.vhd:38:19  */
  assign n164_o = buffer_reg[31:24];
  /* src/input_buffer_4.vhd:39:19  */
  assign n165_o = buffer_reg[23:16];
  /* src/input_buffer_4.vhd:40:19  */
  assign n166_o = buffer_reg[15:8];
  /* src/input_buffer_4.vhd:41:19  */
  assign n167_o = buffer_reg[7:0];
  /* src/input_buffer_4.vhd:27:5  */
  always @(posedge clk)
    n168_q <= n161_o;
  /* src/input_buffer_4.vhd:32:9  */
  assign n169_o = n156_o[1];
  /* src/input_buffer_4.vhd:32:9  */
  assign n170_o = ~n169_o;
  /* src/input_buffer_4.vhd:32:9  */
  assign n171_o = n156_o[0];
  /* src/input_buffer_4.vhd:32:9  */
  assign n172_o = ~n171_o;
  /* src/input_buffer_4.vhd:32:9  */
  assign n173_o = n170_o & n172_o;
  /* src/input_buffer_4.vhd:32:9  */
  assign n174_o = n170_o & n171_o;
  /* src/input_buffer_4.vhd:32:9  */
  assign n175_o = n169_o & n172_o;
  /* src/input_buffer_4.vhd:32:9  */
  assign n176_o = n169_o & n171_o;
  /* src/toplvl.vhd:91:14  */
  assign n177_o = buffer_reg[7:0];
  /* src/input_buffer_4.vhd:32:9  */
  assign n178_o = n173_o ? write_data : n177_o;
  /* src/toplvl.vhd:88:14  */
  assign n179_o = buffer_reg[15:8];
  /* src/input_buffer_4.vhd:32:9  */
  assign n180_o = n174_o ? write_data : n179_o;
  /* src/toplvl.vhd:86:14  */
  assign n181_o = buffer_reg[23:16];
  /* src/input_buffer_4.vhd:32:9  */
  assign n182_o = n175_o ? write_data : n181_o;
  /* src/toplvl.vhd:83:14  */
  assign n183_o = buffer_reg[31:24];
  /* src/input_buffer_4.vhd:32:9  */
  assign n184_o = n176_o ? write_data : n183_o;
  /* src/toplvl.vhd:81:14  */
  assign n185_o = {n184_o, n182_o, n180_o, n178_o};
endmodule

module toplvl
  (input  clk,
   input  reset,
   input  input_write_en,
   input  [1:0] input_write_addr,
   input  [7:0] input_write_data,
   input  weight_write_en,
   input  [3:0] weight_write_addr,
   input  [7:0] weight_write_data,
   input  bias_write_en,
   input  [1:0] bias_write_addr,
   input  [31:0] bias_write_data,
   input  start,
   output done,
   output [31:0] out0,
   output [31:0] out1,
   output [31:0] out2,
   output [31:0] out3);
  wire [31:0] x_buf;
  wire [127:0] w_buf;
  wire [127:0] bias_buf;
  wire [127:0] matvec_result;
  wire [127:0] bias_result;
  wire [127:0] relu_result;
  wire matvec_start;
  wire matvec_done;
  wire capture_en;
  reg [1:0] current_state;
  reg [1:0] next_state;
  wire [7:0] input_buf_inst_x0;
  wire [7:0] input_buf_inst_x1;
  wire [7:0] input_buf_inst_x2;
  wire [7:0] input_buf_inst_x3;
  wire [7:0] weight_buf_inst_w00;
  wire [7:0] weight_buf_inst_w01;
  wire [7:0] weight_buf_inst_w02;
  wire [7:0] weight_buf_inst_w03;
  wire [7:0] weight_buf_inst_w10;
  wire [7:0] weight_buf_inst_w11;
  wire [7:0] weight_buf_inst_w12;
  wire [7:0] weight_buf_inst_w13;
  wire [7:0] weight_buf_inst_w20;
  wire [7:0] weight_buf_inst_w21;
  wire [7:0] weight_buf_inst_w22;
  wire [7:0] weight_buf_inst_w23;
  wire [7:0] weight_buf_inst_w30;
  wire [7:0] weight_buf_inst_w31;
  wire [7:0] weight_buf_inst_w32;
  wire [7:0] weight_buf_inst_w33;
  wire [31:0] bias_buf_inst_bias0;
  wire [31:0] bias_buf_inst_bias1;
  wire [31:0] bias_buf_inst_bias2;
  wire [31:0] bias_buf_inst_bias3;
  wire [31:0] matvec_inst_y0;
  wire [31:0] matvec_inst_y1;
  wire [31:0] matvec_inst_y2;
  wire [31:0] matvec_inst_y3;
  wire matvec_inst_done;
  wire [7:0] n31_o;
  wire [7:0] n32_o;
  wire [7:0] n33_o;
  wire [7:0] n34_o;
  wire [7:0] n35_o;
  wire [7:0] n36_o;
  wire [7:0] n37_o;
  wire [7:0] n38_o;
  wire [7:0] n39_o;
  wire [7:0] n40_o;
  wire [7:0] n41_o;
  wire [7:0] n42_o;
  wire [7:0] n43_o;
  wire [7:0] n44_o;
  wire [7:0] n45_o;
  wire [7:0] n46_o;
  wire [7:0] n47_o;
  wire [7:0] n48_o;
  wire [7:0] n49_o;
  wire [7:0] n50_o;
  wire [31:0] bias01_inst_out0;
  wire [31:0] bias01_inst_out1;
  wire [31:0] n56_o;
  wire [31:0] n57_o;
  wire [31:0] n58_o;
  wire [31:0] n59_o;
  wire [31:0] bias23_inst_out0;
  wire [31:0] bias23_inst_out1;
  wire [31:0] n62_o;
  wire [31:0] n63_o;
  wire [31:0] n64_o;
  wire [31:0] n65_o;
  wire [31:0] relu01_inst_out0;
  wire [31:0] relu01_inst_out1;
  wire [31:0] n68_o;
  wire [31:0] n69_o;
  wire [31:0] relu23_inst_out0;
  wire [31:0] relu23_inst_out1;
  wire [31:0] n72_o;
  wire [31:0] n73_o;
  wire [31:0] output_buf_inst_out0;
  wire [31:0] output_buf_inst_out1;
  wire [31:0] output_buf_inst_out2;
  wire [31:0] output_buf_inst_out3;
  wire [31:0] n76_o;
  wire [31:0] n77_o;
  wire [31:0] n78_o;
  wire [31:0] n79_o;
  wire [1:0] n88_o;
  wire [1:0] n94_o;
  wire n96_o;
  wire [1:0] n98_o;
  wire n100_o;
  wire n102_o;
  wire n104_o;
  wire [3:0] n105_o;
  reg [1:0] n109_o;
  wire n115_o;
  wire n117_o;
  wire n119_o;
  wire n121_o;
  wire n123_o;
  wire [3:0] n124_o;
  reg n128_o;
  reg n132_o;
  reg n137_o;
  wire [31:0] n140_o;
  wire [127:0] n141_o;
  wire [127:0] n142_o;
  wire [127:0] n143_o;
  wire [127:0] n144_o;
  wire [127:0] n145_o;
  reg [1:0] n146_q;
  assign done = n128_o;
  assign out0 = output_buf_inst_out0;
  assign out1 = output_buf_inst_out1;
  assign out2 = output_buf_inst_out2;
  assign out3 = output_buf_inst_out3;
  /* src/toplvl.vhd:34:10  */
  assign x_buf = n140_o; // (signal)
  /* src/toplvl.vhd:35:10  */
  assign w_buf = n141_o; // (signal)
  /* src/toplvl.vhd:36:10  */
  assign bias_buf = n142_o; // (signal)
  /* src/toplvl.vhd:38:10  */
  assign matvec_result = n143_o; // (signal)
  /* src/toplvl.vhd:39:10  */
  assign bias_result = n144_o; // (signal)
  /* src/toplvl.vhd:40:10  */
  assign relu_result = n145_o; // (signal)
  /* src/toplvl.vhd:42:10  */
  assign matvec_start = n132_o; // (signal)
  /* src/toplvl.vhd:43:10  */
  assign matvec_done = matvec_inst_done; // (signal)
  /* src/toplvl.vhd:44:10  */
  assign capture_en = n137_o; // (signal)
  /* src/toplvl.vhd:47:10  */
  always @*
    current_state = n146_q; // (isignal)
  initial
    current_state = 2'b00;
  /* src/toplvl.vhd:48:10  */
  always @*
    next_state = n109_o; // (isignal)
  initial
    next_state = 2'b00;
  /* src/toplvl.vhd:51:3  */
  input_buffer_4 input_buf_inst (
    .clk(clk),
    .reset(reset),
    .write_en(input_write_en),
    .write_addr(input_write_addr),
    .write_data(input_write_data),
    .x0(input_buf_inst_x0),
    .x1(input_buf_inst_x1),
    .x2(input_buf_inst_x2),
    .x3(input_buf_inst_x3));
  /* src/toplvl.vhd:65:3  */
  weight_buffer_16 weight_buf_inst (
    .clk(clk),
    .reset(reset),
    .write_en(weight_write_en),
    .write_addr(weight_write_addr),
    .write_data(weight_write_data),
    .w00(weight_buf_inst_w00),
    .w01(weight_buf_inst_w01),
    .w02(weight_buf_inst_w02),
    .w03(weight_buf_inst_w03),
    .w10(weight_buf_inst_w10),
    .w11(weight_buf_inst_w11),
    .w12(weight_buf_inst_w12),
    .w13(weight_buf_inst_w13),
    .w20(weight_buf_inst_w20),
    .w21(weight_buf_inst_w21),
    .w22(weight_buf_inst_w22),
    .w23(weight_buf_inst_w23),
    .w30(weight_buf_inst_w30),
    .w31(weight_buf_inst_w31),
    .w32(weight_buf_inst_w32),
    .w33(weight_buf_inst_w33));
  /* src/toplvl.vhd:96:3  */
  bias_buffer_4 bias_buf_inst (
    .clk(clk),
    .reset(reset),
    .write_en(bias_write_en),
    .write_addr(bias_write_addr),
    .write_data(bias_write_data),
    .bias0(bias_buf_inst_bias0),
    .bias1(bias_buf_inst_bias1),
    .bias2(bias_buf_inst_bias2),
    .bias3(bias_buf_inst_bias3));
  /* src/toplvl.vhd:112:3  */
  matvec_engine_4x4 matvec_inst (
    .clk(clk),
    .reset(reset),
    .start(matvec_start),
    .w00(n31_o),
    .w01(n32_o),
    .w02(n33_o),
    .w03(n34_o),
    .w10(n35_o),
    .w11(n36_o),
    .w12(n37_o),
    .w13(n38_o),
    .w20(n39_o),
    .w21(n40_o),
    .w22(n41_o),
    .w23(n42_o),
    .w30(n43_o),
    .w31(n44_o),
    .w32(n45_o),
    .w33(n46_o),
    .x0(n47_o),
    .x1(n48_o),
    .x2(n49_o),
    .x3(n50_o),
    .y0(matvec_inst_y0),
    .y1(matvec_inst_y1),
    .y2(matvec_inst_y2),
    .y3(matvec_inst_y3),
    .done(matvec_inst_done));
  /* src/toplvl.vhd:119:22  */
  assign n31_o = w_buf[127:120];
  /* src/toplvl.vhd:120:22  */
  assign n32_o = w_buf[119:112];
  /* src/toplvl.vhd:121:22  */
  assign n33_o = w_buf[111:104];
  /* src/toplvl.vhd:122:22  */
  assign n34_o = w_buf[103:96];
  /* src/toplvl.vhd:124:22  */
  assign n35_o = w_buf[95:88];
  /* src/toplvl.vhd:125:22  */
  assign n36_o = w_buf[87:80];
  /* src/toplvl.vhd:126:22  */
  assign n37_o = w_buf[79:72];
  /* src/toplvl.vhd:127:22  */
  assign n38_o = w_buf[71:64];
  /* src/toplvl.vhd:129:22  */
  assign n39_o = w_buf[63:56];
  /* src/toplvl.vhd:130:22  */
  assign n40_o = w_buf[55:48];
  /* src/toplvl.vhd:131:22  */
  assign n41_o = w_buf[47:40];
  /* src/toplvl.vhd:132:22  */
  assign n42_o = w_buf[39:32];
  /* src/toplvl.vhd:134:22  */
  assign n43_o = w_buf[31:24];
  /* src/toplvl.vhd:135:22  */
  assign n44_o = w_buf[23:16];
  /* src/toplvl.vhd:136:22  */
  assign n45_o = w_buf[15:8];
  /* src/toplvl.vhd:137:22  */
  assign n46_o = w_buf[7:0];
  /* src/toplvl.vhd:139:18  */
  assign n47_o = x_buf[31:24];
  /* src/toplvl.vhd:140:18  */
  assign n48_o = x_buf[23:16];
  /* src/toplvl.vhd:141:18  */
  assign n49_o = x_buf[15:8];
  /* src/toplvl.vhd:142:18  */
  assign n50_o = x_buf[7:0];
  /* src/toplvl.vhd:152:3  */
  bias_add_2 bias01_inst (
    .data0(n56_o),
    .data1(n57_o),
    .bias0(n58_o),
    .bias1(n59_o),
    .out0(bias01_inst_out0),
    .out1(bias01_inst_out1));
  /* src/toplvl.vhd:155:29  */
  assign n56_o = matvec_result[127:96];
  /* src/toplvl.vhd:156:29  */
  assign n57_o = matvec_result[95:64];
  /* src/toplvl.vhd:158:24  */
  assign n58_o = bias_buf[127:96];
  /* src/toplvl.vhd:159:24  */
  assign n59_o = bias_buf[95:64];
  /* src/toplvl.vhd:165:3  */
  bias_add_2 bias23_inst (
    .data0(n62_o),
    .data1(n63_o),
    .bias0(n64_o),
    .bias1(n65_o),
    .out0(bias23_inst_out0),
    .out1(bias23_inst_out1));
  /* src/toplvl.vhd:168:29  */
  assign n62_o = matvec_result[63:32];
  /* src/toplvl.vhd:169:29  */
  assign n63_o = matvec_result[31:0];
  /* src/toplvl.vhd:171:24  */
  assign n64_o = bias_buf[63:32];
  /* src/toplvl.vhd:172:24  */
  assign n65_o = bias_buf[31:0];
  /* src/toplvl.vhd:178:3  */
  relu_2 relu01_inst (
    .data0(n68_o),
    .data1(n69_o),
    .out0(relu01_inst_out0),
    .out1(relu01_inst_out1));
  /* src/toplvl.vhd:181:27  */
  assign n68_o = bias_result[127:96];
  /* src/toplvl.vhd:182:27  */
  assign n69_o = bias_result[95:64];
  /* src/toplvl.vhd:188:3  */
  relu_2 relu23_inst (
    .data0(n72_o),
    .data1(n73_o),
    .out0(relu23_inst_out0),
    .out1(relu23_inst_out1));
  /* src/toplvl.vhd:191:27  */
  assign n72_o = bias_result[63:32];
  /* src/toplvl.vhd:192:27  */
  assign n73_o = bias_result[31:0];
  /* src/toplvl.vhd:198:3  */
  output_buffer_4 output_buf_inst (
    .clk(clk),
    .reset(reset),
    .capture_en(capture_en),
    .data0(n76_o),
    .data1(n77_o),
    .data2(n78_o),
    .data3(n79_o),
    .out0(output_buf_inst_out0),
    .out1(output_buf_inst_out1),
    .out2(output_buf_inst_out2),
    .out3(output_buf_inst_out3));
  /* src/toplvl.vhd:205:27  */
  assign n76_o = relu_result[127:96];
  /* src/toplvl.vhd:206:27  */
  assign n77_o = relu_result[95:64];
  /* src/toplvl.vhd:207:27  */
  assign n78_o = relu_result[63:32];
  /* src/toplvl.vhd:208:27  */
  assign n79_o = relu_result[31:0];
  /* src/toplvl.vhd:220:7  */
  assign n88_o = reset ? 2'b00 : next_state;
  /* src/toplvl.vhd:236:9  */
  assign n94_o = start ? 2'b01 : current_state;
  /* src/toplvl.vhd:235:7  */
  assign n96_o = current_state == 2'b00;
  /* src/toplvl.vhd:241:9  */
  assign n98_o = matvec_done ? 2'b10 : current_state;
  /* src/toplvl.vhd:240:7  */
  assign n100_o = current_state == 2'b01;
  /* src/toplvl.vhd:245:7  */
  assign n102_o = current_state == 2'b10;
  /* src/toplvl.vhd:248:7  */
  assign n104_o = current_state == 2'b11;
  assign n105_o = {n104_o, n102_o, n100_o, n96_o};
  /* src/toplvl.vhd:233:5  */
  always @*
    case (n105_o)
      4'b1000: n109_o = 2'b00;
      4'b0100: n109_o = 2'b11;
      4'b0010: n109_o = n98_o;
      4'b0001: n109_o = n94_o;
      default: n109_o = 2'bX;
    endcase
  /* src/toplvl.vhd:264:9  */
  assign n115_o = start ? 1'b1 : 1'b0;
  /* src/toplvl.vhd:263:7  */
  assign n117_o = current_state == 2'b00;
  /* src/toplvl.vhd:268:7  */
  assign n119_o = current_state == 2'b01;
  /* src/toplvl.vhd:271:7  */
  assign n121_o = current_state == 2'b10;
  /* src/toplvl.vhd:274:7  */
  assign n123_o = current_state == 2'b11;
  assign n124_o = {n123_o, n121_o, n119_o, n117_o};
  /* src/toplvl.vhd:261:5  */
  always @*
    case (n124_o)
      4'b1000: n128_o = 1'b1;
      4'b0100: n128_o = 1'b0;
      4'b0010: n128_o = 1'b0;
      4'b0001: n128_o = 1'b0;
      default: n128_o = 1'bX;
    endcase
  /* src/toplvl.vhd:261:5  */
  always @*
    case (n124_o)
      4'b1000: n132_o = 1'b0;
      4'b0100: n132_o = 1'b0;
      4'b0010: n132_o = 1'b0;
      4'b0001: n132_o = n115_o;
      default: n132_o = 1'bX;
    endcase
  /* src/toplvl.vhd:261:5  */
  always @*
    case (n124_o)
      4'b1000: n137_o = 1'b0;
      4'b0100: n137_o = 1'b1;
      4'b0010: n137_o = 1'b0;
      4'b0001: n137_o = 1'b0;
      default: n137_o = 1'bX;
    endcase
  assign n140_o = {input_buf_inst_x0, input_buf_inst_x1, input_buf_inst_x2, input_buf_inst_x3};
  assign n141_o = {weight_buf_inst_w00, weight_buf_inst_w01, weight_buf_inst_w02, weight_buf_inst_w03, weight_buf_inst_w10, weight_buf_inst_w11, weight_buf_inst_w12, weight_buf_inst_w13, weight_buf_inst_w20, weight_buf_inst_w21, weight_buf_inst_w22, weight_buf_inst_w23, weight_buf_inst_w30, weight_buf_inst_w31, weight_buf_inst_w32, weight_buf_inst_w33};
  assign n142_o = {bias_buf_inst_bias0, bias_buf_inst_bias1, bias_buf_inst_bias2, bias_buf_inst_bias3};
  assign n143_o = {matvec_inst_y0, matvec_inst_y1, matvec_inst_y2, matvec_inst_y3};
  assign n144_o = {bias01_inst_out0, bias01_inst_out1, bias23_inst_out0, bias23_inst_out1};
  assign n145_o = {relu01_inst_out0, relu01_inst_out1, relu23_inst_out0, relu23_inst_out1};
  /* src/toplvl.vhd:219:5  */
  always @(posedge clk)
    n146_q <= n88_o;
  initial
    n146_q = 2'b00;
endmodule


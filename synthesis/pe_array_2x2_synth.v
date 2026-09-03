module mac
  (input  clk,
   input  reset,
   input  enable,
   input  [7:0] a,
   input  [7:0] b,
   output [31:0] result);
  wire [31:0] accumulator;
  wire [15:0] n42_o;
  wire [15:0] n43_o;
  wire [15:0] n44_o;
  wire [31:0] n45_o;
  wire [31:0] n46_o;
  wire [31:0] n47_o;
  wire [31:0] n49_o;
  reg [31:0] n52_q;
  assign result = accumulator;
  /* src/mac.vhd:20:10  */
  assign accumulator = n52_q; // (signal)
  /* src/mac.vhd:29:46  */
  assign n42_o = {{8{a[7]}}, a}; // sext
  /* src/mac.vhd:29:46  */
  assign n43_o = {{8{b[7]}}, b}; // sext
  /* src/mac.vhd:29:46  */
  assign n44_o = n42_o * n43_o; // smul
  /* src/mac.vhd:29:38  */
  assign n45_o = {{16{n44_o[15]}}, n44_o}; // sext
  /* src/mac.vhd:29:36  */
  assign n46_o = accumulator + n45_o;
  /* src/mac.vhd:28:7  */
  assign n47_o = enable ? n46_o : accumulator;
  /* src/mac.vhd:26:7  */
  assign n49_o = reset ? 32'b00000000000000000000000000000000 : n47_o;
  /* src/mac.vhd:25:5  */
  always @(posedge clk)
    n52_q <= n49_o;
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
  wire [7:0] n26_o;
  wire [7:0] n27_o;
  wire [7:0] n29_o;
  wire [7:0] n31_o;
  wire [31:0] mac_unit_result;
  reg [7:0] n36_q;
  reg [7:0] n37_q;
  assign a_out = a_reg;
  assign b_out = b_reg;
  assign result = mac_unit_result;
  /* src/pe.vhd:22:10  */
  assign a_reg = n36_q; // (signal)
  /* src/pe.vhd:23:10  */
  assign b_reg = n37_q; // (signal)
  /* src/pe.vhd:31:7  */
  assign n26_o = enable ? a_in : a_reg;
  /* src/pe.vhd:31:7  */
  assign n27_o = enable ? b_in : b_reg;
  /* src/pe.vhd:28:7  */
  assign n29_o = reset ? 8'b00000000 : n26_o;
  /* src/pe.vhd:28:7  */
  assign n31_o = reset ? 8'b00000000 : n27_o;
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
    n36_q <= n29_o;
  /* src/pe.vhd:27:5  */
  always @(posedge clk)
    n37_q <= n31_o;
endmodule

module pe_array_2x2
  (input  clk,
   input  reset,
   input  enable,
   input  [7:0] a_row0_in,
   input  [7:0] a_row1_in,
   input  [7:0] b_col0_in,
   input  [7:0] b_col1_in,
   output [7:0] a_row0_out,
   output [7:0] a_row1_out,
   output [7:0] b_col0_out,
   output [7:0] b_col1_out,
   output [31:0] result00,
   output [31:0] result01,
   output [31:0] result10,
   output [31:0] result11);
  wire [7:0] a_00_01;
  wire [7:0] a_10_11;
  wire [7:0] b_00_10;
  wire [7:0] b_01_11;
  wire [7:0] pe00_a_out;
  wire [7:0] pe00_b_out;
  wire [31:0] pe00_result;
  wire [7:0] pe01_a_out;
  wire [7:0] pe01_b_out;
  wire [31:0] pe01_result;
  wire [7:0] pe10_a_out;
  wire [7:0] pe10_b_out;
  wire [31:0] pe10_result;
  wire [7:0] pe11_a_out;
  wire [7:0] pe11_b_out;
  wire [31:0] pe11_result;
  assign a_row0_out = pe01_a_out;
  assign a_row1_out = pe11_a_out;
  assign b_col0_out = pe10_b_out;
  assign b_col1_out = pe11_b_out;
  assign result00 = pe00_result;
  assign result01 = pe01_result;
  assign result10 = pe10_result;
  assign result11 = pe11_result;
  /* src/pe_array_2x2.vhd:28:8  */
  assign a_00_01 = pe00_a_out; // (signal)
  /* src/pe_array_2x2.vhd:29:8  */
  assign a_10_11 = pe10_a_out; // (signal)
  /* src/pe_array_2x2.vhd:30:8  */
  assign b_00_10 = pe00_b_out; // (signal)
  /* src/pe_array_2x2.vhd:31:8  */
  assign b_01_11 = pe01_b_out; // (signal)
  /* src/pe_array_2x2.vhd:33:5  */
  pe pe00 (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .a_in(a_row0_in),
    .b_in(b_col0_in),
    .a_out(pe00_a_out),
    .b_out(pe00_b_out),
    .result(pe00_result));
  /* src/pe_array_2x2.vhd:46:5  */
  pe pe01 (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .a_in(a_00_01),
    .b_in(b_col1_in),
    .a_out(pe01_a_out),
    .b_out(pe01_b_out),
    .result(pe01_result));
  /* src/pe_array_2x2.vhd:59:5  */
  pe pe10 (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .a_in(a_row1_in),
    .b_in(b_00_10),
    .a_out(pe10_a_out),
    .b_out(pe10_b_out),
    .result(pe10_result));
  /* src/pe_array_2x2.vhd:72:5  */
  pe pe11 (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .a_in(a_10_11),
    .b_in(b_01_11),
    .a_out(pe11_a_out),
    .b_out(pe11_b_out),
    .result(pe11_result));
endmodule


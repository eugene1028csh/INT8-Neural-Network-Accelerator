module mac
  (input  clk,
   input  reset,
   input  enable,
   input  [7:0] a,
   input  [7:0] b,
   output [31:0] result);
  wire [31:0] accumulator;
  wire [15:0] n22_o;
  wire [15:0] n23_o;
  wire [15:0] n24_o;
  wire [31:0] n25_o;
  wire [31:0] n26_o;
  wire [31:0] n27_o;
  wire [31:0] n29_o;
  reg [31:0] n32_q;
  assign result = accumulator;
  /* src/mac.vhd:20:10  */
  assign accumulator = n32_q; // (signal)
  /* src/mac.vhd:29:46  */
  assign n22_o = {{8{a[7]}}, a}; // sext
  /* src/mac.vhd:29:46  */
  assign n23_o = {{8{b[7]}}, b}; // sext
  /* src/mac.vhd:29:46  */
  assign n24_o = n22_o * n23_o; // smul
  /* src/mac.vhd:29:38  */
  assign n25_o = {{16{n24_o[15]}}, n24_o}; // sext
  /* src/mac.vhd:29:36  */
  assign n26_o = accumulator + n25_o;
  /* src/mac.vhd:28:7  */
  assign n27_o = enable ? n26_o : accumulator;
  /* src/mac.vhd:26:7  */
  assign n29_o = reset ? 32'b00000000000000000000000000000000 : n27_o;
  /* src/mac.vhd:25:5  */
  always @(posedge clk)
    n32_q <= n29_o;
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
  wire [7:0] n6_o;
  wire [7:0] n7_o;
  wire [7:0] n9_o;
  wire [7:0] n11_o;
  wire [31:0] mac_unit_result;
  reg [7:0] n16_q;
  reg [7:0] n17_q;
  assign a_out = a_reg;
  assign b_out = b_reg;
  assign result = mac_unit_result;
  /* src/pe.vhd:22:10  */
  assign a_reg = n16_q; // (signal)
  /* src/pe.vhd:23:10  */
  assign b_reg = n17_q; // (signal)
  /* src/pe.vhd:31:7  */
  assign n6_o = enable ? a_in : a_reg;
  /* src/pe.vhd:31:7  */
  assign n7_o = enable ? b_in : b_reg;
  /* src/pe.vhd:28:7  */
  assign n9_o = reset ? 8'b00000000 : n6_o;
  /* src/pe.vhd:28:7  */
  assign n11_o = reset ? 8'b00000000 : n7_o;
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
    n16_q <= n9_o;
  /* src/pe.vhd:27:5  */
  always @(posedge clk)
    n17_q <= n11_o;
endmodule


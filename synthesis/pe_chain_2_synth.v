module mac
  (input  clk,
   input  reset,
   input  enable,
   input  [7:0] a,
   input  [7:0] b,
   output [31:0] result);
  wire [31:0] accumulator;
  wire [15:0] n32_o;
  wire [15:0] n33_o;
  wire [15:0] n34_o;
  wire [31:0] n35_o;
  wire [31:0] n36_o;
  wire [31:0] n37_o;
  wire [31:0] n39_o;
  reg [31:0] n42_q;
  assign result = accumulator;
  /* src/mac.vhd:20:10  */
  assign accumulator = n42_q; // (signal)
  /* src/mac.vhd:29:46  */
  assign n32_o = {{8{a[7]}}, a}; // sext
  /* src/mac.vhd:29:46  */
  assign n33_o = {{8{b[7]}}, b}; // sext
  /* src/mac.vhd:29:46  */
  assign n34_o = n32_o * n33_o; // smul
  /* src/mac.vhd:29:38  */
  assign n35_o = {{16{n34_o[15]}}, n34_o}; // sext
  /* src/mac.vhd:29:36  */
  assign n36_o = accumulator + n35_o;
  /* src/mac.vhd:28:7  */
  assign n37_o = enable ? n36_o : accumulator;
  /* src/mac.vhd:26:7  */
  assign n39_o = reset ? 32'b00000000000000000000000000000000 : n37_o;
  /* src/mac.vhd:25:5  */
  always @(posedge clk)
    n42_q <= n39_o;
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
  wire [7:0] n16_o;
  wire [7:0] n17_o;
  wire [7:0] n19_o;
  wire [7:0] n21_o;
  wire [31:0] mac_unit_result;
  reg [7:0] n26_q;
  reg [7:0] n27_q;
  assign a_out = a_reg;
  assign b_out = b_reg;
  assign result = mac_unit_result;
  /* src/pe.vhd:22:10  */
  assign a_reg = n26_q; // (signal)
  /* src/pe.vhd:23:10  */
  assign b_reg = n27_q; // (signal)
  /* src/pe.vhd:31:7  */
  assign n16_o = enable ? a_in : a_reg;
  /* src/pe.vhd:31:7  */
  assign n17_o = enable ? b_in : b_reg;
  /* src/pe.vhd:28:7  */
  assign n19_o = reset ? 8'b00000000 : n16_o;
  /* src/pe.vhd:28:7  */
  assign n21_o = reset ? 8'b00000000 : n17_o;
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
    n26_q <= n19_o;
  /* src/pe.vhd:27:5  */
  always @(posedge clk)
    n27_q <= n21_o;
endmodule

module pe_chain_2
  (input  clk,
   input  reset,
   input  enable,
   input  [7:0] a_in,
   input  [7:0] b_in,
   output [7:0] a_out,
   output [7:0] b_out,
   output [31:0] result0,
   output [31:0] result1);
  wire [7:0] a_link;
  wire [7:0] b_link;
  wire [7:0] pe0_a_out;
  wire [7:0] pe0_b_out;
  wire [31:0] pe0_result;
  wire [7:0] pe1_a_out;
  wire [7:0] pe1_b_out;
  wire [31:0] pe1_result;
  assign a_out = pe1_a_out;
  assign b_out = pe1_b_out;
  assign result0 = pe0_result;
  assign result1 = pe1_result;
  /* src/pe_chain_2.vhd:20:12  */
  assign a_link = pe0_a_out; // (signal)
  /* src/pe_chain_2.vhd:21:12  */
  assign b_link = pe0_b_out; // (signal)
  /* src/pe_chain_2.vhd:27:9  */
  pe pe0 (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .a_in(a_in),
    .b_in(b_in),
    .a_out(pe0_a_out),
    .b_out(pe0_b_out),
    .result(pe0_result));
  /* src/pe_chain_2.vhd:41:9  */
  pe pe1 (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .a_in(a_link),
    .b_in(b_link),
    .a_out(pe1_a_out),
    .b_out(pe1_b_out),
    .result(pe1_result));
endmodule


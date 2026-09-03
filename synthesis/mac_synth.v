module mac
  (input  clk,
   input  reset,
   input  enable,
   input  [7:0] a,
   input  [7:0] b,
   output [31:0] result);
  wire [31:0] accumulator;
  wire [15:0] n4_o;
  wire [15:0] n5_o;
  wire [15:0] n6_o;
  wire [31:0] n7_o;
  wire [31:0] n8_o;
  wire [31:0] n9_o;
  wire [31:0] n11_o;
  reg [31:0] n14_q;
  assign result = accumulator;
  /* src/mac.vhd:20:10  */
  assign accumulator = n14_q; // (signal)
  /* src/mac.vhd:29:46  */
  assign n4_o = {{8{a[7]}}, a}; // sext
  /* src/mac.vhd:29:46  */
  assign n5_o = {{8{b[7]}}, b}; // sext
  /* src/mac.vhd:29:46  */
  assign n6_o = n4_o * n5_o; // smul
  /* src/mac.vhd:29:38  */
  assign n7_o = {{16{n6_o[15]}}, n6_o}; // sext
  /* src/mac.vhd:29:36  */
  assign n8_o = accumulator + n7_o;
  /* src/mac.vhd:28:7  */
  assign n9_o = enable ? n8_o : accumulator;
  /* src/mac.vhd:26:7  */
  assign n11_o = reset ? 32'b00000000000000000000000000000000 : n9_o;
  /* src/mac.vhd:25:5  */
  always @(posedge clk)
    n14_q <= n11_o;
endmodule


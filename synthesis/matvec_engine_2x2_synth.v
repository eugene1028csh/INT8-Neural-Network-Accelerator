module mac
  (input  clk,
   input  reset,
   input  enable,
   input  [7:0] a,
   input  [7:0] b,
   output [31:0] result);
  wire [31:0] accumulator;
  wire [15:0] n179_o;
  wire [15:0] n180_o;
  wire [15:0] n181_o;
  wire [31:0] n182_o;
  wire [31:0] n183_o;
  wire [31:0] n184_o;
  wire [31:0] n186_o;
  reg [31:0] n189_q;
  assign result = accumulator;
  /* src/mac.vhd:20:10  */
  assign accumulator = n189_q; // (signal)
  /* src/mac.vhd:29:46  */
  assign n179_o = {{8{a[7]}}, a}; // sext
  /* src/mac.vhd:29:46  */
  assign n180_o = {{8{b[7]}}, b}; // sext
  /* src/mac.vhd:29:46  */
  assign n181_o = n179_o * n180_o; // smul
  /* src/mac.vhd:29:38  */
  assign n182_o = {{16{n181_o[15]}}, n181_o}; // sext
  /* src/mac.vhd:29:36  */
  assign n183_o = accumulator + n182_o;
  /* src/mac.vhd:28:7  */
  assign n184_o = enable ? n183_o : accumulator;
  /* src/mac.vhd:26:7  */
  assign n186_o = reset ? 32'b00000000000000000000000000000000 : n184_o;
  /* src/mac.vhd:25:5  */
  always @(posedge clk)
    n189_q <= n186_o;
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
  wire [7:0] n163_o;
  wire [7:0] n164_o;
  wire [7:0] n166_o;
  wire [7:0] n168_o;
  wire [31:0] mac_unit_result;
  reg [7:0] n173_q;
  reg [7:0] n174_q;
  assign a_out = a_reg;
  assign b_out = b_reg;
  assign result = mac_unit_result;
  /* src/pe.vhd:22:10  */
  assign a_reg = n173_q; // (signal)
  /* src/pe.vhd:23:10  */
  assign b_reg = n174_q; // (signal)
  /* src/pe.vhd:31:7  */
  assign n163_o = enable ? a_in : a_reg;
  /* src/pe.vhd:31:7  */
  assign n164_o = enable ? b_in : b_reg;
  /* src/pe.vhd:28:7  */
  assign n166_o = reset ? 8'b00000000 : n163_o;
  /* src/pe.vhd:28:7  */
  assign n168_o = reset ? 8'b00000000 : n164_o;
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
    n173_q <= n166_o;
  /* src/pe.vhd:27:5  */
  always @(posedge clk)
    n174_q <= n168_o;
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

module matvec_engine_2x2
  (input  clk,
   input  reset,
   input  start,
   input  [7:0] w00,
   input  [7:0] w01,
   input  [7:0] w10,
   input  [7:0] w11,
   input  [7:0] x0,
   input  [7:0] x1,
   output [31:0] y0,
   output [31:0] y1,
   output done);
  reg [7:0] w00_reg;
  reg [7:0] w01_reg;
  reg [7:0] w10_reg;
  reg [7:0] w11_reg;
  reg [7:0] x0_reg;
  reg [7:0] x1_reg;
  reg [7:0] array_a_row0;
  reg [7:0] array_a_row1;
  reg [7:0] array_b_col0;
  reg [7:0] array_b_col1;
  reg array_enable;
  reg array_reset;
  wire [31:0] array_result00;
  wire [31:0] array_result10;
  reg [2:0] current_state;
  reg [2:0] next_state;
  wire [7:0] matvec_units_a_row0_out;
  wire [7:0] matvec_units_a_row1_out;
  wire [7:0] matvec_units_b_col0_out;
  wire [7:0] matvec_units_b_col1_out;
  wire [31:0] matvec_units_result00;
  wire [31:0] matvec_units_result01;
  wire [31:0] matvec_units_result10;
  wire [31:0] matvec_units_result11;
  wire n22_o;
  wire n23_o;
  wire [7:0] n24_o;
  wire [7:0] n25_o;
  wire [7:0] n26_o;
  wire [7:0] n27_o;
  wire [7:0] n28_o;
  wire [7:0] n29_o;
  wire [7:0] n31_o;
  wire [7:0] n33_o;
  wire [7:0] n35_o;
  wire [7:0] n37_o;
  wire [7:0] n39_o;
  wire [7:0] n41_o;
  wire [2:0] n43_o;
  wire [2:0] n54_o;
  wire n56_o;
  wire n58_o;
  wire n60_o;
  wire n62_o;
  wire n64_o;
  wire n66_o;
  wire [5:0] n67_o;
  reg [2:0] n74_o;
  wire n78_o;
  wire n80_o;
  wire n82_o;
  wire n84_o;
  wire n86_o;
  wire n88_o;
  wire [5:0] n89_o;
  reg n93_o;
  reg [7:0] n98_o;
  reg [7:0] n103_o;
  reg [7:0] n108_o;
  reg [7:0] n115_o;
  reg n122_o;
  reg n127_o;
  reg [7:0] n130_q;
  reg [7:0] n131_q;
  reg [7:0] n132_q;
  reg [7:0] n133_q;
  reg [7:0] n134_q;
  reg [7:0] n135_q;
  reg [2:0] n136_q;
  assign y0 = array_result00;
  assign y1 = array_result10;
  assign done = n93_o;
  /* src/matvec_engine_2x2.vhd:33:10  */
  always @*
    w00_reg = n130_q; // (isignal)
  initial
    w00_reg = 8'b00000000;
  /* src/matvec_engine_2x2.vhd:34:10  */
  always @*
    w01_reg = n131_q; // (isignal)
  initial
    w01_reg = 8'b00000000;
  /* src/matvec_engine_2x2.vhd:35:10  */
  always @*
    w10_reg = n132_q; // (isignal)
  initial
    w10_reg = 8'b00000000;
  /* src/matvec_engine_2x2.vhd:36:10  */
  always @*
    w11_reg = n133_q; // (isignal)
  initial
    w11_reg = 8'b00000000;
  /* src/matvec_engine_2x2.vhd:37:10  */
  always @*
    x0_reg = n134_q; // (isignal)
  initial
    x0_reg = 8'b00000000;
  /* src/matvec_engine_2x2.vhd:38:10  */
  always @*
    x1_reg = n135_q; // (isignal)
  initial
    x1_reg = 8'b00000000;
  /* src/matvec_engine_2x2.vhd:41:10  */
  always @*
    array_a_row0 = n98_o; // (isignal)
  initial
    array_a_row0 = 8'b00000000;
  /* src/matvec_engine_2x2.vhd:42:10  */
  always @*
    array_a_row1 = n103_o; // (isignal)
  initial
    array_a_row1 = 8'b00000000;
  /* src/matvec_engine_2x2.vhd:43:10  */
  always @*
    array_b_col0 = n108_o; // (isignal)
  initial
    array_b_col0 = 8'b00000000;
  /* src/matvec_engine_2x2.vhd:44:10  */
  always @*
    array_b_col1 = n115_o; // (isignal)
  initial
    array_b_col1 = 8'b00000000;
  /* src/matvec_engine_2x2.vhd:46:10  */
  always @*
    array_enable = n122_o; // (isignal)
  initial
    array_enable = 1'b0;
  /* src/matvec_engine_2x2.vhd:47:10  */
  always @*
    array_reset = n127_o; // (isignal)
  initial
    array_reset = 1'b0;
  /* src/matvec_engine_2x2.vhd:49:10  */
  assign array_result00 = matvec_units_result00; // (signal)
  /* src/matvec_engine_2x2.vhd:50:10  */
  assign array_result10 = matvec_units_result10; // (signal)
  /* src/matvec_engine_2x2.vhd:61:10  */
  always @*
    current_state = n136_q; // (isignal)
  initial
    current_state = 3'b000;
  /* src/matvec_engine_2x2.vhd:62:10  */
  always @*
    next_state = n74_o; // (isignal)
  initial
    next_state = 3'b000;
  /* src/matvec_engine_2x2.vhd:65:3  */
  pe_array_2x2 matvec_units (
    .clk(clk),
    .reset(array_reset),
    .enable(array_enable),
    .a_row0_in(array_a_row0),
    .a_row1_in(array_a_row1),
    .b_col0_in(array_b_col0),
    .b_col1_in(array_b_col1),
    .a_row0_out(),
    .a_row1_out(),
    .b_col0_out(),
    .b_col1_out(),
    .result00(matvec_units_result00),
    .result01(),
    .result10(matvec_units_result10),
    .result11());
  /* src/matvec_engine_2x2.vhd:105:26  */
  assign n22_o = current_state == 3'b000;
  /* src/matvec_engine_2x2.vhd:105:35  */
  assign n23_o = start & n22_o;
  /* src/matvec_engine_2x2.vhd:105:9  */
  assign n24_o = n23_o ? w00 : w00_reg;
  /* src/matvec_engine_2x2.vhd:105:9  */
  assign n25_o = n23_o ? w01 : w01_reg;
  /* src/matvec_engine_2x2.vhd:105:9  */
  assign n26_o = n23_o ? w10 : w10_reg;
  /* src/matvec_engine_2x2.vhd:105:9  */
  assign n27_o = n23_o ? w11 : w11_reg;
  /* src/matvec_engine_2x2.vhd:105:9  */
  assign n28_o = n23_o ? x0 : x0_reg;
  /* src/matvec_engine_2x2.vhd:105:9  */
  assign n29_o = n23_o ? x1 : x1_reg;
  /* src/matvec_engine_2x2.vhd:93:7  */
  assign n31_o = reset ? 8'b00000000 : n24_o;
  /* src/matvec_engine_2x2.vhd:93:7  */
  assign n33_o = reset ? 8'b00000000 : n25_o;
  /* src/matvec_engine_2x2.vhd:93:7  */
  assign n35_o = reset ? 8'b00000000 : n26_o;
  /* src/matvec_engine_2x2.vhd:93:7  */
  assign n37_o = reset ? 8'b00000000 : n27_o;
  /* src/matvec_engine_2x2.vhd:93:7  */
  assign n39_o = reset ? 8'b00000000 : n28_o;
  /* src/matvec_engine_2x2.vhd:93:7  */
  assign n41_o = reset ? 8'b00000000 : n29_o;
  /* src/matvec_engine_2x2.vhd:93:7  */
  assign n43_o = reset ? 3'b000 : next_state;
  /* src/matvec_engine_2x2.vhd:126:9  */
  assign n54_o = start ? 3'b001 : current_state;
  /* src/matvec_engine_2x2.vhd:125:7  */
  assign n56_o = current_state == 3'b000;
  /* src/matvec_engine_2x2.vhd:130:7  */
  assign n58_o = current_state == 3'b001;
  /* src/matvec_engine_2x2.vhd:133:7  */
  assign n60_o = current_state == 3'b010;
  /* src/matvec_engine_2x2.vhd:136:7  */
  assign n62_o = current_state == 3'b011;
  /* src/matvec_engine_2x2.vhd:139:7  */
  assign n64_o = current_state == 3'b100;
  /* src/matvec_engine_2x2.vhd:142:7  */
  assign n66_o = current_state == 3'b101;
  assign n67_o = {n66_o, n64_o, n62_o, n60_o, n58_o, n56_o};
  /* src/matvec_engine_2x2.vhd:124:5  */
  always @*
    case (n67_o)
      6'b100000: n74_o = 3'b000;
      6'b010000: n74_o = 3'b101;
      6'b001000: n74_o = 3'b100;
      6'b000100: n74_o = 3'b011;
      6'b000010: n74_o = 3'b010;
      6'b000001: n74_o = n54_o;
      default: n74_o = 3'bX;
    endcase
  /* src/matvec_engine_2x2.vhd:161:5  */
  assign n78_o = current_state == 3'b000;
  /* src/matvec_engine_2x2.vhd:164:5  */
  assign n80_o = current_state == 3'b001;
  /* src/matvec_engine_2x2.vhd:167:5  */
  assign n82_o = current_state == 3'b010;
  /* src/matvec_engine_2x2.vhd:174:5  */
  assign n84_o = current_state == 3'b011;
  /* src/matvec_engine_2x2.vhd:181:5  */
  assign n86_o = current_state == 3'b100;
  /* src/matvec_engine_2x2.vhd:188:5  */
  assign n88_o = current_state == 3'b101;
  assign n89_o = {n88_o, n86_o, n84_o, n82_o, n80_o, n78_o};
  /* src/matvec_engine_2x2.vhd:160:5  */
  always @*
    case (n89_o)
      6'b100000: n93_o = 1'b1;
      6'b010000: n93_o = 1'b0;
      6'b001000: n93_o = 1'b0;
      6'b000100: n93_o = 1'b0;
      6'b000010: n93_o = 1'b0;
      6'b000001: n93_o = 1'b0;
      default: n93_o = 1'bX;
    endcase
  /* src/matvec_engine_2x2.vhd:160:5  */
  always @*
    case (n89_o)
      6'b100000: n98_o = 8'b00000000;
      6'b010000: n98_o = 8'b00000000;
      6'b001000: n98_o = w01_reg;
      6'b000100: n98_o = w00_reg;
      6'b000010: n98_o = 8'b00000000;
      6'b000001: n98_o = 8'b00000000;
      default: n98_o = 8'bX;
    endcase
  /* src/matvec_engine_2x2.vhd:160:5  */
  always @*
    case (n89_o)
      6'b100000: n103_o = 8'b00000000;
      6'b010000: n103_o = w11_reg;
      6'b001000: n103_o = w10_reg;
      6'b000100: n103_o = 8'b00000000;
      6'b000010: n103_o = 8'b00000000;
      6'b000001: n103_o = 8'b00000000;
      default: n103_o = 8'bX;
    endcase
  /* src/matvec_engine_2x2.vhd:160:5  */
  always @*
    case (n89_o)
      6'b100000: n108_o = 8'b00000000;
      6'b010000: n108_o = 8'b00000000;
      6'b001000: n108_o = x1_reg;
      6'b000100: n108_o = x0_reg;
      6'b000010: n108_o = 8'b00000000;
      6'b000001: n108_o = 8'b00000000;
      default: n108_o = 8'bX;
    endcase
  /* src/matvec_engine_2x2.vhd:160:5  */
  always @*
    case (n89_o)
      6'b100000: n115_o = 8'b00000000;
      6'b010000: n115_o = 8'b00000000;
      6'b001000: n115_o = 8'b00000000;
      6'b000100: n115_o = 8'b00000000;
      6'b000010: n115_o = 8'b00000000;
      6'b000001: n115_o = 8'b00000000;
      default: n115_o = 8'bX;
    endcase
  /* src/matvec_engine_2x2.vhd:160:5  */
  always @*
    case (n89_o)
      6'b100000: n122_o = 1'b0;
      6'b010000: n122_o = 1'b1;
      6'b001000: n122_o = 1'b1;
      6'b000100: n122_o = 1'b1;
      6'b000010: n122_o = 1'b0;
      6'b000001: n122_o = 1'b0;
      default: n122_o = 1'bX;
    endcase
  /* src/matvec_engine_2x2.vhd:160:5  */
  always @*
    case (n89_o)
      6'b100000: n127_o = 1'b0;
      6'b010000: n127_o = 1'b0;
      6'b001000: n127_o = 1'b0;
      6'b000100: n127_o = 1'b0;
      6'b000010: n127_o = 1'b1;
      6'b000001: n127_o = 1'b0;
      default: n127_o = 1'bX;
    endcase
  /* src/matvec_engine_2x2.vhd:92:5  */
  always @(posedge clk)
    n130_q <= n31_o;
  initial
    n130_q = 8'b00000000;
  /* src/matvec_engine_2x2.vhd:92:5  */
  always @(posedge clk)
    n131_q <= n33_o;
  initial
    n131_q = 8'b00000000;
  /* src/matvec_engine_2x2.vhd:92:5  */
  always @(posedge clk)
    n132_q <= n35_o;
  initial
    n132_q = 8'b00000000;
  /* src/matvec_engine_2x2.vhd:92:5  */
  always @(posedge clk)
    n133_q <= n37_o;
  initial
    n133_q = 8'b00000000;
  /* src/matvec_engine_2x2.vhd:92:5  */
  always @(posedge clk)
    n134_q <= n39_o;
  initial
    n134_q = 8'b00000000;
  /* src/matvec_engine_2x2.vhd:92:5  */
  always @(posedge clk)
    n135_q <= n41_o;
  initial
    n135_q = 8'b00000000;
  /* src/matvec_engine_2x2.vhd:92:5  */
  always @(posedge clk)
    n136_q <= n43_o;
  initial
    n136_q = 3'b000;
endmodule


module mac
  (input  clk,
   input  reset,
   input  enable,
   input  [7:0] a,
   input  [7:0] b,
   output [31:0] result);
  wire [31:0] accumulator;
  wire [15:0] n205_o;
  wire [15:0] n206_o;
  wire [15:0] n207_o;
  wire [31:0] n208_o;
  wire [31:0] n209_o;
  wire [31:0] n210_o;
  wire [31:0] n212_o;
  reg [31:0] n215_q;
  assign result = accumulator; //(module output)
  /* src/mac.vhd:20:10  */
  assign accumulator = n215_q; // (signal)
  /* src/mac.vhd:29:46  */
  assign n205_o = {{8{a[7]}}, a}; // sext
  /* src/mac.vhd:29:46  */
  assign n206_o = {{8{b[7]}}, b}; // sext
  /* src/mac.vhd:29:46  */
  assign n207_o = $signed(n205_o) * $signed(n206_o); // smul
  /* src/mac.vhd:29:38  */
  assign n208_o = {{16{n207_o[15]}}, n207_o}; // sext
  /* src/mac.vhd:29:36  */
  assign n209_o = accumulator + n208_o;
  /* src/mac.vhd:28:7  */
  assign n210_o = enable ? n209_o : accumulator;
  /* src/mac.vhd:26:7  */
  assign n212_o = reset ? 32'b00000000000000000000000000000000 : n210_o;
  /* src/mac.vhd:25:5  */
  always @(posedge clk)
    n215_q <= n212_o;
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
  wire [7:0] n189_o;
  wire [7:0] n190_o;
  wire [7:0] n192_o;
  wire [7:0] n194_o;
  wire [31:0] mac_unit_result;
  reg [7:0] n199_q;
  reg [7:0] n200_q;
  assign a_out = a_reg; //(module output)
  assign b_out = b_reg; //(module output)
  assign result = mac_unit_result; //(module output)
  /* src/pe.vhd:22:10  */
  assign a_reg = n199_q; // (signal)
  /* src/pe.vhd:23:10  */
  assign b_reg = n200_q; // (signal)
  /* src/pe.vhd:31:7  */
  assign n189_o = enable ? a_in : a_reg;
  /* src/pe.vhd:31:7  */
  assign n190_o = enable ? b_in : b_reg;
  /* src/pe.vhd:28:7  */
  assign n192_o = reset ? 8'b00000000 : n189_o;
  /* src/pe.vhd:28:7  */
  assign n194_o = reset ? 8'b00000000 : n190_o;
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
    n199_q <= n192_o;
  /* src/pe.vhd:27:5  */
  always @(posedge clk)
    n200_q <= n194_o;
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
  assign a_row0_out = pe01_a_out; //(module output)
  assign a_row1_out = pe11_a_out; //(module output)
  assign b_col0_out = pe10_b_out; //(module output)
  assign b_col1_out = pe11_b_out; //(module output)
  assign result00 = pe00_result; //(module output)
  assign result01 = pe01_result; //(module output)
  assign result10 = pe10_result; //(module output)
  assign result11 = pe11_result; //(module output)
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

module relu_2
  (input  [31:0] data0,
   input  [31:0] data1,
   output [31:0] out0,
   output [31:0] out1);
  wire n158_o;
  wire [31:0] n159_o;
  wire n161_o;
  wire [31:0] n162_o;
  assign out0 = n159_o; //(module output)
  assign out1 = n162_o; //(module output)
  /* src/relu_2.vhd:14:37  */
  assign n158_o = data0[31]; // extract
  /* src/relu_2.vhd:14:27  */
  assign n159_o = n158_o ? 32'b00000000000000000000000000000000 : data0;
  /* src/relu_2.vhd:16:37  */
  assign n161_o = data1[31]; // extract
  /* src/relu_2.vhd:16:27  */
  assign n162_o = n161_o ? 32'b00000000000000000000000000000000 : data1;
endmodule

module bias_add_2
  (input  [31:0] data0,
   input  [31:0] data1,
   input  [31:0] bias0,
   input  [31:0] bias1,
   output [31:0] out0,
   output [31:0] out1);
  wire [31:0] n153_o;
  wire [31:0] n154_o;
  assign out0 = n153_o; //(module output)
  assign out1 = n154_o; //(module output)
  /* src/bias_add_2.vhd:21:17  */
  assign n153_o = data0 + bias0;
  /* src/bias_add_2.vhd:22:17  */
  assign n154_o = data1 + bias1;
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
  wire n36_o;
  wire n37_o;
  wire [7:0] n38_o;
  wire [7:0] n39_o;
  wire [7:0] n40_o;
  wire [7:0] n41_o;
  wire [7:0] n42_o;
  wire [7:0] n43_o;
  wire [7:0] n45_o;
  wire [7:0] n47_o;
  wire [7:0] n49_o;
  wire [7:0] n51_o;
  wire [7:0] n53_o;
  wire [7:0] n55_o;
  wire [2:0] n57_o;
  wire [2:0] n68_o;
  wire n70_o;
  wire n72_o;
  wire n74_o;
  wire n76_o;
  wire n78_o;
  wire n80_o;
  wire [5:0] n81_o;
  reg [2:0] n88_o;
  wire n92_o;
  wire n94_o;
  wire n96_o;
  wire n98_o;
  wire n100_o;
  wire n102_o;
  wire [5:0] n103_o;
  reg n107_o;
  reg [7:0] n112_o;
  reg [7:0] n117_o;
  reg [7:0] n122_o;
  reg [7:0] n129_o;
  reg n136_o;
  reg n141_o;
  reg [7:0] n144_q;
  reg [7:0] n145_q;
  reg [7:0] n146_q;
  reg [7:0] n147_q;
  reg [7:0] n148_q;
  reg [7:0] n149_q;
  reg [2:0] n150_q;
  assign y0 = array_result00; //(module output)
  assign y1 = array_result10; //(module output)
  assign done = n107_o; //(module output)
  /* src/matvec_engine_2x2.vhd:33:10  */
  always @*
    w00_reg = n144_q; // (isignal)
  initial
    w00_reg = 8'b00000000;
  /* src/matvec_engine_2x2.vhd:34:10  */
  always @*
    w01_reg = n145_q; // (isignal)
  initial
    w01_reg = 8'b00000000;
  /* src/matvec_engine_2x2.vhd:35:10  */
  always @*
    w10_reg = n146_q; // (isignal)
  initial
    w10_reg = 8'b00000000;
  /* src/matvec_engine_2x2.vhd:36:10  */
  always @*
    w11_reg = n147_q; // (isignal)
  initial
    w11_reg = 8'b00000000;
  /* src/matvec_engine_2x2.vhd:37:10  */
  always @*
    x0_reg = n148_q; // (isignal)
  initial
    x0_reg = 8'b00000000;
  /* src/matvec_engine_2x2.vhd:38:10  */
  always @*
    x1_reg = n149_q; // (isignal)
  initial
    x1_reg = 8'b00000000;
  /* src/matvec_engine_2x2.vhd:41:10  */
  always @*
    array_a_row0 = n112_o; // (isignal)
  initial
    array_a_row0 = 8'b00000000;
  /* src/matvec_engine_2x2.vhd:42:10  */
  always @*
    array_a_row1 = n117_o; // (isignal)
  initial
    array_a_row1 = 8'b00000000;
  /* src/matvec_engine_2x2.vhd:43:10  */
  always @*
    array_b_col0 = n122_o; // (isignal)
  initial
    array_b_col0 = 8'b00000000;
  /* src/matvec_engine_2x2.vhd:44:10  */
  always @*
    array_b_col1 = n129_o; // (isignal)
  initial
    array_b_col1 = 8'b00000000;
  /* src/matvec_engine_2x2.vhd:46:10  */
  always @*
    array_enable = n136_o; // (isignal)
  initial
    array_enable = 1'b0;
  /* src/matvec_engine_2x2.vhd:47:10  */
  always @*
    array_reset = n141_o; // (isignal)
  initial
    array_reset = 1'b0;
  /* src/matvec_engine_2x2.vhd:49:10  */
  assign array_result00 = matvec_units_result00; // (signal)
  /* src/matvec_engine_2x2.vhd:50:10  */
  assign array_result10 = matvec_units_result10; // (signal)
  /* src/matvec_engine_2x2.vhd:61:10  */
  always @*
    current_state = n150_q; // (isignal)
  initial
    current_state = 3'b000;
  /* src/matvec_engine_2x2.vhd:62:10  */
  always @*
    next_state = n88_o; // (isignal)
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
  assign n36_o = current_state == 3'b000;
  /* src/matvec_engine_2x2.vhd:105:35  */
  assign n37_o = start & n36_o;
  /* src/matvec_engine_2x2.vhd:105:9  */
  assign n38_o = n37_o ? w00 : w00_reg;
  /* src/matvec_engine_2x2.vhd:105:9  */
  assign n39_o = n37_o ? w01 : w01_reg;
  /* src/matvec_engine_2x2.vhd:105:9  */
  assign n40_o = n37_o ? w10 : w10_reg;
  /* src/matvec_engine_2x2.vhd:105:9  */
  assign n41_o = n37_o ? w11 : w11_reg;
  /* src/matvec_engine_2x2.vhd:105:9  */
  assign n42_o = n37_o ? x0 : x0_reg;
  /* src/matvec_engine_2x2.vhd:105:9  */
  assign n43_o = n37_o ? x1 : x1_reg;
  /* src/matvec_engine_2x2.vhd:93:7  */
  assign n45_o = reset ? 8'b00000000 : n38_o;
  /* src/matvec_engine_2x2.vhd:93:7  */
  assign n47_o = reset ? 8'b00000000 : n39_o;
  /* src/matvec_engine_2x2.vhd:93:7  */
  assign n49_o = reset ? 8'b00000000 : n40_o;
  /* src/matvec_engine_2x2.vhd:93:7  */
  assign n51_o = reset ? 8'b00000000 : n41_o;
  /* src/matvec_engine_2x2.vhd:93:7  */
  assign n53_o = reset ? 8'b00000000 : n42_o;
  /* src/matvec_engine_2x2.vhd:93:7  */
  assign n55_o = reset ? 8'b00000000 : n43_o;
  /* src/matvec_engine_2x2.vhd:93:7  */
  assign n57_o = reset ? 3'b000 : next_state;
  /* src/matvec_engine_2x2.vhd:126:9  */
  assign n68_o = start ? 3'b001 : current_state;
  /* src/matvec_engine_2x2.vhd:125:7  */
  assign n70_o = current_state == 3'b000;
  /* src/matvec_engine_2x2.vhd:130:7  */
  assign n72_o = current_state == 3'b001;
  /* src/matvec_engine_2x2.vhd:133:7  */
  assign n74_o = current_state == 3'b010;
  /* src/matvec_engine_2x2.vhd:136:7  */
  assign n76_o = current_state == 3'b011;
  /* src/matvec_engine_2x2.vhd:139:7  */
  assign n78_o = current_state == 3'b100;
  /* src/matvec_engine_2x2.vhd:142:7  */
  assign n80_o = current_state == 3'b101;
  assign n81_o = {n80_o, n78_o, n76_o, n74_o, n72_o, n70_o};
  /* src/matvec_engine_2x2.vhd:124:5  */
  always @*
    case (n81_o)
      6'b100000: n88_o = 3'b000;
      6'b010000: n88_o = 3'b101;
      6'b001000: n88_o = 3'b100;
      6'b000100: n88_o = 3'b011;
      6'b000010: n88_o = 3'b010;
      6'b000001: n88_o = n68_o;
      default: n88_o = 3'bX;
    endcase
  /* src/matvec_engine_2x2.vhd:161:5  */
  assign n92_o = current_state == 3'b000;
  /* src/matvec_engine_2x2.vhd:164:5  */
  assign n94_o = current_state == 3'b001;
  /* src/matvec_engine_2x2.vhd:167:5  */
  assign n96_o = current_state == 3'b010;
  /* src/matvec_engine_2x2.vhd:174:5  */
  assign n98_o = current_state == 3'b011;
  /* src/matvec_engine_2x2.vhd:181:5  */
  assign n100_o = current_state == 3'b100;
  /* src/matvec_engine_2x2.vhd:188:5  */
  assign n102_o = current_state == 3'b101;
  assign n103_o = {n102_o, n100_o, n98_o, n96_o, n94_o, n92_o};
  /* src/matvec_engine_2x2.vhd:160:5  */
  always @*
    case (n103_o)
      6'b100000: n107_o = 1'b1;
      6'b010000: n107_o = 1'b0;
      6'b001000: n107_o = 1'b0;
      6'b000100: n107_o = 1'b0;
      6'b000010: n107_o = 1'b0;
      6'b000001: n107_o = 1'b0;
      default: n107_o = 1'bX;
    endcase
  /* src/matvec_engine_2x2.vhd:160:5  */
  always @*
    case (n103_o)
      6'b100000: n112_o = 8'b00000000;
      6'b010000: n112_o = 8'b00000000;
      6'b001000: n112_o = w01_reg;
      6'b000100: n112_o = w00_reg;
      6'b000010: n112_o = 8'b00000000;
      6'b000001: n112_o = 8'b00000000;
      default: n112_o = 8'bX;
    endcase
  /* src/matvec_engine_2x2.vhd:160:5  */
  always @*
    case (n103_o)
      6'b100000: n117_o = 8'b00000000;
      6'b010000: n117_o = w11_reg;
      6'b001000: n117_o = w10_reg;
      6'b000100: n117_o = 8'b00000000;
      6'b000010: n117_o = 8'b00000000;
      6'b000001: n117_o = 8'b00000000;
      default: n117_o = 8'bX;
    endcase
  /* src/matvec_engine_2x2.vhd:160:5  */
  always @*
    case (n103_o)
      6'b100000: n122_o = 8'b00000000;
      6'b010000: n122_o = 8'b00000000;
      6'b001000: n122_o = x1_reg;
      6'b000100: n122_o = x0_reg;
      6'b000010: n122_o = 8'b00000000;
      6'b000001: n122_o = 8'b00000000;
      default: n122_o = 8'bX;
    endcase
  /* src/matvec_engine_2x2.vhd:160:5  */
  always @*
    case (n103_o)
      6'b100000: n129_o = 8'b00000000;
      6'b010000: n129_o = 8'b00000000;
      6'b001000: n129_o = 8'b00000000;
      6'b000100: n129_o = 8'b00000000;
      6'b000010: n129_o = 8'b00000000;
      6'b000001: n129_o = 8'b00000000;
      default: n129_o = 8'bX;
    endcase
  /* src/matvec_engine_2x2.vhd:160:5  */
  always @*
    case (n103_o)
      6'b100000: n136_o = 1'b0;
      6'b010000: n136_o = 1'b1;
      6'b001000: n136_o = 1'b1;
      6'b000100: n136_o = 1'b1;
      6'b000010: n136_o = 1'b0;
      6'b000001: n136_o = 1'b0;
      default: n136_o = 1'bX;
    endcase
  /* src/matvec_engine_2x2.vhd:160:5  */
  always @*
    case (n103_o)
      6'b100000: n141_o = 1'b0;
      6'b010000: n141_o = 1'b0;
      6'b001000: n141_o = 1'b0;
      6'b000100: n141_o = 1'b0;
      6'b000010: n141_o = 1'b1;
      6'b000001: n141_o = 1'b0;
      default: n141_o = 1'bX;
    endcase
  /* src/matvec_engine_2x2.vhd:92:5  */
  always @(posedge clk)
    n144_q <= n45_o;
  initial
    n144_q = 8'b00000000;
  /* src/matvec_engine_2x2.vhd:92:5  */
  always @(posedge clk)
    n145_q <= n47_o;
  initial
    n145_q = 8'b00000000;
  /* src/matvec_engine_2x2.vhd:92:5  */
  always @(posedge clk)
    n146_q <= n49_o;
  initial
    n146_q = 8'b00000000;
  /* src/matvec_engine_2x2.vhd:92:5  */
  always @(posedge clk)
    n147_q <= n51_o;
  initial
    n147_q = 8'b00000000;
  /* src/matvec_engine_2x2.vhd:92:5  */
  always @(posedge clk)
    n148_q <= n53_o;
  initial
    n148_q = 8'b00000000;
  /* src/matvec_engine_2x2.vhd:92:5  */
  always @(posedge clk)
    n149_q <= n55_o;
  initial
    n149_q = 8'b00000000;
  /* src/matvec_engine_2x2.vhd:92:5  */
  always @(posedge clk)
    n150_q <= n57_o;
  initial
    n150_q = 3'b000;
endmodule

module dense_layer_2x2
  (input  clk,
   input  reset,
   input  start,
   input  [7:0] w00,
   input  [7:0] w01,
   input  [7:0] w10,
   input  [7:0] w11,
   input  [7:0] x0,
   input  [7:0] x1,
   input  [31:0] bias0,
   input  [31:0] bias1,
   output [31:0] y0,
   output [31:0] y1,
   output done);
  reg [31:0] matvec_result0;
  reg [31:0] matvec_result1;
  reg [31:0] bias_result0;
  reg [31:0] bias_result1;
  wire [31:0] matvec_unit_y0;
  wire [31:0] matvec_unit_y1;
  wire matvec_unit_done;
  wire [31:0] bias_unit_out0;
  wire [31:0] bias_unit_out1;
  wire [31:0] relu_unit_out0;
  wire [31:0] relu_unit_out1;
  assign y0 = relu_unit_out0; //(module output)
  assign y1 = relu_unit_out1; //(module output)
  assign done = matvec_unit_done; //(module output)
  /* src/dense_layer_2x2.vhd:26:10  */
  always @*
    matvec_result0 = matvec_unit_y0; // (isignal)
  initial
    matvec_result0 = 32'b00000000000000000000000000000000;
  /* src/dense_layer_2x2.vhd:27:10  */
  always @*
    matvec_result1 = matvec_unit_y1; // (isignal)
  initial
    matvec_result1 = 32'b00000000000000000000000000000000;
  /* src/dense_layer_2x2.vhd:28:10  */
  always @*
    bias_result0 = bias_unit_out0; // (isignal)
  initial
    bias_result0 = 32'b00000000000000000000000000000000;
  /* src/dense_layer_2x2.vhd:29:10  */
  always @*
    bias_result1 = bias_unit_out1; // (isignal)
  initial
    bias_result1 = 32'b00000000000000000000000000000000;
  /* src/dense_layer_2x2.vhd:33:3  */
  matvec_engine_2x2 matvec_unit (
    .clk(clk),
    .reset(reset),
    .start(start),
    .w00(w00),
    .w01(w01),
    .w10(w10),
    .w11(w11),
    .x0(x0),
    .x1(x1),
    .y0(matvec_unit_y0),
    .y1(matvec_unit_y1),
    .done(matvec_unit_done));
  /* src/dense_layer_2x2.vhd:52:5  */
  bias_add_2 bias_unit (
    .data0(matvec_result0),
    .data1(matvec_result1),
    .bias0(bias0),
    .bias1(bias1),
    .out0(bias_unit_out0),
    .out1(bias_unit_out1));
  /* src/dense_layer_2x2.vhd:62:5  */
  relu_2 relu_unit (
    .data0(bias_result0),
    .data1(bias_result1),
    .out0(relu_unit_out0),
    .out1(relu_unit_out1));
endmodule


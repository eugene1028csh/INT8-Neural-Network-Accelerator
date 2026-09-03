module mac
  (input  clk,
   input  reset,
   input  enable,
   input  [7:0] a,
   input  [7:0] b,
   output [31:0] result);
  wire [31:0] accumulator;
  wire [15:0] n199_o;
  wire [15:0] n200_o;
  wire [15:0] n201_o;
  wire [31:0] n202_o;
  wire [31:0] n203_o;
  wire [31:0] n204_o;
  wire [31:0] n206_o;
  reg [31:0] n209_q;
  assign result = accumulator;
  /* src/mac.vhd:20:10  */
  assign accumulator = n209_q; // (signal)
  /* src/mac.vhd:29:46  */
  assign n199_o = {{8{a[7]}}, a}; // sext
  /* src/mac.vhd:29:46  */
  assign n200_o = {{8{b[7]}}, b}; // sext
  /* src/mac.vhd:29:46  */
  assign n201_o = n199_o * n200_o; // smul
  /* src/mac.vhd:29:38  */
  assign n202_o = {{16{n201_o[15]}}, n201_o}; // sext
  /* src/mac.vhd:29:36  */
  assign n203_o = accumulator + n202_o;
  /* src/mac.vhd:28:7  */
  assign n204_o = enable ? n203_o : accumulator;
  /* src/mac.vhd:26:7  */
  assign n206_o = reset ? 32'b00000000000000000000000000000000 : n204_o;
  /* src/mac.vhd:25:5  */
  always @(posedge clk)
    n209_q <= n206_o;
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
  wire [7:0] n183_o;
  wire [7:0] n184_o;
  wire [7:0] n186_o;
  wire [7:0] n188_o;
  wire [31:0] mac_unit_result;
  reg [7:0] n193_q;
  reg [7:0] n194_q;
  assign a_out = a_reg;
  assign b_out = b_reg;
  assign result = mac_unit_result;
  /* src/pe.vhd:22:10  */
  assign a_reg = n193_q; // (signal)
  /* src/pe.vhd:23:10  */
  assign b_reg = n194_q; // (signal)
  /* src/pe.vhd:31:7  */
  assign n183_o = enable ? a_in : a_reg;
  /* src/pe.vhd:31:7  */
  assign n184_o = enable ? b_in : b_reg;
  /* src/pe.vhd:28:7  */
  assign n186_o = reset ? 8'b00000000 : n183_o;
  /* src/pe.vhd:28:7  */
  assign n188_o = reset ? 8'b00000000 : n184_o;
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
    n193_q <= n186_o;
  /* src/pe.vhd:27:5  */
  always @(posedge clk)
    n194_q <= n188_o;
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

module matmul_engine_2x2
  (input  clk,
   input  reset,
   input  start,
   input  [7:0] a00,
   input  [7:0] a01,
   input  [7:0] a10,
   input  [7:0] a11,
   input  [7:0] b00,
   input  [7:0] b01,
   input  [7:0] b10,
   input  [7:0] b11,
   output [31:0] c00,
   output [31:0] c01,
   output [31:0] c10,
   output [31:0] c11,
   output done);
  reg [7:0] a00_reg;
  reg [7:0] a01_reg;
  reg [7:0] a10_reg;
  reg [7:0] a11_reg;
  reg [7:0] b00_reg;
  reg [7:0] b01_reg;
  reg [7:0] b10_reg;
  reg [7:0] b11_reg;
  reg [7:0] array_a_row0;
  reg [7:0] array_a_row1;
  reg [7:0] array_b_col0;
  reg [7:0] array_b_col1;
  reg array_enable;
  reg array_reset;
  wire [31:0] array_result00;
  wire [31:0] array_result01;
  wire [31:0] array_result10;
  wire [31:0] array_result11;
  reg [2:0] current_state;
  reg [2:0] next_state;
  wire [7:0] array_unit_a_row0_out;
  wire [7:0] array_unit_a_row1_out;
  wire [7:0] array_unit_b_col0_out;
  wire [7:0] array_unit_b_col1_out;
  wire [31:0] array_unit_result00;
  wire [31:0] array_unit_result01;
  wire [31:0] array_unit_result10;
  wire [31:0] array_unit_result11;
  wire n28_o;
  wire n29_o;
  wire [7:0] n30_o;
  wire [7:0] n31_o;
  wire [7:0] n32_o;
  wire [7:0] n33_o;
  wire [7:0] n34_o;
  wire [7:0] n35_o;
  wire [7:0] n36_o;
  wire [7:0] n37_o;
  wire [7:0] n39_o;
  wire [7:0] n41_o;
  wire [7:0] n43_o;
  wire [7:0] n45_o;
  wire [7:0] n47_o;
  wire [7:0] n49_o;
  wire [7:0] n51_o;
  wire [7:0] n53_o;
  wire [2:0] n55_o;
  wire [2:0] n68_o;
  wire n70_o;
  wire n72_o;
  wire n74_o;
  wire n76_o;
  wire n78_o;
  wire n80_o;
  wire n82_o;
  wire [6:0] n83_o;
  reg [2:0] n91_o;
  wire n95_o;
  wire n97_o;
  wire n99_o;
  wire n101_o;
  wire n103_o;
  wire n105_o;
  wire n107_o;
  wire [6:0] n108_o;
  reg n112_o;
  reg [7:0] n117_o;
  reg [7:0] n122_o;
  reg [7:0] n127_o;
  reg [7:0] n132_o;
  reg n140_o;
  reg n145_o;
  reg [7:0] n148_q;
  reg [7:0] n149_q;
  reg [7:0] n150_q;
  reg [7:0] n151_q;
  reg [7:0] n152_q;
  reg [7:0] n153_q;
  reg [7:0] n154_q;
  reg [7:0] n155_q;
  reg [2:0] n156_q;
  assign c00 = array_result00;
  assign c01 = array_result01;
  assign c10 = array_result10;
  assign c11 = array_result11;
  assign done = n112_o;
  /* src/matmul_engine_2x2.vhd:34:10  */
  always @*
    a00_reg = n148_q; // (isignal)
  initial
    a00_reg = 8'b00000000;
  /* src/matmul_engine_2x2.vhd:34:19  */
  always @*
    a01_reg = n149_q; // (isignal)
  initial
    a01_reg = 8'b00000000;
  /* src/matmul_engine_2x2.vhd:35:10  */
  always @*
    a10_reg = n150_q; // (isignal)
  initial
    a10_reg = 8'b00000000;
  /* src/matmul_engine_2x2.vhd:35:19  */
  always @*
    a11_reg = n151_q; // (isignal)
  initial
    a11_reg = 8'b00000000;
  /* src/matmul_engine_2x2.vhd:37:10  */
  always @*
    b00_reg = n152_q; // (isignal)
  initial
    b00_reg = 8'b00000000;
  /* src/matmul_engine_2x2.vhd:37:19  */
  always @*
    b01_reg = n153_q; // (isignal)
  initial
    b01_reg = 8'b00000000;
  /* src/matmul_engine_2x2.vhd:38:10  */
  always @*
    b10_reg = n154_q; // (isignal)
  initial
    b10_reg = 8'b00000000;
  /* src/matmul_engine_2x2.vhd:38:19  */
  always @*
    b11_reg = n155_q; // (isignal)
  initial
    b11_reg = 8'b00000000;
  /* src/matmul_engine_2x2.vhd:40:10  */
  always @*
    array_a_row0 = n117_o; // (isignal)
  initial
    array_a_row0 = 8'b00000000;
  /* src/matmul_engine_2x2.vhd:41:10  */
  always @*
    array_a_row1 = n122_o; // (isignal)
  initial
    array_a_row1 = 8'b00000000;
  /* src/matmul_engine_2x2.vhd:43:10  */
  always @*
    array_b_col0 = n127_o; // (isignal)
  initial
    array_b_col0 = 8'b00000000;
  /* src/matmul_engine_2x2.vhd:44:10  */
  always @*
    array_b_col1 = n132_o; // (isignal)
  initial
    array_b_col1 = 8'b00000000;
  /* src/matmul_engine_2x2.vhd:46:10  */
  always @*
    array_enable = n140_o; // (isignal)
  initial
    array_enable = 1'b0;
  /* src/matmul_engine_2x2.vhd:47:10  */
  always @*
    array_reset = n145_o; // (isignal)
  initial
    array_reset = 1'b0;
  /* src/matmul_engine_2x2.vhd:49:10  */
  assign array_result00 = array_unit_result00; // (signal)
  /* src/matmul_engine_2x2.vhd:50:10  */
  assign array_result01 = array_unit_result01; // (signal)
  /* src/matmul_engine_2x2.vhd:51:10  */
  assign array_result10 = array_unit_result10; // (signal)
  /* src/matmul_engine_2x2.vhd:52:10  */
  assign array_result11 = array_unit_result11; // (signal)
  /* src/matmul_engine_2x2.vhd:64:10  */
  always @*
    current_state = n156_q; // (isignal)
  initial
    current_state = 3'b000;
  /* src/matmul_engine_2x2.vhd:65:10  */
  always @*
    next_state = n91_o; // (isignal)
  initial
    next_state = 3'b000;
  /* src/matmul_engine_2x2.vhd:68:3  */
  pe_array_2x2 array_unit (
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
    .result00(array_unit_result00),
    .result01(array_unit_result01),
    .result10(array_unit_result10),
    .result11(array_unit_result11));
  /* src/matmul_engine_2x2.vhd:118:26  */
  assign n28_o = current_state == 3'b000;
  /* src/matmul_engine_2x2.vhd:118:35  */
  assign n29_o = start & n28_o;
  /* src/matmul_engine_2x2.vhd:118:9  */
  assign n30_o = n29_o ? a00 : a00_reg;
  /* src/matmul_engine_2x2.vhd:118:9  */
  assign n31_o = n29_o ? a01 : a01_reg;
  /* src/matmul_engine_2x2.vhd:118:9  */
  assign n32_o = n29_o ? a10 : a10_reg;
  /* src/matmul_engine_2x2.vhd:118:9  */
  assign n33_o = n29_o ? a11 : a11_reg;
  /* src/matmul_engine_2x2.vhd:118:9  */
  assign n34_o = n29_o ? b00 : b00_reg;
  /* src/matmul_engine_2x2.vhd:118:9  */
  assign n35_o = n29_o ? b01 : b01_reg;
  /* src/matmul_engine_2x2.vhd:118:9  */
  assign n36_o = n29_o ? b10 : b10_reg;
  /* src/matmul_engine_2x2.vhd:118:9  */
  assign n37_o = n29_o ? b11 : b11_reg;
  /* src/matmul_engine_2x2.vhd:102:7  */
  assign n39_o = reset ? 8'b00000000 : n30_o;
  /* src/matmul_engine_2x2.vhd:102:7  */
  assign n41_o = reset ? 8'b00000000 : n31_o;
  /* src/matmul_engine_2x2.vhd:102:7  */
  assign n43_o = reset ? 8'b00000000 : n32_o;
  /* src/matmul_engine_2x2.vhd:102:7  */
  assign n45_o = reset ? 8'b00000000 : n33_o;
  /* src/matmul_engine_2x2.vhd:102:7  */
  assign n47_o = reset ? 8'b00000000 : n34_o;
  /* src/matmul_engine_2x2.vhd:102:7  */
  assign n49_o = reset ? 8'b00000000 : n35_o;
  /* src/matmul_engine_2x2.vhd:102:7  */
  assign n51_o = reset ? 8'b00000000 : n36_o;
  /* src/matmul_engine_2x2.vhd:102:7  */
  assign n53_o = reset ? 8'b00000000 : n37_o;
  /* src/matmul_engine_2x2.vhd:102:7  */
  assign n55_o = reset ? 3'b000 : next_state;
  /* src/matmul_engine_2x2.vhd:143:9  */
  assign n68_o = start ? 3'b001 : current_state;
  /* src/matmul_engine_2x2.vhd:142:7  */
  assign n70_o = current_state == 3'b000;
  /* src/matmul_engine_2x2.vhd:148:7  */
  assign n72_o = current_state == 3'b001;
  /* src/matmul_engine_2x2.vhd:151:7  */
  assign n74_o = current_state == 3'b010;
  /* src/matmul_engine_2x2.vhd:154:7  */
  assign n76_o = current_state == 3'b011;
  /* src/matmul_engine_2x2.vhd:157:7  */
  assign n78_o = current_state == 3'b100;
  /* src/matmul_engine_2x2.vhd:160:7  */
  assign n80_o = current_state == 3'b101;
  /* src/matmul_engine_2x2.vhd:163:7  */
  assign n82_o = current_state == 3'b110;
  assign n83_o = {n82_o, n80_o, n78_o, n76_o, n74_o, n72_o, n70_o};
  /* src/matmul_engine_2x2.vhd:140:5  */
  always @*
    case (n83_o)
      7'b1000000: n91_o = 3'b000;
      7'b0100000: n91_o = 3'b110;
      7'b0010000: n91_o = 3'b101;
      7'b0001000: n91_o = 3'b100;
      7'b0000100: n91_o = 3'b011;
      7'b0000010: n91_o = 3'b010;
      7'b0000001: n91_o = n68_o;
      default: n91_o = 3'bX;
    endcase
  /* src/matmul_engine_2x2.vhd:184:7  */
  assign n95_o = current_state == 3'b000;
  /* src/matmul_engine_2x2.vhd:187:7  */
  assign n97_o = current_state == 3'b001;
  /* src/matmul_engine_2x2.vhd:190:7  */
  assign n99_o = current_state == 3'b010;
  /* src/matmul_engine_2x2.vhd:197:7  */
  assign n101_o = current_state == 3'b011;
  /* src/matmul_engine_2x2.vhd:204:7  */
  assign n103_o = current_state == 3'b100;
  /* src/matmul_engine_2x2.vhd:211:7  */
  assign n105_o = current_state == 3'b101;
  /* src/matmul_engine_2x2.vhd:214:7  */
  assign n107_o = current_state == 3'b110;
  assign n108_o = {n107_o, n105_o, n103_o, n101_o, n99_o, n97_o, n95_o};
  /* src/matmul_engine_2x2.vhd:183:5  */
  always @*
    case (n108_o)
      7'b1000000: n112_o = 1'b1;
      7'b0100000: n112_o = 1'b0;
      7'b0010000: n112_o = 1'b0;
      7'b0001000: n112_o = 1'b0;
      7'b0000100: n112_o = 1'b0;
      7'b0000010: n112_o = 1'b0;
      7'b0000001: n112_o = 1'b0;
      default: n112_o = 1'bX;
    endcase
  /* src/matmul_engine_2x2.vhd:183:5  */
  always @*
    case (n108_o)
      7'b1000000: n117_o = 8'b00000000;
      7'b0100000: n117_o = 8'b00000000;
      7'b0010000: n117_o = 8'b00000000;
      7'b0001000: n117_o = a01_reg;
      7'b0000100: n117_o = a00_reg;
      7'b0000010: n117_o = 8'b00000000;
      7'b0000001: n117_o = 8'b00000000;
      default: n117_o = 8'bX;
    endcase
  /* src/matmul_engine_2x2.vhd:183:5  */
  always @*
    case (n108_o)
      7'b1000000: n122_o = 8'b00000000;
      7'b0100000: n122_o = 8'b00000000;
      7'b0010000: n122_o = a11_reg;
      7'b0001000: n122_o = a10_reg;
      7'b0000100: n122_o = 8'b00000000;
      7'b0000010: n122_o = 8'b00000000;
      7'b0000001: n122_o = 8'b00000000;
      default: n122_o = 8'bX;
    endcase
  /* src/matmul_engine_2x2.vhd:183:5  */
  always @*
    case (n108_o)
      7'b1000000: n127_o = 8'b00000000;
      7'b0100000: n127_o = 8'b00000000;
      7'b0010000: n127_o = 8'b00000000;
      7'b0001000: n127_o = b10_reg;
      7'b0000100: n127_o = b00_reg;
      7'b0000010: n127_o = 8'b00000000;
      7'b0000001: n127_o = 8'b00000000;
      default: n127_o = 8'bX;
    endcase
  /* src/matmul_engine_2x2.vhd:183:5  */
  always @*
    case (n108_o)
      7'b1000000: n132_o = 8'b00000000;
      7'b0100000: n132_o = 8'b00000000;
      7'b0010000: n132_o = b11_reg;
      7'b0001000: n132_o = b01_reg;
      7'b0000100: n132_o = 8'b00000000;
      7'b0000010: n132_o = 8'b00000000;
      7'b0000001: n132_o = 8'b00000000;
      default: n132_o = 8'bX;
    endcase
  /* src/matmul_engine_2x2.vhd:183:5  */
  always @*
    case (n108_o)
      7'b1000000: n140_o = 1'b0;
      7'b0100000: n140_o = 1'b1;
      7'b0010000: n140_o = 1'b1;
      7'b0001000: n140_o = 1'b1;
      7'b0000100: n140_o = 1'b1;
      7'b0000010: n140_o = 1'b0;
      7'b0000001: n140_o = 1'b0;
      default: n140_o = 1'bX;
    endcase
  /* src/matmul_engine_2x2.vhd:183:5  */
  always @*
    case (n108_o)
      7'b1000000: n145_o = 1'b0;
      7'b0100000: n145_o = 1'b0;
      7'b0010000: n145_o = 1'b0;
      7'b0001000: n145_o = 1'b0;
      7'b0000100: n145_o = 1'b0;
      7'b0000010: n145_o = 1'b1;
      7'b0000001: n145_o = 1'b0;
      default: n145_o = 1'bX;
    endcase
  /* src/matmul_engine_2x2.vhd:101:5  */
  always @(posedge clk)
    n148_q <= n39_o;
  initial
    n148_q = 8'b00000000;
  /* src/matmul_engine_2x2.vhd:101:5  */
  always @(posedge clk)
    n149_q <= n41_o;
  initial
    n149_q = 8'b00000000;
  /* src/matmul_engine_2x2.vhd:101:5  */
  always @(posedge clk)
    n150_q <= n43_o;
  initial
    n150_q = 8'b00000000;
  /* src/matmul_engine_2x2.vhd:101:5  */
  always @(posedge clk)
    n151_q <= n45_o;
  initial
    n151_q = 8'b00000000;
  /* src/matmul_engine_2x2.vhd:101:5  */
  always @(posedge clk)
    n152_q <= n47_o;
  initial
    n152_q = 8'b00000000;
  /* src/matmul_engine_2x2.vhd:101:5  */
  always @(posedge clk)
    n153_q <= n49_o;
  initial
    n153_q = 8'b00000000;
  /* src/matmul_engine_2x2.vhd:101:5  */
  always @(posedge clk)
    n154_q <= n51_o;
  initial
    n154_q = 8'b00000000;
  /* src/matmul_engine_2x2.vhd:101:5  */
  always @(posedge clk)
    n155_q <= n53_o;
  initial
    n155_q = 8'b00000000;
  /* src/matmul_engine_2x2.vhd:101:5  */
  always @(posedge clk)
    n156_q <= n55_o;
  initial
    n156_q = 3'b000;
endmodule


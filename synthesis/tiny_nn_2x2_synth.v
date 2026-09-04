module mac
  (input  clk,
   input  reset,
   input  enable,
   input  [7:0] a,
   input  [7:0] b,
   output [31:0] result);
  wire [31:0] accumulator;
  wire [15:0] n309_o;
  wire [15:0] n310_o;
  wire [15:0] n311_o;
  wire [31:0] n312_o;
  wire [31:0] n313_o;
  wire [31:0] n314_o;
  wire [31:0] n316_o;
  reg [31:0] n319_q;
  assign result = accumulator;
  /* src/mac.vhd:20:10  */
  assign accumulator = n319_q; // (signal)
  /* src/mac.vhd:29:46  */
  assign n309_o = {{8{a[7]}}, a}; // sext
  /* src/mac.vhd:29:46  */
  assign n310_o = {{8{b[7]}}, b}; // sext
  /* src/mac.vhd:29:46  */
  assign n311_o = n309_o * n310_o; // smul
  /* src/mac.vhd:29:38  */
  assign n312_o = {{16{n311_o[15]}}, n311_o}; // sext
  /* src/mac.vhd:29:36  */
  assign n313_o = accumulator + n312_o;
  /* src/mac.vhd:28:7  */
  assign n314_o = enable ? n313_o : accumulator;
  /* src/mac.vhd:26:7  */
  assign n316_o = reset ? 32'b00000000000000000000000000000000 : n314_o;
  /* src/mac.vhd:25:5  */
  always @(posedge clk)
    n319_q <= n316_o;
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
  wire [7:0] n293_o;
  wire [7:0] n294_o;
  wire [7:0] n296_o;
  wire [7:0] n298_o;
  wire [31:0] mac_unit_result;
  reg [7:0] n303_q;
  reg [7:0] n304_q;
  assign a_out = a_reg;
  assign b_out = b_reg;
  assign result = mac_unit_result;
  /* src/pe.vhd:22:10  */
  assign a_reg = n303_q; // (signal)
  /* src/pe.vhd:23:10  */
  assign b_reg = n304_q; // (signal)
  /* src/pe.vhd:31:7  */
  assign n293_o = enable ? a_in : a_reg;
  /* src/pe.vhd:31:7  */
  assign n294_o = enable ? b_in : b_reg;
  /* src/pe.vhd:28:7  */
  assign n296_o = reset ? 8'b00000000 : n293_o;
  /* src/pe.vhd:28:7  */
  assign n298_o = reset ? 8'b00000000 : n294_o;
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
    n303_q <= n296_o;
  /* src/pe.vhd:27:5  */
  always @(posedge clk)
    n304_q <= n298_o;
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

module relu_2
  (input  [31:0] data0,
   input  [31:0] data1,
   output [31:0] out0,
   output [31:0] out1);
  wire n262_o;
  wire [31:0] n263_o;
  wire n265_o;
  wire [31:0] n266_o;
  assign out0 = n263_o;
  assign out1 = n266_o;
  /* src/relu_2.vhd:14:37  */
  assign n262_o = data0[31];
  /* src/relu_2.vhd:14:27  */
  assign n263_o = n262_o ? 32'b00000000000000000000000000000000 : data0;
  /* src/relu_2.vhd:16:37  */
  assign n265_o = data1[31];
  /* src/relu_2.vhd:16:27  */
  assign n266_o = n265_o ? 32'b00000000000000000000000000000000 : data1;
endmodule

module bias_add_2
  (input  [31:0] data0,
   input  [31:0] data1,
   input  [31:0] bias0,
   input  [31:0] bias1,
   output [31:0] out0,
   output [31:0] out1);
  wire [31:0] n257_o;
  wire [31:0] n258_o;
  assign out0 = n257_o;
  assign out1 = n258_o;
  /* src/bias_add_2.vhd:21:17  */
  assign n257_o = data0 + bias0;
  /* src/bias_add_2.vhd:22:17  */
  assign n258_o = data1 + bias1;
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
  wire n140_o;
  wire n141_o;
  wire [7:0] n142_o;
  wire [7:0] n143_o;
  wire [7:0] n144_o;
  wire [7:0] n145_o;
  wire [7:0] n146_o;
  wire [7:0] n147_o;
  wire [7:0] n149_o;
  wire [7:0] n151_o;
  wire [7:0] n153_o;
  wire [7:0] n155_o;
  wire [7:0] n157_o;
  wire [7:0] n159_o;
  wire [2:0] n161_o;
  wire [2:0] n172_o;
  wire n174_o;
  wire n176_o;
  wire n178_o;
  wire n180_o;
  wire n182_o;
  wire n184_o;
  wire [5:0] n185_o;
  reg [2:0] n192_o;
  wire n196_o;
  wire n198_o;
  wire n200_o;
  wire n202_o;
  wire n204_o;
  wire n206_o;
  wire [5:0] n207_o;
  reg n211_o;
  reg [7:0] n216_o;
  reg [7:0] n221_o;
  reg [7:0] n226_o;
  reg [7:0] n233_o;
  reg n240_o;
  reg n245_o;
  reg [7:0] n248_q;
  reg [7:0] n249_q;
  reg [7:0] n250_q;
  reg [7:0] n251_q;
  reg [7:0] n252_q;
  reg [7:0] n253_q;
  reg [2:0] n254_q;
  assign y0 = array_result00;
  assign y1 = array_result10;
  assign done = n211_o;
  /* src/matvec_engine_2x2.vhd:33:10  */
  always @*
    w00_reg = n248_q; // (isignal)
  initial
    w00_reg = 8'b00000000;
  /* src/matvec_engine_2x2.vhd:34:10  */
  always @*
    w01_reg = n249_q; // (isignal)
  initial
    w01_reg = 8'b00000000;
  /* src/matvec_engine_2x2.vhd:35:10  */
  always @*
    w10_reg = n250_q; // (isignal)
  initial
    w10_reg = 8'b00000000;
  /* src/matvec_engine_2x2.vhd:36:10  */
  always @*
    w11_reg = n251_q; // (isignal)
  initial
    w11_reg = 8'b00000000;
  /* src/matvec_engine_2x2.vhd:37:10  */
  always @*
    x0_reg = n252_q; // (isignal)
  initial
    x0_reg = 8'b00000000;
  /* src/matvec_engine_2x2.vhd:38:10  */
  always @*
    x1_reg = n253_q; // (isignal)
  initial
    x1_reg = 8'b00000000;
  /* src/matvec_engine_2x2.vhd:41:10  */
  always @*
    array_a_row0 = n216_o; // (isignal)
  initial
    array_a_row0 = 8'b00000000;
  /* src/matvec_engine_2x2.vhd:42:10  */
  always @*
    array_a_row1 = n221_o; // (isignal)
  initial
    array_a_row1 = 8'b00000000;
  /* src/matvec_engine_2x2.vhd:43:10  */
  always @*
    array_b_col0 = n226_o; // (isignal)
  initial
    array_b_col0 = 8'b00000000;
  /* src/matvec_engine_2x2.vhd:44:10  */
  always @*
    array_b_col1 = n233_o; // (isignal)
  initial
    array_b_col1 = 8'b00000000;
  /* src/matvec_engine_2x2.vhd:46:10  */
  always @*
    array_enable = n240_o; // (isignal)
  initial
    array_enable = 1'b0;
  /* src/matvec_engine_2x2.vhd:47:10  */
  always @*
    array_reset = n245_o; // (isignal)
  initial
    array_reset = 1'b0;
  /* src/matvec_engine_2x2.vhd:49:10  */
  assign array_result00 = matvec_units_result00; // (signal)
  /* src/matvec_engine_2x2.vhd:50:10  */
  assign array_result10 = matvec_units_result10; // (signal)
  /* src/matvec_engine_2x2.vhd:61:10  */
  always @*
    current_state = n254_q; // (isignal)
  initial
    current_state = 3'b000;
  /* src/matvec_engine_2x2.vhd:62:10  */
  always @*
    next_state = n192_o; // (isignal)
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
  assign n140_o = current_state == 3'b000;
  /* src/matvec_engine_2x2.vhd:105:35  */
  assign n141_o = start & n140_o;
  /* src/matvec_engine_2x2.vhd:105:9  */
  assign n142_o = n141_o ? w00 : w00_reg;
  /* src/matvec_engine_2x2.vhd:105:9  */
  assign n143_o = n141_o ? w01 : w01_reg;
  /* src/matvec_engine_2x2.vhd:105:9  */
  assign n144_o = n141_o ? w10 : w10_reg;
  /* src/matvec_engine_2x2.vhd:105:9  */
  assign n145_o = n141_o ? w11 : w11_reg;
  /* src/matvec_engine_2x2.vhd:105:9  */
  assign n146_o = n141_o ? x0 : x0_reg;
  /* src/matvec_engine_2x2.vhd:105:9  */
  assign n147_o = n141_o ? x1 : x1_reg;
  /* src/matvec_engine_2x2.vhd:93:7  */
  assign n149_o = reset ? 8'b00000000 : n142_o;
  /* src/matvec_engine_2x2.vhd:93:7  */
  assign n151_o = reset ? 8'b00000000 : n143_o;
  /* src/matvec_engine_2x2.vhd:93:7  */
  assign n153_o = reset ? 8'b00000000 : n144_o;
  /* src/matvec_engine_2x2.vhd:93:7  */
  assign n155_o = reset ? 8'b00000000 : n145_o;
  /* src/matvec_engine_2x2.vhd:93:7  */
  assign n157_o = reset ? 8'b00000000 : n146_o;
  /* src/matvec_engine_2x2.vhd:93:7  */
  assign n159_o = reset ? 8'b00000000 : n147_o;
  /* src/matvec_engine_2x2.vhd:93:7  */
  assign n161_o = reset ? 3'b000 : next_state;
  /* src/matvec_engine_2x2.vhd:126:9  */
  assign n172_o = start ? 3'b001 : current_state;
  /* src/matvec_engine_2x2.vhd:125:7  */
  assign n174_o = current_state == 3'b000;
  /* src/matvec_engine_2x2.vhd:130:7  */
  assign n176_o = current_state == 3'b001;
  /* src/matvec_engine_2x2.vhd:133:7  */
  assign n178_o = current_state == 3'b010;
  /* src/matvec_engine_2x2.vhd:136:7  */
  assign n180_o = current_state == 3'b011;
  /* src/matvec_engine_2x2.vhd:139:7  */
  assign n182_o = current_state == 3'b100;
  /* src/matvec_engine_2x2.vhd:142:7  */
  assign n184_o = current_state == 3'b101;
  assign n185_o = {n184_o, n182_o, n180_o, n178_o, n176_o, n174_o};
  /* src/matvec_engine_2x2.vhd:124:5  */
  always @*
    case (n185_o)
      6'b100000: n192_o = 3'b000;
      6'b010000: n192_o = 3'b101;
      6'b001000: n192_o = 3'b100;
      6'b000100: n192_o = 3'b011;
      6'b000010: n192_o = 3'b010;
      6'b000001: n192_o = n172_o;
      default: n192_o = 3'bX;
    endcase
  /* src/matvec_engine_2x2.vhd:161:5  */
  assign n196_o = current_state == 3'b000;
  /* src/matvec_engine_2x2.vhd:164:5  */
  assign n198_o = current_state == 3'b001;
  /* src/matvec_engine_2x2.vhd:167:5  */
  assign n200_o = current_state == 3'b010;
  /* src/matvec_engine_2x2.vhd:174:5  */
  assign n202_o = current_state == 3'b011;
  /* src/matvec_engine_2x2.vhd:181:5  */
  assign n204_o = current_state == 3'b100;
  /* src/matvec_engine_2x2.vhd:188:5  */
  assign n206_o = current_state == 3'b101;
  assign n207_o = {n206_o, n204_o, n202_o, n200_o, n198_o, n196_o};
  /* src/matvec_engine_2x2.vhd:160:5  */
  always @*
    case (n207_o)
      6'b100000: n211_o = 1'b1;
      6'b010000: n211_o = 1'b0;
      6'b001000: n211_o = 1'b0;
      6'b000100: n211_o = 1'b0;
      6'b000010: n211_o = 1'b0;
      6'b000001: n211_o = 1'b0;
      default: n211_o = 1'bX;
    endcase
  /* src/matvec_engine_2x2.vhd:160:5  */
  always @*
    case (n207_o)
      6'b100000: n216_o = 8'b00000000;
      6'b010000: n216_o = 8'b00000000;
      6'b001000: n216_o = w01_reg;
      6'b000100: n216_o = w00_reg;
      6'b000010: n216_o = 8'b00000000;
      6'b000001: n216_o = 8'b00000000;
      default: n216_o = 8'bX;
    endcase
  /* src/matvec_engine_2x2.vhd:160:5  */
  always @*
    case (n207_o)
      6'b100000: n221_o = 8'b00000000;
      6'b010000: n221_o = w11_reg;
      6'b001000: n221_o = w10_reg;
      6'b000100: n221_o = 8'b00000000;
      6'b000010: n221_o = 8'b00000000;
      6'b000001: n221_o = 8'b00000000;
      default: n221_o = 8'bX;
    endcase
  /* src/matvec_engine_2x2.vhd:160:5  */
  always @*
    case (n207_o)
      6'b100000: n226_o = 8'b00000000;
      6'b010000: n226_o = 8'b00000000;
      6'b001000: n226_o = x1_reg;
      6'b000100: n226_o = x0_reg;
      6'b000010: n226_o = 8'b00000000;
      6'b000001: n226_o = 8'b00000000;
      default: n226_o = 8'bX;
    endcase
  /* src/matvec_engine_2x2.vhd:160:5  */
  always @*
    case (n207_o)
      6'b100000: n233_o = 8'b00000000;
      6'b010000: n233_o = 8'b00000000;
      6'b001000: n233_o = 8'b00000000;
      6'b000100: n233_o = 8'b00000000;
      6'b000010: n233_o = 8'b00000000;
      6'b000001: n233_o = 8'b00000000;
      default: n233_o = 8'bX;
    endcase
  /* src/matvec_engine_2x2.vhd:160:5  */
  always @*
    case (n207_o)
      6'b100000: n240_o = 1'b0;
      6'b010000: n240_o = 1'b1;
      6'b001000: n240_o = 1'b1;
      6'b000100: n240_o = 1'b1;
      6'b000010: n240_o = 1'b0;
      6'b000001: n240_o = 1'b0;
      default: n240_o = 1'bX;
    endcase
  /* src/matvec_engine_2x2.vhd:160:5  */
  always @*
    case (n207_o)
      6'b100000: n245_o = 1'b0;
      6'b010000: n245_o = 1'b0;
      6'b001000: n245_o = 1'b0;
      6'b000100: n245_o = 1'b0;
      6'b000010: n245_o = 1'b1;
      6'b000001: n245_o = 1'b0;
      default: n245_o = 1'bX;
    endcase
  /* src/matvec_engine_2x2.vhd:92:5  */
  always @(posedge clk)
    n248_q <= n149_o;
  initial
    n248_q = 8'b00000000;
  /* src/matvec_engine_2x2.vhd:92:5  */
  always @(posedge clk)
    n249_q <= n151_o;
  initial
    n249_q = 8'b00000000;
  /* src/matvec_engine_2x2.vhd:92:5  */
  always @(posedge clk)
    n250_q <= n153_o;
  initial
    n250_q = 8'b00000000;
  /* src/matvec_engine_2x2.vhd:92:5  */
  always @(posedge clk)
    n251_q <= n155_o;
  initial
    n251_q = 8'b00000000;
  /* src/matvec_engine_2x2.vhd:92:5  */
  always @(posedge clk)
    n252_q <= n157_o;
  initial
    n252_q = 8'b00000000;
  /* src/matvec_engine_2x2.vhd:92:5  */
  always @(posedge clk)
    n253_q <= n159_o;
  initial
    n253_q = 8'b00000000;
  /* src/matvec_engine_2x2.vhd:92:5  */
  always @(posedge clk)
    n254_q <= n161_o;
  initial
    n254_q = 3'b000;
endmodule

module requantize_2
  (input  [31:0] data0,
   input  [31:0] data1,
   output [7:0] out0,
   output [7:0] out1);
  wire [31:0] n96_o;
  wire [31:0] n98_o;
  wire n100_o;
  wire n102_o;
  wire [7:0] n103_o;
  wire [7:0] n105_o;
  wire [7:0] n107_o;
  wire n109_o;
  wire n111_o;
  wire [7:0] n112_o;
  wire [7:0] n114_o;
  wire [7:0] n116_o;
  assign out0 = n107_o;
  assign out1 = n116_o;
  /* src/requantize_2.vhd:19:16  */
  assign n96_o = $signed(data0) >> 31'b0000000000000000000000000000010;
  /* src/requantize_2.vhd:20:16  */
  assign n98_o = $signed(data1) >> 31'b0000000000000000000000000000010;
  /* src/requantize_2.vhd:22:16  */
  assign n100_o = $signed(n96_o) > $signed(32'b00000000000000000000000001111111);
  /* src/requantize_2.vhd:24:19  */
  assign n102_o = $signed(n96_o) < $signed(32'b11111111111111111111111110000000);
  /* src/requantize_2.vhd:27:17  */
  assign n103_o = n96_o[7:0];  // trunc
  /* src/requantize_2.vhd:24:5  */
  assign n105_o = n102_o ? 8'b10000000 : n103_o;
  /* src/requantize_2.vhd:22:5  */
  assign n107_o = n100_o ? 8'b01111111 : n105_o;
  /* src/requantize_2.vhd:31:16  */
  assign n109_o = $signed(n98_o) > $signed(32'b00000000000000000000000001111111);
  /* src/requantize_2.vhd:33:19  */
  assign n111_o = $signed(n98_o) < $signed(32'b11111111111111111111111110000000);
  /* src/requantize_2.vhd:36:17  */
  assign n112_o = n98_o[7:0];  // trunc
  /* src/requantize_2.vhd:33:5  */
  assign n114_o = n111_o ? 8'b10000000 : n112_o;
  /* src/requantize_2.vhd:31:5  */
  assign n116_o = n109_o ? 8'b01111111 : n114_o;
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
  assign y0 = relu_unit_out0;
  assign y1 = relu_unit_out1;
  assign done = matvec_unit_done;
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

module tiny_nn_2x2
  (input  clk,
   input  reset,
   input  start,
   input  [7:0] x0,
   input  [7:0] x1,
   input  [7:0] w1_00,
   input  [7:0] w1_01,
   input  [7:0] w1_10,
   input  [7:0] w1_11,
   input  [31:0] b1_0,
   input  [31:0] b1_1,
   input  [7:0] w2_00,
   input  [7:0] w2_01,
   input  [7:0] w2_10,
   input  [7:0] w2_11,
   input  [31:0] b2_0,
   input  [31:0] b2_1,
   output done,
   output [31:0] y0,
   output [31:0] y1);
  reg [31:0] l1_out0;
  reg [31:0] l1_out1;
  reg [7:0] hidden_q0;
  reg [7:0] hidden_q1;
  reg l1_start;
  reg l1_done;
  reg l2_start;
  reg l2_done;
  reg [2:0] current_state;
  reg [2:0] next_state;
  wire [31:0] l1_y0;
  wire [31:0] l1_y1;
  wire l1_done;
  wire [7:0] requant_out0;
  wire [7:0] requant_out1;
  wire [31:0] l2_y0;
  wire [31:0] l2_y1;
  wire l2_done;
  wire [2:0] n24_o;
  wire [2:0] n29_o;
  wire n31_o;
  wire n33_o;
  wire [2:0] n35_o;
  wire n37_o;
  wire n39_o;
  wire [2:0] n41_o;
  wire n43_o;
  wire n45_o;
  wire [5:0] n46_o;
  reg [2:0] n51_o;
  wire n55_o;
  wire n57_o;
  wire n59_o;
  wire [2:0] n60_o;
  reg n63_o;
  reg n67_o;
  reg n71_o;
  reg [2:0] n74_q;
  assign done = n63_o;
  assign y0 = l2_y0;
  assign y1 = l2_y1;
  /* src/tiny_nn_2x2.vhd:33:10  */
  always @*
    l1_out0 = l1_y0; // (isignal)
  initial
    l1_out0 = 32'b00000000000000000000000000000000;
  /* src/tiny_nn_2x2.vhd:34:10  */
  always @*
    l1_out1 = l1_y1; // (isignal)
  initial
    l1_out1 = 32'b00000000000000000000000000000000;
  /* src/tiny_nn_2x2.vhd:35:10  */
  always @*
    hidden_q0 = requant_out0; // (isignal)
  initial
    hidden_q0 = 8'b00000000;
  /* src/tiny_nn_2x2.vhd:36:10  */
  always @*
    hidden_q1 = requant_out1; // (isignal)
  initial
    hidden_q1 = 8'b00000000;
  /* src/tiny_nn_2x2.vhd:37:10  */
  always @*
    l1_start = n67_o; // (isignal)
  initial
    l1_start = 1'b0;
  /* src/tiny_nn_2x2.vhd:38:10  */
  always @*
    l1_done = l1_done; // (isignal)
  initial
    l1_done = 1'b0;
  /* src/tiny_nn_2x2.vhd:39:10  */
  always @*
    l2_start = n71_o; // (isignal)
  initial
    l2_start = 1'b0;
  /* src/tiny_nn_2x2.vhd:40:10  */
  always @*
    l2_done = l2_done; // (isignal)
  initial
    l2_done = 1'b0;
  /* src/tiny_nn_2x2.vhd:51:10  */
  always @*
    current_state = n74_q; // (isignal)
  initial
    current_state = 3'b000;
  /* src/tiny_nn_2x2.vhd:52:10  */
  always @*
    next_state = n51_o; // (isignal)
  initial
    next_state = 3'b000;
  /* src/tiny_nn_2x2.vhd:54:3  */
  dense_layer_2x2 l1 (
    .clk(clk),
    .reset(reset),
    .start(l1_start),
    .w00(w1_00),
    .w01(w1_01),
    .w10(w1_10),
    .w11(w1_11),
    .x0(x0),
    .x1(x1),
    .bias0(b1_0),
    .bias1(b1_1),
    .y0(l1_y0),
    .y1(l1_y1),
    .done(l1_done));
  /* src/tiny_nn_2x2.vhd:78:3  */
  requantize_2 requant (
    .data0(l1_out0),
    .data1(l1_out1),
    .out0(requant_out0),
    .out1(requant_out1));
  /* src/tiny_nn_2x2.vhd:87:3  */
  dense_layer_2x2 l2 (
    .clk(clk),
    .reset(reset),
    .start(l2_start),
    .w00(w2_00),
    .w01(w2_01),
    .w10(w2_10),
    .w11(w2_11),
    .x0(hidden_q0),
    .x1(hidden_q1),
    .bias0(b2_0),
    .bias1(b2_1),
    .y0(l2_y0),
    .y1(l2_y1),
    .done(l2_done));
  /* src/tiny_nn_2x2.vhd:114:7  */
  assign n24_o = reset ? 3'b000 : next_state;
  /* src/tiny_nn_2x2.vhd:127:9  */
  assign n29_o = start ? 3'b001 : current_state;
  /* src/tiny_nn_2x2.vhd:126:7  */
  assign n31_o = current_state == 3'b000;
  /* src/tiny_nn_2x2.vhd:131:7  */
  assign n33_o = current_state == 3'b001;
  /* src/tiny_nn_2x2.vhd:135:9  */
  assign n35_o = l1_done ? 3'b011 : current_state;
  /* src/tiny_nn_2x2.vhd:134:7  */
  assign n37_o = current_state == 3'b010;
  /* src/tiny_nn_2x2.vhd:139:7  */
  assign n39_o = current_state == 3'b011;
  /* src/tiny_nn_2x2.vhd:143:9  */
  assign n41_o = l2_done ? 3'b101 : current_state;
  /* src/tiny_nn_2x2.vhd:142:7  */
  assign n43_o = current_state == 3'b100;
  /* src/tiny_nn_2x2.vhd:146:7  */
  assign n45_o = current_state == 3'b101;
  assign n46_o = {n45_o, n43_o, n39_o, n37_o, n33_o, n31_o};
  /* src/tiny_nn_2x2.vhd:125:5  */
  always @*
    case (n46_o)
      6'b100000: n51_o = 3'b000;
      6'b010000: n51_o = n41_o;
      6'b001000: n51_o = 3'b100;
      6'b000100: n51_o = n35_o;
      6'b000010: n51_o = 3'b010;
      6'b000001: n51_o = n29_o;
      default: n51_o = 3'bX;
    endcase
  /* src/tiny_nn_2x2.vhd:158:9  */
  assign n55_o = current_state == 3'b001;
  /* src/tiny_nn_2x2.vhd:161:9  */
  assign n57_o = current_state == 3'b011;
  /* src/tiny_nn_2x2.vhd:164:9  */
  assign n59_o = current_state == 3'b101;
  assign n60_o = {n59_o, n57_o, n55_o};
  /* src/tiny_nn_2x2.vhd:157:5  */
  always @*
    case (n60_o)
      3'b100: n63_o = 1'b1;
      3'b010: n63_o = 1'b0;
      3'b001: n63_o = 1'b0;
      default: n63_o = 1'b0;
    endcase
  /* src/tiny_nn_2x2.vhd:157:5  */
  always @*
    case (n60_o)
      3'b100: n67_o = 1'b0;
      3'b010: n67_o = 1'b0;
      3'b001: n67_o = 1'b1;
      default: n67_o = 1'b0;
    endcase
  /* src/tiny_nn_2x2.vhd:157:5  */
  always @*
    case (n60_o)
      3'b100: n71_o = 1'b0;
      3'b010: n71_o = 1'b1;
      3'b001: n71_o = 1'b0;
      default: n71_o = 1'b0;
    endcase
  /* src/tiny_nn_2x2.vhd:113:5  */
  always @(posedge clk)
    n74_q <= n24_o;
  initial
    n74_q = 3'b000;
endmodule


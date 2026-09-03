# INT8 Neural Network Accelerator in VHDL

A neural-network inference accelerator implemented in VHDL using signed INT8 arithmetic, INT32 accumulation, and a systolic-array datapath.

The project is being developed incrementally from a single multiply-accumulate unit into a complete quantized neural-network inference pipeline.

---

## Current Architecture

```text
INT8 Inputs / Weights
        ↓
       MAC
        ↓
 Processing Element
        ↓
 2×2 Systolic Array
        ↓
 Matrix-Vector Engine
        ↓
     Bias Add
        ↓
       ReLU
        ↓
  2-Neuron Dense Layer     ← CURRENT MILESTONE
        ↓
 Tiny Multi-Layer NN       ← NEXT
```

The currently implemented dense layer computes:

```text
y = ReLU(Wx + b)
```

---

## Arithmetic Format

```text
Inputs        : signed INT8
Weights       : signed INT8

INT8 × INT8
      ↓
16-bit product
      ↓
INT32 accumulator

Bias          : signed INT32
Dense outputs : signed INT32
```

---

# Implemented Modules

## `mac.vhd` ✅

Signed multiply-accumulate unit:

```text
accumulator ← accumulator + (a × b)
```

Features:

- signed 8-bit operands
- 32-bit accumulator
- synchronous reset
- enable control

---

## `pe.vhd` ✅

Processing Element containing:

- one MAC
- horizontal A forwarding register
- vertical B forwarding register
- local INT32 accumulator

```text
          B in
            ↓
A in → [ PE ] → A out
            ↓
          B out
```

---

## `pe_chain_2.vhd` ✅

Two connected PEs used to verify:

- registered forwarding
- one-clock propagation between PEs
- independent accumulation

---

## `pe_array_2x2.vhd` ✅

2×2 systolic array containing four PEs.

```text
             B0             B1
              ↓              ↓

A0 →       [PE00]  →      [PE01]
              ↓              ↓
A1 →       [PE10]  →      [PE11]
              ↓              ↓
```

Data movement:

```text
A → left to right
B → top to bottom
```

Each PE performs MAC operations concurrently.

For matrix multiplication:

```text
PE00 → C00
PE01 → C01
PE10 → C10
PE11 → C11
```

---

# Automatic Matrix Multiplication

## `matmul_engine_2x2.vhd` ✅

Adds an FSM and scheduler around the systolic array.

For:

```text
A = [a00 a01]

    [a10 a11]

B = [b00 b01]

    [b10 b11]
```

the accelerator computes:

```text
C = A × B
```

The scheduler skews the inputs so the correct values meet at the correct PE.

```text
Cycle 1:
Arow0 = a00
Arow1 = 0
Bcol0 = b00
Bcol1 = 0

Cycle 2:
Arow0 = a01
Arow1 = a10
Bcol0 = b10
Bcol1 = b01

Cycle 3:
Arow0 = 0
Arow1 = a11
Bcol0 = 0
Bcol1 = b11

Cycle 4:
all external inputs = 0
```

FSM:

```text
IDLE
 ↓
CLEAR
 ↓
CYCLE1
 ↓
CYCLE2
 ↓
CYCLE3
 ↓
CYCLE4
 ↓
DONE
```

### Verified Example

```text
A = [1 2]       B = [5 6]

    [3 4]           [7 8]
```

Result:

```text
C = [19 22]

    [43 50]
```

---

# Matrix-Vector Engine

## `matvec_engine_2x2.vhd` ✅

Implements:

```text
y = W × x
```

For:

```text
W = [w00 w01]       x = [x0]

    [w10 w11]           [x1]
```

the outputs are:

```text
y0 = w00*x0 + w01*x1
y1 = w10*x0 + w11*x1
```

The left column of the systolic array performs the useful computation.

Scheduler:

```text
Cycle 1:
Arow0 = w00
Arow1 = 0
Bcol0 = x0

Cycle 2:
Arow0 = w01
Arow1 = w10
Bcol0 = x1

Cycle 3:
Arow0 = 0
Arow1 = w11
Bcol0 = 0
```

### Verified Example

```text
W = [1 2]

    [3 4]

x = [5]

    [6]
```

Result:

```text
y = [17]

    [39]
```

Observed accumulation:

```text
y0: 0 → 5  → 17
y1: 0 → 15 → 39
```

---

# Bias Addition

## `bias_add_2.vhd` ✅

Adds one bias value to each neuron output.

```text
z0 = data0 + bias0
z1 = data1 + bias1
```

This block is purely combinational.

Verified example:

```text
data = [17, 39]
bias = [-7, 3]

output = [10, 42]
```

---

# ReLU Activation

## `relu_2.vhd` ✅

Implements:

```text
ReLU(x) = max(0, x)
```

For signed INT32 values, bit 31 is the sign bit:

```text
MSB = 1 → negative → output 0
MSB = 0 → non-negative → preserve value
```

Implemented as combinational logic.

Verified cases include:

```text
-5  → 0
 5  → 5
 0  → 0
-10 → 0
```

---

# Dense Neural-Network Layer

## `dense_layer_2x2.vhd` ✅

This is the first complete neural-network layer in the project.

It combines:

```text
matvec_engine_2x2
        ↓
bias_add_2
        ↓
relu_2
```

and computes:

```text
y = ReLU(Wx + b)
```

Internal architecture:

```text
INT8 input vector
      +
INT8 weights
      ↓
Matrix-Vector Engine
      ↓
INT32 MatVec Result
      ↓
Bias Addition
      ↓
ReLU
      ↓
INT32 Layer Output
```

### Verified Dense-Layer Example

```text
W = [1 2]

    [3 4]

x = [5]

    [6]

bias = [-20]

       [  3]
```

Matrix-vector result:

```text
Wx = [17]

     [39]
```

After bias:

```text
Wx + b = [-3]

         [42]
```

After ReLU:

```text
y = [0]

    [42]
```

The complete dense-layer testbench passes successfully.

---

# Verification

Modules currently verified with VHDL testbenches:

```text
MAC                         ✅
Processing Element          ✅
PE forwarding chain         ✅
2×2 systolic array          ✅
Manual matrix multiply      ✅
Automatic MatMul engine     ✅
Matrix-vector engine        ✅
Bias addition               ✅
ReLU                        ✅
Dense layer                 ✅
```

Simulation is performed using GHDL.

Waveforms are exported as VCD files and viewed using Surfer.

---

# Synthesis

RTL synthesis flow:

```text
VHDL
 ↓
GHDL --synth
 ↓
Verilog netlist
 ↓
Yosys
 ↓
Statistics + RTL schematic
```

Yosys reports are used to inspect inferred hardware including:

- multipliers
- adders
- registers
- multiplexers
- FSM/control logic

Graphviz is used to generate SVG schematics.

Major synthesized blocks currently include the MAC, PE hierarchy, systolic array, MatMul engine, and MatVec engine.

Dense-layer synthesis and waveform capture are the next documentation checkpoint.

---

# Tools

- VHDL-2008
- GHDL
- Yosys
- Graphviz
- TerosHDL
- VHDL-LS
- Surfer
- VS Code
- WSL2 / Ubuntu
- Git / GitHub

---

# Project Structure

```text
.
├── src/
│   ├── mac.vhd
│   ├── pe.vhd
│   ├── pe_chain_2.vhd
│   ├── pe_array_2x2.vhd
│   ├── matmul_engine_2x2.vhd
│   ├── matvec_engine_2x2.vhd
│   ├── bias_add_2.vhd
│   ├── relu_2.vhd
│   └── dense_layer_2x2.vhd
│
├── tb/
│   ├── ...
│   ├── matvec_engine_2x2_tb.vhd
│   ├── bias_add_2_tb.vhd
│   ├── relu_2_tb.vhd
│   └── dense_layer_2x2_tb.vhd
│
├── synthesis/
│   ├── synthesized Verilog
│   ├── Yosys statistics
│   ├── DOT graphs
│   └── SVG schematics
│
├── waveforms/
│   └── VCD waveforms
│
└── README.md
```

---

# Progress

```text
INT8 MAC                          ✅
↓
Processing Element               ✅
↓
PE Chain                         ✅
↓
2×2 Systolic Array               ✅
↓
Manual Matrix Multiplication     ✅
↓
Automatic MatMul Engine          ✅
↓
Matrix-Vector Engine             ✅
↓
Bias Addition                    ✅
↓
ReLU                             ✅
↓
2-Neuron Dense Layer             ✅  ← CURRENT CHECKPOINT
↓
Dense Layer Waveform/Synthesis   ⏳
↓
Tiny Multi-Layer Neural Network  NEXT
↓
Inter-Layer Requantization
↓
Python Reference Model
↓
INT8 Weight Export
↓
VHDL vs Python Verification
↓
4×4 Systolic Array
↓
Input / Weight Buffers
↓
Top-Level Inference Controller
↓
Final Synthesis / Resource Study
↓
Documentation / Portfolio Polish
```

---

# Next Milestone

The next stage is to connect multiple dense layers into a tiny complete neural network.

Initial target:

```text
2 INT8 Inputs
      ↓
Dense Layer 1
2 Hidden Neurons
      ↓
Requantization
      ↓
Dense Layer 2
      ↓
2 Output Scores
      ↓
Prediction
```

The main new challenge will be converting the INT32 output of one dense layer back into an INT8 representation suitable for the next layer.

After the hardware pipeline is working, a Python reference model will be used to generate expected inference results and verify the VHDL implementation.

---

# Final Goal

Build a complete INT8 neural-network inference accelerator capable of:

- accepting quantized inputs
- processing trained INT8 weights
- performing systolic MAC computation
- executing dense neural-network layers
- applying bias and activation functions
- executing a small multi-layer network
- comparing hardware inference against a Python golden model
- scaling from a 2×2 to a 4×4 systolic architecture
- analyzing synthesized hardware resources and architecture
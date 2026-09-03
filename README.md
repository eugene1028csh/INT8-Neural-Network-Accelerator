# INT8 Neural Network Accelerator in VHDL

A hardware accelerator for neural-network inference implemented in VHDL.

The project is being developed incrementally from a single INT8 multiply-accumulate unit into a systolic-array-based neural-network accelerator. The current design supports automatic 2×2 matrix multiplication and 2×2 matrix-vector multiplication using signed INT8 operands and INT32 accumulation.

The long-term goal is to run a small quantized neural network in hardware and verify its inference results against a Python reference model.

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
 MatMul / MatVec Engine
        ↓
      Bias        ← next
        ↓
      ReLU
        ↓
   Dense Layer
        ↓
 Tiny Neural Network
```

### Arithmetic Format

- Inputs: signed INT8
- Weights: signed INT8
- Multiplication: INT8 × INT8
- Product: 16-bit
- Accumulation: signed INT32

---

## Implemented Modules

### `mac.vhd`

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

### `pe.vhd`

Processing Element containing:

- one MAC unit
- registered horizontal forwarding of `A`
- registered vertical forwarding of `B`

Dataflow:

```text
          B in
            ↓
A in → [ PE ] → A out
            ↓
          B out
```

Each PE accumulates its own local result.

---

### `pe_chain_2.vhd`

Two connected Processing Elements used to verify one-cycle data propagation between PEs.

---

### `pe_array_2x2.vhd`

2×2 systolic array containing four Processing Elements.

```text
             B0             B1
              ↓              ↓

A0 →       [PE00]  →      [PE01]
              ↓              ↓
A1 →       [PE10]  →      [PE11]
              ↓              ↓
```

- `A` values propagate left → right
- `B` values propagate top → bottom
- each PE performs MAC operations concurrently

For matrix multiplication:

```text
PE00 → C00
PE01 → C01
PE10 → C10
PE11 → C11
```

---

## Automatic 2×2 Matrix Multiplication

### `matmul_engine_2x2.vhd`

Wraps the systolic array with an FSM and input scheduler.

For:

```text
A = [a00 a01]      B = [b00 b01]
    [a10 a11]          [b10 b11]
```

the engine computes:

```text
C = A × B
```

The scheduler automatically skews the matrix data so the correct operands meet inside each PE.

```text
Cycle 1:
Arow0 = a00    Arow1 = 0
Bcol0 = b00    Bcol1 = 0

Cycle 2:
Arow0 = a01    Arow1 = a10
Bcol0 = b10    Bcol1 = b01

Cycle 3:
Arow0 = 0      Arow1 = a11
Bcol0 = 0      Bcol1 = b11

Cycle 4:
0, 0, 0, 0
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
A = [1 2]
    [3 4]

B = [5 6]
    [7 8]
```

Result:

```text
C = [19 22]
    [43 50]
```

---

## Automatic Matrix-Vector Multiplication

### `matvec_engine_2x2.vhd`

Implements:

```text
y = W × x
```

where:

```text
W = [w00 w01]      x = [x0]
    [w10 w11]          [x1]
```

giving:

```text
y0 = w00*x0 + w01*x1
y1 = w10*x0 + w11*x1
```

Only the left column of the current 2×2 systolic array is required for the two output values.

The scheduler feeds:

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

Expected and simulated result:

```text
y = [17]
    [39]
```

The waveform shows the accumulators building the outputs over successive clock cycles:

```text
y0: 0 → 5  → 17
y1: 0 → 15 → 39
```

---

## Verification

Each major module is tested using VHDL testbenches and GHDL simulation.

Current verification includes:

- MAC arithmetic
- signed multiplication
- accumulator enable/hold behaviour
- PE forwarding
- PE-chain propagation
- 2×2 systolic-array operation
- automatic matrix multiplication
- automatic matrix-vector multiplication
- FSM/scheduler behaviour

Waveforms are exported as VCD files and inspected using Surfer.

---

## Synthesis

The design is synthesized using:

```text
VHDL
 ↓
GHDL synthesis
 ↓
Verilog netlist
 ↓
Yosys
 ↓
RTL statistics / schematics
```

Synthesis reports are used to inspect inferred hardware such as:

- multipliers
- adders
- registers
- multiplexers
- FSM/control logic

Graphviz is used with Yosys to generate RTL schematics.

---

## Tools

- VHDL-2008
- GHDL
- Yosys
- Graphviz
- TerosHDL
- VHDL-LS
- Surfer
- VS Code / GitHub Codespaces

---

## Project Structure

```text
.
├── src/
│   ├── mac.vhd
│   ├── pe.vhd
│   ├── pe_chain_2.vhd
│   ├── pe_array_2x2.vhd
│   ├── matmul_engine_2x2.vhd
│   └── matvec_engine_2x2.vhd
│
├── tb/
│   └── testbenches
│
├── synthesis/
│   ├── synthesized Verilog
│   ├── Yosys statistics
│   └── RTL schematics
│
├── waveforms/
│   └── simulation waveforms
│
└── README.md
```

---

## Roadmap

Current progress:

```text
MAC                         ✅
Processing Element          ✅
PE Chain                    ✅
2×2 Systolic Array          ✅
2×2 Matrix Multiplication   ✅
Automatic MatMul Engine     ✅
Matrix-Vector Engine        ✅
Bias Addition               🚧
ReLU
Dense Layer
Tiny Multi-Layer NN
INT8 Quantization
Python Reference Model
VHDL vs Python Verification
4×4 Systolic Array
Input / Weight Buffers
Top-Level Inference Control
Final Synthesis Analysis
```

The next stage is:

```text
Matrix-Vector Output
        ↓
     + Bias
        ↓
       ReLU
        ↓
   Dense Layer
```

---

## Final Goal

The completed accelerator will accept quantized neural-network inputs and weights, execute inference using hardware MAC operations and systolic dataflow, and compare its output against a Python golden/reference model.

The project is intended as a hands-on exploration of:

- digital hardware design
- systolic architectures
- pipelining and dataflow
- finite-state-machine control
- fixed-point / quantized neural-network inference
- RTL verification
- synthesis and hardware-resource analysis
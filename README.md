## Architecture and Results

The project implements an **INT8 neural-network accelerator in VHDL** based on a **4×4 systolic array of 16 processing elements (PEs)**. Each PE contains an INT8 × INT8 MAC with INT32 accumulation.

```text
 INT8 Input Buffer ──┐
                     │
                     ▼
                ┌──────────────┐
 INT8 Weight ──►│ 4×4 MatVec   │
    Buffer      │    Engine    │
                └──────┬───────┘
                       │ INT32
                       ▼
 INT32 Bias ─────► Bias Addition
    Buffer              │
                        ▼
                       ReLU
                        │
                        ▼
                 Output Buffer
                        │
                        ▼
                   INT32 Outputs

              FSM Controller
                     │
                     └────► start / control
```

### 4×4 Systolic Array

```text
              B0      B1      B2      B3
               ↓       ↓       ↓       ↓
A0 ────────► [PE00]─►[PE01]─►[PE02]─►[PE03]
               ↓       ↓       ↓       ↓
A1 ────────► [PE10]─►[PE11]─►[PE12]─►[PE13]
               ↓       ↓       ↓       ↓
A2 ────────► [PE20]─►[PE21]─►[PE22]─►[PE23]
               ↓       ↓       ↓       ↓
A3 ────────► [PE30]─►[PE31]─►[PE32]─►[PE33]

Each PE:
INT8 A × INT8 B → INT32 accumulator
```

For an input vector `x`, weight matrix `W`, and bias vector `b`, the integrated accelerator computes:

```text
y = ReLU(Wx + b)
```

Input, weight, bias, and output buffers are controlled through write interfaces, while an FSM manages execution using a `start` / `done` handshake.

A configurable INT8 requantization unit has also been implemented and verified separately for future multi-layer operation.

## Verification

The design was verified incrementally from individual MACs and PEs through the 2×2 and 4×4 systolic arrays, MatMul/MatVec engines, activation logic, buffers, and final top level.

The integrated accelerator was verified using both directed and randomized self-checking testbenches.

The randomized testbench generates weights, inputs, and biases using VHDL `uniform()`, calculates the expected result internally, and automatically compares it against the hardware output:

```text
expected = ReLU(Wx + b)
```

A total of **100 randomized end-to-end transactions** were executed, producing **400 automatic output comparisons**, with all tests passing.

Tests were performed consecutively without resetting between transactions to also verify correct accelerator reuse.

## Synthesis Results

The design was synthesized using **GHDL and Yosys**.

| Resource | Count |
|---|---:|
| Processing Elements | 16 |
| Multipliers (`$mul`) | 16 |
| Adders (`$add`) | 21 |
| Register cells (`$sdffe`) | 79 |
| Multiplexers (`$mux`) | 17 |
| Priority multiplexers (`$pmux`) | 18 |
| Total generic cells | 295 |

The 16 inferred multipliers correspond to the 16 MAC units in the systolic array. The current buffers are implemented using registers rather than inferred RAM.

These are generic Yosys synthesis results, not FPGA-specific LUT, DSP, or BRAM utilization figures.

## Performance

Using a **100 MHz simulation clock (10 ns period)**, waveform analysis measured:

```text
start accepted → done = 10 clock cycles
```

giving a compute latency of approximately:

```text
10 cycles × 10 ns = 100 ns
```

A 4×4 matrix-vector operation performs **16 useful MAC operations**, corresponding to approximately **160 MMAC/s** when normalized to this simulated transaction latency.

The 100 MHz clock is a simulation assumption rather than a measured maximum hardware frequency. FPGA timing analysis would be required to determine the achievable clock rate.

## Current Status

The accelerator core is now functionally complete and verified.

The next major stage is **RISC-V / MMIO integration**, allowing software to load operands, start execution, monitor accelerator status, and read the resulting outputs.
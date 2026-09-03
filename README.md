# Mini INT8 Neural Network Accelerator in VHDL

A learning project to build a small neural-network inference accelerator from scratch in VHDL.

## End Goal

- INT8 neural-network inference
- Multiply-Accumulate (MAC) units
- Processing Elements (PEs)
- 2x2 PE array
- 4x4 systolic/MAC array
- Input and weight buffers
- Controller FSM
- ReLU
- Matrix-vector multiplication
- Run a tiny trained neural network
- Verify hardware outputs against Python

## Current Progress

### Completed
- [x] INT8 MAC
- [x] MAC testbench
- [x] Signed multiplication
- [x] 32-bit accumulation
- [x] Enable/hold behavior
- [x] Processing Element
- [x] PE forwarding registers
- [x] PE testbench
- [x] Self-checking assertions
- [x] Waveform testing with GHDL/VCD

### Next
- [ ] Build `pe_chain_2.vhd`
- [ ] Build `pe_chain_2_tb.vhd`
- [ ] Observe data moving from PE0 -> PE1
- [ ] Build 2x2 PE array

## Architecture So Far

MAC:

    acc <= acc + (a * b)

Data widths:

    Input A      : signed INT8
    Input B      : signed INT8
    Product      : signed INT16
    Accumulator  : signed INT32

PE:

    a_in ----+----> MAC
             |
             +----> register ----> a_out

    b_in ----+----> MAC
             |
             +----> register ----> b_out

Each PE performs a MAC operation while forwarding its inputs to the next PE.

## Project Structure

    MAC_Accelerator/
    ├── src/
    │   ├── mac.vhd
    │   ├── pe.vhd
    │   └── pe_chain_2.vhd
    │
    ├── tb/
    │   ├── mac_tb.vhd
    │   └── pe_tb.vhd
    │
    └── README.md

## Tools

### Installed in Codespaces
- GHDL

### VS Code Extensions
- TerosHDL
- Surfer
- VHDL

## Running with GHDL

From the `MAC_Accelerator` directory:

### MAC

    ghdl -a --std=08 src/mac.vhd
    ghdl -a --std=08 tb/mac_tb.vhd
    ghdl -e --std=08 mac_tb
    ghdl -r --std=08 mac_tb --stop-time=60ns --vcd=mac_tb.vcd

### Processing Element

    ghdl -a --std=08 src/mac.vhd
    ghdl -a --std=08 src/pe.vhd
    ghdl -a --std=08 tb/pe_tb.vhd
    ghdl -e --std=08 pe_tb
    ghdl -r --std=08 pe_tb --stop-time=60ns --vcd=pe_tb.vcd

## Important Concepts Learned

- Entity = external interface of a hardware block
- Architecture = internal implementation
- Signals declared inside an architecture connect/store internal values
- `signed(7 downto 0)` represents INT8 values
- INT8 x INT8 produces a 16-bit product
- A wider 32-bit accumulator prevents overflow when many products are added
- Registers update on rising clock edges
- Multiple VHDL processes/components operate concurrently
- `enable = 0` causes registers to retain their previous values
- PE forwarding registers introduce one clock-cycle movement between PEs
- VHDL assertions allow self-checking testbenches

## Current Checkpoint

Next session:

Build two connected Processing Elements:

    a_in -> PE0 -> a_link -> PE1 -> a_out
    b_in -> PE0 -> b_link -> PE1 -> b_out

PE0 and PE1 each contain their own MAC.

The main thing to observe will be that PE1 receives PE0's forwarded values one clock cycle later.

## Progress Log — 12 Aug 2026

### Completed Today

#### 1. Built a 2×2 PE Systolic Array

Created:

`src/pe_array_2x2.vhd`

The array contains four Processing Elements:

```text
                B0              B1
                ↓               ↓
           +---------+     +---------+
A0 ------> |  PE00   | --> |  PE01   | ------> A0 out
           +----+----+     +----+----+
                |               |
                ↓               ↓
           +---------+     +---------+
A1 ------> |  PE10   | --> |  PE11   | ------> A1 out
           +----+----+     +----+----+
                |               |
                ↓               ↓
             B0 out          B1 out
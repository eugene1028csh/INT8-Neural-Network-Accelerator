# INT8 Neural Network Accelerator

A VHDL-based INT8 neural-network inference accelerator built incrementally from MAC units to a trained, quantized 2-layer neural network.

## Progress Tracker

- ✅ INT8 MAC
- ✅ Processing Element
- ✅ PE chain
- ✅ 2×2 systolic array
- ✅ Manual 2×2 MatMul
- ✅ Automatic 2×2 MatMul engine
- ✅ 2×2 MatVec engine
- ✅ Bias add
- ✅ ReLU
- ✅ Dense layer
- ✅ INT32 → INT8 requantization
- ✅ Tiny 2-layer NN controller
- ✅ Testbenches + waveforms
- ✅ Synthesis + Yosys stats/schematics
- ✅ Python reference model
- ✅ Automated Python ↔ VHDL verification
- ✅ Train XOR NN in Python
- ✅ Quantize trained weights/inputs/biases
- ✅ Scale-aware fixed-point requantization
- ✅ Integer-only Python inference: 4/4 XOR
- ✅ Trained quantized NN running in VHDL: 4/4 XOR
- ⬜ Configurable requantizer
- ⬜ 4×4 systolic array
- ⬜ 4×4 MatMul / MatVec
- ⬜ Input / weight / bias / output buffers
- ⬜ Top-level accelerator controller
- ⬜ Randomized verification
- ⬜ Final synthesis + performance analysis
- ⬜ RISC-V + MMIO integration

## Latest Updates

- Trained a 2-layer XOR neural network using SGD in Python.
- Quantized trained weights to INT8 and biases to INT32.
- Replaced arbitrary `>> 2` requantization with fixed-point `×414 >> 16`.
- Verified the full integer network in Python with 4/4 XOR accuracy.
- Loaded trained quantized parameters into VHDL and achieved 4/4 XOR inference.

## Current Status

**Phase 1: Tiny trained INT8 neural-network accelerator — COMPLETE ✅**

Next: understand and clean up the current training/requantization flow before scaling to a 4×4 architecture.
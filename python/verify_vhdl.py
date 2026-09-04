import subprocess
import re
import numpy as np

def relu(x):
    return np.maximum(x,0)

def requantize(x):
    shifted = x >> 2
    return np.clip(shifted,-128,127).astype(np.int8)

x = np.array([4,4], dtype =np.int8)
W1 = np.array([[2,2],
              [1,3]], dtype = np.int8)
b1 = np.array([0,0], dtype = np.int32)

W2 = np.array([[2,1],
              [1,2]], dtype = np.int8)
b2 = np.array([1,-20], dtype = np.int32)

l1 = W1.astype(np.int32) @ x.astype(np.int32) +b1
l1 = relu(l1)

hiddenq = requantize(l1)

l2= W2.astype(np.int32) @ hiddenq.astype(np.int32) + b2
expected = relu(l2)

result = subprocess.run(
    ["ghdl",
     "-r",
     "--std=08",
     "tiny_nn_2x2_tb",
     "--stop-time=300ns"],
     capture_output = True,
     text  = True
)

sim_output = result.stdout + result.stderr

if result.returncode != 0:
    raise RuntimeError(sim_output)

print(sim_output)

match = re.search(
    r"VHDL_OUTPUT y0=(-?\d+)\s+y1=(-?\d+)",
    sim_output
)


if not match:
    raise RuntimeError("Could not find this VHDL output")

vhdl_output = np.array([
    int(match.group(1)),
    int(match.group(2))
], dtype = np.int32)

print("Python expected:", expected)
print("VHDL output:    ", vhdl_output)

if np.array_equal(expected, vhdl_output):
    print("PASS: Python and VHDL match")
else:
    print("FAIL: Python and VHDL differ")

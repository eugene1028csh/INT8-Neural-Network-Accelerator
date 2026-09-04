import numpy as np

def quantize_symmetric(x):
    max_abs = np.max(np.abs(x))
    scale = max_abs/ 127.0

    q = np.round(x/scale)
    q = np.clip(q,-127,127).astype(np.int8)

    return q, scale

weights = np.array([-0.8,0.2,0.5,1.0], dtype = np.float32)

q_weights, scale = quantize_symmetric(weights)

print("Original:", weights)
print("Quantized:", q_weights)
print("Scale:", scale)
print("Dequantized", q_weights.astype(np.float32)*scale)
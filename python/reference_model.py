import numpy as np

def relu(x):
    return np.maximum(x,0)

def requantize(x):
    shifted = x >> 2
    return np.clip(shifted, -128, 127).astype(np.int8)

x = np.array([4, 4], dtype=np.int8)

W1 = np.array([
    [2,2],
    [1,3]
], dtype = np.int8)

b1 = np.array([0,0], dtype = np.int32)

W2 = np.array([
    [2,1],
    [1,2]
], dtype = np.int8)

b2 = np.array([1,-20], dtype = np.int32)

l1 = W1.astype(np.int32) @ x.astype(np.int32) + b1
l1 = relu(l1)

hidden_q = requantize(l1)

l2 = W2.astype(np.int32) @ x.astype(np.int32) + b2
y = relu(l2)

print("Layer 1:", l1)
print("Requantized: ", hidden_q)
print("Layer 2 before ReLU", l2)
print("Output", y)

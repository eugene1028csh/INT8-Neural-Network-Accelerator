#scale values from Python
#        ↓
#r = Sx × Sw / Snext
#        ↓
#r ≈ 0.00632
#        ↓ × 2^16
#414
#        ↓
#hardware uses:
#(data × 414) >> 163

import numpy as np


# ============================================================
# 1. XOR DATASET
# ============================================================

X = np.array([
    [0.0, 0.0],
    [0.0, 1.0],
    [1.0, 0.0],
    [1.0, 1.0]
], dtype=np.float32)

labels = np.array([0, 1, 1, 0])


# ============================================================
# 2. INITIALISE NETWORK
# ============================================================

rng = np.random.default_rng(0)

# Shape: [output_neurons, input_neurons]
W1 = rng.normal(0, 0.5, size=(2, 2)).astype(np.float32)
b1 = np.full(2, 0.1, dtype=np.float32)

W2 = rng.normal(0, 0.5, size=(2, 2)).astype(np.float32)
b2 = np.zeros(2, dtype=np.float32)


# ============================================================
# 3. ACTIVATION FUNCTIONS
# ============================================================

def relu(x):
    return np.maximum(x, 0)


def softmax(scores):
    shifted = scores - np.max(scores)
    exp_scores = np.exp(shifted)
    return exp_scores / np.sum(exp_scores)


# ============================================================
# 4. TRAIN NETWORK USING SGD
# ============================================================

learning_rate = 0.1

for epoch in range(10000):

    total_loss = 0.0

    for x, label in zip(X, labels):

        # ----------------------------
        # Forward pass
        # ----------------------------

        z1 = W1 @ x + b1
        hidden = relu(z1)

        scores = W2 @ hidden + b2
        probs = softmax(scores)

        # ----------------------------
        # Correct answer / target
        # ----------------------------

        target = np.zeros(2, dtype=np.float32)
        target[label] = 1.0

        # ----------------------------
        # Cross-entropy loss
        # ----------------------------

        loss = -np.log(probs[label] + 1e-12)
        total_loss += loss

        # ----------------------------
        # Backpropagation
        # ----------------------------

        d_scores = probs - target

        # Layer 2 gradients
        dW2 = np.outer(d_scores, hidden)
        db2 = d_scores

        # Gradient back into hidden layer
        d_hidden = W2.T @ d_scores

        # ReLU derivative
        d_z1 = d_hidden * (z1 > 0)

        # Layer 1 gradients
        dW1 = np.outer(d_z1, x)
        db1 = d_z1

        # ----------------------------
        # Gradient descent update
        # ----------------------------

        W1 -= learning_rate * dW1
        b1 -= learning_rate * db1

        W2 -= learning_rate * dW2
        b2 -= learning_rate * db2

    if epoch % 1000 == 0:
        print("Epoch:", epoch, "Loss:", total_loss)


# ============================================================
# 5. CHECK FLOATING-POINT NETWORK
# ============================================================

print("\nFinal predictions:")

for x, label in zip(X, labels):

    z1 = W1 @ x + b1
    hidden = relu(z1)

    scores = W2 @ hidden + b2
    probs = softmax(scores)

    prediction = np.argmax(probs)

    print(
        "Input:", x,
        "Expected:", label,
        "Predicted:", prediction,
        "Probabilities:", probs
    )


print("\nTrained W1:")
print(W1)

print("\nTrained b1:")
print(b1)

print("\nTrained W2:")
print(W2)

print("\nTrained b2:")
print(b2)


# ============================================================
# 6. SYMMETRIC INT8 QUANTISATION
# ============================================================

def quantize_symmetric(tensor):

    max_abs = np.max(np.abs(tensor))

    if max_abs == 0:
        return np.zeros_like(tensor, dtype=np.int8), 1.0

    scale = max_abs / 127.0

    q = np.round(tensor / scale)
    q = np.clip(q, -127, 127).astype(np.int8)

    return q, scale


# Quantise trained weights
W1_q, W1_scale = quantize_symmetric(W1)
W2_q, W2_scale = quantize_symmetric(W2)


print("\nQuantized W1:")
print(W1_q)
print("W1 scale:", W1_scale)

print("\nQuantized W2:")
print(W2_q)
print("W2 scale:", W2_scale)


# Check how accurately weights can be reconstructed
print("\nRecovered W1:")
print(W1_q.astype(np.float32) * W1_scale)

print("\nRecovered W2:")
print(W2_q.astype(np.float32) * W2_scale)


# ============================================================
# 7. QUANTISE NETWORK INPUTS
# ============================================================

X_scale = np.max(np.abs(X)) / 127.0

X_q = np.round(X / X_scale)
X_q = np.clip(X_q, -127, 127).astype(np.int8)


print("\nInput scale:")
print(X_scale)

print("\nQuantized inputs:")
print(X_q)


# ============================================================
# 8. LAYER 1 INT32 ACCUMULATOR SCALE
# ============================================================

# INT8 weight * INT8 input gives an INT32 accumulator.
#
# Real accumulator value approximately equals:
#
# accumulator_integer * (X_scale * W1_scale)

L1_acc_scale = X_scale * W1_scale

print("\nLayer 1 accumulator scale:")
print(L1_acc_scale)


# ============================================================
# 9. QUANTISE LAYER 1 BIAS
# ============================================================

# Bias must use the SAME scale as the INT32 MAC accumulator.

b1_q = np.round(b1 / L1_acc_scale).astype(np.int32)

print("\nQuantized b1:")
print(b1_q)


# ============================================================
# 10. CALCULATE FLOAT HIDDEN ACTIVATIONS
# ============================================================

# All four samples at once.
#
# Single input:
#     W1 @ x
#
# Batch of inputs:
#     X @ W1.T

hidden_float = relu(X @ W1.T + b1)

print("\nFloating-point hidden activations:")
print(hidden_float)


# ============================================================
# 11. CHOOSE INT8 HIDDEN-ACTIVATION SCALE
# ============================================================

hidden_scale = np.max(np.abs(hidden_float)) / 127.0

print("\nHidden activation scale:")
print(hidden_scale)


# ============================================================
# 12. CALCULATE REQUANTISATION MULTIPLIER
# ============================================================

# INT32 accumulator currently uses:
#
#     L1_acc_scale
#
# Layer 2 wants an INT8 input using:
#
#     hidden_scale
#
# Therefore:
#
# hidden_q =
# accumulator * (L1_acc_scale / hidden_scale)

requant_multiplier = L1_acc_scale / hidden_scale

print("\nLayer 1 requantization multiplier:")
print(requant_multiplier)


# ============================================================
# 13. INTEGER-ONLY LAYER 1
# ============================================================

print("\nINT8 / INT32 Layer 1:")

hidden_q_all = []

for x_q in X_q:

    # INT8 × INT8 -> INT32 MAC
    l1_acc = (
        W1_q.astype(np.int32)
        @ x_q.astype(np.int32)
        + b1_q
    )

    # ReLU
    l1_relu = np.maximum(l1_acc, 0)

    # INT32 -> INT8 requantisation
    hidden_q = np.round(
        l1_relu * requant_multiplier
    )

    hidden_q = np.clip(
        hidden_q,
        -128,
        127
    ).astype(np.int8)

    hidden_q_all.append(hidden_q)

    print("\nInput:", x_q)
    print("INT32 accumulator:", l1_acc)
    print("After ReLU:", l1_relu)
    print("INT8 hidden:", hidden_q)


hidden_q_all = np.array(hidden_q_all, dtype=np.int8)

print("\nAll requantized hidden activations:")
print(hidden_q_all)

# ============================================================
# 14. LAYER 2 INTEGER INFERENCE
# ============================================================

# Layer 2 input scale is the hidden activation scale
L2_input_scale = hidden_scale

# INT32 accumulator scale for Layer 2
L2_acc_scale = L2_input_scale * W2_scale

print("\nLayer 2 accumulator scale:")
print(L2_acc_scale)


# Quantise Layer 2 bias to the accumulator scale
b2_q = np.round(b2 / L2_acc_scale).astype(np.int32)

print("\nQuantized b2:")
print(b2_q)


# ============================================================
# 15. FULL INTEGER NETWORK TEST
# ============================================================

print("\nFull quantized network:")

correct = 0

for i, hidden_q in enumerate(hidden_q_all):

    # INT8 x INT8 -> INT32 accumulation + INT32 bias
    l2_acc = (
        W2_q.astype(np.int32)
        @ hidden_q.astype(np.int32)
        + b2_q
    )

    # For classification, largest score wins.
    prediction = np.argmax(l2_acc)

    expected = labels[i]

    if prediction == expected:
        correct += 1

    print(
        "Input:", X_q[i],
        "Scores:", l2_acc,
        "Expected:", expected,
        "Predicted:", prediction
    )


print("\nAccuracy:", correct, "/", len(labels))
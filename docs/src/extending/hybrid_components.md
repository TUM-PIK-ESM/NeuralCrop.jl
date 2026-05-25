# Hybrid components

Hybrid components connect neural modules with process-based dynamics. This is the central extension path for data-constrained process improvement.

## Design pattern

NeuralCrop hybrid components generally follow this pattern:

1. Build neural inputs from current state and forcing.
2. Predict process modifiers or tendencies using `MLP` or `NODE`.
3. Apply predictions inside a physically structured state update.
4. Train via rollout losses that compare modeled trajectories to reference data.

## Where to implement

- Add model-specific hybrid logic in `src/hybrid`.
- Add reusable neural wrappers or helpers in `src/neural_network`.
- Integrate calls from daily simulation drivers.

## Parameter and state flow

The training loop passes:

- `nn_model` for architecture,
- `ps` for trainable parameters,
- `st` for Lux state,
- batch data and initialized model states.

Keep this interface intact when introducing new hybrid modules so rollout training remains compatible.

## Numerical stability

When adding hybrid components:

- scale inputs and targets carefully,
- guard against NaN/Inf in losses,
- start with short rollouts and small batches,
- and verify that process outputs remain in physically plausible ranges.

# Neural networks

NeuralCrop uses Lux.jl for neural-network layers and Optimisers.jl for parameter updates.

## Model wrappers

`MLP` wraps a Lux model for feed-forward emulators. `NODE` wraps a Lux model together with a solver and time span for neural ODE-style components.

## Emulator functions

Emulator functions include neural predictions for photosynthesis-related variables, storage carbon, allocation, litter and soil carbon turnover, soil nitrogen turnover, and soil moisture.

## Custom solvers

The package defines simple Euler-style solvers for daily updates. These are small, differentiable building blocks for neural ODE components.

# Hybrid model

Hybrid NeuralCrop simulations insert neural-network components into selected crop and soil processes.

## Neural emulators

Neural emulators are implemented with Lux layers wrapped as `MLP` or `NODE` structures. Emulator functions convert model state and forcing inputs into rate modifiers, tendencies, or pool updates.

## Neural ODE components

Several hybrid functions use small ODE-style updates with custom Euler solvers. This keeps the neural component compatible with the daily model time step while preserving differentiability.

## Training context

Hybrid components are trained through rollout losses, where the full crop model is advanced through time and the neural parameters are updated from differences between model output and reference targets.

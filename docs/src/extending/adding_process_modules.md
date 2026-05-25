# Adding process modules

This page describes a practical workflow for adding a new process to NeuralCrop.

## 1. Choose the process domain

Put new routines under the appropriate domain:

- `src/physics/crop` for crop physiology and management.
- `src/physics/soil` for soil water/biogeochemistry/temperature.
- `src/physics/climate` for forcing buffers and climate transforms.

## 2. Add state and parameters

If the process needs new state variables, update:

1. `src/physics/variables/define_structs.jl`
2. `src/physics/variables/init_struct.jl`
3. optional output fields in `src/physics/variables/output.jl`

Keep array shapes consistent with existing conventions (`(layers, cells)` or `(cells,)`).

## 3. Implement a mutating process function

Use an in-place function signature ending in `!`, and update only the state owned by that process. Avoid hidden allocation inside day loops when possible.

## 4. Wire into the daily driver

Register the new process call in:

- `src/simulations/daily_crop_C3.jl`
- `src/simulations/daily_crop_C4.jl`
- and, if needed, `src/training/daily_crop_C3_training.jl`

Keep the call order physically consistent with existing dependencies (for example, climate update before phenology, and phenology before harvest logic).

## 5. Export and document

Export the new function in `src/NeuralCrop.jl` if it is public, then add or update pages in `docs/src/processes` to describe the new behavior.

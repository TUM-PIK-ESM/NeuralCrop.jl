# Initialization

NeuralCrop initialization creates typed state containers and moves their arrays to the selected device.

## State containers

Important state containers include:

- `ClimBuf` for rolling climate buffers.
- `Crop` and `Calendar` for crop state and management callbacks.
- `Photos` and `PetPar` for photosynthesis and potential evapotranspiration variables.
- `Soil` for soil water, carbon, nitrogen, and snow state.
- `Output` for diagnostics collected during simulations and training.

## Device argument

Initialization functions accept a `device` function. Use `Array` for CPU arrays. GPU workflows use device functions from the CUDA/LuxCUDA stack.

## Typical order

A simulation usually loads data, builds an `InitialData` batch with `InitialDataLoader`, initializes state with `init_structs!`, spins up climate buffers with `spin_up_climbuf!`, and then calls a daily simulation driver.

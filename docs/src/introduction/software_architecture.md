# Software architecture

NeuralCrop.jl is organized around process domains. The top-level module includes source files from `src/physics`, `src/hybrid`, `src/neural_network`, `src/training`, `src/simulations`, and `src/utilities`.

## Source layout

- `physics/variables` defines state containers, parameters, initialization, callbacks, and output buffers.
- `physics/climate` handles climate reading, climate buffers, snow, and temperature stress.
- `physics/crop` implements crop physiology, phenology, management, photosynthesis, carbon allocation, nitrogen demand and uptake, transpiration, interception, and harvesting.
- `physics/soil` implements pedotransfer functions, soil temperature, water, carbon, nitrogen, evaporation, infiltration, and percolation.
- `hybrid` contains neural-network replacements for selected crop and soil process components.
- `neural_network` defines MLP/NODE wrappers, custom Euler solvers, emulator functions, losses, and training loops.
- `simulations` contains daily C3 and C4 crop drivers.

## Data movement

Most initialization and data-loading functions accept a `device` argument. Passing `Array` keeps arrays on CPU, while GPU-oriented device functions can move compatible arrays to accelerator memory.

## Public interface

The package exports model state types, parameters, initialization routines, daily simulation drivers, process functions, neural emulator functions, training loops, and selected utilities. See [API index](@ref) for a generated index.

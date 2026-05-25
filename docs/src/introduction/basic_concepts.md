# Basic concepts

NeuralCrop.jl represents crop growth as a coupled set of daily process updates. The core state is stored in mutable containers for climate buffers, crop pools, soil pools, management calendars, photosynthesis variables, potential evapotranspiration variables, and output arrays.

## Gridded crop simulation

The package is built around batches of grid cells. Most state variables are arrays whose last dimension indexes grid cells. This design makes it possible to run many locations at once and to move state between CPU and GPU devices with a `device` function.

## Process-based and hybrid components

NeuralCrop supports two related model modes:

- Process-based simulations use explicit crop, soil, water, carbon, and nitrogen process functions.
- Hybrid simulations replace selected process rates or tendencies with neural emulators while preserving the surrounding physical model structure.

## Daily time stepping

The main simulation routines advance state one day at a time. Each day reads climate forcing, updates snow and climate buffers, handles cultivation and harvest callbacks, computes crop physiology, updates soil water and biogeochemistry, and writes selected output variables.

## External data

NeuralCrop relies on climate, management, soil, and LPJmL-derived initial-condition data. The repository includes small example files, but large-scale production forcing data should be obtained from the original data providers and cited accordingly.

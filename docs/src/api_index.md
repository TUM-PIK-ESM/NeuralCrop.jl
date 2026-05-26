# API index

This page is generated from source docstrings and organized by module area.

Quick jump:
- [Variables and initialization](#variables-and-initialization)
- [Climate processes](#climate-processes)
- [Crop processes](#crop-processes)
- [Soil processes](#soil-processes)
- [Hybrid processes](#hybrid-processes)
- [Neural networks and training](#neural-networks-and-training)
- [Simulation drivers](#simulation-drivers)
- [Utilities](#utilities)

## Variables and initialization

Core model state types, parameter presets, and initialization/data-loading entry points.

```@autodocs
Modules = [NeuralCrop]
Pages = [
    "physics/variables/default_param.jl",
    "physics/variables/pft.jl",
    "physics/variables/define_structs.jl",
    "physics/variables/init_var.jl",
    "physics/variables/init_struct.jl",
    "physics/variables/output.jl",
    "physics/variables/DataLoader.jl",
    "utilities/data_loader.jl",
    "utilities/data_norm.jl",
]
Order = [:constant, :type, :function]
Private = false
```

## Climate processes

Climate forcing preparation and temperature/snow process updates.

```@autodocs
Modules = [NeuralCrop]
Pages = [
    "physics/climate/readclimate.jl",
    "physics/climate/climbuf.jl",
    "physics/climate/spinup_climbuf.jl",
    "physics/climate/snow.jl",
    "physics/climate/temp_stress.jl",
]
Order = [:function, :type]
Private = false
```

## Crop processes

Crop biophysics, allocation, phenology, management, and N cycling operators.

```@autodocs
Modules = [NeuralCrop]
Pages = [
    "physics/crop/albedo.jl",
    "physics/crop/radiation.jl",
    "physics/crop/photosynthesis.jl",
    "physics/crop/respiration.jl",
    "physics/crop/interception.jl",
    "physics/crop/transpiration.jl",
    "physics/crop/phenology.jl",
    "physics/crop/cultivate.jl",
    "physics/crop/harvesting.jl",
    "physics/crop/carbon_allocation.jl",
    "physics/crop/crop_carbon.jl",
    "physics/crop/lai_crop.jl",
    "physics/crop/fertilizer.jl",
    "physics/crop/nitrogen_demand.jl",
    "physics/crop/nitrogen_uptake.jl",
    "physics/crop/nitrogen_allocation.jl",
]
Order = [:function, :type]
Private = false
```

## Soil processes

Soil water/temperature, pedotransfer, carbon, and nitrogen process kernels.

```@autodocs
Modules = [NeuralCrop]
Pages = [
    "physics/soil/pedotransfer.jl",
    "physics/soil/infil_perc.jl",
    "physics/soil/evaporation.jl",
    "physics/soil/soil_water.jl",
    "physics/soil/soil_temp.jl",
    "physics/soil/soil_carbon.jl",
    "physics/soil/nitrogen_transform.jl",
    "physics/soil/soil_nitrogen.jl",
    "physics/variables/callback.jl",
]
Order = [:function, :type]
Private = false
```

## Hybrid processes

Hybrid physics-neural couplers for crop carbon/photosynthesis and soil processes.

```@autodocs
Modules = [NeuralCrop]
Pages = [
    "hybrid/crop_carbon.jl",
    "hybrid/photosynthesis.jl",
    "hybrid/soil_carbon.jl",
    "hybrid/soil_nitrogen.jl",
    "hybrid/soil_water.jl",
]
Order = [:function, :type]
Private = false
```

## Neural networks and training

Neural emulator blocks, solver wrappers, losses, and training loops.

```@autodocs
Modules = [NeuralCrop]
Pages = [
    "neural_network/define_net_struct.jl",
    "neural_network/init_net.jl",
    "neural_network/neural_emulator.jl",
    "neural_network/solver.jl",
    "neural_network/loss.jl",
    "neural_network/training_loop.jl",
    "training/daily_crop_C3_training.jl",
]
Order = [:function, :type]
Private = false
```

## Simulation drivers

Daily end-to-end drivers for C3/C4 simulations.

```@autodocs
Modules = [NeuralCrop]
Pages = [
    "simulations/daily_crop_C3.jl",
    "simulations/daily_crop_C4.jl",
]
Order = [:function]
Private = false
```

## Utilities

Shared kernels, unit conversions, data helpers, and visualization tools.

```@autodocs
Modules = [NeuralCrop]
Pages = [
    "utilities/kernel_launch.jl",
    "physics/variables/units.jl",
    "utilities/utils.jl",
    "utilities/visualization.jl",
]
Order = [:function, :constant, :type]
Private = false
```
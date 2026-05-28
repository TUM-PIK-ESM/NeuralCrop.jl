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
    "parameters/default_params.jl",
    "parameters/pft.jl",
    "processes/initialization/define_structs.jl",
    "processes/initialization/init_states.jl",
    "processes/initialization/init_structs.jl",
    "input_output/output.jl",
    "input_output/data_loader.jl",
    "input_output/load_nc.jl",
]
Order = [:constant, :type, :function]
Private = false
```

## Climate processes

Climate forcing preparation and temperature/snow process updates.

```@autodocs
Modules = [NeuralCrop]
Pages = [
    "processes/climate/readclimate.jl",
    "processes/climate/climbuf.jl",
    "processes/climate/spinup_climbuf.jl",
    "processes/climate/snow.jl",
    "processes/climate/temp_stress.jl",
]
Order = [:function, :type]
Private = false
```

## Crop processes

Crop biophysics, allocation, phenology, management, and N cycling operators.

```@autodocs
Modules = [NeuralCrop]
Pages = [
    "processes/crop/albedo.jl",
    "processes/crop/radiation.jl",
    "processes/crop/photosynthesis.jl",
    "processes/crop/respiration.jl",
    "processes/crop/interception.jl",
    "processes/crop/transpiration.jl",
    "processes/crop/phenology.jl",
    "processes/crop/cultivate.jl",
    "processes/crop/harvesting.jl",
    "processes/crop/carbon_allocation.jl",
    "processes/crop/crop_carbon.jl",
    "processes/crop/lai_crop.jl",
    "processes/crop/fertilizer.jl",
    "processes/crop/nitrogen_demand.jl",
    "processes/crop/nitrogen_uptake.jl",
    "processes/crop/nitrogen_allocation.jl",
]
Order = [:function, :type]
Private = false
```

## Soil processes

Soil water/temperature, pedotransfer, carbon, and nitrogen process kernels.

```@autodocs
Modules = [NeuralCrop]
Pages = [
    "processes/soil/pedotransfer.jl",
    "processes/soil/infil_perc.jl",
    "processes/soil/evaporation.jl",
    "processes/soil/soil_water.jl",
    "processes/soil/soil_temp.jl",
    "processes/soil/soil_carbon.jl",
    "processes/soil/nitrogen_transform.jl",
    "processes/soil/soil_nitrogen.jl",
    "utils/callback.jl",
]
Order = [:function, :type]
Private = false
```

## Hybrid processes

Hybrid physics-neural couplers for crop carbon/photosynthesis and soil processes.

```@autodocs
Modules = [NeuralCrop]
Pages = [
    "hybrid_processes/crop_carbon.jl",
    "hybrid_processes/photosynthesis.jl",
    "hybrid_processes/soil_carbon.jl",
    "hybrid_processes/soil_nitrogen.jl",
    "hybrid_processes/soil_water.jl",
]
Order = [:function, :type]
Private = false
```

## Neural networks and training

Neural emulator blocks, solver wrappers, losses, and training loops.
This section includes unified execution helpers (`run_mlp`, `run_node`, `run_hybrid_decay`) that reduce repeated ODE wrapper code in high-level emulators such as `neural_stoc`, `neural_moisture`, and hybrid soil/litter updates.

```@autodocs
Modules = [NeuralCrop]
Pages = [
    "neural_network/define_net_struct.jl",
    "neural_network/init_net.jl",
    "neural_network/neural_emulator.jl",
    "neural_network/solver.jl",
    "training/loss_function.jl",
    "training/training_loop.jl",
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

## Utils

Shared kernels, unit conversions, data helpers, and visualization tools.

```@autodocs
Modules = [NeuralCrop]
Pages = [
    "utils/kernel_launch.jl",
    "utils/conversions.jl",
    "utils/normalization.jl",
    "utils/visualization.jl",
    "utils/lonlat_split.jl"
]
Order = [:function, :constant, :type]
Private = false
```
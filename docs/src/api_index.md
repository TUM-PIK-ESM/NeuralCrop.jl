# API index

This page provides a compact, module-oriented API map in the style of modern Julia model documentation. The goal is to help users locate interfaces quickly without reading a long, function-by-function manual.

## Full symbol index

```@index
Modules = [NeuralCrop]
```

## API by source module

### Variables and initialization

```@autodocs
Modules = [NeuralCrop]
Pages = [
    "physics/variables/define_structs.jl",
    "physics/variables/default_param.jl",
    "physics/variables/init_var.jl",
    "physics/variables/init_struct.jl",
    "physics/variables/output.jl",
    "physics/variables/DataLoader.jl",
]
all     = true
```

### Climate and crop processes

```@autodocs
Modules = [NeuralCrop]
Pages = [
    "physics/climate/climbuf.jl",
    "physics/climate/temp_stress.jl",
    "physics/climate/spinup_climbuf.jl",
    "physics/climate/readclimate.jl",
    "physics/climate/snow.jl",
    "physics/crop/photosynthesis.jl",
    "physics/crop/carbon_allocation.jl",
    "physics/crop/crop_carbon.jl",
    "physics/crop/phenology.jl",
    "physics/crop/lai_crop.jl",
    "physics/crop/respiration.jl",
    "physics/crop/interception.jl",
    "physics/crop/transpiration.jl",
    "physics/crop/nitrogen_allocation.jl",
    "physics/crop/nitrogen_demand.jl",
    "physics/crop/nitrogen_uptake.jl",
    "physics/crop/fertilizer.jl",
    "physics/crop/harvesting.jl",
]
all     = true
```

### Soil and hybrid processes

```@autodocs
Modules = [NeuralCrop]
Pages = [
    "physics/soil/soil_water.jl",
    "physics/soil/soil_carbon.jl",
    "physics/soil/soil_nitrogen.jl",
    "hybrid/crop_carbon.jl",
    "hybrid/photosynthesis.jl",
    "hybrid/soil_carbon.jl",
    "hybrid/soil_nitrogen.jl",
    "hybrid/soil_water.jl",
]
all     = true
```

### Neural and simulation drivers

```@autodocs
Modules = [NeuralCrop]
Pages = [
    "neural_network/define_net_struct.jl",
    "neural_network/solver.jl",
    "neural_network/neural_emulator.jl",
    "neural_network/loss.jl",
    "neural_network/training_loop.jl",
    "training/daily_crop_C3_training.jl",
    "simulations/daily_crop_C3.jl",
    "simulations/daily_crop_C4.jl",
]
all     = true
```

## Notes

- Some symbols may not render detailed entries yet if the corresponding source code has no docstring.
- For workflow-level guidance, start from the Introduction, Running, Models, and Processes sections rather than this API page.
```

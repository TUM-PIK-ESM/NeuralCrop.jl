# API index

This page provides a compact, module-oriented API map in the style of modern Julia model documentation. The goal is to help users locate interfaces quickly without reading a long, function-by-function manual.

## Full symbol index

```@index
Modules = [NeuralCrop]
```

## Workflow entry points

Use these quick routes when you are trying to complete a concrete task.

### I want to run a simulation

- Drivers: `daily_crop_C3!`, `daily_crop_C4!`
- Setup and state allocation: `init_structs!`, `init_crop`, `init_soil`, `init_climbuf`, `init_output`
- Data loading: `DataLoader`, `DataLoader_winter_wheat`, `InitilDataLoader`, `ClimateDataLoader`
- Output extraction: `output_predict!`, `output_finetune!`
- Jump links: [Simulation outputs and utilities](#simulation-outputs-and-utilities), [Neural and simulation drivers](#neural-and-simulation-drivers)

### I want to train hybrid components

- Training loop and loss: `train_loop_rollout!`, `train_loop_winter_wheat_rollout!`, `loss_crop_rollout!`, `daily_crop_C3_training!`
- Neural wrappers and emulators: `NODE`, `MLP`, `neural_lambda`, `neural_vmax`, `neural_stoc`, `neural_allocation`, `neural_moisture`
- Hybrid process hooks: `crop_carbon_hybrid!`, `hybrid_photos_C3!`, `hybrid_photos_C4!`, `hybrid_litc`, `hybrid_soilc`, `hybrid_litn`, `hybrid_soiln`
- Jump links: [Hybrid, neural, and training](#hybrid-neural-and-training), [Neural and simulation drivers](#neural-and-simulation-drivers)

### I want to add or modify a process

- Climate process entry points: `readclimate!`, `update_climbuf!`, `snow!`, `temp_stress`
- Crop process entry points: `photosynthesis_C3!`, `phenology_crop!`, `crop_carbon!`, `crop_nitrogen!`, `harvest_crop!`
- Soil process entry points: `soil_water!`, `soil_carbon!`, `soil_nitrogen!`, `pedotransfer!`, `soiltemp_lag!`
- Jump links: [Climate and crop processes](#climate-and-crop-processes), [Soil and hybrid processes](#soil-and-hybrid-processes)

### I want to inspect model state and parameters

- Parameter presets: `lpjmlparams`, `photoparams`, `soilparams`, `snowparams`, `cft1`, `cft2`, `cft3`, `cft4`
- State containers: `Crop`, `Soil`, `ClimBuf`, `DailyWeather`, `Photos`, `Output`
- Unit and normalization helpers: `deg2rad`, `ppm2Pa`, `z_score_norm`, `apply_z_score`
- Jump links: [Types and parameter presets](#types-and-parameter-presets), [Variables and initialization](#variables-and-initialization)

## Exported API overview

This section lists the main exported symbols even when some of them do not yet have full docstrings.

### Types and parameter presets
Use these to configure crop functional types, physical parameters, and model state containers before running simulations.

- `LPJmLParams`, `PftParameters`, `PhotoParams`, `SoilParams`, `SnowParams`
- `Photos`, `PetPar`, `DailyWeather`, `ClimBuf`, `CO2`, `Crop`, `Calendar`, `Managed_land`, `Soil`, `Output`
- `lpjmlparams`, `photoparams`, `soilparams`, `snowparams`
- `cft1`, `cft2`, `cft3`, `cft4`
- Detailed section: [Variables and initialization](#variables-and-initialization)

### Initialization and data
Use these to build model-ready batches and allocate in-memory state on CPU/GPU backends.

- `init_structs!`, `init_climbuf`, `init_crop`, `init_pet`, `init_soil`, `init_data_norm`, `init_output`
- `InitilDataLoader`, `ClimateDataLoader`, `DataLoader`, `DataLoader_winter_wheat`
- Detailed section: [Variables and initialization](#variables-and-initialization)

### Climate, crop, and soil processes
Use these process kernels to update daily forcing, crop growth, soil water, and soil biogeochemistry.

- Climate: `annual_climbuf!`, `daily_climbuf!`, `infil_perc!`, `spin_up_climbuf!`, `update_climbuf!`, `readclimate!`, `snow!`
- Crop radiation and water: `albedo!`, `petpar!`, `apar_crop!`, `apar_crop_maize!`, `transpiration!`, `interception!`
- Crop physiology: `photosynthesis_C3!`, `photosynthesis_C4!`, `carbon_allocation!`, `respiration!`, `phenology_crop!`, `lai_crop!`, `lai_deficit!`, `cultivate!`, `harvest_crop!`, `fertilizer!`
- Crop nutrients: `crop_nitrogen!`, `crop_nitrogen_old!`, `ndemand_crop!`, `nuptake_crop!`
- Soil processes: `soiltemp_lag!`, `pedotransfer!`, `update_lit_tillage!`, `update_lit_winter_wheat!`, `soil_carbon!`, `evaporation!`, `soil_water!`, `nitrogen_transform!`, `soil_nitrogen!`, `update_litc_tillage!`, `update_litn_tillage!`
- Shared helpers: `root_distribution`, `temp_stress`
- Detailed sections: [Climate and crop processes](#climate-and-crop-processes), [Soil and hybrid processes](#soil-and-hybrid-processes)

### Hybrid, neural, and training
Use these interfaces to embed neural emulators in process updates and train parameters with rollout objectives.

- Hybrid crop/soil: `crop_carbon_hybrid!`, `hybrid_photos_C3!`, `hybrid_photos_C4!`, `hybrid_litc`, `hybrid_soilc`, `hybrid_litn`, `hybrid_soiln`
- Neural model wrappers and solvers: `NODE`, `MLP`, `solve`, `SciMLEuler`, `SciMLEuler_litc`, `SciMLEuler_soilc`
- Neural emulators: `neural_gpp`, `neural_lambda`, `neural_vmax`, `neural_stoc`, `neural_allocation`, `neural_moisture`, `get_mlp`, `get_node`
- Training loop and loss: `train_loop_winter_wheat_rollout!`, `train_loop_rollout!`, `loss_crop_rollout!`, `daily_crop_C3_training!`
- Detailed section: [Neural and simulation drivers](#neural-and-simulation-drivers)

### Simulation outputs and utilities
Use these helpers for daily simulation entry points, output extraction, normalization, and plotting.

- Daily simulation drivers: `daily_crop_C3!`, `daily_crop_C4!`
- Output aggregation: `output_training!`, `output_predict!`, `output_finetune!`
- Units and normalization: `deg2rad`, `ppm2Pa`, `ppm2bar`, `hour2day`, `hour2sec`, `degCtoK`, `min_max_norm`, `z_score_norm`, `apply_z_score`
- Plot/data helpers: `load_nc_file_one_dimension`, `load_nc_file_dimensions`, `plot_loss_curve`
- Detailed section: [Neural and simulation drivers](#neural-and-simulation-drivers)

## API by source module

### Variables and initialization
Key symbols:

- `LPJmLParams`, `PftParameters`, `PhotoParams`, `SoilParams`, `SnowParams`
- `Photos`, `PetPar`, `DailyWeather`, `ClimBuf`, `CO2`, `Crop`, `Calendar`, `Managed_land`, `Soil`, `Output`
- `init_structs!`, `init_climbuf`, `init_crop`, `init_pet`, `init_soil`, `init_data_norm`, `init_output`
- `InitilDataLoader`, `ClimateDataLoader`, `DataLoader`, `DataLoader_winter_wheat`

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
Order = [:module, :constant, :type, :function, :macro]
Private = false
```

### Climate and crop processes
Key symbols:

- Climate: `annual_climbuf!`, `daily_climbuf!`, `infil_perc!`, `spin_up_climbuf!`, `update_climbuf!`, `readclimate!`, `snow!`
- Radiation and energy: `albedo!`, `petpar!`, `apar_crop!`, `apar_crop_maize!`, `temp_stress`
- Crop growth: `photosynthesis_C3!`, `photosynthesis_C4!`, `phenology_crop!`, `lai_crop!`, `lai_deficit!`, `crop_carbon!`, `carbon_allocation!`, `respiration!`
- Management and water: `cultivate!`, `harvest_crop!`, `fertilizer!`, `interception!`, `transpiration!`
- Crop nitrogen: `crop_nitrogen!`, `crop_nitrogen_old!`, `ndemand_crop!`, `nuptake_crop!`, `root_distribution`

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
Order = [:module, :constant, :type, :function, :macro]
Private = false
```

### Soil and hybrid processes
Key symbols:

- Soil core: `soiltemp_lag!`, `pedotransfer!`, `evaporation!`, `soil_water!`, `infil_perc!`
- Soil carbon and nitrogen: `soil_carbon!`, `soil_nitrogen!`, `nitrogen_transform!`, `update_lit_tillage!`, `update_lit_winter_wheat!`, `update_litc_tillage!`, `update_litn_tillage!`
- Hybrid replacements: `crop_carbon_hybrid!`, `hybrid_photos_C3!`, `hybrid_photos_C4!`, `hybrid_litc`, `hybrid_soilc`, `hybrid_litn`, `hybrid_soiln`

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
Order = [:module, :constant, :type, :function, :macro]
Private = false
```

### Neural and simulation drivers
Key symbols:

- Neural wrappers: `NODE`, `MLP`, `SciMLEuler`, `SciMLEuler_litc`, `SciMLEuler_soilc`, `solve`
- Neural emulators: `neural_gpp`, `neural_lambda`, `neural_vmax`, `neural_stoc`, `neural_allocation`, `neural_moisture`, `get_mlp`, `get_node`
- Training: `train_loop_rollout!`, `train_loop_winter_wheat_rollout!`, `loss_crop_rollout!`, `daily_crop_C3_training!`
- Simulations: `daily_crop_C3!`, `daily_crop_C4!`
- Output and plotting: `output_training!`, `output_predict!`, `output_finetune!`, `load_nc_file_one_dimension`, `load_nc_file_dimensions`, `plot_loss_curve`

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
Order = [:module, :constant, :type, :function, :macro]
Private = false
```

## Notes

- Some symbols may not render detailed entries yet if the corresponding source code has no docstring.
- For workflow-level guidance, start from the Introduction, Running, Models, and Processes sections rather than this API page.
```

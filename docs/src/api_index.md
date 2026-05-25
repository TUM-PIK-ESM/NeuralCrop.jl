# API index

This page provides a compact, module-oriented API map in the style of modern Julia model documentation. The goal is to help users locate interfaces quickly without reading a long, function-by-function manual.

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
- Detailed sections: [Climate and crop processes](#climate-and-crop-processes), [Soil processes](#soil-processes), and [Hybrid processes](#hybrid-processes)

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


### Climate and crop processes
Key symbols:

- Climate: `annual_climbuf!`, `daily_climbuf!`, `infil_perc!`, `spin_up_climbuf!`, `update_climbuf!`, `readclimate!`, `snow!`
- Radiation and energy: `albedo!`, `petpar!`, `apar_crop!`, `apar_crop_maize!`, `temp_stress`
- Crop growth: `photosynthesis_C3!`, `photosynthesis_C4!`, `phenology_crop!`, `lai_crop!`, `lai_deficit!`, `crop_carbon!`, `carbon_allocation!`, `respiration!`
- Management and water: `cultivate!`, `harvest_crop!`, `fertilizer!`, `interception!`, `transpiration!`
- Crop nitrogen: `crop_nitrogen!`, `crop_nitrogen_old!`, `ndemand_crop!`, `nuptake_crop!`, `root_distribution`


### Soil processes
Key symbols:

- Soil core: `soiltemp_lag!`, `pedotransfer!`, `evaporation!`, `soil_water!`, `infil_perc!`
- Soil carbon and nitrogen: `soil_carbon!`, `soil_nitrogen!`, `nitrogen_transform!`, `update_lit_tillage!`, `update_lit_winter_wheat!`, `update_litc_tillage!`, `update_litn_tillage!`


### Hybrid processes
Key symbols:

- Hybrid replacements: `crop_carbon_hybrid!`, `hybrid_photos_C3!`, `hybrid_photos_C4!`, `hybrid_litc`, `hybrid_soilc`, `hybrid_litn`, `hybrid_soiln`


### Neural and simulation drivers
Key symbols:

- Neural wrappers: `NODE`, `MLP`, `SciMLEuler`, `SciMLEuler_litc`, `SciMLEuler_soilc`, `solve`
- Neural emulators: `neural_gpp`, `neural_lambda`, `neural_vmax`, `neural_stoc`, `neural_allocation`, `neural_moisture`, `get_mlp`, `get_node`
- Training: `train_loop_rollout!`, `train_loop_winter_wheat_rollout!`, `loss_crop_rollout!`, `daily_crop_C3_training!`
- Simulations: `daily_crop_C3!`, `daily_crop_C4!`


## Notes

- Some symbols may not render detailed entries yet if the corresponding source code has no docstring.
- For workflow-level guidance, start from the Introduction, Running, Models, and Processes sections rather than this API page.
```

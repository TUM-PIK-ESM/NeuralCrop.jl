# Crop model

The crop model represents crop phenology, photosynthesis, leaf area, carbon allocation, respiration, nitrogen demand, nitrogen uptake, transpiration, interception, management, and harvest.

## C3 and C4 pathways

NeuralCrop provides separate daily drivers for C3 and C4 crops. The main difference is the photosynthesis pathway used during the daily crop physiology step.

## Management callbacks

Sowing, fertilization, and harvesting are handled through crop calendar and management state. The crop state is initialized or reset on sowing and harvest days.

## Outputs

Crop diagnostics include LAI, biomass, yield, GPP, respiration, vegetation carbon pools, phenological state, water stress, nitrogen stress, and harvest masks.

# Input data

NeuralCrop requires external climate, soil, management, and initial-condition data. Large-scale forcing data are not bundled with the package because they originate from third-party data providers.

## Climate forcing

Daily simulations use temperature, precipitation, shortwave radiation, longwave radiation, and CO2 forcing. Climate arrays are loaded into named tuples and then sliced into simulation batches with data-loader utilities.

## Crop management

Crop input data include sowing dates, phenological heat units, fertilizer, manure, harvest dates for winter wheat workflows, and residue fractions.

## Soil and initial state

Soil parameters include soil pH, saturation water content, sand and clay fractions, thermal diffusivity parameters, and soil-layer depth. Initial soil water, carbon, and nitrogen pools currently come from LPJmL-derived state data.

## Example data

The repository includes small example files in `examples/` and grid files in `inputs/`. These are intended for demonstration and testing of workflows, not for full-scale production experiments.

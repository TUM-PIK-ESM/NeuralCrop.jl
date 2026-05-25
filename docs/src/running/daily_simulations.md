# Daily simulations

Daily simulations are driven by `daily_crop_C3!` and `daily_crop_C4!`. Both functions update model state in place over a range of days.

## Process-based simulation

The process-based methods call explicit crop and soil routines for photosynthesis, respiration, carbon allocation, nitrogen demand and uptake, evapotranspiration, soil water, soil carbon, and soil nitrogen.

## Hybrid simulation

Hybrid methods accept a model, parameters, and states for neural-network components. These components can replace selected process calculations such as soil water, soil carbon, soil nitrogen, or crop carbon related terms.

## Output

Outputs are written into preallocated `Output` containers. Common diagnostics include GPP, LAI, biomass, yield, respiration, soil water, vegetation carbon, litter carbon, fast carbon, slow carbon, and harvest masks.

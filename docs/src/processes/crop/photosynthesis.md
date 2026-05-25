# Photosynthesis

Photosynthesis routines compute gross carbon gain and related variables from absorbed radiation, day length, temperature, CO2, crop parameters, and temperature stress.

## C3 photosynthesis

`photosynthesis_C3!` is used for C3 crop simulations such as wheat.

## C4 photosynthesis

`photosynthesis_C4!` is used for C4 crop simulations such as maize.

## Hybrid photosynthesis

Hybrid routines can use neural components to emulate selected photosynthesis-related quantities such as `lambda` or `vmax` while preserving the surrounding daily crop update.

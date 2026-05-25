# Phenology and management

Phenology and management determine when crops are planted, how they progress through growing stages, and when carbon and nitrogen pools are reset or transferred at harvest.

## Phenology

Phenology routines accumulate heat and vernalization-related quantities to track crop development.

## Cultivation

`cultivate!` initializes crop variables on sowing days and applies management inputs such as fertilizer and manure.

## Harvest

`harvest_crop!` handles harvest timing, yield output, residue transfers, and calendar bookkeeping.

# Training

Training routines roll the crop model forward through time and differentiate losses through the hybrid dynamics.

## Rollout training

`train_loop_rollout!` trains over daily rollout windows. Each batch loads a subset of grid cells, initializes state, spins up climate buffers, evaluates the rollout loss, and updates neural-network parameters with Optimisers.jl.

## Losses

`loss_crop_rollout!` compares normalized model outputs against LPJmL-derived targets. The current loss combines terms for photosynthesis variables, GPP, vegetation carbon, soil carbon pools, and soil water.

## Practical notes

Training is memory intensive because it differentiates through model dynamics. Start with small batches and short rollouts before scaling to larger spatial domains or longer periods.

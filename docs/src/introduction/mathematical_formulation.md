# Mathematical formulation

NeuralCrop.jl follows a daily, process-based crop modeling structure inspired by LPJmL. The full equations are distributed across process modules. This page summarizes the high-level coupling.

## State vector

For each grid cell, the model state contains crop carbon and nitrogen pools, leaf area, phenological state, soil water by layer, soil carbon and nitrogen pools, snow state, climate buffers, and output diagnostics.

## Daily update

A daily update can be viewed schematically as

```math
x_{t+1} = F_{\theta}(x_t, u_t, p),
```

where `x_t` is the model state, `u_t` is daily forcing, `p` contains crop and soil parameters, and `F_theta` is either a purely process-based update or a hybrid update with trainable neural-network components.

## Hybrid replacement

Hybrid components replace selected process tendencies or rate modifiers:

```math
r_t = N_{\theta}(z_t),
```

where `z_t` contains normalized state and forcing inputs. The neural output is then inserted into the physical update, preserving mass-flow structure where the surrounding process function enforces it.

## Training objective

Training routines compare normalized model outputs against reference targets, including crop productivity, vegetation carbon, soil carbon pools, and soil water. The rollout loss is accumulated over daily windows to train neural components inside the model dynamics.

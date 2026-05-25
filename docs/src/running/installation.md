# Installation

NeuralCrop.jl is currently installed from GitHub:

```julia
pkg> add https://github.com/yunan-l/NeuralCrop.jl.git
```

For local development:

```bash
git clone https://github.com/yunan-l/NeuralCrop.jl.git
cd NeuralCrop.jl
julia --project=. -e "import Pkg; Pkg.instantiate()"
```

The package is developed for Julia 1.10.x.

## Reproducibility

The repository provides `Project.toml`, which records direct dependencies and compatibility constraints. To reproduce an exact package environment for a publication or experiment, keep the generated `Manifest.toml` together with the corresponding repository commit.

## GPU support

NeuralCrop uses CUDA, LuxCUDA, Adapt, and KernelAbstractions for GPU-capable workflows. A CUDA-capable system is required for GPU execution; CPU execution remains useful for development and smaller examples.

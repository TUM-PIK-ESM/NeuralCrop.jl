# Contributing

Contributions are welcome. NeuralCrop is an active research codebase, and clear, focused contributions help a lot.

## Development setup

```bash
git clone https://github.com/yunan-l/NeuralCrop.jl.git
cd NeuralCrop.jl
julia --project=. -e "import Pkg; Pkg.instantiate()"
```

For documentation work:

```bash
julia --project=docs -e "import Pkg; Pkg.instantiate()"
julia --project=docs docs/make.jl
```

## Contribution guidelines

1. Keep pull requests focused on one theme.
2. Prefer small, composable functions and in-place updates in performance-sensitive loops.
3. Preserve array shape conventions and device-compatibility patterns.
4. Update docs when behavior or public interfaces change.
5. Include tests for new behavior when feasible.

## Suggested PR structure

1. Problem statement and motivation.
2. Summary of design choices.
3. Validation: tests, comparisons, or diagnostics.
4. Notes on numerical stability and performance implications.

## Questions and contact

For collaboration and usage questions, please open an issue in the repository or contact the maintainers listed in the project README.

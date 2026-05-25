# Core interfaces

NeuralCrop is organized around a small set of interface boundaries that make extension manageable:

1. Data loaders produce model-ready named tuples for climate, crop management, soil parameters, and initial states.
2. Initialization routines allocate and populate mutable state containers on the chosen device.
3. Daily drivers (`daily_crop_C3!`, `daily_crop_C4!`) orchestrate process calls in a fixed daily update order.
4. Process modules update specific parts of state in place.
5. Output routines store diagnostics for training and analysis.

## State-first extension pattern

Most extensions start by deciding where new state should live:

- `Crop` for plant-level pools or stresses.
- `Soil` for layer-resolved soil quantities.
- `DailyWeather` or `ClimBuf` for forcing transforms and memory terms.
- `Output` for diagnostics needed by analysis or losses.

After adding state, update initialization so arrays are allocated consistently for CPU/GPU workflows.

## In-place process APIs

The package follows mutating process functions (with `!`) that update pre-allocated state. This avoids repeated allocations during long rollouts and is important for training performance.

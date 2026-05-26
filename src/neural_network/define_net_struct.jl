struct MLP{M <: Lux.AbstractLuxLayer, K} <:Lux.Lux.AbstractLuxWrapperLayer{:model}
    model::M 
    kwargs::K
end

"""
MLP(model; kwargs...)

Wrap a Lux layer as a feed-forward emulator container.
"""
function MLP(model::Lux.AbstractLuxLayer;  kwargs...)
    return MLP{typeof(model), typeof(kwargs)}(model, kwargs)
end

struct NODE{M <: Lux.AbstractLuxLayer, So, T, K} <:Lux.Lux.AbstractLuxWrapperLayer{:model}
    model::M
    solver::So
    tspan::T
    kwargs::K
end

"""
NODE(model; solver=nothing, tspan=(0.0f0, 1.0f0), kwargs...)

Wrap a Lux layer as a neural-ODE emulator container.
"""
function NODE(model::Lux.AbstractLuxLayer; solver=nothing, tspan=(0.0f0, 1.0f0), kwargs...)
    return NODE{typeof(model), typeof(solver), typeof(tspan), typeof(kwargs)}(model, solver, tspan, kwargs)
end
# Neural network model/parameter struct definitions.

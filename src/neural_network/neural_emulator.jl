"""
make_stateful(n, ps, st)

Construct a stateful Lux layer wrapper from model, parameters, and states.
"""
make_stateful(n, ps, st) = Lux.StatefulLuxLayer{true}(n.model, ps, st)


"""
run_mlp(n, ps, st, input)

Evaluate an MLP emulator and return a flat vector output.
"""
run_mlp(n::MLP, ps, st, input) = vec(make_stateful(n, ps, st)(input, ps))


"""
run_node(n, u0, ps, st; dt=1.0f0, rhs_builder, solve_kwargs...)

Build and solve a NODE update with a caller-provided RHS builder.
"""
function run_node(rhs_builder, n::NODE, u0, ps, st; dt = 1.0f0, solve_kwargs...)
    st_model = make_stateful(n, ps, st)
    rhs(u, p, t) = rhs_builder(st_model, u, p, t)
    prob = ODEProblem{false}(ODEFunction{false}(rhs), u0, n.tspan, ps)
    return solve(prob, n.solver; dt = dt, solve_kwargs...)
end

"""
neural_lambda(n, ps, st, input)

Predict stomatal-regulation `lambda` from neural emulator.
"""
function neural_lambda(n::MLP, ps, st, input)
    return run_mlp(n, ps, st, input)
end
# function neural_lambda(n::MLP, ps, st, input)
#     st_model = Lux.StatefulLuxLayer{true}(n.model, ps, st)    
#     return vec(st_model(input, ps)) 
# end

"""
neural_vmax(n, ps, st, input)

Predict photosynthetic capacity `vmax` from neural emulator.
"""
function neural_vmax(n::MLP, ps, st, input)
    return run_mlp(n, ps, st, input)
end


"""
neural_stoc(n, u0, ps, st, input; dt=1.0f0)

Predict storage-carbon state trajectory using NODE/MLP emulators.
"""
function neural_stoc(n::NODE, u0, ps, st, input; dt = 1.0f0)
    return vec(run_node(n, u0, ps, st; dt = dt) do st_model, u, p, t
        st_model(vcat(u / 500, input), p)
    end)
end

function neural_stoc(n::MLP, ps, st, input)
    return run_mlp(n, ps, st, input)
end


"""
neural_allocation(n, u0, ps, st, input; dt=1.0f0)

Predict multi-pool vegetation carbon allocation with a NODE emulator.
"""
function neural_allocation(n::NODE, u0, ps, st, input; dt = 1.0f0)
    return run_node(n, u0, ps, st; dt = dt) do st_model, u, p, t
        st_model(vcat(u / 200, input), p)
    end
end
# function neural_allocation(n::NODE, u0, ps, st, input; dt = 1.0f0)  
#     st_model = Lux.StatefulLuxLayer{true}(n.model, ps, st)
#     rhs(u, p, t) = st_model(vcat(u/200, input), p)  
#     prob = ODEProblem{false}(ODEFunction{false}(rhs), u0, n.tspan, ps)  
#     return solve(prob, n.solver; dt = dt)
# end

"""
run_hybrid_decay(n, u0, ps, st, input, response; dt=1.0f0, solve_kwargs...)

Shared hybrid litter/soil decay update where decay rates are modulated by neural outputs.
"""
function run_hybrid_decay(n::NODE, u0, ps, st, input, response; dt = 1.0f0, solve_kwargs...)
    return run_node(n, u0, ps, st; dt = dt, solve_kwargs...) do st_model, u, p, t
        -(1.0f0 .- exp.(-response .* st_model(input, p) / 365)) .* u
    end
end


"""
hybrid_litc(n, u0, ps, st, input, response; dt=1.0f0)

Hybrid litter-carbon update where decay rates are modulated by neural outputs.
"""
function hybrid_litc(n::NODE, u0, ps, st, input, response; dt = 1.0f0)
    return run_hybrid_decay(n, u0, ps, st, input, response; dt = dt)
end


"""
hybrid_litn(n, u0, ps, st, input, response; dt=1.0f0)

Hybrid litter-nitrogen update where decay rates are modulated by neural outputs.
"""
function hybrid_litn(n::NODE, u0, ps, st, input, response; dt = 1.0f0)
    return run_hybrid_decay(n, u0, ps, st, input, response; dt = dt)
end


"""
hybrid_soilc(n, u0, ps, st, input, response, A_trans, c_input; dt=1.0f0)

Hybrid soil-carbon update including transition matrix and external inputs.
"""
function hybrid_soilc(n::NODE, u0, ps, st, input, response, A_trans, c_input; dt = 1.0f0)
    return run_hybrid_decay(n, u0, ps, st, input, response;
                            A_trans = A_trans, c_input = c_input, dt = dt)
end


"""
hybrid_soiln(n, u0, ps, st, input, response, A_trans, c_input; dt=1.0f0)

Hybrid soil-nitrogen update including transition matrix and external inputs.
"""
function hybrid_soiln(n::NODE, u0, ps, st, input, response, A_trans, c_input; dt = 1.0f0)
    return run_hybrid_decay(n, u0, ps, st, input, response;
                            A_trans = A_trans, c_input = c_input, dt = dt)
end


"""
neural_moisture(n, u0, ps, st, input, soildepth, perc, transp; dt=1.0f0)

Hybrid soil-moisture update combining water balance terms with neural correction.
"""
function neural_moisture(n::NODE, u0, ps, st, input, soildepth, perc, transp, evapor; dt = 1.0f0)
    return run_node(n, u0, ps, st; dt = dt) do st_model, u, p, t
        perc - transp - evapor + st_model(vcat(u ./ soildepth, input), p)
    end
end

function neural_moisture(n::NODE, u0, ps, st, input, soildepth; dt = 1.0f0)
    return run_node(n, u0, ps, st; dt = dt) do st_model, u, p, t
        st_model(vcat(u ./ soildepth, input), p)
    end
end
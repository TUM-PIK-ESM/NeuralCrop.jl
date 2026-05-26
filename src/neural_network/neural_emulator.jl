"""
neural_lambda(n, ps, st, input)

Predict stomatal-regulation `lambda` from neural emulator.
"""
function neural_lambda(n::MLP, ps, st, input)
    
    st_model = Lux.StatefulLuxLayer{true}(n.model, ps, st)
        
    return vec(st_model(input, ps))
    
end


"""
neural_vmax(n, ps, st, input)

Predict photosynthetic capacity `vmax` from neural emulator.
"""
function neural_vmax(n::MLP, ps, st, input)
    
    st_model = Lux.StatefulLuxLayer{true}(n.model, ps, st)
        
    return vec(st_model(input, ps))
    
end


"""
neural_stoc(n, u0, ps, st, input; dt=1.0f0)

Predict storage-carbon state trajectory using NODE/MLP emulators.
"""
function neural_stoc(n::NODE, u0, ps, st, input; dt = 1.0f0)
    
    st_model = Lux.StatefulLuxLayer{true}(n.model, ps, st)

    rhs(u, p, t) = st_model(vcat(u/500, input), p)
    
    prob = ODEProblem{false}(ODEFunction{false}(rhs), u0, n.tspan, ps)
    
    return vec(solve(prob, n.solver; dt = dt))
end

function neural_stoc(n::MLP, ps, st, input)
    
    st_model = Lux.StatefulLuxLayer{true}(n.model, ps, st)
        
    return vec(st_model(input, ps))
    
end


"""
neural_allocation(n, u0, ps, st, input; dt=1.0f0)

Predict multi-pool vegetation carbon allocation with a NODE emulator.
"""
function neural_allocation(n::NODE, u0, ps, st, input; dt = 1.0f0)
    
    st_model = Lux.StatefulLuxLayer{true}(n.model, ps, st)

    rhs(u, p, t) = st_model(vcat(u/200, input), p)
    
    prob = ODEProblem{false}(ODEFunction{false}(rhs), u0, n.tspan, ps)
    
    return solve(prob, n.solver; dt = dt)
end


"""
hybrid_litc(n, u0, ps, st, input, response; dt=1.0f0)

Hybrid litter-carbon update where decay rates are modulated by neural outputs.
"""
function hybrid_litc(n::NODE, u0, ps, st, input, response; dt = 1.0f0)
    
    st_model = Lux.StatefulLuxLayer{true}(n.model, ps, st)
    
    rhs(u, p, t) = -(1.0f0 .- exp.(-response .* st_model(input, p)/365)) .* u
  
    prob = ODEProblem{false}(ODEFunction{false}(rhs), u0, n.tspan, ps) 
    
    return solve(prob, n.solver; dt = dt)
end


"""
hybrid_litn(n, u0, ps, st, input, response; dt=1.0f0)

Hybrid litter-nitrogen update where decay rates are modulated by neural outputs.
"""
function hybrid_litn(n::NODE, u0, ps, st, input, response; dt = 1.0f0)
    
    st_model = Lux.StatefulLuxLayer{true}(n.model, ps, st)
    
    rhs(u, p, t) = -(1.0f0 .- exp.(-response .* st_model(input, p)/365)) .* u
  
    prob = ODEProblem{false}(ODEFunction{false}(rhs), u0, n.tspan, ps) 
    
    return solve(prob, n.solver; dt = dt)
end


"""
hybrid_soilc(n, u0, ps, st, input, response, A_trans, c_input; dt=1.0f0)

Hybrid soil-carbon update including transition matrix and external inputs.
"""
function hybrid_soilc(n::NODE, u0, ps, st, input, response, A_trans, c_input; dt = 1.0f0)

    st_model = Lux.StatefulLuxLayer{true}(n.model, ps, st)
    
    rhs(u, p, t) = -(1.0f0 .- exp.(-response .* st_model(input, p)/365)) .* u
  
    prob = ODEProblem{false}(ODEFunction{false}(rhs), u0, n.tspan, ps) 
    
    return solve(prob, n.solver; A_trans = A_trans, c_input = c_input, dt = dt)
end


"""
hybrid_soiln(n, u0, ps, st, input, response, A_trans, c_input; dt=1.0f0)

Hybrid soil-nitrogen update including transition matrix and external inputs.
"""
function hybrid_soiln(n::NODE, u0, ps, st, input, response, A_trans, c_input; dt = 1.0f0)

    st_model = Lux.StatefulLuxLayer{true}(n.model, ps, st)
    
    rhs(u, p, t) = -(1.0f0 .- exp.(-response .* st_model(input, p)/365)) .* u
  
    prob = ODEProblem{false}(ODEFunction{false}(rhs), u0, n.tspan, ps) 
    
    return solve(prob, n.solver; A_trans = A_trans, c_input = c_input, dt = dt)
end


"""
neural_moisture(n, u0, ps, st, input, soildepth, perc, transp; dt=1.0f0)

Hybrid soil-moisture update combining water balance terms with neural correction.
"""
function neural_moisture(n::NODE, u0, ps, st, input, soildepth, perc, transp, evapor; dt = 1.0f0)
    
    st_model = Lux.StatefulLuxLayer{true}(n.model, ps, st)

    rhs(u, p, t) = perc - transp - evapor + st_model(vcat(u./soildepth, input), p) 
    
    prob = ODEProblem{false}(ODEFunction{false}(rhs), u0, n.tspan, ps)
    
    return solve(prob, n.solver; dt = dt)
end

function neural_moisture(n::NODE, u0, ps, st, input, soildepth; dt = 1.0f0)
    
    st_model = Lux.StatefulLuxLayer{true}(n.model, ps, st)

    rhs(u, p, t) = st_model(vcat(u./soildepth, input), p) 
    
    prob = ODEProblem{false}(ODEFunction{false}(rhs), u0, n.tspan, ps)
    
    return solve(prob, n.solver; dt = dt)
end

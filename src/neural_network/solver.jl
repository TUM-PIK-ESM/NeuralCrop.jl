"""Minimal explicit-Euler solver tag for neural ODE updates."""
struct SciMLEuler
end 

"""Solve a DE problem with one explicit-Euler step."""
function solve(prob::SciMLBase.AbstractDEProblem, solver::SciMLEuler; kwargs...)

    u = prob.u0
    f = prob.f
    p = prob.p
    t = prob.tspan[1]
    
    dt = kwargs[:dt]
    
    u = @muladd u + dt .* f(u, p, t)

    return u
end


"""Explicit-Euler solver tag returning updated state and litter decay flux."""
struct SciMLEuler_litc
end 

"""Solve with explicit Euler and return `(u_new, respiration_like_flux)`."""
function solve(prob::SciMLBase.AbstractDEProblem, solver::SciMLEuler_litc; kwargs...)

    u = prob.u0
    f = prob.f
    p = prob.p
    t = prob.tspan[1]
    
    dt = kwargs[:dt]
    
    u = @muladd u + dt .* f(u, p, t)

    return u, -f(u, p, t)
end


"""Explicit-Euler solver tag for soil-carbon style transition updates."""
struct SciMLEuler_soilc
end 

"""Solve with explicit Euler including transition/input forcing terms."""
function solve(prob::SciMLBase.AbstractDEProblem, solver::SciMLEuler_soilc; kwargs...)

    u = prob.u0
    f = prob.f
    p = prob.p
    t = prob.tspan[1]
    
    A_trans = kwargs[:A_trans]
    c_input = kwargs[:c_input]
    dt = kwargs[:dt]
    
    u =  @muladd u + dt .* (A_trans .* c_input + f(u, p, t))

    return u, -f(u, p, t)
end

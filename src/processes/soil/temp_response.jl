"""
temp_response(temp; lpjmlparams=lpjmlparams)

Calculate the temperature response function for soil decomposition based on LPJmL's formulation. The function is defined as
`g(T) = exp(e0 * (1/(temp_response+10) - 1/(T+temp_response)))` for `T >= -40`,
otherwise `0`.
"""
function temp_response(temp::AbstractArray{T};
                       lpjmlparams::LPJmLParams = lpjmlparams
) where {T <: AbstractFloat}

    @unpack e0, temp_response = lpjmlparams
    
    return ifelse.(temp .>= T(-40.0), exp.(e0 .* (one(T) / (temp_response + T(10.0)) .- one(T) ./ (temp .+ temp_response))), zero(T))
end

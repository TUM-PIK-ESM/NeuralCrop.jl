function z_score_one_dimension(x::AbstractArray{T}) where {T <: AbstractFloat}
    μ = mean(x; dims = 1)
    σ = std(x; dims = 1)
    x_norm = similar(x)

    if σ[1] == 0
        x_norm .= 0.0f0
    else
        x_norm = (x .- μ) ./ σ
    end
    
    return x_norm, μ, σ
end

function z_score_norm(x::AbstractArray{T}) where {T <: AbstractFloat}
    μ = vec(mean(x; dims = 1))
    σ = vec(std(x; dims = 1))
    x_norm = similar(x)

    for i in axes(x, 2)
        if σ[i] == 0
            x_norm[:, i] .= 0.0f0
        else
            x_norm[:, i] = (x[:, i] .- μ[i]) ./ σ[i]
        end
    end

    return x_norm, μ, σ
end

function apply_z_score(x::AbstractArray{T}, μ, σ) where {T <: AbstractFloat}
    x_norm = similar(x)

    for i in axes(x, 2)
        if σ[i] == 0
            x_norm[:, i] .= 0.0f0
        else
            x_norm[:, i] = (x[:, i] .- μ[i]) ./ σ[i]
        end
    end
    
    return x_norm
end


function min_max_one_dimension(x)
    x_min = minimum(x; dims = 1)
    x_max = maximum(x; dims = 1)
    if x_max[1] == x_min[1]
        x_norm .= 0.0f0
        x_max[1] = x_min[1] + 1.0f0
    else
        x_norm = (x .- x_min) ./ (x_max .- x_min)
    end

    return x_norm, x_min, x_max
end

function min_max_norm(x)
    
    x_min = vec(minimum(x; dims=1))
    x_max = vec(maximum(x; dims=1))
    x_norm = similar(x)

    for i in axes(x, 2)
        if x_max[i] == x_min[i]
            x_norm[:, i] .= 0.0f0
        elseif abs(x_max[i]) < 1f-3
            x_norm[:, i] = x[:, i]
            x_max[i] = 1.0f0
            x_min[i] = 0.0f0
        elseif (x_max[i] - x_min[i]) < 1.0
            x_min[i] = 0.0f0
            x_norm[:, i] = (x[:, i] .- x_min[i]) ./ (x_max[i] - x_min[i])
        else
            x_norm[:, i] = (x[:, i] .- x_min[i]) ./ (x_max[i] - x_min[i])
        end
    end

    # for i in axes(x, 2)
    #     if (x_max[i] == x_min[i]) && (x_max[i] == 0)
    #         x_max[i] = 1.0f0
    #         x_min[i] = 0.0f0
    #         x_norm[:, i] .= 0.0f0
    #     elseif (x_max[i] == x_min[i]) && (x_max[i] != 0)
    #         x_min[i] = 0.0f0
    #         x_norm[:, i] .= 1.0f0
    #     elseif abs(x_max[i]) < 1f-3
    #         x_norm[:, i] = x[:, i]
    #         x_max[i] = 1.0f0
    #         x_min[i] = 0.0f0
    #     else
    #         x_norm[:, i] = (x[:, i] .- x_min[i]) ./ (x_max[i] - x_min[i])
    #     end
    # end

    return x_norm, x_min, x_max
end
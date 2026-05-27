"""
spatial_group_split(indices, coords, rng; train_ratio=0.8, lon_block=8, lat_block=8)

Split indices into training and validation sets based on spatial groups.
"""

function spatial_group_split(indices, coords, rng; train_ratio=0.8, lon_block=8, lat_block=8)
    group_to_indices = Dict{Tuple{Int, Int}, Vector{Int}}()
    for idx in indices
        lonidx, latidx = coords[idx]
        key = (cld(lonidx, lon_block), cld(latidx, lat_block))
        if !haskey(group_to_indices, key)
            group_to_indices[key] = Int[]
        end
        push!(group_to_indices[key], idx)
    end

    groups = collect(keys(group_to_indices))
    shuffle!(rng, groups)

    train_target = floor(Int, train_ratio * length(indices))
    train_idx = Int[]
    valid_idx = Int[]
    n_train = 0
    for g in groups
        g_idx = group_to_indices[g]
        if n_train < train_target
            append!(train_idx, g_idx)
            n_train += length(g_idx)
        else
            append!(valid_idx, g_idx)
        end
    end

    if isempty(valid_idx)
        g_last = groups[end]
        valid_idx = group_to_indices[g_last]
        train_idx = setdiff(train_idx, valid_idx)
    end
    return train_idx, valid_idx
end
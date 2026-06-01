"""
soil_nitrogen!(crop_cal, crop, soil)

Update litter and soil nitrogen pools and crop-available mineral nitrogen.
"""
function soil_nitrogen!(crop_cal::Calendar,
                        soil::Soil;
                        lpjmlparams::LPJmLParams = lpjmlparams,
                        soil_decomp_params::SoilDecompParams = soil_decomp_params
)

    @unpack intercept, moist3, moist2, moist1, eps = soil_decomp_params

    # compute soil carbon: litter carbon and soil carbon
    # soil.decom_litn = (1.0f0 .- exp.(-soil.respose_litn / 100)) .* soil.litn
    moist = (soil.w .* soil.whcs .+ soil.wpwps .+ soil.w_fw) ./ max.(soil.wsats .- soil.wpwps, eps)
    moist = clamp.(moist, eps, 1.0f0)
    gtemp_soil = temp_response(soil.temp; lpjmlparams = lpjmlparams)
    response = gtemp_soil .* (intercept .+ moist3 .* moist.^3 .+ moist2 .* moist.^2 .+ moist1 .* moist)
    response = clamp.(response, 0.0f0, 1.0f0)
    
    response_litter = reshape(response[1, :], (1, :))
    soil.decom_litn = (1.0f0 .- exp.(-soil.respose_litn .* response_litter)) .* soil.litn
    soil.litn = soil.litn  - soil.decom_litn

    # using 'callback' to adjust litter carbon due to tillage, 'scallback' means the tillage of sowing day and 'hcallback' means the tillage of harvesting day
    update_litn_tillage!(soil, crop_cal)

    # soil.decom_fastn = (1.0f0 .- exp.(-soil.respose_fastn .* response / 50)) .* soil.fastn
    soil.decom_fastn = (1.0f0 .- exp.(-soil.respose_fastn .* response)) .* soil.fastn
    soil.fastn = soil.fastn + soil.n_shift_fast .* sum(soil.decom_litn, dims = 1) - soil.decom_fastn
 
    # soil.decom_slown = (1.0f0 .- exp.(-soil.respose_slown .* response / 10)) .* soil.slown
    soil.decom_slown = (1.0f0 .- exp.(-soil.respose_slown .* response)) .* soil.slown
    soil.slown = soil.slown + soil.n_shift_slow .* sum(soil.decom_litn, dims = 1) - soil.decom_slown

    # Nitrogen mineralization/immobilization/nitrification updates.
    # TODO: we do not yet test it, so we close it for now.
    # nitrogen_transform!(soil; lpjmlparams = lpjmlparams)
    
end


"""
update_litn_tillage!(soil, crop_cal)

Apply tillage/harvest crop nitrogen to litter nitrogen pools.
"""
function update_litn_tillage!(soil::Soil,
                              crop_cal::Calendar
)

    soil.litn = soil.litn .* (1 .- reshape(crop_cal.scallback, (1, :))) .* (1 .- reshape(crop_cal.hcallback, (1, :))) + 
                soil.tillage_frac * soil.litn .* reshape(crop_cal.scallback, (1, :)) +
                (soil.tillage_frac * (soil.litn .+ soil.c_input)) .* reshape(crop_cal.hcallback, (1, :)) 

end


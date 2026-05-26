"""
soiltemp_lag!(soil, climbuf, device; DEPTH=0.25f0, DIFFUS_CONV=0.0864f0, HALF_OMEGA=0.008607f0)

Compute lagged soil temperature profile from climate buffer and soil diffusivity.
"""
function soiltemp_lag!(soil::Soil,
                       climbuf::ClimBuf,
                       device;
                       DEPTH = 0.25f0,
                       DIFFUS_CONV = 0.0864f0,
                       HALF_OMEGA = 0.008607f0)

    a, b = linreg(climbuf.temp, device)

    soil_diffus = (soil.tdiff_15 - soil.tdiff_0) ./ 0.15f0 * 0.03f0 + soil.tdiff_0
    soil_alag = DEPTH ./ sqrt.(soil_diffus * DIFFUS_CONV ./ HALF_OMEGA)

    launch_1d!(soiltemp_lag_kernel!,
               climbuf.atemp_mean,
               climbuf.temp,
               soil_alag,
               soil.w,
               soil.temp,
               a,
               b)

end

@kernel function soiltemp_lag_kernel!(climbuf_atemp_mean::AbstractArray{T},
                                      climbuf_temp::AbstractArray{M},
                                      soil_alag::AbstractArray{T},
                                      soil_w::AbstractArray{M},
                                      soil_temp::AbstractArray{M},
                                      a::AbstractArray{T},
                                      b::AbstractArray{T},
                                      NDAYS = 31 # NDAYS
) where {T <: AbstractFloat, M <: AbstractFloat}
    
    cell = @index(Global)

    temp_lag = zero(T)

    if soil_w[1, cell] < 1.0f-5
        soil_temp[1, cell] = climbuf_temp[NDAYS-1, cell]
        soil_temp[2, cell] = climbuf_temp[NDAYS-1, cell]
        soil_temp[3, cell] = climbuf_temp[NDAYS-1, cell]
        soil_temp[4, cell] = climbuf_temp[NDAYS-1, cell]
        soil_temp[5, cell] = climbuf_temp[NDAYS-1, cell]
    else
        temp_lag = a[cell] + b[cell] * (NDAYS - 1 - soil_alag[cell] * 365 * T(0.5) * T(0.3183098)) # LAG_CONV(NDAYYEAR*0.5*M_1_PI) = 365 * T(0.5) * T(0.3183098)
        soil_temp[1, cell] = climbuf_atemp_mean[cell] + exp(-soil_alag[cell]) * (temp_lag - climbuf_atemp_mean[cell])
        soil_temp[2, cell] = climbuf_atemp_mean[cell] + exp(-soil_alag[cell]) * (temp_lag - climbuf_atemp_mean[cell])
        soil_temp[3, cell] = climbuf_atemp_mean[cell] + exp(-soil_alag[cell]) * (temp_lag - climbuf_atemp_mean[cell])
        soil_temp[4, cell] = climbuf_atemp_mean[cell] + exp(-soil_alag[cell]) * (temp_lag - climbuf_atemp_mean[cell])
        soil_temp[5, cell] = climbuf_atemp_mean[cell] + exp(-soil_alag[cell]) * (temp_lag - climbuf_atemp_mean[cell])
    end

end


function linreg(climbuf_temp::AbstractArray{M},
                device
) where {M <: AbstractFloat}


    a = device(zeros(Float32, size(climbuf_temp, 2)))
    b = device(zeros(Float32, size(climbuf_temp, 2)))

    launch_1d!(linreg_kernel!, a, b, climbuf_temp)

    return a, b

end


@kernel function linreg_kernel!(a::AbstractArray{T},
                                b::AbstractArray{T},
                                climbuf_temp::AbstractArray{M},
                                NDAYS = 31 # NDAYS
) where {T <: AbstractFloat, M <: AbstractFloat}
    
    cell = @index(Global)
    
    ∑x = NDAYS * (NDAYS + 1) / 2
    ∑x² = (NDAYS * (NDAYS + 1) * (2 * NDAYS + 1)) / 6
    ∑y = zero(T)
    ∑xy = zero(T)
    n = 1

    for day in 1:NDAYS
        ∑y += climbuf_temp[day, cell]
        ∑xy += climbuf_temp[day, cell] * n
        n += 1
    end

    Δ = 1 / (n * ∑x² - ∑x * ∑x)
    a[cell] = (∑x² * ∑y - ∑x * ∑xy) * Δ
    b[cell] = (n * ∑xy - ∑x * ∑y) * Δ

end

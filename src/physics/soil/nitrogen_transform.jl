"""
nitrogen_transform!(soil, c_shift_fast, c_shift_slow; lpjmlparams=lpjmlparams, k_l=0.0f0)

Apply mineralization, immobilization, and nitrification transformations in soil N pools.
"""
function nitrogen_transform!(soil::Soil,
                             c_shift_fast::AbstractArray{T},
                             c_shift_slow::AbstractArray{T};
                             lpjmlparams::LPJmLParams = lpjmlparams,
                             k_l = 0.0f0 # Parton et al., 2001 equ. 2
) where {T <: AbstractFloat}

    @unpack fastfrac, atmfrac, k_soil10 = lpjmlparams

    # NO3 and N2O from mineralization of litter organic matter
    F_Nmineral = sum(soil.decom_litn, dims = 1) * atmfrac .* (fastfrac * c_shift_fast + (1.0f0 - fastfrac) * c_shift_slow);
    soil.NH4 .+= F_Nmineral * (1 - k_l)
    soil.NO3 .+= F_Nmineral * k_l

    # NO3 and N2O from mineralization of soil organic matter
    F_Nmineral = soil.decom_fastn + soil.decom_slown
    soil.NH4 .+= F_Nmineral * (1 - k_l)
    soil.NO3 .+= F_Nmineral * k_l

    # Immobilization consumes mineral N (NH4 + NO3) and transfers it to slow soil pools.
    # decom_sum_lit* are reduced to 1D cell vectors for 1D kernel launch.
    decom_sum_litc = vec(sum(soil.decom_litc, dims = 1))
    decom_sum_litn = vec(sum(soil.decom_litn, dims = 1))
    launch_1D!(immobilize_kernel!,
                decom_sum_litc, 
                decom_sum_litn,
                soil.NH4,
                soil.NO3,
                soil.slown,
                c_shift_fast,
                c_shift_slow,
                soil.layer_depth)

    # Nitrification converts NH4 to NO3 with soil moisture/temperature modifiers.
    launch_1D!(nitrify_kernel!,
                soil.ph,
                soil.NH4,
                soil.NO3,
                soil.swc,
                soil.wsats,
                soil.temp)

end



@kernel function immobilize_kernel!(decom_sum_litc::AbstractArray{T},
                                    decom_sum_litn::AbstractArray{T},
                                    soil_NH4::AbstractArray{M},           
                                    soil_NO3::AbstractArray{M},
                                    soil_slown::AbstractArray{M},
                                    c_shift_fast::AbstractArray{T},
                                    c_shift_slow::AbstractArray{T},
                                    soil_layer_depth::AbstractArray{T};
                                    lpjmlparams::LPJmLParams = lpjmlparams,
                                    cn_ratio = 15,
                                    soil_layers = 5,
                                    k_N = 5f-3
) where {T <: AbstractFloat, M <: AbstractFloat}
    
    cell = @index(Global)

    @unpack fastfrac, atmfrac, k_soil10 = lpjmlparams

    # Each thread updates all soil layers for one cell.
    for l in 1:soil_layers

        N_sum = soil_NH4[l, cell] + soil_NO3[l, cell]
        if(N_sum > 0) # immobilization of N 
            n_immo = fastfrac * (1 - atmfrac) * (decom_sum_litc / cn_ratio - decom_sum_litn) * c_shift_fast[l] * N_sum / soil_layer_depth[l] * 1f3 / (k_N + N_sum / soil_layer_depth[l] * 1f3)
            if(n_immo > 0)
                if(n_immo > N_sum)
                    n_immo = N_sum
                end
                soil_slown[l, cell] += n_immo
                soil_NH4[l, cell] -= n_immo * soil_NH4[l, cell] / N_sum
                soil_NO3[l, cell] -= n_immo * soil_NO3[l, cell] / N_sum
            end
        end

        # Fast/slow litter fractions are handled separately with different shift factors.
        N_sum = soil_NH4[l, cell] + soil_NO3[l, cell]
        if(N_sum > 0) # immobilization of N 
            n_immo = (1 - fastfrac) * (1 - atmfrac) * (decom_sum_litc / cn_ratio - decom_sum_litn) * c_shift_slow[l] * N_sum / soil_layer_depth[l] * 1f3 / (k_N + N_sum / soil_layer_depth[l] * 1f3)
            if(n_immo > 0)
                if(n_immo > N_sum)
                    n_immo = N_sum
                end
                soil_slown[l, cell] += n_immo
                soil_NH4[l, cell] -= n_immo * soil_NH4[l, cell] / N_sum
                soil_NO3[l, cell] -= n_immo * soil_NO3[l, cell] / N_sum
            end
        end
    end

end


@kernel function nitrify_kernel!(soil_ph::AbstractArray{T},
                                 soil_NH4::AbstractArray{M},           
                                 soil_NO3::AbstractArray{M},
                                 soil_swc::AbstractArray{M},
                                 soil_wsats::AbstractArray{M},
                                 soil_temp::AbstractArray{M};
                                 lpjmlparams::LPJmLParams = lpjmlparams,
                                 soil_layers = 5,
                                 a_nit = 0.45f0,
                                 b_nit = 1.27f0,
                                 c_nit = 0.0012f0,
                                 d_nit = 2.84f0
) where {T <: AbstractFloat, M <: AbstractFloat}
    
    cell = @index(Global)

    @unpack k_max, k_2 = lpjmlparams

    # Potential nitrification rate is shaped by water-filled pore space and temperature response.
    for l in 1:soil_layers

        x = soil_swc[l, cell] / soil_wsats[l, cell]
        n_nit = a_nit - b_nit
        m_nit = a_nit - c_nit
        z_nit = d_nit * (b_nit - a_nit) / (a_nit - c_nit)
        fac_wfps = ((x - b_nit) / n_nit)^(z_nit) * ((x - c_nit) / m_nit)^(d_nit)
        fac_temp = exp(-(soil_temp[l, cell] - T(18.79))^2 / T(2*5.26*5.26))

        F_NO3 = k_max * soil_NH4[l, cell] * fac_temp * fac_wfps * soil_ph[cell]
        if F_NO3 > soil_NH4[l, cell]
            F_NO3 = soil_NH4[l, cell]
        end
        # F_N2O = k_2 * F_NO3
        soil_NO3[l, cell] += F_NO3 * (1 - k_2)
        soil_NH4[l, cell] -= F_NO3
    end
end

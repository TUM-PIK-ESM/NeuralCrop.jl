# space validation
"""
train_loop_rollout!(...)

Run epoch-wise training for rollout-based objectives and checkpoint outputs.
"""
# space validation
function train_loop!(climate_path, daily_crop, crop_name, irrigation, usingNODE, rollout, nn_model, ps, ps_frozen, st, pftparameters, data, train_i, valid_i, loss_func, opt_state, η_schedule, device, save_path; batch_size=10, N_epochs=1, scheduler_offset::Int=0, save_mode::Symbol=:valid)
    
    @assert save_mode in [:valid, :train] "save_mode has to be :valid or :train"
    
    best_ps = deepcopy(ps)
    results = (i_epoch = Int[], train_loss=Float32[], learning_rate=Float32[], duration=Float32[], valid_loss=Float32[], loss_min=[Inf32], i_epoch_min=[1])
    
    progress = Progress(N_epochs, 1)
    
     # initial error 
    lowest_train_err = Inf
    lowest_valid_err = Inf
    
    for i_epoch in 1:N_epochs

        Optimisers.adjust!(opt_state, Float32(η_schedule(i_epoch + scheduler_offset)))

        epoch_start_time = time()

        ### ========================================== ###
        ###               Training Loop                ###
        ### ========================================== ###
        loss_trian = []
        for i in 1:batch_size:length(train_i)
            batch_i = i:min(i+batch_size-1, length(train_i))
            data_index = train_i[batch_i]

            InitialData = InitialDataLoader(data, data_index, device; training = true, training_by_yield = true)
            climbuf, crop, crop_cal, photos, pet, soil, managed_land, dailyWeather, output = init_states!(pftparameters, InitialData, length(data_index), device)

            loss_trian_rollout = []
            for chunk_i in 1:2
                start_year = 1981 + (chunk_i - 1) * 10
                if chunk_i == 4
                    end_year = 2016
                    years = 6 # how many years
                else
                    end_year = start_year + 9
                    years = 10 # how many years
                end
                start_day = 1
                end_day = 365*years
        
                @load joinpath(climate_path, "climate_$(crop_name)_$(start_year)_$(end_year).jld2") climate
            
                climate = ClimateDataLoader(climate, data_index, device)
                
                ## climate spin-up
                if chunk_i == 1
                    spin_up_climbuf!(pftparameters, climate.temp_spinup, climbuf, 1, device)
                end
                data_batch = (; latitude = InitialData.latitude, climate, ModelState = InitialData.ModelState)
        
                for day in start_day:rollout:end_day
                    day_start = day
                    day_end = min(day+rollout-1, end_day)
                    loss_p(ps) = loss_func(chunk_i, daily_crop, irrigation, usingNODE, day_start, day_end, nn_model, ps, ps_frozen, st, pftparameters, data_batch, length(data_index), climbuf, crop, crop_cal, photos, pet, soil, managed_land, dailyWeather, output, device)
                    l, gs = Zygote.withgradient(loss_p, ps)
                    if !isnan(l) && !isinf(l)
                        push!(loss_trian_rollout, l)
                        opt_state, ps = Optimisers.update(opt_state, ps, gs[1])
                    else
                        @warn "Training loss too large ($l), skipping update to prevent NaN."
                    end
                end
            end
            if !isempty(loss_trian_rollout)
                push!(loss_trian, mean(loss_trian_rollout))
            end
        end
        train_err = mean(loss_trian)
        epoch_time = time() - epoch_start_time
        push!(results[:i_epoch], i_epoch)
        push!(results[:train_loss], train_err)
        push!(results[:learning_rate], η_schedule(i_epoch))
        push!(results[:duration], epoch_time)

        ### ========================================== ###
        ###              Validation Loop               ###
        ### ========================================== ###
        loss_valid = []
        for i in 1:batch_size:length(valid_i)
            batch_i = i:min(i+batch_size-1, length(valid_i))
            data_index = valid_i[batch_i]

            InitialData = InitialDataLoader(data, data_index, device; training = true, training_by_yield = true)
            climbuf, crop, crop_cal, photos, pet, soil, managed_land, dailyWeather, output = init_states!(pftparameters, InitialData, length(data_index), device)

            loss_valid_rollout = []
            for chunk_i in 1:2
                start_year = 1981 + (chunk_i - 1) * 10
                if chunk_i == 4
                    end_year = 2016
                    years = 6 # how many years
                else
                    end_year = start_year + 9
                    years = 10 # how many years
                end
                start_day = 1
                end_day = 365*years
        
                @load joinpath(climate_path, "climate_$(crop_name)_$(start_year)_$(end_year).jld2") climate
            
                climate = ClimateDataLoader(climate, data_index, device)
                
                ## climate spin-up
                if chunk_i == 1
                    spin_up_climbuf!(pftparameters, climate.temp_spinup, climbuf, 1, device)
                end
                data_batch = (; latitude = InitialData.latitude, climate, ModelState = InitialData.ModelState)
        
                for day in start_day:rollout:end_day
                    day_start = day
                    day_end = min(day+rollout-1, end_day)
                    l = loss_func(chunk_i, daily_crop, irrigation, usingNODE, day_start, day_end, nn_model, ps, ps_frozen, st, pftparameters, data_batch, length(data_index), climbuf, crop, crop_cal, photos, pet, soil, managed_land, dailyWeather, output, device)
                    if !isnan(l) && !isinf(l)
                        push!(loss_valid_rollout, l)
                    else
                        @warn "Validation loss too large ($l), skipping."
                    end
                end
            end
            if !isempty(loss_valid_rollout)
                push!(loss_valid, mean(loss_valid_rollout))
            end
        end
        valid_err = mean(loss_valid)
        push!(results[:valid_loss], valid_err)

        next!(progress; showvalues = [(:i_epoch, i_epoch), (:train_loss, train_err), (:valid_loss, valid_err)])
        
        if i_epoch == N_epochs
            plot_loss_curve(results[:i_epoch], results[:train_loss], results[:valid_loss], save_path.fig_path)
        end
        
        if save_mode==:valid
            if valid_err < lowest_valid_err
                lowest_valid_err = valid_err 
                best_ps = deepcopy(ps)
                results[:loss_min] .= lowest_valid_err
                results[:i_epoch_min] .= i_epoch
            end
        else
            if train_err < lowest_train_err
                lowest_train_err = train_err
                best_ps = deepcopy(ps)
                results[:loss_min] .= lowest_train_err
                results[:i_epoch_min] .= i_epoch
            end
        end

        print(" -> validation loss: $lowest_valid_err")
        flush(stdout)

        ps_save = adapt(Array, best_ps)
        @save save_path.ps_path ps_save

    end

    return nn_model, best_ps, st, results
    
end
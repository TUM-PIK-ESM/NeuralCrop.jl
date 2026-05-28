"""
loss_crop_rollout!(daily_crop, day_start, day_end, nn_model, ps, st, parameters, data_i, batch_size, climbuf, crop, crop_cal, photos, pet, soil, managed_land, output, device)

Compute rollout loss for hybrid training against LPJmL-normalized targets.
"""
function loss_crop_rollout!(daily_crop, day_start, day_end, nn_model, ps, st, parameters, data_i, batch_size, climbuf, crop, crop_cal, photos, pet, soil, managed_land, output, device)
    
    @unpack ModelState = data_i
    
    output = daily_crop(day_start, day_end, nn_model, ps, ps_frozen, st, parameters, data_i, batch_size, climbuf, crop, crop_cal, photos, pet, soil, managed_land, dailyWeather, output, device)
    
    # generate crop growing mask
    growing_mask_gpp = output.growing_mask[2:end, :][day_start:day_end, :]
    growing_mask_vegc = repeat(output.growing_mask[2:end, :][day_start:day_end, :], 1, 4)[:, sort(repeat(1:size(output.growing_mask[2:end, :][day_start:day_end, :], 2), 4))] 

    if isempty(growing_mask_gpp[growing_mask_gpp .!= 0])
        gpp_loss = mean(abs2, ((output.gpp[2:end, :][day_start:day_end, :] .- lpjml.gpp_n[day_start:day_end, :]) .* growing_mask_gpp))
    else
        gpp_loss = mean(abs2, ((output.gpp[2:end, :][day_start:day_end, :] .- lpjml.gpp_n[day_start:day_end, :]) .* growing_mask_gpp))
    end

    data_loss = gpp_loss
     
    return data_loss
end
# A example loss function for hybrid training
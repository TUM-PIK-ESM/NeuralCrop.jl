using Lux, CUDA, LuxCUDA
const gdev = gpu_device()

"""
load_nc_file_one_dimension(file_path, variable)

Load a 1D variable from a NetCDF file.
"""
function load_nc_file_one_dimension(file_path::String, 
                                    variable::String,
                                    timerange::UnitRange
)

    ds = NCDataset(file_path, "r")

    dataset = ds[variable][:, :, timerange]

    close(ds)

    return dataset
end

"""
load_nc_file_dimensions(file_path, variable)

Load a multi-dimensional variable from a NetCDF file.
"""
function load_nc_file_dimensions(file_path::String, 
                                 variable::String,
                                 timerange::UnitRange
)

    ds = NCDataset(file_path, "r")

    dataset = ds[variable][:, :, :, timerange]

    close(ds)

    return dataset
end


function ExtractDay(file_path::String, variable::String, day_index, save_path::String)
    
    ds = NCDataset(file_path, "r")
    extract_band = ds[variable][:, :, day_index]
    
    latitudes = ds["latitude"][:]
    longitudes = ds["longitude"][:]
    times = ds["time"][day_index]
    
    new_dataset = NCDataset(save_path, "c")
    
    defDim(new_dataset, "latitude", length(latitudes))
    defDim(new_dataset, "longitude", length(longitudes))
    defDim(new_dataset, "time", length(times)) 

    defVar(new_dataset, "latitude", latitudes, ("latitude",), attrib = OrderedDict(
                   "units" => "degrees_north",
                   "long_name" => "latitude",
                   "standard_name" => "latitude",
                   "axis" => "Y"))
    defVar(new_dataset, "longitude", longitudes, ("longitude",), attrib = OrderedDict(
                   "units" => "degrees_east",
                   "long_name" => "longitude",
                   "standard_name" => "longitude",
                   "axis" => "X"))
    defVar(new_dataset, "time", times, ("time",), attrib = OrderedDict(
                   "units" => "days since 2010-1-1 0:0:0",
                   "calendar" => ds["time"].attrib["calendar"]))
    
    extract_var = defVar(new_dataset, variable, extract_band, ("longitude", "latitude", "time"), attrib = OrderedDict(
               "units" => ds[variable].attrib["units"],
               "missing_value" => ds[variable].attrib["missing_value"],
               "_FillValue" => ds[variable].attrib["_FillValue"]))
    
    extract_var[:, :, :] = extract_band
    
    close(new_dataset)
    close(ds)
    
end

# change date into index
function TimeToIdx(year, month, day, time)
    target_date = DateTimeNoLeap(year, month, day)
    time_idx = findall(x -> x == target_date, time)[1]
    
    return time_idx
end

# Crop processes

Crop processes convert daily forcing and soil state into crop growth, stress, carbon gain, nitrogen dynamics, water use, and harvest output.

The daily crop order is approximately:

1. Read climate and update snow.
2. Apply cultivation and fertilizer management.
3. Update climate buffers, albedo, radiation, and soil temperature.
4. Update phenology and harvest state.
5. Compute photosynthesis and crop carbon.
6. Update nitrogen allocation and uptake.
7. Compute interception, transpiration, and evaporation.

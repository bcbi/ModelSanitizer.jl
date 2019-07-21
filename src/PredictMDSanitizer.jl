module PredictMDSanitizer

include("../ext/Requires/src/Requires.jl")

include("sanitize.jl")

function __init__()::Nothing
    Requires.@require DataFrames="a93c6f00-e57d-5684-b7b6-d8193f3e46c0" include("dataframes.jl")
    return nothing
end

end # module

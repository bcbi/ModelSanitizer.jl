module ModelSanitizer

export sanitize!
export Model, Data

include("../ext/Requires/src/Requires.jl")

include("types.jl")

include("arrays.jl")
include("elements.jl")
include("sanitize.jl")
include("x-is-in-y.jl")
include("utils.jl")

function __init__()::Nothing
    Requires.@require DataFrames="a93c6f00-e57d-5684-b7b6-d8193f3e46c0" include("dataframes.jl")
    return nothing
end

end # module

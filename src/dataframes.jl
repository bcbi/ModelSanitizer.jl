import .DataFrames

function sanitize!(x::T)::Nothing where T <: DataFrames.AbstractDataFrame
    while sum(size(x)) > 0
        DataFrames.select!(x, DataFrames.Not(:))
    end
    return nothing
end

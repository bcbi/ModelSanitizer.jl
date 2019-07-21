import .DataFrames

function sanitize!(x::T)::Nothing where T <: DataFrames.AbstractDataFrame
    while sum(size(x)) > 0
        try
            DataFrames.select!(x, DataFrames.Not(:))
        catch
            DataFrames.deletecols!(x, :)
        end
    end
    return nothing
end

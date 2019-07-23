import .DataFrames

function _sanitize!(df::T)::T where T <: DataFrames.AbstractDataFrame
    while sum(size(df)) > 0
        try
            DataFrames.select!(df, DataFrames.Not(:))
        catch
            DataFrames.deletecols!(df, :)
        end
    end
    return df
end

# _elements(df) = _elements()

function _elements!(all_elements::Vector{Any}, df::DataFrames.AbstractDataFrame) where T
    append!(all_elements, df)
    _elements(all_elements, convert(Array, df))
    return all_elements
end

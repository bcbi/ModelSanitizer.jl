function _sanitize!(arr::A, data, elements; matches::Integer = 5)::A where A <: AbstractArray{T, N} where T where N
    # while sum(size(df)) > 0
    #     try
    #         DataFrames.select!(df, DataFrames.Not(:))
    #     catch
    #         DataFrames.deletecols!(df, :)
    #     end
    # end
    # return df
    return arr
end

function _elements!(all_elements::Vector{Any}, arr::AbstractArray)
    append!(all_elements, df)
    for object in arr
        _elements!(all_elements, object)
    end
    return all_elements
end

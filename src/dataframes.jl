import .DataFrames

function _sanitize!(df::T)::T where T <: DataFrames.AbstractDataFrame
    zero!(df)
    return df
end

function zero!(df::T)::T where T <: DataFrames.AbstractDataFrame
    for column in names(df)
        df[:, column] .= zero!(df[:, column])
    end
    return df
end

# function _sanitize!(df::T)::T where T <: DataFrames.AbstractDataFrame
#     zero!(df)
#     while sum(size(df)) > 0
#         try
#             DataFrames.select!(df, DataFrames.Not(:))
#         catch
#             DataFrames.deletecols!(df, :)
#         end
#     end
#     return df
# end

function _elements!(all_elements::Vector{Any}, df::DataFrames.AbstractDataFrame) where T
    append!(all_elements, df)
    _elements(all_elements, convert(Array, df))
    return all_elements
end

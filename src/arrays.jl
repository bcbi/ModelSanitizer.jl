function _how_many_elements_occur_in_this_array(elements::_DataElements{T}, arr::AbstractArray)::Int where T
    temp::Vector{Bool} = Vector{Bool}(undef, length(elements.v))
    for i = 1:length(elements.v)
        temp[i] = elements.v[i] in arr
    end
    result::Int = sum(temp)
    return result
end

function _sanitize!(arr::A, data::Vector{Data}, elements::_DataElements{T}; required_matches::Integer = 5)::A where A <: AbstractArray{T, N} where T where N
    if _how_many_elements_occur_in_this_ariray(elements, arr) >= required_matches
        zero!(arr)
    end
    return arr
end

function _elements!(all_elements::Vector{Any}, arr::AbstractArray)
    # push!(all_elements, arr)
    for object in arr
        _elements!(all_elements, object)
    end
    return all_elements
end

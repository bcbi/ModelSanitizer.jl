function _x_in_y(x, y::AbstractArray)::Bool
    for i = 1:length(y)
        if isassigned(y, i)
            if isapprox(x, y[i])
                return true
            end
        end
    end
    return false
end

_x_in_y(x::Missing, y::AbstractArray)::Bool = false

function _how_many_elements_occur_in_this_array(elements::_DataElements{T}, arr::AbstractArray)::Int where T
    temp::Vector{Bool} = Vector{Bool}(undef, length(elements.v))
    for i = 1:length(elements.v)
        temp[i] = _x_in_y(elements.v[i], arr)
    end
    result::Int = sum(temp)
    return result
end

function _sanitize!(arr::AbstractArray, data::Vector{Data}, elements::_DataElements; required_matches::Integer = 5)
    for i = 1:length(arr)
        if isassigned(arr, i)
            _sanitize!(arr[i], data::Vector{Data}, elements::_DataElements)
        end
    end
    if _how_many_elements_occur_in_this_array(elements, arr) >= required_matches
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

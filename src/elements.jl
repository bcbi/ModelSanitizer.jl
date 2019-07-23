function _elements(d::T) where T
    all_elements = Vector{Any}(undef, 0)
    _elements!(all_elements, d)
    all_elements_typefixed = _fix_vector_type(all_elements)
    unique!(all_elements_typefixed)
    result = _DataElements(all_elements_typefixed)
    return result
end

function _elements!(all_elements::Vector{Any}, d::V) where V <: AbstractVector{D} where D <: Data{T} where T
    # push!(all_elements, d)
    _elements_fields!(all_elements, d)
    _elements_iterable!(all_elements, d)
    _elements_indexable!(all_elements, d)
    return all_elements
end

function _elements!(all_elements::Vector{Any}, d::D) where D <: Data{T} where T
    # push!(all_elements, d)
    _elements_fields!(all_elements, d)
    _elements_iterable!(all_elements, d)
    _elements_indexable!(all_elements, d)
    return all_elements
end

function _elements!(all_elements::Vector{Any}, d::T) where T
    push!(all_elements, d)
    _elements_fields!(all_elements, d)
    _elements_iterable!(all_elements, d)
    _elements_indexable!(all_elements, d)
    return all_elements
end

function _elements_fields!(all_elements::Vector{Any}, d::T) where T
    for field in fieldnames(T)
        _elements!(all_elements, _get_property(d, field))
    end
    return all_elements
end

function _elements_iterable!(all_elements::Vector{Any}, d::T) where T
    if _is_iterable(T)
        try
            for object in d
                try
                    _elements!(all_elements, object)
                catch ex_inner
                    # showerror(stderr, ex)
                    # Base.show_backtrace(stderr, catch_backtrace())
                    # @debug("Ignoring exception [inner]", exception=(ex, catch_backtrace()))
                end
            end
        catch ex_outer
            # showerror(stderr, ex)
            # Base.show_backtrace(stderr, catch_backtrace())
            # @debug("Ignoring exception [outer]", exception=(ex, catch_backtrace()))
        end
    end
    return all_elements
end

function _elements_indexable!(all_elements::Vector{Any}, d::T) where T
    if _has_isassigned(T)
        _elements_indexable_with_check_assigned!(all_elements, d)
    else
        _elements_indexable_without_check_assigned!(all_elements, d)
    end
    return all_elements
end

function _elements_indexable_with_check_assigned!(all_elements::Vector{Any}, d::T) where T
    if _is_indexable(T)
        for i = 1:length(d)
            if isassigned(d, i)
                _elements!(all_elements, d[i])
            end
        end
    end
    return all_elements
end



function _elements_indexable_without_check_assigned!(all_elements::Vector{Any}, d::T) where T
    if _is_indexable(T)
        for i = 1:length(d)
            try
                _elements!(all_elements, d[i])
            catch
            end
        end
    end
    return all_elements
end

function _get_property(m, field)
    try
        result = getproperty(m, field)
        return result
    catch ex
        # showerror(stderr, ex)
        # Base.show_backtrace(stderr, catch_backtrace())
        @debug("Ignoring exception", exception=(ex, catch_backtrace()))
    end
    return nothing
end

# alternatively, we could replace `Union{typeof.(original_array)...}` with
# `typejoin(typeof.(original_array)...)`
function _fix_vector_type(original_vector::V) where V <: AbstractVector{T} where T
    new_vector = convert(Vector{Union{typeof.(original_vector)...}}, original_vector)
    return new_vector
end

function _is_iterable(::Type{T})::Bool where T <: Number
    return false
end

function _is_iterable(::Type{T})::Bool where T <: Char
    return false
end

function _is_iterable(::Type{T})::Bool where T
    return hasmethod(iterate, (T,))
end

function _has_isassigned(::Type{T})::Bool where T
    return hasmethod(isassigned, (T, Int,))
end

function _is_indexable(::Type{T})::Bool where T <: Number
    return false
end

function _is_indexable(::Type{T})::Bool where T <: Char
    return false
end

function _is_indexable(::Type{T})::Bool where T
    return hasmethod(length, (T,))
end

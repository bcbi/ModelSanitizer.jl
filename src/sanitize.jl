"""
"""
function sanitize! end

function sanitize!(x::T)::Nothing where T
    _sanitize_fields!(x)
    _sanitize_iterable!(x)
    _sanitize_indexable!(x)
    return nothing
end

# function sanitize!(x::T)::Nothing where T <: Nothing
#     return nothing
# end

function _sanitize_fields!(x::T)::Nothing where T
    for field in fieldnames(T)
        sanitize!(_get_property(x, field))
    end
    return nothing
end

function _get_property(x, field)
    try
        result = getproperty(x, field)
        return result
    catch ex
        # showerror(stderr, ex)
        # Base.show_backtrace(stderr, catch_backtrace())
        @debug("Ignoring exception", exception=(ex, catch_backtrace()))
    end
    return nothing
end

function _sanitize_iterable!(x::T)::Nothing where T
    if _is_iterable(T)
        try
            for element in x
                try
                    sanitize!(element)
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
    return nothing
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

function _sanitize_indexable(x::T)::Nothing where T
    if _has_isassigned(T)
        _sanitize_indexable_with_check_assigned!(x)
    else
        _sanitize_indexable_without_check_assigned!(x)
    end
    return nothing
end

function _has_isassigned(::Type{T})::Bool where T
    hasmethod(isassigned, (T, Int,))
end

function _sanitize_indexable_with_check_assigned!(x::T)::Nothing where T
    if _is_indexable(T)
        for i = 1:length(x)
            if isassigned(x, i)
                sanitize!(x[i])
            end
        end
    end
    return nothing
end

function _sanitize_indexable_without_check_assigned!(x::T)::Nothing where T
    if _is_indexable(T)
        for i = 1:length(x)
            try
                sanitize!(x[i])
            catch
            end
        end
    end
    return nothing
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

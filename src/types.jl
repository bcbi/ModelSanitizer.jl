"""
    A wrapper around a model to be sanitized.
"""
struct Model{T}
    m::T
end

"""
    A wrapper around a source of data.
"""
struct Data{T}
    d::T
end

struct _DataElements{T}
    v::T
end

function Base.iterate(elements::_DataElements{T}, varargs...) where T
    result = Base.iterate(elements.v, varargs...)
    return result
end

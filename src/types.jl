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

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

struct _Vector_Of_Data_Elements{T}
    arr::T
end

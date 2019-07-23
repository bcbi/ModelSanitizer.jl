function zero!(arr::A) where A <: AbstractArray{T, N} where T where N
    _zero_element = zero(T)
    for i = 1:length(arr)
        arr[i] = _zero_element
    end
    return arr
end

Base.zero(::Type{Any}) = 0

Base.zero(::Type{T}) where T = 0

Base.zero(::Type{T}) where T <: AbstractString = ""

Base.zero(::Type{T}) where T <: Nothing = nothing

Base.zero(::Type{T}) where T <: Missing = missing

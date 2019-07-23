# ModelSanitizer

<p>
<a
href="https://doi.org/10.5281/zenodo.1291209">
<img
src="https://zenodo.org/badge/109460252.svg"/>
</a>
</p>

<p>
<a
href="https://app.bors.tech/repositories/18923">
<img
src="https://bors.tech/images/badge_small.svg"
alt="Bors enabled">
</a>
<a
href="https://travis-ci.com/bcbi/ModelSanitizer.jl/branches">
<img
src="https://travis-ci.com/bcbi/ModelSanitizer.jl.svg?branch=master">
</a>
<a
href="https://codecov.io/gh/bcbi/ModelSanitizer.jl">
<img
src="https://codecov.io/gh/bcbi/ModelSanitizer.jl/branch/master/graph/badge.svg">
</a>
</p>

## Usage

ModelSanitizer exports the `sanitize!` function and the `Model` and `Data`
structs. If your model is stored in `m` and your data are stored in `x1`,
`x2`, `x3`, etc. then you can sanitize your model with:
```julia
sanitize!(Model(M), Data(x1), Data(x2), Data(x3), ...)
```

## Examples

### Example 1

```julia
julia> using ModelSanitizer

julia> using Statistics

julia> using Test

julia> mutable struct LinearModel{T}
           X::Matrix{T}
           y::Vector{T}
           beta::Vector{T}
           function LinearModel{T}()::LinearModel{T} where T
               m::LinearModel{T} = new()
               return m
           end
       end

julia> function fit!(m::LinearModel{T}, X::Matrix{T}, y::Vector{T})::LinearModel{T} where T
           m.X = deepcopy(X)
           m.y = deepcopy(y)
           m.beta = beta = (m.X'm.X)\(m.X'm.y)
           return m
       end
fit! (generic function with 1 method)

julia> function predict(m::LinearModel{T}, X::Matrix{T})::Vector{T} where T
           y_hat::Vector{T} = X * m.beta
           return y_hat
       end
predict (generic function with 1 method)

julia> function mse(y::Vector{T}, y_hat::Vector{T})::T where T
           _mse::T = mean((y .- y_hat).^2)
           return _mse
       end
mse (generic function with 1 method)

julia> function mse(m::LinearModel{T}, X::Matrix{T}, y::Vector{T})::T where T
           y_hat::Vector{T} = predict(m, X)
           _mse::T = mse(y, y_hat)
           return _mse
       end
mse (generic function with 2 methods)

julia> function mse(m::LinearModel{T})::T where T
           X::Matrix{T} = m.X
           y::Vector{T} = m.y
           _mse::T = mse(m, X, y)
           return _mse
       end
mse (generic function with 3 methods)

julia> rmse(varargs...) = sqrt(mse(varargs...))
rmse (generic function with 1 method)

julia> function r2(y::Vector{T}, y_hat::Vector{T})::T where T
           y_bar::T = mean(y)
           SS_tot::T = sum((y .- y_bar).^2)
           SS_res::T = sum((y .- y_hat).^2)
           _r2::T = 1 - SS_res/SS_tot
           return _r2
       end
r2 (generic function with 1 method)

julia> function r2(m::LinearModel{T}, X::Matrix{T}, y::Vector{T})::T where T
           y_hat::Vector{T} = predict(m, X)
           _r2::T = r2(y, y_hat)
           return _r2
       end
r2 (generic function with 2 methods)

julia> function r2(m::LinearModel{T})::T where T
           X::Matrix{T} = m.X
           y::Vector{T} = m.y
           _r2::T = r2(m, X, y)
           return _r2
       end
r2 (generic function with 3 methods)

julia> X = randn(Float64, 5_000, 14)
5000×14 Array{Float64,2}:
  1.84395     -1.56254     2.06219     …  -1.13972      0.0234446  -1.77897
  ⋮                                    ⋱                            ⋮
  0.171551     0.448959   -0.700931    …   0.0807892    0.0605863  -0.953048

julia> y = X * randn(Float64, 14) + randn(5_000)
5000-element Array{Float64,1}:
 -2.560508391420522
  ⋮
  2.982863184584144

julia> m = LinearModel{Float64}()
LinearModel{Float64}(#undef, #undef, #undef)

julia> testing_rows = 1:2:5_000
1:2:4999

julia> training_rows = setdiff(1:5_000, testing_rows)
2500-element Array{Int64,1}:
    2
    ⋮
 5000

julia> fit!(m, X[training_rows, :], y[training_rows])
LinearModel{Float64}([0.00244607 … -0.165779; 0.388185 … -0.538876; … ; 1.11807 … 0.508189; -2.11473 … -0.232537], [2.71265,  … 2.98286], [-0.435012 … 0.270724])

julia> @show mse(m)
mse(m) = 1.031528585636355
1.031528585636355

julia> @show rmse(m)
rmse(m) = 1.0156419574024869
1.0156419574024869

julia> @show r2(m)
r2(m) = 0.9081989868708816
0.9081989868708816

julia> @show mse(m, X[testing_rows, :], y[testing_rows])
mse(m, X[testing_rows, :], y[testing_rows]) = 0.9880756524934934
0.9880756524934934

julia> @show rmse(m, X[testing_rows, :], y[testing_rows])
rmse(m, X[testing_rows, :], y[testing_rows]) = 0.9940199457221638
0.9940199457221638

julia> @show r2(m, X[testing_rows, :], y[testing_rows])
r2(m, X[testing_rows, :], y[testing_rows]) = 0.9156702341388883
0.9156702341388883

julia> Test.@test m.X == X[training_rows, :]
Test Passed

julia> Test.@test m.y == y[training_rows]
Test Passed

julia> Test.@test all(m.X .== X[training_rows, :])
Test Passed

julia> Test.@test all(m.y .== y[training_rows])
Test Passed

julia> Test.@test !all(m.X .== 0)
Test Passed

julia> Test.@test !all(m.y .== 0)
Test Passed

julia> sanitize!(Model(m), Data(X), Data(y)) # sanitize the model with ModelSanitizer
Model{LinearModel{Float64}}(LinearModel{Float64}([0.0 … 0.0; 0.0 … 0.0; … ; 0.0 … 0.0; 0.0 … 0.0], [0.0 … 0.0], [0.763981 … -0.378458]))

julia> Test.@test m.X != X[training_rows, :]
Test Passed

julia> Test.@test m.y != y[training_rows]
Test Passed

julia> Test.@test !all(m.X .== X[training_rows, :])
Test Passed

julia> Test.@test !all(m.y .== y[training_rows])
Test Passed

julia> Test.@test all(m.X .== 0)
Test Passed

julia> Test.@test all(m.y .== 0)
Test Passed
```

### Example 2

```julia
```

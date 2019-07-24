using DataFrames
using ModelSanitizer
using Statistics
using StatsBase
using StatsModels
using Test

mutable struct DataFrameLinearModel{T}
    formula::F where F <: AbstractTerm
    sch::S where S <: StatsModels.Schema
    X::DataFrame
    y::Vector{T}
    beta::Vector{T}
    function DataFrameLinearModel{T}()::DataFrameLinearModel{T} where T
        m::DataFrameLinearModel{T} = new()
        return m
    end
end

function fit!(m::DataFrameLinearModel{T}, X::DataFrame, y::Vector{T})::DataFrameLinearModel{T} where T
    m.X = deepcopy(X)
    m.y = deepcopy(y)
    formula = Term(first(names(m.X))) ~ sum(Term.(names(m.X)))
    sch = schema(formula, m.X)
    formula = apply_schema(formula, sch)
    m.formula = formula
    m.sch = sch
    _, Xmatrix = modelcols(m.formula, X)
    m.beta = (Xmatrix'Xmatrix)\(Xmatrix'm.y)
    return m
end

function predict(m::DataFrameLinearModel{T}, X::DataFrame)::Vector{T} where T
    formula = m.formula
    sch = m.sch
    formula = apply_schema(formula, sch)
    _, Xmatrix = modelcols(formula, X)
    y_hat::Vector{T} = Xmatrix * m.beta
    return y_hat
end

function predict(m::LinearModel{T})::Vector{T} where T
    y_hat::Vector{T} = predict(m, m.X)
    return y_hat
end

function mse(y::Vector{T}, y_hat::Vector{T})::T where T
    _mse::T = mean((y .- y_hat).^2)
    return _mse
end

function mse(m::DataFrameLinearModel{T}, X::DataFrame, y::Vector{T})::T where T
    y_hat::Vector{T} = predict(m, X)
    _mse::T = mse(y, y_hat)
    return _mse
end

function mse(m::DataFrameLinearModel{T})::T where T
    X::DataFrame = m.X
    y::Vector{T} = m.y
    _mse::T = mse(m, X, y)
    return _mse
end

rmse(varargs...) = sqrt(mse(varargs...))

function r2(y::Vector{T}, y_hat::Vector{T})::T where T
    y_bar::T = mean(y)
    SS_tot::T = sum((y .- y_bar).^2)
    SS_res::T = sum((y .- y_hat).^2)
    _r2::T = 1 - SS_res/SS_tot
    return _r2
end

function r2(m::DataFrameLinearModel{T}, X::DataFrame, y::Vector{T})::T where T
    y_hat::Vector{T} = predict(m, X)
    _r2::T = r2(y, y_hat)
    return _r2
end

function r2(m::DataFrameLinearModel{T})::T where T
    X::DataFrame = m.X
    y::Vector{T} = m.y
    _r2::T = r2(m, X, y)
    return _r2
end

X = DataFrame()
X[:x1] = randn(1_000)
X[:x2] = randn(1_000)
X[:x3] = randn(1_000)
X[:x4] = sample([1,2,3], pweights([0.005, 0.99, 0.005]), 1_000; replace=true)
X[:x5] = sample([1,2,3], pweights([0.005, 0.99, 0.005]), 1_000; replace=true)
X[:x6] = sample([1,2,3], pweights([0.005, 0.99, 0.005]), 1_000; replace=true)
X[:x7] = sample(["foo", "bar"], pweights([0.3, 0.7]), 1_000; replace=true)
X[:x8] = sample(["apple", "banana", "carrot"], pweights([0.1, 0.7, 0.2]), 1_000; replace=true)
X[:x9] = sample(["red", "green", "yellow", "blue"], pweights([0.2, 0.3, 0.15, 0.35]), 1_000; replace=true)
formula = Term(first(names(X))) ~ sum(Term.(names(X)))
sch = schema(formula, X)
formula = apply_schema(formula, sch)
_, Xmatrix = modelcols(formula, X)
y = Xmatrix * randn(Float64, 12) + randn(1_000)/2
m = DataFrameLinearModel{Float64}()
testing_rows = 1:2:1_000
training_rows = setdiff(1:1_000, testing_rows)
fit!(m, X[training_rows, :], y[training_rows])

@show mse(m)
@show rmse(m)
@show r2(m)

@show mse(m, X[testing_rows, :], y[testing_rows])
@show rmse(m, X[testing_rows, :], y[testing_rows])
@show r2(m, X[testing_rows, :], y[testing_rows])

@test m.X == X[training_rows, :]
@test all(convert(Matrix, m.X) .== convert(Matrix, X[training_rows, :]))
for column in names(m.X)
    for i = 1:size(m.X, 2)
        @test m.X[i, column] != 0 && m.X[i, column] != ""
    end
end
@test m.y == y[training_rows]
@test all(m.y .== y[training_rows])
@test !all(m.y .== 0)

sanitize!(Model(m), Data(X), Data(y)) # sanitize the model with ModelSanitizer

@test m.X != X[training_rows, :]
@test !all(convert(Matrix, m.X) .== convert(Matrix, X[training_rows, :]))
for column in names(m.X)
    for i = 1:size(m.X, 2)
        @test m.X[i, column] == 0 || m.X[i, column] == ""
    end
end
@test m.y != y[training_rows]
@test !all(m.y .== y[training_rows])
@test all(m.y .== 0)

# if you know exactly where the data are stored inside the model, you can
# directly delete them with ForceSanitize:
sanitize!(ForceSanitize(m.X), ForceSanitize(m.y))

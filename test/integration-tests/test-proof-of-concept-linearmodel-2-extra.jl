data = Data[Data(X), Data(y)]
elements = ModelSanitizer._elements(data)

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

m = DataFrameLinearModel{Float64}()
fit!(m, X[training_rows, :], y[training_rows])

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

sanitize!(ForceSanitize(m.X))

@test m.X != X[training_rows, :]
@test !all(convert(Matrix, m.X) .== convert(Matrix, X[training_rows, :]))
for column in names(m.X)
    for i = 1:size(m.X, 2)
        @test m.X[i, column] == 0 || m.X[i, column] == ""
    end
end
@test m.y == y[training_rows]
@test all(m.y .== y[training_rows])
@test !all(m.y .== 0)

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

m = DataFrameLinearModel{Float64}()
fit!(m, X[training_rows, :], y[training_rows])

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

sanitize!(ForceSanitize(m.X), ForceSanitize(m.y))

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

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

m = DataFrameLinearModel{Float64}()
fit!(m, X[training_rows, :], y[training_rows])

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

sanitize!(Model(m))

@test m.X != X[training_rows, :]
@test !all(convert(Matrix, m.X) .== convert(Matrix, X[training_rows, :]))
for column in names(m.X)
    for i = 1:size(m.X, 2)
        @test m.X[i, column] == 0 || m.X[i, column] == ""
    end
end
@test m.y == y[training_rows]
@test all(m.y .== y[training_rows])
@test !all(m.y .== 0)

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

m = DataFrameLinearModel{Float64}()
fit!(m, X[training_rows, :], y[training_rows])

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

sanitize!(Model(m), Data(X))

@test m.X != X[training_rows, :]
@test !all(convert(Matrix, m.X) .== convert(Matrix, X[training_rows, :]))
for column in names(m.X)
    for i = 1:size(m.X, 2)
        @test m.X[i, column] == 0 || m.X[i, column] == ""
    end
end
@test m.y == y[training_rows]
@test all(m.y .== y[training_rows])
@test !all(m.y .== 0)

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

m = DataFrameLinearModel{Float64}()
fit!(m, X[training_rows, :], y[training_rows])

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

sanitize!(Model(m), Data(X), Data(y))

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

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

m = DataFrameLinearModel{Float64}()
fit!(m, X[training_rows, :], y[training_rows])

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

sanitize!(Model(m), Data[Data(X), Data(y)])

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

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

m = DataFrameLinearModel{Float64}()
fit!(m, X[training_rows, :], y[training_rows])

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

sanitize!(Model(m), Data([[[[[[], [[[[X], [y]]]], []]]]]]))

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

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

m = DataFrameLinearModel{Float64}()
fit!(m, X[training_rows, :], y[training_rows])

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

sanitize!(Model(m), Data([[[[[[], [[[[[X, y]]]]], []]]]]]))

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

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

m = DataFrameLinearModel{Float64}()
fit!(m, X[training_rows, :], y[training_rows])

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

sanitize!(Model(m), Data[Data(X[1:20, :]), Data(y[1:20])])

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

fit!(m, X[training_rows, :], y[training_rows])

Test.@test m.X == X[training_rows, :]
Test.@test m.y == y[training_rows]
Test.@test all(m.X .== X[training_rows, :])
Test.@test all(m.y .== y[training_rows])
Test.@test !all(m.X .== 0)
Test.@test !all(m.y .== 0)

sanitize!(Model(m))

Test.@test m.X == X[training_rows, :]
Test.@test m.y == y[training_rows]
Test.@test all(m.X .== X[training_rows, :])
Test.@test all(m.y .== y[training_rows])
Test.@test !all(m.X .== 0)
Test.@test !all(m.y .== 0)

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

fit!(m, X[training_rows, :], y[training_rows])

Test.@test m.X == X[training_rows, :]
Test.@test m.y == y[training_rows]
Test.@test all(m.X .== X[training_rows, :])
Test.@test all(m.y .== y[training_rows])
Test.@test !all(m.X .== 0)
Test.@test !all(m.y .== 0)

sanitize!(Model(m), Data(X))
Test.@test m.y == y[training_rows]
Test.@test all(m.y .== y[training_rows])
Test.@test !all(m.y .== 0)

Test.@test m.X != X[training_rows, :]
Test.@test !all(m.X .== X[training_rows, :])
Test.@test all(m.X .== 0)

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

fit!(m, X[training_rows, :], y[training_rows])

Test.@test m.X == X[training_rows, :]
Test.@test m.y == y[training_rows]
Test.@test all(m.X .== X[training_rows, :])
Test.@test all(m.y .== y[training_rows])
Test.@test !all(m.X .== 0)
Test.@test !all(m.y .== 0)

sanitize!(Model(m), Data(X), Data(y))

Test.@test m.X != X[training_rows, :]
Test.@test m.y != y[training_rows]
Test.@test !all(m.X .== X[training_rows, :])
Test.@test !all(m.y .== y[training_rows])
Test.@test all(m.X .== 0)
Test.@test all(m.y .== 0)

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

fit!(m, X[training_rows, :], y[training_rows])

Test.@test m.X == X[training_rows, :]
Test.@test m.y == y[training_rows]
Test.@test all(m.X .== X[training_rows, :])
Test.@test all(m.y .== y[training_rows])
Test.@test !all(m.X .== 0)
Test.@test !all(m.y .== 0)

sanitize!(Model(m), Data[Data(X), Data(y)])

Test.@test m.X != X[training_rows, :]
Test.@test m.y != y[training_rows]
Test.@test !all(m.X .== X[training_rows, :])
Test.@test !all(m.y .== y[training_rows])
Test.@test all(m.X .== 0)
Test.@test all(m.y .== 0)

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

fit!(m, X[training_rows, :], y[training_rows])

Test.@test m.X == X[training_rows, :]
Test.@test m.y == y[training_rows]
Test.@test all(m.X .== X[training_rows, :])
Test.@test all(m.y .== y[training_rows])
Test.@test !all(m.X .== 0)
Test.@test !all(m.y .== 0)

sanitize!(Model(m), Data([[[[[[], [[[[X], [y]]]], []]]]]]))

Test.@test m.X != X[training_rows, :]
Test.@test m.y != y[training_rows]
Test.@test !all(m.X .== X[training_rows, :])
Test.@test !all(m.y .== y[training_rows])
Test.@test all(m.X .== 0)
Test.@test all(m.y .== 0)

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

fit!(m, X[training_rows, :], y[training_rows])

Test.@test m.X == X[training_rows, :]
Test.@test m.y == y[training_rows]
Test.@test all(m.X .== X[training_rows, :])
Test.@test all(m.y .== y[training_rows])
Test.@test !all(m.X .== 0)
Test.@test !all(m.y .== 0)

sanitize!(Model(m), Data([[[[[[], [[[[[X, y]]]]], []]]]]]))

Test.@test m.X != X[training_rows, :]
Test.@test m.y != y[training_rows]
Test.@test !all(m.X .== X[training_rows, :])
Test.@test !all(m.y .== y[training_rows])
Test.@test all(m.X .== 0)
Test.@test all(m.y .== 0)

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

fit!(m, X[training_rows, :], y[training_rows])

Test.@test m.X == X[training_rows, :]
Test.@test m.y == y[training_rows]
Test.@test all(m.X .== X[training_rows, :])
Test.@test all(m.y .== y[training_rows])
Test.@test !all(m.X .== 0)
Test.@test !all(m.y .== 0)

sanitize!(Model(m), Data[Data(X[1:20]), Data(y[1:20])])

Test.@test m.X != X[training_rows, :]
Test.@test m.y != y[training_rows]
Test.@test !all(m.X .== X[training_rows, :])
Test.@test !all(m.y .== y[training_rows])
Test.@test all(m.X .== 0)
Test.@test all(m.y .== 0)

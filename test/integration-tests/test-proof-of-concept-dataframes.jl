import DataFrames
import ModelSanitizer
import Test

struct A
a
end

struct B
b1
b2
b3
end

struct C
c1
c2
end

struct D
d1
d2
end

struct E
e
end

struct F
f
end

model = A(B(C(1.0, DataFrames.DataFrame(:x => [1,2,3], :y => [4,5,6])), D(Any[1, 2.0, DataFrames.DataFrame(:z => [7,8,9], :t => [10, 11, 12]), 4.0, E(DataFrames.DataFrame(:s => [13, 14, 15, missing]))], Any[6, "7.0", E(DataFrames.DataFrame()), 9, :ten]), F("F")))

Test.@test model.a.b1.c2[1, :x] == 1
Test.@test model.a.b1.c2[2, :x] == 2
Test.@test model.a.b1.c2[3, :x] == 3
Test.@test model.a.b1.c2[1, :y] == 4
Test.@test model.a.b1.c2[2, :y] == 5
Test.@test model.a.b1.c2[3, :y] == 6
Test.@test model.a.b2.d1[3][1, :z] == 7
Test.@test model.a.b2.d1[3][2, :z] == 8
Test.@test model.a.b2.d1[3][3, :z] == 9
Test.@test model.a.b2.d1[3][1, :t] == 10
Test.@test model.a.b2.d1[3][2, :t] == 11
Test.@test model.a.b2.d1[3][3, :t] == 12
Test.@test model.a.b2.d1[5].e[1, :s] == 13
Test.@test model.a.b2.d1[5].e[2, :s] == 14
Test.@test model.a.b2.d1[5].e[3, :s] == 15
Test.@test model.a.b2.d1[5].e[4, :s] === missing
Test.@test ismissing(model.a.b2.d1[5].e[4, :s])

ModelSanitizer.sanitize!(ModelSanitizer.Model(model))

Test.@test model.a.b1.c2[1, :x] == 0
Test.@test model.a.b1.c2[2, :x] == 0
Test.@test model.a.b1.c2[3, :x] == 0
Test.@test model.a.b1.c2[1, :y] == 0
Test.@test model.a.b1.c2[2, :y] == 0
Test.@test model.a.b1.c2[3, :y] == 0

Test.@test model.a.b2.d1[3][1, :z] == 0
Test.@test model.a.b2.d1[3][2, :z] == 0
Test.@test model.a.b2.d1[3][3, :z] == 0
Test.@test model.a.b2.d1[3][1, :t] == 0
Test.@test model.a.b2.d1[3][2, :t] == 0
Test.@test model.a.b2.d1[3][3, :t] == 0

Test.@test model.a.b2.d1[5].e[1, :s] == 0
Test.@test model.a.b2.d1[5].e[2, :s] == 0
Test.@test model.a.b2.d1[5].e[3, :s] == 0
Test.@test model.a.b2.d1[5].e[4, :s] == 0

for column in names(model.a.b1.c2)
    Test.@test all(model.a.b1.c2[:, column] .== 0)
end
for column in names(model.a.b2.d1[3])
    Test.@test all(model.a.b2.d1[3][:, column] .== 0)
end
for column in names(model.a.b2.d1[5].e)
    Test.@test all(model.a.b2.d1[5].e[:, column] .== 0)
end

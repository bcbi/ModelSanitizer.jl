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

model = A(B(C(1.0, DataFrames.DataFrame(:x => [1,2,3], :y => [4,5,6])), D(Any[1, 2.0, DataFrames.DataFrame(:z => [7,8,9], :t => [10, 11, 12]), 4.0, E(DataFrames.DataFrame(:s => [13, 14, 15]))], Any[6, "7.0", E(DataFrames.DataFrame()), 9, :ten]), F("F")))

Test.@test model.a.b1.c2[1, :x] == 1
Test.@test model.a.b1.c2[2, :x] == 2
Test.@test model.a.b1.c2[3, :x] == 3
Test.@test model.a.b1.c2[1, :y] == 4
Test.@test model.a.b1.c2[2, :y] == 5
Test.@test model.a.b1.c2[3, :y] == 6

Test.@test size(model.a.b1.c2) == (3, 2)
Test.@test size(model.a.b2.d1[3]) == (3,2)
Test.@test size(model.a.b2.d1[5].e) == (3, 1)
Test.@test size(model.a.b2.d2[3].e) == (0, 0)

ModelSanitizer.sanitize!(model)

Test.@test size(model.a.b1.c2) == (0, 0)
Test.@test size(model.a.b2.d1[3]) == (0,0)
Test.@test size(model.a.b2.d1[5].e) == (0, 0)
Test.@test size(model.a.b2.d2[3].e) == (0, 0)

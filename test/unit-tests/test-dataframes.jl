import DataFrames
import PredictMDSanitizer
import Test

a = DataFrames.DataFrame()
a[:x] = [1, 2, 3]
a[:y] = [4, 5, 6]
a[:z] = [7, 8, 9]

Test.@test a[1, :x] == 1
Test.@test a[2, :x] == 2
Test.@test a[3, :x] == 3
Test.@test a[1, :y] == 4
Test.@test a[2, :y] == 5
Test.@test a[3, :y] == 6
Test.@test a[1, :z] == 7
Test.@test a[2, :z] == 8
Test.@test a[3, :z] == 9

Test.@test size(a) == (3,3)

PredictMDSanitizer.sanitize!(a)

Test.@test size(a) == (0,0)

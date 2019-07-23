import DataFrames
import ModelSanitizer
import Test

struct Bar{T}
    x::T
end

x1 = [[[], [], [1]], [[], 10, 3, 4], [], [], [8], [1]]
x2 = [[], [[8], [1], [1], [], Bar([[[], [[5], [7, 2]]]])], [], [8], [], []]
x3 = [[], [], [[DataFrames.DataFrame(:x => [6])]], [], 9, [], [[], [], [[[], [[4, 1]]]]]]

data = ModelSanitizer.Data[ModelSanitizer.Data(x1),
                           ModelSanitizer.Data(x2),
                           ModelSanitizer.Data(x3)]

elements = ModelSanitizer._elements(data)

Test.@test 1 in elements
Test.@test 2 in elements
Test.@test 3 in elements
Test.@test 4 in elements
Test.@test 5 in elements
Test.@test 6 in elements
Test.@test 7 in elements
Test.@test 8 in elements
Test.@test 9 in elements
Test.@test 10 in elements

Test.@test ModelSanitizer._how_many_elements_occur_in_this_array(elements, []) == 0
Test.@test ModelSanitizer._how_many_elements_occur_in_this_array(elements, [0]) == 0
Test.@test ModelSanitizer._how_many_elements_occur_in_this_array(elements, [0, 1]) == 1
Test.@test ModelSanitizer._how_many_elements_occur_in_this_array(elements, [0, 2, 4]) == 2
Test.@test ModelSanitizer._how_many_elements_occur_in_this_array(elements, [1, 3, 5, 0]) == 3

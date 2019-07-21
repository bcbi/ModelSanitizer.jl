import PredictMDSanitizer
import Test

struct Foo end
Test.@test_throws PredictMDSanitizer._get_property(Foo(), :a)
Test.@test !PredictMDSanitizer._is_iterable(typeof(1.0))
Test.@test !PredictMDSanitizer._is_iterable(typeof('a'))
Test.@test !PredictMDSanitizer._is_iterable(Foo)
Test.@test !PredictMDSanitizer._is_indexable(typeof(1.0))
Test.@test !PredictMDSanitizer._is_indexable(typeof('a'))
Test.@test PredictMDSanitizer._is_indexable(Foo)

import ModelSanitizer
import Test

struct Foo end
Test.@test ModelSanitizer._get_property(Foo(), :a) isa Nothing
Test.@test !ModelSanitizer._is_iterable(typeof(1.0))
Test.@test !ModelSanitizer._is_iterable(typeof('a'))
Test.@test !ModelSanitizer._is_iterable(Foo)
Test.@test !ModelSanitizer._is_indexable(typeof(1.0))
Test.@test !ModelSanitizer._is_indexable(typeof('a'))
Test.@test !ModelSanitizer._is_indexable(Foo)

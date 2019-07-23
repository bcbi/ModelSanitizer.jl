using ModelSanitizer
using Test

@testset "ModelSanitizer.jl" begin
    @testset "Unit tests" begin
        @debug("Running unit tests...")
        @testset "unit-tests/test-dataframes.jl" begin
            include("unit-tests/test-dataframes.jl")
        end
        @testset "unit-tests/test-elements.jl" begin
            include("unit-tests/test-elements.jl")
        end
        # @testset "unit-tests/test-sanitize.jl" begin
        #     include("unit-tests/test-sanitize.jl")
        # end
        @testset "unit-tests/test-utils.jl" begin
            include("unit-tests/test-utils.jl")
        end
        @testset "unit-tests/test-zero.jl" begin
            include("unit-tests/test-zero.jl")
        end
    end
    # @testset "Integration tests" begin
    #     @debug("Running integration tests...")
    #     @testset "integration-tests/test-proof-of-concept-dataframes.jl" begin
    #         include("integration-tests/test-proof-of-concept-dataframes.jl")
    #     end
    #     @testset "integration-tests/test-proof-of-concept-linearmodel.jl" begin
    #         include("integration-tests/test-proof-of-concept-linearmodel.jl")
    #     end
    #     @testset "integration-tests/test-proof-of-concept-mlj.jl" begin
    #         include("integration-tests/test-proof-of-concept-mlj.jl")
    #     end
    # end
end

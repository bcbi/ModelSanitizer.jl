using PredictMDSanitizer
using Test

@testset "PredictMDSanitizer.jl" begin
    @testset "Unit tests" begin
        @debug("Running unit tests...")
        @testset "unit-tests/test-sanitize.jl" begin
            include("unit-tests/test-sanitize.jl")
        end
        @testset "unit-tests/test-dataframes.jl" begin
            include("unit-tests/test-dataframes.jl")
        end
    end
    @testset "Integration tests" begin
        @debug("Running integration tests...")
        @testset "integration-tests/test-proof-of-concept-dataframes.jl" begin
            include("integration-tests/test-proof-of-concept-dataframes.jl")
        end
        @testset "integration-tests/test-proof-of-concept-mlj.jl" begin
            include("integration-tests/test-proof-of-concept-mlj.jl")
        end
    end
end
    

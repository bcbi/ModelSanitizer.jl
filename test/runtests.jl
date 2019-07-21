using PredictMDSanitizer
using Test

@testset "PredictMDSanitizer.jl" begin
    @testset "test-proof-of-concept-dataframes.jl" begin
        include("test-proof-of-concept-dataframes.jl")
    end
    @testset "test-proof-of-concept-mlj.jl" begin
        include("test-proof-of-concept-mlj.jl")
    end
end

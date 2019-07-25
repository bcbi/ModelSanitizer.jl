import BenchmarkTools
import PkgBenchmark

const project_root = dirname(dirname(@__FILE__))

const proof_of_concept_dataframes = joinpath(project_root, "test", "integration-tests", "test-proof-of-concept-dataframes.jl")
const proof_of_concept_linearmodel = joinpath(project_root, "test", "integration-tests", "test-proof-of-concept-linearmodel.jl")
const proof_of_concept_mlj = joinpath(project_root, "test", "integration-tests", "test-proof-of-concept-mlj.jl")

# run each of the scripts once to force compilation of all of the functions
include(proof_of_concept_dataframes)
include(proof_of_concept_linearmodel)
include(proof_of_concept_mlj)

const fail_travis_if_benchmarks_detect_performance_regression = true
const target = "HEAD"
const baseline = "origin/master-benchmark"

BenchmarkTools.judge("ModelSanitizer", target, baseline)

import BenchmarkTools
import PkgBenchmark

const project_root = dirname(dirname(@__FILE__))

const proof_of_concept_dataframes = joinpath(project_root, "test", "integration-tests", "test-proof-of-concept-dataframes.jl")
const proof_of_concept_linearmodel = joinpath(project_root, "test", "integration-tests", "test-proof-of-concept-linearmodel.jl")
const proof_of_concept_mlj = joinpath(project_root, "test", "integration-tests", "test-proof-of-concept-mlj.jl")

const SUITEXXXXXXX = BenchmarkTools.BenchmarkGroup()
SUITEXXXXXXX["integration-tests"] = BenchmarkTools.BenchmarkGroup()
SUITEXXXXXXX["integration-tests"]["proof-of-concept-dataframes"] = BenchmarkTools.@benchmarkable include($proof_of_concept_dataframes)
SUITEXXXXXXX["integration-tests"]["proof-of-concept-linearmodel"] = BenchmarkTools.@benchmarkable include($proof_of_concept_linearmodel)
SUITEXXXXXXX["integration-tests"]["proof-of-concept-mlj"] = BenchmarkTools.@benchmarkable include($proof_of_concept_mlj)

const project_root = dirname(dirname(@__FILE__))

const benchmarks = joinpath(project_root, "benchmark", "benchmarks.jl")
const run_benchmarks = joinpath(project_root, "benchmark", "run-benchmarks.jl")

include(benchmarks)
include(run_benchmarks)
